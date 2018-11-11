# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 2.0.1"

HOSTNAME = "templates"
ANSIBLEROLE = "#{HOSTNAME}"
IPADDR = "192.168.0.1"
CPUS = "2"
MEMORY = "1024"
MULTIVOL = false
MULTIVOLSIZE = 10240
MULTIVOLNAME = "#{HOSTNAME}-vol02.vdi"
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

  case "netports"
  when HOSTNAME == "okd"
    config.vm.network :forwarded_port, guest: 80, host: 80, 
      virtualbox__hostonly: true
    config.vm.network :forwarded_port, guest: 443, host: 443, 
      virtualbox__hostonly: true
    config.vm.network :forwarded_port, guest: 2375, host: 2375, 
      virtualbox__hostonly: true
    config.vm.network :forwarded_port, guest: 2376, host: 2376, 
      virtualbox__hostonly: true
    config.vm.network :forwarded_port, guest: 2379, host: 2379, 
      virtualbox__hostonly: true
    config.vm.network :forwarded_port, guest: 2380, host: 2380, 
      virtualbox__hostonly: true
    config.vm.network :forwarded_port, guest: 5000, host: 5000, 
      virtualbox__hostonly: true
    config.vm.network :forwarded_port, guest: 8443, host: 8443, 
      virtualbox__hostonly: true
  else
    config.vm.network :forwarded_port, guest: 80, host: 10080,
      virtualbox__hostonly: true
    config.vm.network :forwarded_port, guest: 443, host: 10443,
      virtualbox__hostonly: true
    config.vm.network :forwarded_port, guest: 8052, host: 10052,
      virtualbox__hostonly: true
  end


  # Disable selinux and reboot
  unless FileTest.exist?("./untracked-files/first_boot_complete")
    config.vm.provision :shell, inline: "yum -y update"
    config.vm.provision :shell, inline: "sed -i s/^SELINUX=enforcing/SELINUX=permissive/ /etc/selinux/config"
    config.vm.provision :reload
    require 'fileutils'
    FileUtils.touch("#{VAGRANTROOT}/untracked-files/first_boot_complete")
  end

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
  # out what the issue was.  The following lines are left in place
  # for the moment in case it crops up again.
  # 
  #config.vm.synced_folder "./", "/vagrant"
  #config.vm.synced_folder "#{VAGRANTROOT}", "/vagrant-#{HOSTNAME}"
  config.vm.synced_folder "#{VAGRANTROOT}", "/vagrant"
  #config.vm.provision :shell, inline: "rm -rf --one-file-system /vagrant"
  #config.vm.provision :shell, inline: "[[ -d /vagrant ]] && mv -fnu /vagrant /vagrant-BADSYNC"
  #config.vm.provision :shell, inline: "ln -s /vagrant-#{HOSTNAME}/ /vagrant"
 
  if MULTIVOL == true
    # Create second volume
    config.vm.provision "shell", inline: "mkdir -p #{MOUNTPOINT}"
    #config.vm.provision "shell", inline: "mkdir -p /mnt"
    config.persistent_storage.enabled = true
    config.persistent_storage.use_lvm = false
    config.persistent_storage.diskdevice = '/dev/sdb'
    config.persistent_storage.location = "./untracked-files/#{MULTIVOLNAME}"
    config.persistent_storage.size = MULTIVOLSIZE
    config.persistent_storage.mountname = 'xfs'
    config.persistent_storage.filesystem = 'xfs'
    config.persistent_storage.mountpoint = MOUNTPOINT
    config.persistent_storage.mountoptions = ['defaults']
    config.vm.provision "shell", inline: "mount -a"
  end

  
  config.vm.provision :shell, inline: "yum -y install ansible"
  config.vm.provision "file", 
    source: "~/.gitconfig", 
    destination: ".gitconfig"

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
  #config.vm.provision "file", 
  #  source: "./files/hosts", 
  #  destination: "/etc/hosts"
  
  # Set ansible roles environment variable
  # This is unused and may be set wrong, i.e. as currently
  # configured it addresses the host context but it probably should 
  # be the guest context, like the follwoing
  #  ENV['ANSIBLE_ROLES_PATH'] = "#{VAGRANTROOT}/ansible/roles"
  ENV['ANSIBLE_ROLES_PATH'] = "~vagrant/ansible/roles"

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
    source: "#{VAGRANTROOT}/ansible/playbooks/#{ANSIBLEROLE}.yml", 
    destination: "~vagrant/playbooks/localhost.yml"

     
  ## Set the host: value in localhost.yml equal to #{HOSTNAME} 
  ## from the vagran file.
  ##  I don't think I can do this inline, I need to use the 
  ##  shell provisioner
  #
  #config.vm.provision :shell, inline: "echo #{HOSTNAME} >> ~vagrant/hostname.txt"
  #config.vm.provision :shell, inline: "echo #{HOSTNAME} $MYENV >> ~vagrant/hostname.txt", env: {"MYENV" => "myenv"}
  #config.vm.provision :shell, inline: "sed -i s/<HOSTNAME>/${PLAYBOOKHOST}/g, env: { PLAYBOOKHOST => #HOSTNAME }"
  #config.vm.provision :shell, inline: "sed -i s/HOSTNAME/$PLAYBOOKHOST/g ~vagrant/playbooks/localhost.yml, env: { PLAYBOOKHOST => playbookhost }"
   

  # Run ansible provisioning 
  config.vm.provision :ansible do |ansible|
    ansible.verbose = "v"
    ansible.config_file = "#{VAGRANTROOT}/ansible/ansible.cfg"
    ansible.galaxy_role_file = "#{VAGRANTROOT}/ansible/requirements.yml"
    ansible.playbook = "#{VAGRANTROOT}/ansible/playbooks/#{ANSIBLEROLE}.yml"
    #ansible.groups = {
    #  "group1" => ["#{HOSTNAME}"], 
    ##  "group1:vars" => {"ntp_manage_config" => true,
    ##                    "ntp_timezone" => "America/NewYork",
    ##                    "firewall_allowed_tcp_ports" => {["22", "80", "443", "8052", "8080"]}
    #}
  end

end
