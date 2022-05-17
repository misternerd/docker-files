# TODO Upgrade to 22.04
FROM mrnerd/baseimage:21.10

# Fixes issue with rendering
ENV QT_GRAPHICSSYSTEM=native

# If qml-module-qtqml is missing, the popup menu doesn't work (but shows no error in stderr)
RUN apt-get install -y --no-install-recommends software-properties-common dbus-x11 locales gnome-keyring qml-module-qtqml  && \
    add-apt-repository ppa:nextcloud-devs/client && \
    apt-get update && \
    apt-get install -y --no-install-recommends nextcloud-desktop && \
    echo 'LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/local/lib/x86_64-linux-gnu' >> /etc/environment && \
    rm -rf /var/cache/apt

USER $UID
CMD ["/usr/bin/nextcloud"]
