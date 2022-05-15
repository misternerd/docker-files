#!/bin/bash

# This is the path where youtube-dl will store any data.
DOWNLOAD_FOLDER=/path/to/your/downloads

docker run --rm \
	-v $DOWNLOAD_FOLDER:/app \
  mrnerd/youtube-dl \
	$@
