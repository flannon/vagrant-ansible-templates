# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.require_version ">= 2.0.1"

HOSTNAME = "nginx"
CPUS = "2"
MEMORY = "1024"
MULTIVOL = false
MOUNTPOINT = "/mnt"
VAGRANTDIR = File.expand_path(File.dirname(__FILE__))
VAGRANTROOT = File.dirname(__FILE__)
VAGRANTFILE_API_VERSION = "2"

# Ensure vagrant plugins
#required_plugins = %w( vagrant-vbguest vagrant-scp vagrant-share vagrant-persistent-storage vagrant vagrant-reload )
required_plugins = %w( vagrant-vbguest vagrant-scp vagrant-share vagrant-persistent-storage vagrant-reload )
required_plugins.each do |plugin|
  exec "vagrant plugin install #{plugin};vagrant #{ARGV.join(" ")}" unless Vagrant.has_plugin? plugin || ARGV[0] == 'plugin'
end

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  config.vm.box = "centos/7"
  config.ssh.insert_key = false
  config.vm.network :private_network, ip: "192.168.50.99",
    virtualbox__hostonly: true
  config.vm.network :forwarded_port, guest: 80, host: 80,
    virtualbox__hostonly: true
  config.vm.network :forwarded_port, guest: 443, host: 443,
    virtualbox__hostonly: true
  config.vm.network :forwarded_port, guest: 8052, host: 8052,
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
  config.vm.synced_folder ".", "/vagrant"
  config.vm.provision :shell, inline: "yum -y install ansible"

  # Disable selinux and reboot
  unless FileTest.exist?("./untracked-files/first_boot_selinux_disabled")
    config.vm.provision :shell, inline: "sed -i s/^SELINUX=enforcing/SELINUX=permissive/ /etc/selinux/config"
    config.vm.provision :reload
    require 'fileutils'
    FileUtils.touch("./first_boot_selinux_disabled")
  end

  # Set ansible roles environment variable
  ENV['ANSIBLE_ROLES_PATH'] = "#{VAGRANTROOT}/provisioning/roles"

  config.vm.define HOSTNAME

  # Run ansible provisioning 
  config.vm.provision :ansible do |ansible|
    ansible.verbose = "v"
    #ansible.becomr = "root"
    ansible.config_file = "provisioning/ansible.cfg"
    #ansible.galaxy_role_path = "provisioning/roles"
    ansible.galaxy_role_file = "provisioning/requirements.yml"
    ansible.playbook = "provisioning/main.yml"
    #ansible.groups = {
    #  "group1" => ["#HOSTNAME"], 
    #  "group1:vars" => {"ntp_manage_config" => true,
    #                    "ntp_timezone" => "America/NewYork",
    #                    "firewall_allowed_tcp_ports" => {["22", "80", "443", "8052", "8080"]}
    #}
  end

end
