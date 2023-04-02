Vagrant.configure("2") do |config|

    config.vm.define "db01" do |db01|
      db01.vm.box = "ubuntu/focal64"
      db01.vm.hostname = "Databaseserver01"
      db01.vm.network "private_network", ip: "192.168.56.30"
  
      db01.vm.provider "virtualbox" do |db01|
        db01.name = "Databaseserver01"
        db01.memory = 3000
      end
      db01.ssh.insert_key = false
      db01.ssh.private_key_path = [ '/.ssh/id_rsa', '~/.vagrant.d/insecure_private_key' ]
      db01.ssh.forward_agent = true
      db01.vm.provision "shell" do |s|
      ssh_pub_key = File.readlines("/media/bart/Vagrant/IAC/.ssh/id_rsa.pub").first.strip
      s.inline = <<-SHELL
      echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
      echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
      SHELL
      end
  
      db01.vm.provision "ansible" do |ansible|
          ansible.playbook = "playbook.yml"
          ansible.inventory_path = "/media/bart/Vagrant/IAC/inventory.yml"
      end
    end
    
    aantalWebservers = 4
    (1..aantalWebservers).each do |i|
      config.vm.define "web0#{i}" do |node|
        node.vm.box = "ubuntu/jammy64"
        node.vm.hostname = "Webserver0#{i}"
        node.vm.network "private_network", ip: "192.168.56.1#{i}"
  
        node.vm.provider "virtualbox" do |node|
      node.name = "Webserver0#{i}"
      node.memory = 2048
        end
        node.ssh.insert_key = false
        node.ssh.private_key_path = [ '/.ssh/id_rsa', '~/.vagrant.d/insecure_private_key' ]
        node.ssh.forward_agent = true
        node.vm.provision "shell" do |s|
        ssh_pub_key = File.readlines("/media/bart/Vagrant/IAC/.ssh/id_rsa.pub").first.strip
        s.inline = <<-SHELL
        echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
        echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
        SHELL
        end
  
        node.vm.provision "ansible" do |ansible|
        ansible.playbook = "playbook.yml"
        ansible.inventory_path = "/media/bart/Vagrant/IAC/inventory.yml"
        end
      end
    end 
  
    config.vm.define "lb01" do |lb01|
      lb01.vm.box = "ubuntu/jammy64"
      lb01.vm.hostname = "Loadbalancer01"
      lb01.vm.network "private_network", ip: "192.168.56.20"
  
      lb01.vm.provider "virtualbox" do |lb01|
        lb01.name = "Loadbalancer01"
        lb01.memory = 2048
      end
      lb01.ssh.insert_key = false
      lb01.ssh.private_key_path = [ '/.ssh/id_rsa', '~/.vagrant.d/insecure_private_key' ]
      lb01.ssh.forward_agent = true
      lb01.vm.provision "shell" do |s|
      ssh_pub_key = File.readlines("/media/bart/Vagrant/IAC/.ssh/id_rsa.pub").first.strip
      s.inline = <<-SHELL
      echo #{ssh_pub_key} >> /home/vagrant/.ssh/authorized_keys
      echo #{ssh_pub_key} >> /root/.ssh/authorized_keys
      SHELL
      end
  
      lb01.vm.provision "ansible" do |ansible|
          ansible.playbook = "playbook.yml"
      ansible.inventory_path = "/media/bart/Vagrant/IAC/inventory.yml"
      end
    end
  end
