# Virtual Machine Instance: backstage-vm-01
resource "mgc_virtual_machine_instances" "backstage_vm_01" {
  provider          = mgc.br-se1
  name              = "backstage-vm-01"
  availability_zone = "br-se1-a"
  machine_type      = "BV1-4-150"
  image             = "cloud-ubuntu-24.04 LTS"
  ssh_key_name      = "notebook-mgc"
  user_data = base64encode(<<-EOT
#!/bin/bash
echo "Provisionando instancia na MGC com backstage!!!" > /tmp/backstage_provision.log
EOT
  )
}

# Public IP for VM: backstage-vm-01
## Public ip
resource "mgc_network_public_ips" "public_ip_backstage_vm_01" {
  provider    = mgc.br-se1
  description = "Public ip VM backstage-vm-01"
  vpc_id      = "22ade374-7352-4705-9be1-6337b2322805"
  depends_on  = [mgc_virtual_machine_instances.backstage_vm_01]
}
## Attach public ip
resource "mgc_network_public_ips_attach" "public_ip_attach_backstage_vm_01" {
  provider     = mgc.br-se1
  public_ip_id = mgc_network_public_ips.public_ip_backstage_vm_01.id
  interface_id = mgc_virtual_machine_instances.backstage_vm_01.network_interfaces[0].id
  depends_on   = [mgc_network_public_ips.public_ip_backstage_vm_01]
}

# Volumes and Attachments for VM: backstage-vm-01
resource "mgc_block_storage_volumes" "backstage_vm_01_volume_01" {
  provider          = mgc.br-se1
  availability_zone = "br-se1-a"
  name              = "backstage-vm-01-volume-01"
  size              = 10
  type              = "cloud_nvme10k"
}
resource "mgc_block_storage_volume_attachment" "attach_backstage_vm_01_volume_01" {
  depends_on = [
    mgc_block_storage_volumes.backstage_vm_01_volume_01,
    mgc_virtual_machine_instances.backstage_vm_01
  ]
  provider           = mgc.br-se1
  block_storage_id   = mgc_block_storage_volumes.backstage_vm_01_volume_01.id
  virtual_machine_id = mgc_virtual_machine_instances.backstage_vm_01.id
}
