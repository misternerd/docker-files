FROM ubuntu:21.10

ARG USERNAME
ARG UID
ARG GID
ARG TIMEZONE
ARG LANG
ARG LC_DATE
ARG LC_TIME
ARG LC_CTYPE
ARG LC_NUMERIC
ARG LC_COLLATE
ARG LC_MONETARY
ARG LC_MESSAGES
ARG LC_PAPER
ARG LC_NAME
ARG LC_ADDRESS
ARG LC_TELEPHONE
ARG LC_MEASUREMENT
ARG LC_IDENTIFICATION

ENV UID=$UID
ENV GID=$GID
ENV USER=$USERNAME
ENV HOME=/home/$USERNAME
ENV TZ=$TIMEZONE
ENV LANG=$LANG
ENV LC_DATE=$LC_DATE
ENV LC_TIME=$LC_TIME
ENV LC_CTYPE=$LC_CTYPE
ENV LC_NUMERIC=$LC_NUMERIC
ENV LC_COLLATE=$LC_COLLATE
ENV LC_MONETARY=$LC_MONETARY
ENV LC_MESSAGES=$LC_MESSAGES
ENV LC_PAPER=$LC_PAPER
ENV LC_NAME=$LC_NAME
ENV LC_ADDRESS=$LC_ADDRESS
ENV LC_TELEPHONE=$LC_TELEPHONE
ENV LC_MEASUREMENT=$LC_MEASUREMENT
ENV LC_IDENTIFICATION=$LC_IDENTIFICATION


# Create default user
RUN groupadd -g $GID $USER && \
    echo "Creating user $USER and adding some common groups for GUI apps" && \
    useradd -d $HOME -m -g $USER -G video,dialout -u $UID -s /bin/bash $USER && \
    chown ${UID}:${GID} -R $HOME

# Install software & locales
RUN apt-get update && \
    apt-get -y upgrade && \
    echo "Removing snapd and pinning it, as it won't work within Docker" && \
    apt autoremove -y --purge snapd && \apt autoremove -y --purge snapd && \
    echo 'Package: snapd\nPin: release *\nPin-Priority: -1' > /etc/apt/preferences.d/snapd && \
    echo "Installing some common requirements, especially for GUI apps" && \
    apt-get install -y --no-install-recommends locales gnupg2 ca-certificates curl libasound2 libdbus-glib-1-2 libgtk-3-0 libxrender1 libxt6 libx11-xcb1 && \
    locale-gen $LANG $LC_DATE && \
    update-locale && \
    echo "$TZ" > /etc/timezone && \
    ln -fs /usr/share/zoneinfo/$TZ /etc/localtime

    
