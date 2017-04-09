#!/usr/bin/env bash

set -o errexit
set -o pipefail
set -o nounset

init(){
    echo "[$(date +%T)] ${FUNCNAME}()"

    if [ "$#" -lt 1 ]; then
        echo "Error: Not enough arguments"
        echo "Example create: $0 create do_api_key ssh_key_name [optional_droplet_region] [optional_droplet_tagname]"
        echo "Example destroy: $0 destroy do_api_key [optional_droplet_tagname]"
        echo "Example check: $0 check do_api_key [optional_droplet_tagname]"
        exit 1
    fi

    # Can be create or destroy
    OPERATION=$1
    shift

    # Get this from https://cloud.digitalocean.com/settings/api/tokens
    DO_API_KEY=$1
    shift

    SSH_FINGERPRINT="null"
    if [ $OPERATION = "create" ]; then
        # Get this from https://cloud.digitalocean.com/settings/security
        if [ "$#" -gt 0 ]; then
            SSH_FINGERPRINT="[\"$1\"]"
            shift
        fi
    fi

    # Droplet region
    if [ "$#" -gt 0 ]; then
        DROPLET_REGION="$1"
        shift
    else
        DROPLET_REGION="nyc3"
    fi

    # Tag name used to identify needed droplet
    if [ "$#" -gt 0 ]; then
        DROPLET_TAG_NAME="\"$1\""
        shift
    else
        DROPLET_TAG_NAME="private-vpn"
    fi

    DROPLET_CONFIGURATION="{\"name\":\"$DROPLET_TAG_NAME\",\"region\":\"$DROPLET_REGION\",\"size\":\"512mb\",\"image\":\"ubuntu-14-04-x64\",\"ssh_keys\":$SSH_FINGERPRINT,\"backups\":false,\"ipv6\":false,\"user_data\":null,\"private_networking\":null,\"volumes\": null,\"tags\":[\"$DROPLET_TAG_NAME\"]}"
    DROPLETS_ENTRYPOINT="https://api.digitalocean.com/v2/droplets"

    DROPLET_IP=""
}

create_vpn_droplet(){
    echo "[$(date +%T)] ${FUNCNAME}()"

    response=$(curl -s \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $DO_API_KEY" \
        -d "$DROPLET_CONFIGURATION" "$DROPLETS_ENTRYPOINT")
}

vpn_exists(){
    echo "[$(date +%T)] ${FUNCNAME}()"

    response=$(curl -s -X GET \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $DO_API_KEY" \
        "$DROPLETS_ENTRYPOINT?page=1&per_page=1&tag_name=$DROPLET_TAG_NAME")

    # Empty response
    if [ -z "$response" ]; then
        return 2
    else

        # No droplets found
        if [[ $response == *"{\"total\":0}"* ]]; then
            return 3
        fi

        DROPLET_IP=$(echo $response | grep -Po '(?<="v4":\[\{"ip_address":")[^"]*')

        if [ -z "$DROPLET_IP" ]; then
            echo "Failed to get droplet ip from the following response:"
            echo $response
            exit 4
        fi
    fi
}

destroy_vpn_droplet(){
    echo "[$(date +%T)] ${FUNCNAME}()"

    response=$(curl -s -X DELETE \
        -H "Content-Type: application/json" \
        -H "Authorization: Bearer $DO_API_KEY" \
        "$DROPLETS_ENTRYPOINT?tag_name=$DROPLET_TAG_NAME")
}

install_vpn_software(){
    echo "[$(date +%T)] ${FUNCNAME}()"

    # Need to confirm fingerprint
    ssh -t root@$DROPLET_IP exit

    # Upload and execute install file
    scp "$(dirname $0)/openvpn-script-run.sh" root@$DROPLET_IP:
    ssh -t root@$DROPLET_IP /usr/bin/env bash ./openvpn-script-run.sh

    # Download ovpn file
    scp root@$DROPLET_IP:*.ovpn $(dirname $0)/
}

main () {
    # Initialize main variables
    init $*


    case "$OPERATION" in
    "check")
        if vpn_exists; then
            echo "VPN found on $DROPLET_IP"
        else
            echo "VPN can't be found"
        fi
        ;;
    "destroy")
        destroy_vpn_droplet

        if vpn_exists; then
            echo "Failed to destroy the droplet on $DROPLET_IP"
            exit 1
        fi
        ;;
    *)
        if vpn_exists; then
            echo "VPN Already exists on $DROPLET_IP"
        else
            create_vpn_droplet

            echo "Sleeping for 60s"
            sleep 60

            if vpn_exists; then
                echo "VPN created on $DROPLET_IP"
            else
                echo "Sleeping for 60s more"

                if vpn_exists; then
                    echo "VPN created on $DROPLET_IP"
                else
                    echo "Failed to create VPN"
                    exit 1
                fi

            fi
        fi

        install_vpn_software
        ;;
    esac

    echo "DONE"
}

main $*
