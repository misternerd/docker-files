#!/bin/bash

# We need the username in Docker
. ../.env

# You should mount folders for config and data. In the example below, there are three config folders
# mapped, you could also just map in one folder to /home/$MRNERD_USERNAME
docker run --rm \
	-e DISPLAY=$DISPLAY \
	-e LIBGL_ALWAYS_SOFTWARE=1 \
	-v /etc/machine-id:/etc/machine-id \
	-v /etc/timezone:/etc/timezone:ro \
	-v /etc/localtime:/etc/localtime:ro \
	-v /tmp/.X11-unix:/tmp/.X11-unix \
	-v /run/dbus:/run/dbus \
	-v /var/lib/dbus:/var/lib/dbus \
	-v /path/to/shared/data/folder:/data \
	-v /path/to/nextcloud-config/.config/nextcloud/.config:/home/$MRNERD_USERNAME/.config \
	-v /path/to/nextcloud-config/.local:/home/$MRNERD_USERNAME/.local \
	-v path/to/nextcloud-config/nextcloud/.pki:/home/$MRNERD_USERNAME/.pki \
	mrnerd/nextcloud-client
