#!/bin/bash

echo ==== setup ubuntu desktop ====
cd /vagrant/ubuntu-desktop-16.04

# https://askubuntu.com/questions/426831/lxde-auto-login
sudo cp -av  lightdm.conf /etc/lightdm/

cp -av *.desktop ~/Desktop/
