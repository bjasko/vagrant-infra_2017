# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  # server 1 public cloud
  config.vm.define "srv1pubcloud" do | srv1pubcloud |
    srv1pubcloud.vm.box = "ubuntu-16.04"
    srv1pubcloud.vm.hostname = 'pub-cloud-server-1'

    srv1pubcloud.vm.network :private_network, ip: "192.168.56.100"

    srv1pubcloud.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 512]
      v.customize ["modifyvm", :id, "--name", "pub-cloud-server-1" ]
    end
  end


  # server 1 bringout cloud - data centar
  config.vm.define "srv1bout" do |srv1bout|
    srv1bout.vm.box = "ubuntu-16.04"
    srv1bout.vm.hostname = 'bout-server-1'

    srv1bout.vm.network :private_network, ip: "192.168.56.150"

    srv1bout.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 512]
      v.customize ["modifyvm", :id, "--name", "bout-server-1" ]
    end

    srv1bout.vm.provision :shell, :privileged => false,  inline: <<-SHELL
      sudo add-apt-repository ppa:cipherdyne/fwknop -y
      sudo add-apt-repository ppa:jonathonf/golang -y
      sudo add-apt-repository ppa:ondrej/nginx -y
      sudo apt-get update -y
      sudo apt-get install fwknop-server nginx -y
    
      sudo apt-get install golang-1.8 -y
      /usr/lib/go-1.8/bin/go get -v github.com/jpillora/chisel
      #/home/vagrant/go/bin/chisel --version

    SHELL

  end


  config.vm.define "rcli1" do |rcli1|
    rcli1.vm.box = "ubuntu-16.04"
    rcli1.vm.hostname = 'remote-client-1'

    rcli1.vm.network :private_network, ip: "192.168.56.201"

    rcli1.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 256+128 ]
      v.customize ["modifyvm", :id, "--name", "remote-client-1"]
    end

    rcli1.vm.provision :shell, :privileged => false, inline: <<-SHELL
      sudo add-apt-repository ppa:cipherdyne/fwknop -y
      sudo add-apt-repository ppa:jonathonf/golang -y
      sudo add-apt-repository ppa:ondrej/nginx -y

      sudo apt-get update -y
      sudo apt-get install fwknop-client autossh sshpass nginx -y
      sudo apt-get install golang-1.8 -y

      /usr/lib/go-1.8/bin/go get -v github.com/jpillora/chisel
      #/home/vagrant/go/bin/chisel --version

      echo passwordless ssh srv1bout
      shpass -f /vagrant/ssh_password.txt ssh-copy-id vagrant@192.168.56.150

    SHELL


  end


  config.vm.define "rcli2" do |rcli2|
    rcli2.vm.box = "ubuntu-16.04"
    rcli2.vm.hostname = 'remote-client-2'

    rcli2.vm.network :private_network, ip: "192.168.56.202"

    rcli2.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 256+128 ]
      v.customize ["modifyvm", :id, "--name", "remote-client-2"]
    end

    rcli2.vm.provision :shell, :privileged => false, inline: <<-SHELL

      if dpkg -s nginx 2>/dev/null 
      then 
         echo all installed 
      else
         sudo add-apt-repository ppa:cipherdyne/fwknop -y
         sudo add-apt-repository ppa:jonathonf/golang -y
         sudo add-apt-repository ppa:ondrej/nginx -y
         sudo apt-get update -y
         sudo apt-get install fwknop-client -y
         sudo apt-get install golang-1.8 -y
         sudo apt-get install autossh sshpass nginx -y
         /usr/lib/go-1.8/bin/go get -v github.com/jpillora/chisel
      fi

      echo passwordless ssh srv1bout
      [ -f /home/vagrant/.ssh/id_rsa ] || ssh-keygen -P "" -C "test" -f /home/vagrant/.ssh/id_rsa
      sshpass -f /vagrant/ssh_password.txt ssh-copy-id -o StrictHostKeyChecking=no vagrant@192.168.56.150

      ssh vagrant@192.168.56.150 uname -a

    SHELL


  end


end
