resource "local_file" "ansible_inventory" {
  filename = "../ansible/inventory/hosts"
  content  = <<-EOT
[proxmox_vms]
${module.dkr_srv_1.vm_name} ansible_host=${split("/", module.dkr_srv_1.vm_ipv4_address)[0]}
${module.dkr_srv_2.vm_name} ansible_host=${split("/", module.dkr_srv_2.vm_ipv4_address)[0]}
${module.dkr_srv_3.vm_name} ansible_host=${split("/", module.dkr_srv_3.vm_ipv4_address)[0]}

[vms:children]
proxmox_vms

[swarm_managers:children]
proxmox_vms

[all:children]
vms
EOT
}