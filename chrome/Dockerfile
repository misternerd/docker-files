FROM mrnerd/baseimage:20.04

RUN curl -L https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb > /tmp/chrome.deb&& \
    apt install -yf /tmp/chrome.deb && \
    rm /tmp/chrome.deb && \
    apt-get install -y --no-install-recommends dbus-x11 pulseaudio fonts-arphic-uming fonts-baekmuk ttf-wqy-zenhei fonts-vlgothic fonts-freefont-ttf software-properties-common && \
    mkdir /run/user/$UID && \
    chown $UID:$UID /run/user/$UID

USER $UID
ENTRYPOINT ["/opt/google/chrome/chrome"]
