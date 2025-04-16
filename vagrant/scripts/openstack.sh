#!/bin/bash

<<'MULTILINE-COMMENT'
    Requirments: none
    Description: Script for set Kolla Ansible OpenStack Docker Environment
    Author: Marcos Silvestrini
    Date: 10/04/2025
    Documentation: https://docs.openstack.org/kolla-ansible/latest/user/quickstart.html#recommended-reading
MULTILINE-COMMENT

# Set language/locale and encoding
export LANG=C

# Workdir
cd /home/vagrant || exit

# Install dependencies
sudo apt install -y \
apt-transport-https \
ca-certificates \
curl \
gnupg \
lsb-release

# Install docker
curl -fsSL https://download.docker.com/linux/debian/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/debian $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker vagrant
sudo systemctl enable docker
sudo systemctl start docker
newgrp docker
