#!/usr/bin/env bash
# Runner for ATICC
# Author: Nikita Wootten <nikita.wootten@nist.gov>

set -e -o pipefail # fail on error or undeclared var
readonly script_name=$(basename "${0}")
readonly script_dir=$( cd "$( dirname '${BASH_SOURCE[0]}' )" && pwd )

# prompt [y/n]
# via https://stackvoerflow.com/a/32708121
function prompt_confirm {
    while true; do
        read -r -n 1 -p "${1:-Continue?} [y/n]: " REPLY
        case $REPLY in
            [yY]) echo ; return 0 ;;
            [nN]) echo ; return 1 ;;
            *) printf " \033[31m %s \n\033[0m" "invalid input"
        esac
    done
}

# version of inspec with tag filtering support
inspec_image=chef/inspec:4.46.13

sdpclient_secrets_dir=""
out_dir=""
ssh_key_path=""
ssh_username=""
sdpclient_image=sdpclient
fwknop_command="fwknop --rc-file /root/.config/.fwknoprc —wget-cmd /usr/bin/wget -R -n service_gate"

sdp_gw_address=sdp-gateway.e3lab.solutions
sdp_controller_address=sdp-controller.e3lab.solutions
internal_zone=sdp-attacker.e3lab.solutions

function print_usage {
    echo "Usage: ${script_name} [OPTION]..."
    echo "Runner for ATICC project InSpec Profiles"
    echo "WARNING: Time based tests may require delay between subsequent runs"
    echo "  -h              Display this help message"
    echo "  -s <directory>  Set fwknop secrets directory (MUST be absolute path) (**required)"
    echo "  -k <key path>   Set the ssh key path used for GW, Internal, and SDP profiles (MUST be absolute path) (**required)"
    echo "  -u <username>   Set the username used for GW, Internal, and SDP profiles (**required)"
    echo "  -o <directory>  Set output directory (MUST be absolute path) (**required)"
    echo "  -d <image>      Set sdpclient docker image (default: '${sdpclient_image}')"
    echo "  -f <command>    Set the fwknop command to be run"
    echo "                  (default '${fwknop_command}')"
}

while getopts ":hs:k:u:d:o:f:" opt; do
    case ${opt} in
        h)
            print_usage
            ;;
        s)
            sdpclient_secrets_dir=${OPTARG}
            ;;
        k)
            ssh_key_path=${OPTARG}
            ;;
        u)
            ssh_username=${OPTARG}
            ;;
        d)
            sdpclient_image=${OPTARG}
            ;;
        o)
            out_dir=${OPTARG}
            ;;
        f)
            fwknop_command=${OPTARG}
            ;;
        \?)
            echo "Invalid Option: -${OPTARG}" 1>&2
            exit 1
            ;;
        :)
            echo "Invalid Option: -${OPTARG} requires an argument" 1>&2
            exit 1
            ;;
    esac
done

function build_image {
    prompt_confirm "Image with tag ${sdpclient_image} does not exist, build new sdpclient image?" || exit 0

    docker build -f ${script_dir}/build/sdpclient_base_dockerfile -t ${sdpclient_image} ${script_dir}
}

# Run profile
# run_profile <Target Type> <Target Address> <Profile> <?Tag>
function run_profile {
    local target_args=""
    case ${1} in
        docker)
            target_args="-t docker://${2}"
            ;;
        ssh)
            target_args="--key-files /share/key --t ssh://${ssh_username}@${2}"
            ;;
    esac

    docker exec ${inspec_container_handle} exec /profiles/$3 \
        --input-file /profiles/input_file.yml \
        ${target_args} \
        --reporter json:/output/${3}${4:+"-$4"}.json \
        ${4:+"--tags=$4"} \
        --chef-license=accept-silent
}

function finish {
    echo "Tearing down SDP client and inspec containers..."

    docker stop ${sdpclient_container_handle} > /dev/null
    docker stop ${inspec_container_handle} > /dev/null

    # TODO: Akash trap reset valid column on controller 
}

# confirm required options are set
[ -z "$sdpclient_secrets_dir" ] && echo "Secrets directory (-s) option must be set" && exit 1
[ -z "$out_dir" ] && echo "Output directory (-o) option must be set" && exit 1
[ -z "$ssh_key_path" ] && echo "SSH key path (-k) option must be set" && exit 1
[ -z "$ssh_username" ] && echo "SSH username (-u) option must be set" && exit 1

# confirm image exists
docker image inspect ${sdpclient_image} > /dev/null 2>&1 || build_image
docker image inspect ${inspec_image} > /dev/null 2>&1 || docker pull {inspec_image}

# create output directory
mkdir -p ${out_dir}

echo "Spinning up SDP client container..."

# spin up sdpclient container
# having it tail /dev/null is a good way to keep it runing forever without complaining
sdpclient_container_handle=$(docker run --rm -d \
    -v ${sdpclient_secrets_dir}:/root/.config \
    ${sdpclient_image} tail -f /dev/null)
# spin up inspec container
inspec_container_handle=$(docker run --rm -d \
    -v ${script_dir}/Profiles:/profiles \
    -v ${out_dir}:/output \
    -v ${ssh_key_path}:/share/key \
    -v /var/run/docker.sock:/var/run/docker.sock \
    --entrypoint /bin/bash \
    ${inspec_image})

# prevent dangling container
trap finish EXIT

echo "Running configuration chech profiles (no configuration state)"

# Nikita NS Transiting/Egress test
run_profile ssh ${sdp_gw_address} GW NoState
# Akash MS sql uniqueness test
run_profile ssh ${sdp_controller_address} SDP NoState

echo "Running profiles tagged as Unauthenticated..."

run_profile docker ${sdpclient_container_handle} Client Unauthenticated
# Selena NS/Ingress Test
run_profile ssh ${sdp_gw_address} GW Unauthenticated

echo "Running authenticate command..."
docker exec ${sdpclient_container_handle} $fwknop_command

echo "Running profiles tagged as Authenticated..."

run_profile docker ${sdpclient_container_handle} Client Authenticated
# Selena NS/Ingress Test
run_profile ssh ${sdp_gw_address} GW Authenticated

# TODO: Akash/Nikita credential invalidation tests
#echo "Invalidating credential set"

echo "All profiles ran, json outputs saved to ${out_dir}"
