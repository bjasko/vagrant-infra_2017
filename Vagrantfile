Vagrant.configure("2") do |config|

  # server 1 public cloud
  config.vm.define "srv1pubcloud" do | srv1pubcloud |
    srv1pubcloud.vm.box = "ubuntu-16.04"
    srv1pubcloud.vm.hostname = 'pub-cloud-server-1'

    srv1pubcloud.vm.network :private_network, ip: "192.168.56.100"

    srv1pubcloud.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
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
      #v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 512]
      v.customize ["modifyvm", :id, "--name", "bout-server-1" ]
    end

    srv1bout.vm.provision :shell, inline: <<-SHELL
    SHELL

  end


  config.vm.define "rcli1" do |rcli1|
    rcli1.vm.box = "ubuntu-16.04"
    rcli1.vm.hostname = 'remote-client-1'

    rcli1.vm.network :private_network, ip: "192.168.56.201"

    rcli1.vm.provider :virtualbox do |v|
      #v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 256+128 ]
      v.customize ["modifyvm", :id, "--name", "remote-client-1"]
    end
  end

  config.vm.define "rcli2" do |rcli2|
    rcli2.vm.box = "ubuntu-16.04"
    rcli2.vm.hostname = 'remote-client-2'

    rcli2.vm.network :private_network, ip: "192.168.56.202"

    rcli2.vm.provider :virtualbox do |v|
      #v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 256+128 ]
      v.customize ["modifyvm", :id, "--name", "remote-client-2"]
    end
  end


end
