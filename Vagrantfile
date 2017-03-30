# -*- mode: ruby -*-
# vi: set ft=ruby :

# prva privatni eth device, njega filterisemo
eth_filter="enp0s8"

BOUT_DOMAIN="test.out.ba"
LAN_BOUT="192.168.56"
LAN_CLI1="192.168.1"
LAN_CLI2="192.168.2"
LAN_BOUT_INTERNAL="192.168.0"

SRV1_BOUT=LAN_BOUT+".150"
SRV1_BOUT_INTERNAL=LAN_BOUT_INTERNAL+".150"

# remote client (server kod klijenta)
rcli_provision_shell = <<-SHELL

      if dpkg -s nginx 2>/dev/null 
      then 
         echo all installed 
      else
         # contains nginx mainline repos
         sudo cp /vagrant/apt/sources.list /etc/apt/sources.list 
         sudo sudo apt-key add /vagrant/nginx/nginx_signing.key
         sudo apt-get update -y
         sudo add-apt-repository ppa:cipherdyne/fwknop -y
         sudo add-apt-repository ppa:jonathonf/golang -y
         sudo apt-get update -y
         sudo apt-get install fwknop-client -y
         sudo apt-get install golang-1.8 -y
         sudo apt-get install autossh sshpass nginx postgresql -y
         /usr/lib/go-1.8/bin/go get -v github.com/jpillora/chisel
      fi

      cp /vagrant/fwknop-client/fwknoprc_${LOCAL_IP} /home/vagrant/.fwknoprc

      echo "fwknop -A tcp/22 --use-hmac -a ${LOCAL_IP} -n ${SERVER_IP}"
      fwknop -A tcp/22 --use-hmac -a ${LOCAL_IP} -n ${SERVER_IP}
      echo passwordless ssh srv1bout
      [ -f /home/vagrant/.ssh/id_rsa ] || ssh-keygen -P "" -C "test" -f /home/vagrant/.ssh/id_rsa
      sshpass -f /vagrant/ssh_password.txt ssh-copy-id -o StrictHostKeyChecking=no vagrant@${SERVER_IP}

      ssh vagrant@${SERVER_IP} uname -a


      echo "Updating nginx configuration"
      sudo cp /vagrant/nginx/nginx.conf /etc/nginx/nginx.conf
      case $LOCAL_IP in
        *201) 
	   echo "chisel rcli1"
           sudo cp -av /vagrant/nginx/conf.d/chisel-rcli1.conf  /etc/nginx/conf.d/chisel-rcli1.conf 
           ;;
        *202) 
	   echo "chisel rcli2"
           sudo cp -av /vagrant/nginx/conf.d/chisel-rcli2.conf  /etc/nginx/conf.d/chisel-rcli2.conf 
           ;;
        *) 
           echo "nepostejeci remote client?" 
           ;;
      esac
      sudo service nginx restart
      sudo service nginx status

      sudo su postgres -c "psql < /vagrant/psql/psql_set_password"
      sudo su postgres -c "psql -h localhost -U postgres -W postgres < /vagrant/psql/psql_list_databases"


SHELL

def set_ws_provision_shell( bout_ws )

