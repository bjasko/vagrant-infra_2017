echo "====F18 requirements===="
sudo apt-get -y -q update & sudo apt-get -y -q install  postgresql-client

echo "====F18 install===="
mkdir -p ~/f18
cd ~/f18
tar xvfz /tmp/f18_linux_install.tgz .

exit 0
