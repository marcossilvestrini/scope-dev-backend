#!/bin/bash

<<'MULTILINE-COMMENT'
    Requirments: none
    Description: Script for set Network KVM QEMU
    Author: Marcos Silvestrini
    Date: 04/04/2025
MULTILINE-COMMENT

# Configure  eth1 routes permanently
cp -f configs/network/configure-network.service  /etc/systemd/system
systemctl daemon-reload
systemctl enable configure-network.service
systemctl start configure-network.service