# bringout workstation
ws_provision_shell = <<-SHELL

      if dpkg -s golang-1.8 2>/dev/null && dpkg -s pogresql-client>/dev/null 
      then 
         echo all installed 
      else
         # contains nginx mainline repos
         sudo cp /vagrant/apt/sources.list /etc/apt/sources.list 
         sudo sudo apt-key add /vagrant/nginx/nginx_signing.key
         sudo add-apt-repository ppa:cipherdyne/fwknop -y
         sudo add-apt-repository ppa:jonathonf/golang -y
         sudo apt-get update -y
         #sudo apt-get install fwknop-client -y
         sudo apt-get install golang-1.8 postgresql-client -y
         /usr/lib/go-1.8/bin/go get -v github.com/jpillora/chisel
      fi

      #na radnoj stanici bringout ne trebamo nginx, ni fknop client
      #cp /vagrant/fwknop-client/fwknoprc_${LOCAL_IP} /home/vagrant/.fwknoprc

      #echo "fwknop -A tcp/22 --use-hmac -a ${LOCAL_IP} -n ${SERVER_IP}"
      #fwknop -A tcp/22 --use-hmac -a ${LOCAL_IP} -n ${SERVER_IP}
      #echo passwordless ssh srv1bout
      #[ -f /home/vagrant/.ssh/id_rsa ] || ssh-keygen -P "" -C "test" -f /home/vagrant/.ssh/id_rsa
      #sshpass -f /vagrant/ssh_password.txt ssh-copy-id -o StrictHostKeyChecking=no vagrant@${SERVER_IP}

      #ssh vagrant@${SERVER_IP} uname -a

      echo namjerno rutu LAN_BOUT: #{LAN_BOUT} disableujemo na radnim stanicama
      echo tako da smo sigurno da one samo preko internog lan-a #{LAN_BOUT_INTERNAL} komuniciraju sa serverom
      echo "#!/bin/sh" > /tmp/rc.local
      echo "ip route add #{LAN_BOUT}.0/24 dev enp0s8" >> /tmp/rc.local
      echo "echo end of rc.local" >> /tmp/rc.local
      sudo mv /tmp/rc.local /etc/rc.local
      sudo chmod +x /etc/rc.local
      sudo /etc/rc.local

      # dok nemamo dns-a, podesavamo /etc/hosts
      echo "127.0.0.1  bringout-ws-#{bout_ws}" > /tmp/hosts.file

      # start_chisel.sh pravi link via http/webproxy sa remote klijentskim servisima
      echo "#!/bin/bash" > /tmp/start_chisel.sh
      echo "killall chisel" >> /tmp/start_chisel.sh

      echo "127.0.0.1       localhost" >> /tmp/hosts.file
      echo "::1     localhost ip6-localhost ip6-loopback" >> /tmp/hosts.file
      echo "ff02::1 ip6-allnodes" >> /tmp/hosts.file
      echo "ff02::2 ip6-allrouters" >> /tmp/hosts.file
      for cli_no in 1 2
      do
	  echo "#{SRV1_BOUT_INTERNAL} remote-client-${cli_no} remote-client-${cli_no}.#{BOUT_DOMAIN}"  >> /tmp/hosts.file
	  echo "echo \"na localhostu se aktiviraju portovi  220${cli_no} - ssh, 520${cli_no} - psql za pristup remote-client-${cli_no}\"" >> /tmp/start_chisel.sh
	  echo "echo \"test servisa:\"" >> /tmp/start_chisel.sh
          echo "echo \"psql -p 520${cli_no} -h localhost -U postgres -W postgres\"" >> /tmp/start_chisel.sh
          echo "echo \"postgresql password: test01\"" >> /tmp/start_chisel.sh
          echo "echo \"ssh -p 220${cli_no} vagrant@localhost\"" >> /tmp/start_chisel.sh
	  echo "~/go/bin/chisel client http://remote-client-${cli_no}.#{BOUT_DOMAIN} 220${cli_no}:22 520${cli_no}:5432>/tmp/chisel.log &" >> /tmp/start_chisel.sh
      done
      sudo mv /tmp/hosts.file /etc/hosts

      mv /tmp/start_chisel.sh /home/vagrant/
      chmod +x /home/vagrant/start_chisel.sh

SHELL

return ws_provision_shell
end


def set_wscli_provision_shell( cli_no, ws_no )

# client workstation
ws_provision_shell = <<-SHELL

      if dpkg -s golang-1.8 2>/dev/null && dpkg -s pogresql-client>/dev/null 
      then 
         echo all installed 
      else
         # contains nginx mainline repos
         sudo cp /vagrant/apt/sources.list /etc/apt/sources.list 
         sudo sudo apt-key add /vagrant/nginx/nginx_signing.key
         sudo add-apt-repository ppa:jonathonf/golang -y
         sudo apt-get update -y
         sudo apt-get install golang-1.8 postgresql-client -y
         /usr/lib/go-1.8/bin/go get -v github.com/jpillora/chisel
      fi

      echo namjerno rute LAN_BOUT: #{LAN_BOUT}, kao i lan drugih klijenata disableujemo na radnim stanicama
      echo tako da smo sigurno da one samo preko internog lan-a #{LAN_BOUT_INTERNAL} komuniciraju sa serverom
      echo "#!/bin/sh" > /tmp/rc.local
      echo "ip route add #{LAN_BOUT}.0/24 dev enp0s8" >> /tmp/rc.local
      echo "ip route add #{LAN_BOUT_INTERNAL}.0/23 dev enp0s8" >> /tmp/rc.local
      if [ "#{cli_no}" == "1" ] ; then
       echo "ip route add #{LAN_CLI2}.0/24 dev enp0s8" >> /tmp/rc.local
      else
       echo "ip route add #{LAN_CLI1}.0/24 dev enp0s8" >> /tmp/rc.local
      fi
      echo "echo end of rc.local" >> /tmp/rc.local
      sudo mv /tmp/rc.local /etc/rc.local
      sudo chmod +x /etc/rc.local
      sudo /etc/rc.local

      # dok nemamo dns-a, podesavamo /etc/hosts
      echo "127.0.0.1  ws-#{ws_no}-client-#{cli_no}" > /tmp/hosts.file

      # start_chisel.sh pravi link via http/webproxy sa remote klijentskim servisima
      echo "#!/bin/bash" > /tmp/start_chisel.sh
      echo "killall chisel" >> /tmp/start_chisel.sh

      echo "127.0.0.1       localhost" >> /tmp/hosts.file
      echo "::1     localhost ip6-localhost ip6-loopback" >> /tmp/hosts.file
      echo "ff02::1 ip6-allnodes" >> /tmp/hosts.file
      echo "ff02::2 ip6-allrouters" >> /tmp/hosts.file
      sudo mv /tmp/hosts.file /etc/hosts

      mv /tmp/start_chisel.sh /home/vagrant/
