# -*- mode: ruby -*-
# vi: set ft=ruby :

# prva privatni eth device, njega filterisemo
eth_filter="enp0s8"

BOUT_DOMAIN="test.out.ba"
LAN_BOUT="192.168.56"
LAN_CLI1="192.168.1"
LAN_CLI2="192.168.2"
LAN_BOUT_INTERNAL="192.168.0"
LAN_VPN="10.0.200"

SRV1_BOUT=LAN_BOUT+".150"
SRV1_BOUT_INTERNAL=LAN_BOUT_INTERNAL+".150"

# remote client (server kod klijenta)
rcli_provision_shell = <<-SHELL
echo "hello remote client" 
hostname
SHELL


srv_bout_provision = <<-SHELL
echo "hello world from srv1bout"
SHELL




def set_ws_provision_shell( bout_ws )

# bringout workstation
ws_provision_shell = <<-SHELL
echo "hello bout_ws"
SHELL

return ws_provision_shell
end


def set_wscli_provision_shell( cli_no, ws_no )

# client workstation
ws_provision_shell = <<-SHELL
echo "hello world #{cli_no}, #{ws_no} "
SHELL

return ws_provision_shell
end

rcli1_provision_shell = "SERVER_IP=#{SRV1_BOUT}\nLOCAL_IP=192.168.56.201\necho $SERVER_IP, $LOCAL_IP\n" + rcli_provision_shell
rcli2_provision_shell = "SERVER_IP=#{SRV1_BOUT}\nLOCAL_IP=192.168.56.202\necho $SERVER_IP, $LOCAL_IP\n" + rcli_provision_shell

wsbout1_provision_shell = "SERVER_IP=#{SRV1_BOUT_INTERNAL}\n" + set_ws_provision_shell( "1" )
wsbout2_provision_shell = "SERVER_IP=#{SRV1_BOUT_INTERNAL}\n" + set_ws_provision_shell( "2" )

ws1cli1_provision_shell = set_wscli_provision_shell( "1", "1" )
ws1cli2_provision_shell = set_wscli_provision_shell( "2", "1" )

Vagrant.configure("2") do |config|

  # server 1 public cloud
  config.vm.define "srv1pubcloud" do | srv1pubcloud |
    srv1pubcloud.vm.box = "greenbox"
    srv1pubcloud.vm.hostname = 'pub-cloud-server-1'
    srv1pubcloud.vm.network :private_network, ip: LAN_BOUT+".100"
    srv1pubcloud.vm.network :private_network, ip: LAN_VPN+".254"


    srv1pubcloud.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 512]
      v.customize ["modifyvm", :id, "--name", "pub-cloud-server-1" ]
    end
  end


  # server 1 bringout cloud - data centar
  config.vm.define "srv1bout" do |srv|
    srv.vm.box = "greenbox"
    srv.vm.hostname = 'bout-server-1'

    #srv.persistent_storage.enabled = true
    #srv.persistent_storage.location = "srv1bout.vdi"
    #srv.vm.box_check_update = false

    srv.vm.network :private_network, ip: SRV1_BOUT
    srv.vm.network :private_network, ip: SRV1_BOUT_INTERNAL
    srv.vm.network :private_network, ip: LAN_VPN+".10"

    srv.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 512]
      v.customize ["modifyvm", :id, "--name", "bout-server-1" ]
    end

    srv.vm.provision :shell, :privileged => false,  inline: srv_bout_provision 

  end

 
  config.vm.define "rcli1" do |rcli|

    #rcli.persistent_storage.enabled = true
    #rcli.persistent_storage.location = "rcli1.vdi"
    #rcli.persistent_storage.filesystem = 'ext4'
    #rcli.persistent_storage.mountpoint = '/data'
    #rcli.vm.box_check_update = false

    rcli.vm.box = "greenbox"
    rcli.vm.hostname = 'remote-client-1'

    rcli.vm.network :private_network, ip: LAN_BOUT + ".201"
    rcli.vm.network :private_network, ip: LAN_CLI1 + ".201"
    rcli.vm.network :private_network, ip: LAN_VPN+".101"
    rcli.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 256+128 ]
      v.customize ["modifyvm", :id, "--name", "remote-client-1"]
    end

    rcli.vm.provision :shell, :privileged => false, 
                       inline: rcli1_provision_shell 
  end


  config.vm.define "rcli2" do |rcli|
    rcli.vm.box = "greenbox"
    rcli.vm.hostname = 'remote-client-2'

    #rcli.persistent_storage.enabled = true
    #rcli.persistent_storage.location = "rcli2.vdi"
    #rcli.persistent_storage.filesystem = 'ext4'
    #rcli.persistent_storage.mountpoint = '/data'
    #rcli.vm.box_check_update = false

    rcli.vm.network :private_network, ip: LAN_BOUT + ".202"
    rcli.vm.network :private_network, ip: LAN_CLI2 + ".202"
    rcli.vm.network :private_network, ip: LAN_VPN+".102"

    rcli.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 384 ]
      v.customize ["modifyvm", :id, "--name", "remote-client-2"]
    end
    rcli.vm.provision :shell, :privileged => false, inline: rcli2_provision_shell
    
  end


  config.vm.define "wsbout1" do |ws|
    ws.vm.box = "greenbox"
    ws.vm.hostname = 'bringout-ws-1'

    ws.vm.network :private_network, ip: LAN_BOUT_INTERNAL + ".201"   #, netmask: "24"
    ws.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 512 ]
      v.customize ["modifyvm", :id, "--name", "bringout-ws-1"]
    end
    ws.vm.provision :shell, :privileged => false, inline: wsbout1_provision_shell
    
  end

  config.vm.define "wsbout2" do |ws|
    ws.vm.box = "greenbox"
    ws.vm.hostname = 'bringout-ws-2'

    ws.vm.network :private_network, ip: LAN_BOUT_INTERNAL + ".202"   #, netmask: "24"
    ws.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 384 ]
      v.customize ["modifyvm", :id, "--name", "bringout-ws-2"]
    end
    ws.vm.provision :shell, :privileged => false, inline: wsbout2_provision_shell
    
  end



  config.vm.define "ws1cli1" do |ws|
    ws.vm.box = "greenbox"
    ws.vm.hostname = 'ws-1-cli-1'

    ws.vm.network :private_network, ip: LAN_CLI1 + ".101"  #, netmask: "24"
    ws.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 384 ]
      v.customize ["modifyvm", :id, "--name", "ws-1-cli-1"]
      v.customize ["modifyvm", :id, "--vrdeport", 50001 ]
    end
    ws.vm.provision :shell, :privileged => false, inline: ws1cli1_provision_shell
  end


  config.vm.define "ws1cli2" do |ws|
    ws.vm.box = "greenbox"
    ws.vm.hostname = 'ws-1-cli-2'

    ws.vm.network :private_network, ip: LAN_CLI2 + ".101"  #, netmask: "24"
    ws.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--memory", 384 ]
      v.customize ["modifyvm", :id, "--name", "ws-1-cli-2"]
      v.customize ["modifyvm", :id, "--vrdeport", 50001 ]
    end
    ws.vm.provision :shell, :privileged => false, inline: ws1cli2_provision_shell
  end


end
