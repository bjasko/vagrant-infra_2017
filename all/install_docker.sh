#!/bin/bash

if dpkg -s docker-ce > /dev/null
then
  echo docker already installed
#  exit 0
fi

sudo apt-get install \
	apt-transport-https \
	ca-certificates \
	curl \
	software-properties-common -y

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -


sudo apt-key fingerprint 0EBFCD88


sudo add-apt-repository \
    "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
     $(lsb_release -cs) \
     stable" -y


sudo apt-get update -y
sudo apt-get install docker-ce -y


sudo apt-get install python-pip -y
sudo pip install --upgrade pip 
sudo pip uninstall -y docker docker-py
sudo pip install docker docker-compose

docker --version
docker-compose --version

sudo service docker start
sudo service docker status
