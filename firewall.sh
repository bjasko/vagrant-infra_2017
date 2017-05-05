#!/bin/bash

echo "==== setup routes `hostname` ====="

#LAN_VPN="10.0.200"
if !  ip addr show | grep -q 10.0.200
then
  echo "`hostname` zabrana VPN saobracaja"
  ip route add 10.0.200.0/24 via 127.0.0.1
fi

#LAN_BOUT="192.168.56"
if !  ip addr show | grep -q 192.168.56
then
  echo "`hostname` zabrana LAN_BOUT saobracaja"
  ip route add 192.168.56.0/24 via 127.0.0.1
fi

#LAN_CLI1="192.168.1"
if !  ip addr show | grep -q 192.168.1
then
  echo "`hostname` zabrana LAN_CLI1 saobracaja"
  ip route add 192.168.1.0/24 via 127.0.0.1
fi


#LAN_CLI2="192.168.2"
if !  ip addr show | grep -q 192.168.2
then
  echo "`hostname` zabrana LAN_CLI2 saobracaja"
  ip route add 192.168.2.0/24 via 127.0.0.1
fi


#LAN_BOUT_INTERNAL="192.168.0"
if !  ip addr show | grep -q 192.168.0
then
  echo "`hostname` zabrana LAN_BOUT_INTERNAL saobracaja"
  ip route add 192.168.0.0/24 via 127.0.0.1
fi


