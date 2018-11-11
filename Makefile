# Targets build available ansible environmwents
# 
DATE = `date +%y%m%d:%H:%M:%S`

.PHONY: okd
okd:
	sed -i '' 's/HOSTNAME = .*/HOSTNAME = "okd"/g' Vagrantfile
	sed -i '' 's/IPADDR = .*/IPADDR = "192.168.68.99"/g' Vagrantfile
	sed -i '' 's/CPUS = .*/CPUS = "4"/g' Vagrantfile
	sed -i '' 's/MEMORY = .*/MEMORY = "4096"/g' Vagrantfile
	sed -i '' 's/MULTIVOL = false/MULTIVOL = true/g' Vagrantfile
	sed -i '' 's/MOUNTPOINT = .*/MOUNTPOINT = "\/var\/lib\/docker"/g' Vagrantfile
	vagrant up | tee logs/${DATE}-okd-vagrant-up.log

.PHONY: okd_clean
okd_clean:
	rm -f ./untracked-files/first_boot_complete


.PHONY: workstation
workstation:
	sed -i '' 's/HOSTNAME = .*/HOSTNAME = "workstation"/g' Vagrantfile
	sed -i '' 's/IPADDR = .*/IPADDR = "172.25.250.254"/g' Vagrantfile
	vagrant up | tee logs/${DATE}-workstation-vagrant-up.log

.PHONY: servera
servera:
	sed -i '' 's/HOSTNAME = .*/HOSTNAME = "servera"/g' Vagrantfile
	sed -i '' 's/IPADDR = .*/IPADDR = "172.25.250.10"/g' Vagrantfile
	vagrant up | tee logs/${DATE}-servera-vagrant-up.log

.PHONY: serverb
serverb:
	sed -i '' 's/HOSTNAME = .*/HOSTNAME = "serverb"/g' Vagrantfile
	sed -i '' 's/IPADDR = .*/IPADDR = "172.25.250.11"/g' Vagrantfile
	vagrant up | tee logs/${DATE}-serverb-vagrant-up.log

.PHONY: discovery
discovery:
	sed -i '' 's/HOSTNAME = .*/HOSTNAME = "discovery"/g' Vagrantfile
	sed -i '' 's/IPADDR = .*/IPADDR = "172.39.144.12"/g' Vagrantfile
	vagrant up | tee logs/${DATE}-discovery-vagrant-up.log

.PHONY: clean
clean:
	rm -f ./untracked-files/first_boot_complete

.PHONY: realclean
realclean:
	rm -f Vagrantfile
	rm -f ./untracked-files/first_boot_complete
	git checkout Vagrantfile
