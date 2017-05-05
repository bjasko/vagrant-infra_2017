#!/bin/bash

echo "==== setup routes `hostname` ====="
if !  ip addr show | grep -q 10.0.200
then
  echo "`hostname` zabrana VPN saobracaja"
  ip route add 10.0.200.0/24 via 127.0.0.1
fi

