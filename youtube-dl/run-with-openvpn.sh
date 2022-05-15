#!/bin/bash

# Set this to the name/ID of the container running OpenVPN
OPENVPN_CONTAINER_NAME=mrnerd-openvpn

# This is the path where youtube-dl will store any data.
DOWNLOAD_FOLDER=/path/to/your/downloads

docker run --rm \
  --net=container:mrnerd-openvpn \
	-v $DOWNLOAD_FOLDER:/app \
  mrnerd/youtube-dl \
	$@
