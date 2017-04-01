#!/bin/bash

if [ ! -e /dev/sdb1 ]
then  
   sudo parted -s /dev/sdb mktable msdos
   sudo parted -s /dev/sdb mkpart primary 0 100%
   echo sdb1 created
else
   echo sdb1 already here
fi 

if sudo zpool list | grep -q green.*ONLINE
then
   echo green zpool already created
else
   echo createing zpool green
  sudo zpool create green /dev/sdb1 
fi

sudo zpool list -v
sudo zfs list 
