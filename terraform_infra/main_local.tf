resource "local_file" "ansible_inventory" {
  filename = "../ansible/inventory/hosts"
  content  = <<-EOT
[proxmox_vms]
${module.dkr_srv_1.vm_name} ansible_host=${split("/", module.dkr_srv_1.vm_ipv4_address)[0]}
${module.dkr_srv_2.vm_name} ansible_host=${split("/", module.dkr_srv_2.vm_ipv4_address)[0]}
${module.dkr_srv_3.vm_name} ansible_host=${split("/", module.dkr_srv_3.vm_ipv4_address)[0]}
${module.dkr_wrkr_1.vm_name} ansible_host=${split("/", module.dkr_wrkr_1.vm_ipv4_address)[0]}
${module.dkr_wrkr_2.vm_name} ansible_host=${split("/", module.dkr_wrkr_2.vm_ipv4_address)[0]}

[swarm_servers]
${module.dkr_srv_1.vm_name}
${module.dkr_srv_2.vm_name}
${module.dkr_srv_3.vm_name}

[swarm_workers]
${module.dkr_wrkr_1.vm_name}
${module.dkr_wrkr_2.vm_name}

[vms:children]
proxmox_vms

[swarm_managers:children]
swarm_servers

[all:children]
vms
EOT
}
