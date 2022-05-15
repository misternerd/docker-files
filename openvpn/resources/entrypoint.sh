#!/bin/bash

# Based on https://raw.githubusercontent.com/yacht7/docker-openvpn-client

cleanup() {
    # When you run `docker stop` or any equivalent, a SIGTERM signal is sent to PID 1.
    # A process running as PID 1 inside a container is treated specially by Linux:
    # it ignores any signal with the default action. As a result, the process will
    # not terminate on SIGINT or SIGTERM unless it is coded to do so. Because of this,
    # I've defined behavior for when SIGINT and SIGTERM is received.
    if [ $healthcheck_child ]; then
        echo "Stopping healthcheck script..."
        kill -TERM $healthcheck_child
    fi

    if [ $openvpn_child ]; then
        echo "Stopping OpenVPN..."
        kill -TERM $openvpn_child
    fi

    sleep 1
    rm $CONFIG_FILE_MODIFIED
    echo "Exiting."
    exit 0
}

# Ask the user which config file they want to use
cd /app/configs
read -e -p "Choose config: " CONFIG_FILE_ORIGINAL

if [ ! -f $CONFIG_FILE_ORIGINAL ]; then
    >&2 echo "ERROR: No configuration file found. Please check your mount and file permissions. Exiting."
    exit 1
fi

if ! $(echo $VPN_LOG_LEVEL | grep -Eq '^([1-9]|1[0-1])$'); then
    echo "WARNING: Invalid log level $VPN_LOG_LEVEL. Setting to default."
    vpn_log_level=3
else
    vpn_log_level=$VPN_LOG_LEVEL
fi

echo "
---- Running with the following variables ----
Using configuration file: $CONFIG_FILE_ORIGINAL
Using OpenVPN log level: $vpn_log_level
"

# Create a new configuration file to modify so the original is left untouched.
CONFIG_DIR=$(realpath `dirname $CONFIG_FILE_ORIGINAL`)
CONFIG_FILE_MODIFIED=${CONFIG_FILE_ORIGINAL}.modified

echo "Creating $CONFIG_FILE_MODIFIED and making required changes to that file."
cp $CONFIG_FILE_ORIGINAL $CONFIG_FILE_MODIFIED


trap cleanup INT TERM

local_subnet=$(ip r | grep -v 'default via' | grep eth0 | tail -n 1 | cut -d " " -f 1)
default_gateway=$(ip r | grep 'default via' | cut -d " " -f 3)

echo "Creating VPN kill switch and local routes."

echo "Allowing established and related connections..."
iptables -A INPUT -m conntrack --ctstate ESTABLISHED -j ACCEPT

echo "Allowing loopback connections..."
iptables -A INPUT -i lo -j ACCEPT
iptables -A OUTPUT -o lo -j ACCEPT

echo "Allowing Docker network connections..."
iptables -A INPUT -s $local_subnet -j ACCEPT
iptables -A OUTPUT -d $local_subnet -j ACCEPT

if [ ! -z "$DNS_SERVER_IP" ]
then
    echo "Allowing VPN provider's DNS server $DNS_SERVER_IP"
    iptables -A OUTPUT -o eth0 -d "$DNS_SERVER_IP" -p udp --dport 53 -j ACCEPT
    iptables -A OUTPUT -o eth0 -d "$DNS_SERVER_IP" -p tcp --dport 53 -j ACCEPT
fi

echo "Allowing remote servers in configuration file..."
remote_port=$(grep "port " $CONFIG_FILE_MODIFIED | cut -d " " -f 2)
remote_proto=$(grep "proto " $CONFIG_FILE_MODIFIED | cut -d " " -f 2 | cut -c1-3)
remotes=$(grep "remote " $CONFIG_FILE_MODIFIED | cut -d " " -f 2-4)

echo "  Using:"
echo "$remotes" | while IFS= read line; do
    domain=$(echo "$line" | cut -d " " -f 1)
    port=$(echo "$line" | cut -d " " -f 2)
    proto=$(echo "$line" | cut -d " " -f 3 | cut -c1-3)

    # IPv4 address
    if [[ $domain =~ ^[0-9]+(\.[0-9]+){3}$ ]]
    then
        iptables -A OUTPUT -o eth0 -d $domain -p ${proto:-$remote_proto} --dport ${port:-$remote_port} -j ACCEPT
    # Hostname, lookup all IPv4 addresses
    else
        for ip in $(dig @$DNS_SERVER_IP -4 +short $domain); do
            echo "    $domain (IP:$ip PORT:$port)"
            iptables -A OUTPUT -o eth0 -d $ip -p ${proto:-$remote_proto} --dport ${port:-$remote_port} -j ACCEPT
        done
    fi
done

echo "Allowing connections over VPN interface..."
iptables -A INPUT -i tun0 -j ACCEPT
iptables -A OUTPUT -o tun0 -j ACCEPT

echo "Allowing connections over VPN interface to forwarded ports..."
if [ ! -z $FORWARDED_PORTS ]; then
    for port in ${FORWARDED_PORTS//,/ }; do
        if $(echo $port | grep -Eq '^[0-9]+$') && [ $port -ge 1024 ] && [ $port -le 65535 ]; then
            iptables -A INPUT -i tun0 -p tcp --dport $port -j ACCEPT
            iptables -A INPUT -i tun0 -p udp --dport $port -j ACCEPT
        else
            echo "WARNING: $port not a valid port. Ignoring."
        fi
    done
fi

echo "Preventing anything else..."
iptables -P INPUT DROP
iptables -P OUTPUT DROP
iptables -P FORWARD DROP

echo -e "iptables rules created and routes configured.\n"

echo -e "Running OpenVPN client.\n"
openvpn --auth-nocache --config $CONFIG_FILE_MODIFIED --verb $vpn_log_level --cd "$CONFIG_DIR" --pull-filter ignore "route-ipv6" --pull-filter ignore "ifconfig-ipv6" --up-restart &
openvpn_child=$!

wait $openvpn_child
