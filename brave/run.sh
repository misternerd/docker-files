#!/bin/bash

# Assuming you have the same UID on your machine as in the Docker container
# Needs SYS_ADMIN capability because of the sandbox
docker run --rm \
	-e DISPLAY=$DISPLAY \
	-v /etc/machine-id:/etc/machine-id \
	-v /etc/timezone:/etc/timezone:ro \
	-v /etc/localtime:/etc/localtime:ro \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v /dev/shm:/dev/shm \
	-v /run/user/$UID/pulse:/run/user/$UID/pulse \
	-v /run/dbus:/run/dbus \
	-e XDG_RUNTIME_DIR=/run/user/$UID \
	--cap-add=SYS_ADMIN \
	--device /dev/dri \
	--ipc=host \
	mrnerd/brave --enable-gpu-rasterization --enable-zero-copy --enable-features=VaapiVideoDecoder --disable-features=UseOzonePlatform --use-gl=desktop  "$@"

