# -*- mode: ruby -*-
# vi: set ft=ruby :

eth_filter="enp0s8"

# remote client (server kod klijenta)
rcli_provision_shell = <<-SHELL

      if dpkg -s nginx 2>/dev/null 
      then 
         echo all installed 
      else
         # contains nginx mainline repos
         sudo cp /vagrant/apt/sources.list /etc/apt/sources.list 
         sudo apt-get update -y
         sudo add-apt-repository ppa:cipherdyne/fwknop -y
         sudo add-apt-repository ppa:jonathonf/golang -y
         sudo apt-get update -y
         sudo apt-get install fwknop-client -y
         sudo apt-get install golang-1.8 -y
         sudo apt-get install autossh sshpass nginx -y
         /usr/lib/go-1.8/bin/go get -v github.com/jpillora/chisel
      fi

      sudo sudo apt-key add /vagrant/nginx/nginx_signing.key
      cp /vagrant/fwknop-client/fwknoprc_${LOCAL_IP} /home/vagrant/.fwknoprc

      echo "fwknop -A tcp/22 --use-hmac -a ${LOCAL_IP} -n ${SERVER_IP}"
      fwknop -A tcp/22 --use-hmac -a ${LOCAL_IP} -n ${SERVER_IP}
      echo passwordless ssh srv1bout
      [ -f /home/vagrant/.ssh/id_rsa ] || ssh-keygen -P "" -C "test" -f /home/vagrant/.ssh/id_rsa
      sshpass -f /vagrant/ssh_password.txt ssh-copy-id -o StrictHostKeyChecking=no vagrant@${SERVER_IP}

      ssh vagrant@${SERVER_IP} uname -a
SHELL

# bringout workstation
ws_provision_shell = <<-SHELL

      if dpkg -s golang-1.8 2>/dev/null 
      then 
         echo all installed 
      else
         # contains nginx mainline repos
         sudo cp /vagrant/apt/sources.list /etc/apt/sources.list 
         sudo add-apt-repository ppa:cipherdyne/fwknop -y
         sudo add-apt-repository ppa:jonathonf/golang -y
         sudo apt-get update -y
         #sudo apt-get install fwknop-client -y
         sudo apt-get install golang-1.8 -y
         /usr/lib/go-1.8/bin/go get -v github.com/jpillora/chisel
      fi

      #na radnoj stanici bringout ne trebamo nginx, ni fknop client
      #sudo sudo apt-key add /vagrant/nginx/nginx_signing.key
      #cp /vagrant/fwknop-client/fwknoprc_${LOCAL_IP} /home/vagrant/.fwknoprc

      #echo "fwknop -A tcp/22 --use-hmac -a ${LOCAL_IP} -n ${SERVER_IP}"
      #fwknop -A tcp/22 --use-hmac -a ${LOCAL_IP} -n ${SERVER_IP}
      #echo passwordless ssh srv1bout
      #[ -f /home/vagrant/.ssh/id_rsa ] || ssh-keygen -P "" -C "test" -f /home/vagrant/.ssh/id_rsa
      #sshpass -f /vagrant/ssh_password.txt ssh-copy-id -o StrictHostKeyChecking=no vagrant@${SERVER_IP}

      #ssh vagrant@${SERVER_IP} uname -a
SHELL



rcli1_provision_shell = "SERVER_IP=192.168.56.150\nLOCAL_IP=192.168.56.201\necho $SERVER_IP, $LOCAL_IP\n" + rcli_provision_shell
rcli2_provision_shell = "SERVER_IP=192.168.56.150\nLOCAL_IP=192.168.56.202\necho $SERVER_IP, $LOCAL_IP\n" + rcli_provision_shell
wsbout1_provision_shell = "SERVER_IP=192.168.56.150\n" + ws_provision_shell


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

      if dpkg -s nginx 2>/dev/null 
      then 
         echo all installed 
      else
         sudo add-apt-repository ppa:cipherdyne/fwknop -y
         sudo add-apt-repository ppa:jonathonf/golang -y
         sudo add-apt-repository ppa:ondrej/nginx -y
         sudo apt-get update -y
         sudo apt-get install fwknop-server nginx -y
    
         sudo apt-get install golang-1.8 -y
         /usr/lib/go-1.8/bin/go get -v github.com/jpillora/chisel
         #/home/vagrant/go/bin/chisel --version
      fi

      sudo iptables -F
      sudo iptables -A INPUT -i #{eth_filter} -p tcp --dport 22 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
      sudo iptables -A INPUT -i #{eth_filter} -p tcp --dport 22 -j DROP

      sudo iptables -L INPUT -v

      sudo cp /vagrant/fwknop-server/default /etc/default/fwknop-server
      sudo cp /vagrant/fwknop-server/access.conf /etc/fwknop/access.conf
      sudo cp /vagrant/fwknop-server/fwknopd.conf /etc/fwknop/fwknopd.conf
      sudo chmod 0600 /etc/fwknop/*

      sudo service fwknop-server restart
      #journalctl -u fwknop-server.service
      sudo service fwknop-server status
      sudo iptables -L
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

    rcli1.vm.provision :shell, :privileged => false, 
                       inline: rcli1_provision_shell 
  end


  config.vm.define "rcli2" do |rcli2|
    rcli2.vm.box = "ubuntu-16.04"
    rcli2.vm.hostname = 'remote-client-2'

    rcli2.vm.network :private_network, ip: "192.168.56.202"

    rcli2.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 256+128 ]
      v.customize ["modifyvm", :id, "--name", "remote-client-2"]
    end

    rcli2.vm.provision :shell, :privileged => false, inline: rcli2_provision_shell
    
  end


  config.vm.define "wsbout1" do |ws|
    ws.vm.box = "ubuntu-16.04"
    ws.vm.hostname = 'bringout-ws-1'

    ws.vm.network :private_network, ip: "192.168.56.250"

    ws.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 256+128 ]
      v.customize ["modifyvm", :id, "--name", "bringout-ws-1"]
    end

    ws.vm.provision :shell, :privileged => false, inline: wsbout1_provision_shell
    
  end


end
