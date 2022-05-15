#!/bin/bash

# If possible, set this to your VPN provider's DNS server, so the lookup for the DNS is already executed
# on their server
# TODO Support DoH for the DNS server
DNS_SERVER_IP=1.1.1.1

# It makes sense to give this container a good name, makes it easier to connect other container to it
# Of course, if you need multiple VPNs to different endpoints, you need to use different names
CONTAINER_NAME=mrnerd-openvpn

docker run -it \
    --rm \
    --cap-add=NET_ADMIN \
    --dns $DNS_SERVER_IP \
    --device=/dev/net/tun \
    --name=$CONTAINER_NAME \
    -e DNS_SERVER_IP=$DNS_SERVER_IP \
    mrnerd/openvpn
    
