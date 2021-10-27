#!/usr/bin/env bash
# Runner for ATICC
# Author: Nikita Wootten <nikita.wootten@nist.gov>

set -euo pipefail # fail on error or undeclared var
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

# via https://betterdev.blog/minimal-safe-bash-script-template/
function msg {
    echo >&2 -e "${1-}"
}

# https://betterdev.blog/minimal-safe-bash-script-template/
function die {
    local msg=$1
    local code=${2-1} # default exit status 1
    msg "$msg"
    exit "$code"
}

# version of inspec with tag filtering support
inspec_image="chef/inspec:4.46.13"

sdpclient_secrets_dir=""
out_dir=""
ssh_key_path=""
ssh_username=""
mysql_username="root"
mysql_password=""
sdpclient_image="sdpclient"
fwknop_command="fwknop --rc-file /root/.config/.fwknoprc —-wget-cmd /usr/bin/wget -R -n service_gate"

sdp_gw_address=sdp-gateway.e3lab.solutions
sdp_controller_address=sdp-controller.e3lab.solutions
internal_zone=sdp-attacker.e3lab.solutions

function print_usage {
    echo "Usage: ${script_name} [OPTION]..."
    echo "Runner for ATICC project InSpec Profiles"
    echo "WARNING: Time based tests may require delay between subsequent runs"
    echo "  -h                  Display this help message"
    echo "  -s <directory>      Set fwknop secrets directory (MUST be absolute path) (**required)"
    echo "  -k <key path>       Set the ssh key path used for GW, Internal, and SDP profiles (MUST be absolute path) (**required)"
    echo "  -u <ssh username>   Set the ssh username used for GW, Internal, and SDP profiles (**required)"
    echo "  -n <mysql username> Set the mysql username used for SDP profile (default: '${mysql_username}')"
    echo "  -p <mysql password> Set the mysql password used for SDP profile (**required)"
    echo "  -o <directory>      Set output directory (MUST be absolute path) (**required)"
    echo "  -d <image>          Set sdpclient docker image (default: '${sdpclient_image}')"
    echo "  -f <command>        Set the fwknop command to be run"
    echo "                      (default '${fwknop_command}')"

    return 0
}

function cleanup {
    # unset trap
    trap - SIGINT SIGTERM ERR EXIT

    msg "Tearing down SDP client and inspec containers..."

    docker stop ${sdpclient_container_handle} > /dev/null
    docker stop ${inspec_container_handle} > /dev/null

    msg "Clean credential set"
    ssh -i ${ssh_key_path} ${ssh_username}@${sdp_controller_address} mysql --user=${mysql_username} \
        --password=${mysql_password} sdp < ${script_dir}/sql_queries/clean-host.sql
}

function setup {
    # confirm image exists
    docker image inspect ${sdpclient_image} > /dev/null 2>&1 || build_image
    docker image inspect ${inspec_image} > /dev/null 2>&1 || docker pull {inspec_image}

    # create output directory
    mkdir -p ${out_dir}

    msg "Spinning up SDP client container..."

    # spin up sdpclient container
    # having it tail /dev/null is a good way to keep it runing forever without complaining
    sdpclient_container_handle=$(docker run --rm -d \
        -v ${sdpclient_secrets_dir}:/root/.config \
        ${sdpclient_image} tail -f /dev/null)

    msg "Spinning up inspec container..."
    # spin up inspec container
    inspec_container_handle=$(docker run --rm -d -it \
        -v ${script_dir}/Profile:/profiles \
        -v ${out_dir}:/output \
        -v ${ssh_key_path}:/share/key \
        -v /var/run/docker.sock:/var/run/docker.sock \
        --entrypoint /bin/bash \
        ${inspec_image})

    # prevent dangling container
    trap cleanup SIGINT SIGTERM ERR EXIT
}

function parse_params {
    while getopts ":hs:k:u:n:p:d:o:f:" opt; do
        case ${opt} in
            h)
                print_usage
                exit 0
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
            n)
                mysql_username=${OPTARG}
                ;;
            p)
                mysql_password=${OPTARG}
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
                die "Invalid Option: -${OPTARG}"
                ;;
            :)
                die "Invalid Option: -${OPTARG} requires an argument"
                ;;
        esac
    done

    # confirm required options are set
    [ -z "$sdpclient_secrets_dir" ] && die "Secrets directory (-s) option must be set"
    [ -z "$out_dir" ] && die "Output directory (-o) option must be set"
    [ -z "$ssh_key_path" ] && die "SSH key path (-k) option must be set"
    [ -z "$ssh_username" ] && die "SSH username (-u) option must be set"
    [ -z "$mysql_username" ] && die "MySQL username (-n) option must be set"
    [ -z "$mysql_password" ] && die "MySQL password (-p) option must be set"

    return 0
}

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
            target_args="--key-files /share/key -t ssh://${ssh_username}@${2}"
            ;;
    esac

    msg "Running profile ${3}${4:+"#$4"}:"
    docker exec -it ${inspec_container_handle} inspec exec /profiles/$3 \
        --input-file /profiles/input_file.yml \
        --input=sdpcontroller_mysql_password="${mysql_password}" \
            sdpcontroller_mysql_username="${mysql_username}" \
            fwknop_command="${fwknop_command}" \
        ${target_args} \
        --reporter=cli json:/output/${3}${4:+"-$4"}.json \
        ${4:+"--tags=$4"} \
        --chef-license=accept-silent || msg "Profile ${3}${4:+"-$4"} Ran w/ Errors"
}

function stateless_stage {
    msg "Running configuration check profiles (no configuration state)"

    # Nikita NS Transiting/Egress test
    run_profile ssh ${sdp_gw_address} GW NoState
    # Akash MS sql uniqueness test
    run_profile ssh ${sdp_controller_address} SDP NoState
}

function unauthenticated_stage {
    msg "Running profiles tagged as Unauthenticated..."

    run_profile docker ${sdpclient_container_handle} Client Unauthenticated
    # Selena NS/Ingress Test
    run_profile ssh ${sdp_gw_address} GW Unauthenticated
}

function authenticated_stage {
    msg "Running authenticate command..."
    docker exec ${sdpclient_container_handle} $fwknop_command

    msg "Running profiles tagged as Authenticated..."
    run_profile docker ${sdpclient_container_handle} Client Authenticated
    # Selena NS/Ingress Test
    run_profile ssh ${sdp_gw_address} GW Authenticated
}

function invalidated_stage {
    msg "Invalidating credential set"
    ssh -i ${ssh_key_path} ${ssh_username}@${sdp_controller_address} \
        mysql --user=${mysql_username} --password=${mysql_password} \
            sdp < ${script_dir}/sql_queries/contaminate-host.sql

    msg "Running profiles tagged as Invalidated..."
    run_profile docker ${sdpclient_container_handle} Client Invalidated
}

parse_params "$@"

setup

stateless_stage
unauthenticated_stage
authenticated_stage
invalidated_stage

msg "All profiles ran, json outputs saved to ${out_dir}"