SHELL

return ws_provision_shell
e
end

rcli1_provision_shell = "SERVER_IP=#{SRV1_BOUT}\nLOCAL_IP=192.168.56.201\necho $SERVER_IP, $LOCAL_IP\n" + rcli_provision_shell
rcli2_provision_shell = "SERVER_IP=#{SRV1_BOUT}\nLOCAL_IP=192.168.56.202\necho $SERVER_IP, $LOCAL_IP\n" + rcli_provision_shell

wsbout1_provision_shell = "SERVER_IP=#{SRV1_BOUT_INTERNAL}\n" + set_ws_provision_shell( "1" )
wsbout2_provision_shell = "SERVER_IP=#{SRV1_BOUT_INTERNAL}\n" + set_ws_provision_shell( "2" )

ws1cli1_provision_shell = set_wscli_provision_shell( "1", "1" )

Vagrant.configure("2") do |config|

  # server 1 public cloud
  config.vm.define "srv1pubcloud" do | srv1pubcloud |
    srv1pubcloud.vm.box = "ubuntu-16.04"
    srv1pubcloud.vm.hostname = 'pub-cloud-server-1'
    srv1pubcloud.vm.network :private_network, ip: LAN_BOUT+".100"

    srv1pubcloud.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 512]
      v.customize ["modifyvm", :id, "--name", "pub-cloud-server-1" ]
    end
  end


  # server 1 bringout cloud - data centar
  config.vm.define "srv1bout" do |srv1bout|
    srv1bout.vm.box = "ubuntu-16.04"
    srv1bout.vm.hostname = 'bout-server-1'

    srv1bout.vm.network :private_network, ip: SRV1_BOUT, netmask: "24"
    srv1bout.vm.network :private_network, ip: SRV1_BOUT_INTERNAL, netmask: "24"

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

      echo "#/bin/sh" > /tmp/rc.local
      echo "iptables -F" >> /tmp/rc.local
      echo "iptables -A INPUT -i #{eth_filter} -p tcp --dport 22 -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT" >> /tmp/rc.local
      echo "iptables -A INPUT -i #{eth_filter} -p tcp --dport 22 -j DROP" >> /tmp/rc.local
      sudo mv /tmp/rc.local /etc/rc.local
      sudo chmod +x /etc/rc.local
 
      sudo /etc/rc.local
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

    rcli1.vm.network :private_network, ip: LAN_BOUT + ".201"
    rcli1.vm.network :private_network, ip: LAN_CLI1 + ".201"
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

    rcli2.vm.network :private_network, ip: LAN_BOUT + ".202"
    rcli1.vm.network :private_network, ip: LAN_CLI2 + ".202"

    rcli2.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 256+128 ]
      v.customize ["modifyvm", :id, "--name", "remote-client-2"]
    end
    rcli2.vm.provision :shell, :privileged => false, inline: rcli2_provision_shell
    
  end


  config.vm.define "wsbout1" do |ws|
    ws.vm.box = "ubuntu-16.04"
    ws.vm.hostname = 'bringout-ws-1'

    ws.vm.network :private_network, ip: LAN_BOUT_INTERNAL + ".201", netmask: "24"
    ws.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 256+128 ]
      v.customize ["modifyvm", :id, "--name", "bringout-ws-1"]
    end
    ws.vm.provision :shell, :privileged => false, inline: wsbout1_provision_shell
    
  end

  config.vm.define "wsbout2" do |ws|
    ws.vm.box = "ubuntu-16.04"
    ws.vm.hostname = 'bringout-ws-2'

    ws.vm.network :private_network, ip: LAN_BOUT_INTERNAL + ".202", netmask: "24"
    ws.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 256+128 ]
      v.customize ["modifyvm", :id, "--name", "bringout-ws-2"]
    end
    ws.vm.provision :shell, :privileged => false, inline: wsbout2_provision_shell
    
  end



  config.vm.define "ws1cli1" do |ws|
    ws.vm.box = "ubuntu-16.04"
    ws.vm.hostname = 'ws-1-cli-1'

    ws.vm.network :private_network, ip: LAN_CLI1 + ".101", netmask: "24"
    ws.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 256 ]
      v.customize ["modifyvm", :id, "--name", "ws-1-cli-1"]
    end
    ws.vm.provision :shell, :privileged => false, inline: ws1cli1_provision_shell
    
  end


end
