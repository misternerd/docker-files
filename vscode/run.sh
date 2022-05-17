#!/bin/bash

# We need the username in Docker
. ../.env

# Add least mount the ~/.config and ~/.vscode folders, plus a folder for your actual code
# Add --device /dev/ttyUSB0:/dev/ttyUSB0 if you want to talk to a serial device
docker run --rm \
  -e DISPLAY=$DISPLAY \
  -e XDG_RUNTIME_DIR=/run/user/$UID \
  -v /etc/machine-id:/etc/machine-id \
  -v /etc/timezone:/etc/timezone:ro \
  -v /etc/localtime:/etc/localtime:ro \
  -v /tmp/.X11-unix:/tmp/.X11-unix \
  -v /dev/shm:/dev/shm \
  -v /var/lib/dbus:/var/lib/dbus \
  --name $CONTAINER_NAME \
  --shm-size 1g \
  --ipc host \
  --device /dev/dri \
  --group-add video \
  -v /path/to/vscode-config/.config:/home/$MRNERD_USERNAME/.config \
  -v /path/to/vscode-config/.vscode:/home/$MRNERD_USERNAME/.vscode \
  -v /path/to/your/code:/home/$MRNERD_USERNAME/workspaces \
  mrnerd/vscode
