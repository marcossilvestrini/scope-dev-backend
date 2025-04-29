# Kubeadm

Este documento tem como objetivo criar um cluster kubernetes com kubeadm

## Pre requisitos

### Network

```sh
# Enable IPv4 packet forwarding
# sysctl params required by setup, params persist across reboots
cat <<EOF | sudo tee /etc/sysctl.d/k8s.conf
net.ipv4.ip_forward = 1
EOF

# Apply sysctl params without reboot
sudo sysctl --system

# Verify that net.ipv4.ip_forward is set to 1 with:
sysctl net.ipv4.ip_forward
```

### Container runtimes

#### containerd

