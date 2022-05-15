#!/bin/bash

source ../.env

# TODO  --no-cache --pull
docker build \
  --build-arg USERNAME=$MRNERD_USERNAME \
  --build-arg UID=$MRNERD_UID \
  --build-arg GID=$MRNERD_GID \
  --build-arg TIMEZONE=$MRNERD_TIMEZONE \
  --build-arg LANG=$MRNERD_LANG \
  --build-arg LC_DATE=$MRNERD_LC_DATE \
  --build-arg LC_TIME=$MRNERD_LC_TIME \
  --build-arg LC_CTYPE=$MRNERD_LC_CTYPE \
  --build-arg LC_NUMERIC=$MRNERD_LC_NUMERIC \
  --build-arg LC_COLLATE=$MRNERD_LC_COLLATE \
  --build-arg LC_MONETARY=$MRNERD_LC_MONETARY \
  --build-arg LC_MESSAGES=$MRNERD_LC_MESSAGES \
  --build-arg LC_PAPER=$MRNERD_LC_PAPER \
  --build-arg LC_NAME=$MRNERD_LC_NAME \
  --build-arg LC_ADDRESS=$MRNERD_LC_ADDRESS \
  --build-arg LC_TELEPHONE=$MRNERD_LC_TELEPHONE \
  --build-arg LC_MEASUREMENT=$MRNERD_LC_MEASUREMENT \
  --build-arg LC_IDENTIFICATION=$MRNERD_LC_IDENTIFICATION \
  -t "mrnerd/baseimage:21.10" \
  -f baseimage-ubuntu-21.10.Dockerfile .
