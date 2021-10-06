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

profiles=("Client")
# version of inspec with tag filtering support
inspec_image=chef/inspec:4.46.13

sdpclient_secrets_dir=""
out_dir=""
sdpclient_image=sdpclient
fwknop_command="fwknop --rc-file /root/.config/.fwknoprc —wget-cmd /usr/bin/wget -R -n service_gate"

function print_usage {
    echo "Usage: ${script_name} [OPTION]..."
    echo "Runner for ATICC project InSpec Profiles"
    echo "WARNING: Time based tests may require delay between subsequent runs"
    echo "  -h              Display this help message"
    echo "  -s <directory>  Set fwknop secrets directory (MUST be absolute path) (**required)"
    echo "  -o <directory>  Set output directory (MUST be absolute path) (**required)"
    echo "  -d <image>      Set sdpclient docker image (default: '${sdpclient_image}')"
    echo "  -f <command>    Set the fwknop command to be run"
    echo "                  (default '${fwknop_command}')"
}

while getopts ":hs:d:o:f:" opt; do
    case ${opt} in
        h)
            print_usage
            ;;
        s)
            sdpclient_secrets_dir=${OPTARG}
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

function run_profile {
    docker run -it --rm \
        -v /var/run/docker.sock:/var/run/docker.sock \
        -v ${script_dir}/Profile:/profiles \
        -v ${out_dir}:/output \
        ${inspec_image} exec /profiles/$1 \
            --input_file /profiles/input_file.yml \
            -t docker://${sdpclient_container_handle} \
            --chef-license=accept-silent \
            --reporter json:/output/$1-$2.json \
            --tags=$2
}

function finish {
    echo "Tearing down SDP client container..."

    # tear down sdpclient container
    docker stop ${sdpclient_container_handle} > /dev/null
}

# confirm required options are set
[ -z "$sdpclient_secrets_dir" ] && echo "Secrets directory (-s) option must be set" && exit 1
[ -z "$out_dir" ] && echo "Output directory (-o) option must be set" && exit 1

# confirm image exists
docker image inspect ${sdpclient_image} > /dev/null 2>&1 || build_image
docker image inspect ${inspec_image} > /dev/null 2>&1 || docker pull {inspec_image}

# create output directory
mkdir -p ${out_dir}

echo "Spinning up SDP client container..."

# spin up sdpclient container
# having it tail /dev/null is a good way to keep it runing forever without complaining
sdpclient_container_handle=$(docker run --rm -d -v ${sdpclient_secrets_dir}:/root/.config $sdpclient_image tail -f /dev/null)

# prevent dangling container
trap finish EXIT

echo "Running profiles tagged as Unauthenticated..."
for profile in "${profiles[@]}"; do
    run_profile $profile "Unauthenticated" || echo "Profile ${profile} ran with errors!"
done

echo "Running authenticate command..."
docker exec ${sdpclient_container_handle} $fwknop_command

echo "Running profiles tagged as Authenticated..."
for profile in "${profiles[@]}"; do
    run_profile $profile "Authenticated" || echo "Profile ${profile} ran with errors!"
done

echo "All profiles ran, json outputs saved to ${out_dir}"
