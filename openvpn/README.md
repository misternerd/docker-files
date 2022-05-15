# OpenVPN

This container runs OpenVPN including a kill switch, which only allows access through the VPN and nothing else.
For this container, you need an OpenVPN server. Most VPN providers still support OpenVPN and you can generate/download
config files for it.

You can either place the config files in `./configs` and they'll be baked into the build. Or you mount the OpenVPN
config files to `/app/configs` during runtime.

Now, to connect another container through the VPN, you can just attach it using this container's network. See
(youtube-dl)[../youtube-dl/run-with-openvpn.sh] for an example.