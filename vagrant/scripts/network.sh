#!/bin/bash

<<'MULTILINE-COMMENT'
    Requirments: none
    Description: Script for set Network KVM QEMU
    Author: Marcos Silvestrini
    Date: 04/04/2025
MULTILINE-COMMENT

# Set language/locale and encoding
export LANG=C

cd /home/vagrant || exit

# Configure  eth1 routes permanently
cp -f configs/network/configure-network-eth1.service  /etc/systemd/system
systemctl daemon-reload
systemctl enable configure-network-eth1.service
systemctl start configure-network-eth1.service


# Configure  eth2 routes permanently
cp -f configs/network/configure-network-eth2.service  /etc/systemd/system
systemctl daemon-reload
systemctl enable configure-network-eth2.service
systemctl start configure-network-eth2.service