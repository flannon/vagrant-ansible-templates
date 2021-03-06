# Targets build available ansible environmwents
# 
.PHONY: workstation
workstation:
	sed -i '' 's/templates/workstation/g' Vagrantfile
	sed -i '' 's/192.168.0.1/172.25.250.254/g' Vagrantfile
	vagrant up

.PHONY: servera
servera:
	sed -i '' 's/templates/servera/g' Vagrantfile
	sed -i '' 's/192.168.0.1/172.25.250.10/g' Vagrantfile
	vagrant up

.PHONY: serverb
serverb:
	sed -i '' 's/templates/serverb/g' Vagrantfile
	sed -i '' 's/192.168.0.1/172.25.250.11/g' Vagrantfile
	vagrant up

.PHONY: discovery
discovery:
	sed -i '' 's/templates/discovery/g' Vagrantfile
	sed -i '' 's/192.168.0.1/172.39.144.12/g' Vagrantfile
	vagrant up

.PHONY: testing
testing:
	sed -i '' 's/templates/testing/g' Vagrantfile
	sed -i '' 's/192.168.0.1/172.39.144.59/g' Vagrantfile
	vagrant up

.PHONY: clean
clean:
	rm -f Vagrantfile
	git checkout Vagrantfile
