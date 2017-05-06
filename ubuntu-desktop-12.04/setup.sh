#!/bin/bash

echo ==== setup ubuntu desktop ====
cd /vagrant/ubuntu-desktop-16.04

# https://askubuntu.com/questions/426831/lxde-auto-login

sudo cp -av  lightdm.conf /etc/lightdm/
#sudo service lightdm restart

if [ ! -f /home/vagrant/Desktop/lxterminal.desktop ]
then

  [ -d /home/vagrant/Desktop ] || mkdir /home/vagrant/Desktop
  cp -av *.desktop /home/vagrant/Desktop/

  #echo ".... first start - reboot needed ...."
  #sudo systemctl stop lightdm.service
  #sudo systemctl start lightdm.service
  #sudo killall Xorg 
  #sudo reboot -d 2
fi
