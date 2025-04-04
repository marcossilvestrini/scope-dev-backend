#!/bin/bash

<<'MULTILINE-COMMENT'
    Requirments: none
    Description: Script for set Kubernetes Environment
    Author: Marcos Silvestrini
    Date: 04/04/2025
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

# Install kubectl
curl -fsSL https://pkgs.k8s.io/core:/stable:/v1.28/deb/Release.key | sudo gpg --dearmor -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg
echo "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/v1.28/deb/ /" | sudo tee /etc/apt/sources.list.d/kubernetes.list
sudo apt update
sudo apt install -y kubectl
echo 'source <(kubectl completion bash)' >>~/.bashrc
source ~/.bashrc

# Install helm
# Baixar e executar o script de instalação
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3
chmod 700 get_helm.sh
./get_helm.sh

# Install kind
curl -Lo ./kind https://kind.sigs.k8s.io/dl/v0.20.0/kind-linux-amd64
chmod +x ./kind
sudo mv ./kind /usr/local/bin/kind

# criar cluster