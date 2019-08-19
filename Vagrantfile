# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 2.0.1"

HOSTNAME = "templates"
ANSIBLEROLE = "#{HOSTNAME}"
IPADDR = "172.39.144.59"
CPUS = "2"
MEMORY = "1024"
MULTIVOL = false
MOUNTPOINT = "/mnt"
VAGRANTROOT = File.expand_path(File.dirname(__FILE__))
VAGRANTFILE_API_VERSION = "2"

# Ensure vagrant plugins
required_plugins = %w( vagrant-vbguest vagrant-scp vagrant-share vagrant-persistent-storage vagrant-reload )

required_plugins.each do |plugin|
  exec "vagrant plugin install #{plugin};vagrant #{ARGV.join(" ")}" unless Vagrant.has_plugin? plugin || ARGV[0] == 'plugin'
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|

  config.vm.box = "centos/7"
  config.ssh.insert_key = false
  config.vm.network :private_network, ip: IPADDR,
    virtualbox__hostonly: true
  config.vm.network :forwarded_port, guest: 80, host: 10080,
    virtualbox__hostonly: true
  config.vm.network :forwarded_port, guest: 443, host: 10443,
    virtualbox__hostonly: true
  config.vm.network :forwarded_port, guest: 8052, host: 10052,
    virtualbox__hostonly: true

  config.vm.provider :virtualbox do |vb|
    vb.name = HOSTNAME
    vb.memory = MEMORY
    vb.cpus = CPUS
    if CPUS != "1"
      vb.customize ["modifyvm", :id, "--ioapic", "on"]
    end
    vb.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
    vb.linked_clone = true if Vagrant::VERSION =~ /^1.8/
  end

  config.vm.hostname = HOSTNAME + ".local"
  # I was having trouble with the sync folder.  I never really figured
  # out what the issue was.  The follwoign lines are left in place
  # for the moment in case it crops up again.
  # 
  #config.vm.synced_folder "#{VAGRANTROOT}", "/vagrant-#{HOSTNAME}"
  #config.vm.synced_folder "#{VAGRANTROOT}", "/vagrant"
  #config.vm.provision :shell, inline: "rm -rf --one-file-system /vagrant"
  #config.vm.provision :shell, inline: "[[ -d /vagrant ]] && mv -fnu /vagrant /vagrant-BADSYNC"
  #config.vm.provision :shell, inline: "ln -s /vagrant-#{HOSTNAME}/ /vagrant"
  config.vm.provision :shell, inline: "yum -y install ansible"
  config.vm.provision "file", 
    source: "~/.gitconfig", 
    destination: ".gitconfig"

  # Disable selinux and reboot
  unless FileTest.exist?("./untracked-files/first_boot_complete")
    config.vm.provision :shell, inline: "yum -y update"
    config.vm.provision :shell, inline: "sed -i s/^SELINUX=enforcing/SELINUX=permissive/ /etc/selinux/config"
    config.vm.provision :reload
    #config.vm.synced_folder ".", "/vagrant"
    require 'fileutils'
    FileUtils.touch("#{VAGRANTROOT}/untracked-files/first_boot_complete")
  end

  # Install git and wget
  config.vm.provision :shell, inline: "yum -y install git wget"
  # Load bashrc
  config.vm.provision "file", source: "#{VAGRANTROOT}/files/bashrc", 
     destination: "${HOME}/.bashrc"
  config.vm.provision "file", source: "#{VAGRANTROOT}/files/bashrc", 
    destination: "/home/vagrant/.bashrc"

  # Load ssh keys
  config.vm.provision "file", source: "#{VAGRANTROOT}/files/vagrant", 
    destination: "/home/vagrant/.ssh/id_rsa"
  config.vm.provision :file, source: "#{VAGRANTROOT}/files/vagrant.pub", 
    destination: "/home/vagrant/.ssh/id_rsa.pub"
  
  # Load /etc/hosts
  config.vm.provision "shell", path: "./bin/hosts.sh", privileged: true
  
  config.vm.define HOSTNAME

  # Load ansible config to ~vagrant on the guest
  config.vm.provision "file", 
    source: "#{VAGRANTROOT}/ansible/ansible.cfg", 
    destination: "~vagrant/ansible.cfg"

  config.vm.provision "file", 
    source: "#{VAGRANTROOT}/ansible/inventory", 
    destination: "~vagrant/inventory"

  config.vm.provision "file", 
    source: "#{VAGRANTROOT}/ansible/requirements.yml", 
    destination: "~vagrant/requirements.yml"

  config.vm.provision "shell", inline: "[[ -d ~vagrant/playbooks ]] || \
     mkdir ~vagrant/playbooks/ && chown vagrant: ~vagrant/playbooks"

  config.vm.provision "file", 
    source: "#{VAGRANTROOT}/ansible/playbooks/awx.yml", 
    destination: "~vagrant/playbooks/awx.yml"

  config.vm.provision "file", 
    source: "#{VAGRANTROOT}/ansible/playbooks/default.yml", 
    destination: "~vagrant/playbooks/default.yml"

  config.vm.provision "file", 
    source: "#{VAGRANTROOT}/ansible/playbooks/servera.yml", 
    destination: "~vagrant/playbooks/servera.yml"

  config.vm.provision "file", 
    source: "#{VAGRANTROOT}/ansible/playbooks/serverb.yml", 
    destination: "~vagrant/playbooks/serverb.yml"

  config.vm.provision "file", 
    source: "#{VAGRANTROOT}/ansible/playbooks/serverc.yml", 
    destination: "~vagrant/playbooks/serverc.yml"

  config.vm.provision "file", 
    source: "#{VAGRANTROOT}/ansible/playbooks/serverd.yml", 
    destination: "~vagrant/playbooks/serverd.yml"

  config.vm.provision "file", 
    source: "#{VAGRANTROOT}/ansible/playbooks/servere.yml", 
    destination: "~vagrant/playbooks/servere.yml"

  config.vm.provision "file", 
    source: "#{VAGRANTROOT}/ansible/playbooks/serverf.yml", 
    destination: "~vagrant/playbooks/serverf.yml"
  
  config.vm.provision "file", 
    source: "#{VAGRANTROOT}/ansible/playbooks/tower.yml", 
    destination: "~vagrant/playbooks/tower.yml"

  config.vm.provision "file", 
    source: "#{VAGRANTROOT}/ansible/playbooks/utility.yml", 
    destination: "~vagrant/playbooks/utility.yml"

  config.vm.provision "file", 
    source: "#{VAGRANTROOT}/ansible/playbooks/workstation.yml", 
    destination: "~vagrant/playbooks/workstation.yml"

  config.vm.provision "file", 
    source: "#{VAGRANTROOT}/ansible/playbooks/#{HOSTNAME}.yml", 
    destination: "~vagrant/playbooks/localhost.yml"

     
  # Run ansible provisioning 
  config.vm.provision :ansible do |ansible|
    ansible.verbose = "v"
    ansible.config_file = "#{VAGRANTROOT}/ansible/ansible.cfg"
    ansible.galaxy_role_file = "#{VAGRANTROOT}/ansible/requirements.yml"
    #ansible.galaxy_roles_path = "#{VAGRANTROOT}/ansible/roles"
    ansible.galaxy_roles_path = "#{VAGRANTROOT}/ansible/roles/thirdparty:#{VAGRANTROOT}/ansible/roles/local"
    ansible.playbook = "#{VAGRANTROOT}/ansible/playbooks/#{ANSIBLEROLE}.yml"
  end

end
