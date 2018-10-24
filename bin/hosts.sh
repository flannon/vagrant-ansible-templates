#!/bin/bash

# Red Hat Lab hosts
[[ $(grep '172.25.250.254 workstation.lab.example.com workstation' /etc/hosts) ]] || echo '172.25.250.254 workstation.lab.example.com workstation' >> /etc/hosts

[[ $(grep '172.25.250.8 utility.lab.example.com utility' /etc/hosts) ]] || echo '172.25.250.8 utility.lab.example.com utility' >> /etc/hosts

[[ $( grep '172.25.250.9 tower.lab.example.com tower' /etc/hosts) ]] || echo '172.25.250.9 tower.lab.example.com tower' >> /etc/hosts

[[ $(grep '172.25.250.10 servera.lab.example.com servera' /etc/hosts) ]] || echo '172.25.250.10 servera.lab.example.com servera' >> /etc/hosts

[[ $(grep '172.25.250.11 serverb.lab.example.com serverb' /etc/hosts) ]] || echo '172.25.250.11 serverb.lab.example.com servera' >> /etc/hosts

[[ $(grep '172.25.250.12 serverc.lab.example.com serverc' /etc/hosts) ]] || echo '172.25.250.12 serverc.lab.example.com servera' >> /etc/hosts

[[ $(grep '172.25.250.13 serverd.lab.example.com serverd' /etc/hosts) ]] || echo '172.25.250.13 serverd.lab.example.com servera' >> /etc/hosts

[[ $(grep '172.25.250.14 servere.lab.example.com servere' /etc/hosts) ]] || echo '172.25.250.14 servere.lab.example.com servera' >> /etc/hosts

[[ $(grep '172.25.250.15 serverf.lab.example.com serverf' /etc/hosts) ]] || echo '172.25.250.15 serverf.lab.example.com servera' >> /etc/hosts


# Dlib hosts
[[ $(grep '172.39.144.12 discovery.dlib.example.com serverf' /etc/hosts) ]] || echo '172.39.144.12 discovery.dlib.example.com servera' >> /etc/hosts
