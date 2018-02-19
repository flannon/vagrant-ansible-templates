# -*- mode: ruby -*-
# vi: set ft=ruby :

VAGRANTROOT = File.dirname(__FILE__)

VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos/7"
  config.vm.network :private_network, ip: "192.168.33.39"
  config.ssh.insert_key = false

  config.vm.provider :virtualbox do |v|
    v.name = "docker.dev"
    v.memory = 1024
    v.cpus = 2
    v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    v.customize ["modifyvm", :id, "--ioapic", "on"]
  end

  config.vm.provision :shell, inline: "yum -y install ansible"

  # Set ansible roles environment variable
  ENV['ANSIBLE_ROLES_PATH'] = "#{VAGRANTROOT}/provisioning/roles"

  # Run ansible provisioning 
  config.vm.provision :ansible do |ansible|
    ansible.verbose = "v"
    ansible.config_file = "provisioning/ansible.cfg"
    ansible.playbook = "provisioning/main.yml"
  end

end
