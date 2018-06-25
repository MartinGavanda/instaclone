#!/bin/bash

set -x
exec 2>/home/customization.log

echo -e "\n=== Start Pre-Freeze ==="

INTERFACE_NAME="eth0"
echo "Disabling ${INTERFACE_NAME} interface ..."
ip addr flush dev ${INTERFACE_NAME}
ip link set ${INTERFACE_NAME} down

echo -e "=== End of Pre-Freeze ===\n"

echo -e "Freezing ...\n"

vmware-rpctool "instantclone.freeze"

echo -e "\n=== Start Post-Freeze ==="

# retrieve VM customization info passed from vSphere API
HOSTNAME=$(vmware-rpctool "info-get guestinfo.ic.hostname")
IP_ADDRESS=$(vmware-rpctool "info-get guestinfo.ic.ipaddress")

echo "Updating IP Address ..."
cat > /etc/sysconfig/network-scripts/ifcfg-eth0 <<EOF

TYPE="Ethernet"
PROXY_METHOD="none"
BROWSER_ONLY="no"
BOOTPROTO="none"
DEFROUTE="yes"
IPV4_FAILURE_FATAL="no"
IPV6INIT="yes"
IPV6_AUTOCONF="yes"
IPV6_DEFROUTE="yes"
IPV6_FAILURE_FATAL="no"
IPV6_ADDR_GEN_MODE="stable-privacy"
NAME="eth0"
DEVICE="eth0"
ONBOOT="yes"
IPADDR="$IP_ADDRESS"
PREFIX="24"
GATEWAY="10.20.10.254"
DNS1="8.8.8.8"
IPV6_PRIVACY="no"
EOF

echo "Updating Hostname ..."
hostnamectl set-hostname ${HOSTNAME}

echo "Restart networking ..."
systemctl restart network

echo "Updating Hardware Clock on the system ..."
hwclock --hctosys

echo "=== End of Post-Freeze ==="

echo -e "\nCheck /home/customization.log for details\n\n"
[root@localhost ~]#
