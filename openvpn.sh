#!/bin/sh
set -x

# Default values
: ${OPENVPN_MTU:=1450}
: ${OPENVPN_TXQLEN:=1000}
: ${OPENVPN_DEV:=tun0}
: ${OPENVPN_IP_LOCAL:=10.0.0.1}
: ${OPENVPN_IP_PEER:=10.0.0.2}
: ${OPENVPN_CONFIG:=openvpn.conf}

echo "Configuring ${OPENVPN_DEV}"
ip tuntap add ${OPENVPN_DEV} mode tun
ip addr add ${OPENVPN_IP_LOCAL} peer ${OPENVPN_IP_PEER} dev ${OPENVPN_DEV}
ip link set ${OPENVPN_DEV} mtu ${OPENVPN_MTU}
ip link set ${OPENVPN_DEV} txqueuelen ${OPENVPN_TXQLEN}
ip link set ${OPENVPN_DEV} up
echo "Configuration done"

iptables -w -t nat -A POSTROUTING -o eth0 -s ${OPENVPN_IP_PEER} -j MASQUERADE

exec /usr/sbin/openvpn /etc/openvpn/${OPENVPN_CONFIG}
