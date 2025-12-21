# Proxmox VMs using the proxmox-vm module

locals {
  # Quad9 DNS servers for enhanced privacy and security
  quad9_dns_servers = [
    "9.9.9.9",
    "149.112.112.112"
  ]
}

module "dkr_srv_1" {
  source = "./modules/proxmox-vm"

  # Basic Configuration
  name        = "dkr-srv-1"
  description = "Managed by Terraform"
  tags        = ["community-script", "ubuntu", "docker", "controller", "terraformed"]
  node_name   = "pve-2"
  vm_id       = 3011 # vlan 30 / ip .11

  # Optional simple user data (example)
  #   user_data = <<-EOF
  # #cloud-config
  # runcmd:
  #   - echo "Simple initialization script"
  #   - apt-get update
  #   - echo "Initialization complete"
  # EOF

  # Clone Configuration
  template_vm_id = 9007
  full_clone     = true

  # Agent Configuration
  agent_enabled = false
  agent_timeout = "5m"

  # Hardware Configuration
  memory_dedicated = 4096
  cpu_cores        = 2
  cpu_sockets      = 1

  # Disk Configuration
  disk_datastore_id = "vm-storage"
  disk_interface    = "scsi0"
  disk_size         = 30 # GB
  disk_iothread     = false

  # Network Configuration
  network_bridge   = "vmbr0"
  network_model    = "virtio"
  network_vlan_id  = 30
  network_firewall = false

  # SSH Keys
  ssh_public_key_rsa     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCpjSKK4qiMx4vIOvX7PHBOOctpYQ/XQQKWinw+v8oIQoI3GWkdRTwZpXJ2QSor/10zk5TZphP6XpfXxJj3caPwZPnu/ZFci/Iy40T6O2PDUFBjzaBLoIRci4lkRgjyEITKt9K1gIiqO8CnrMNBQTYj8gt7pHa3jIv102M1JIVqq4IU6tDTnf6Nku20jQcvxQCuJT0AszLZwMsD8IMOPkOfztnYOeJTXKOvcT+Vff3+ORXtXbVXNvAhobiSdK1MH5dAMsDZs9QcAazJGMfp50BcBUiHCRUo2XRk+IjMt7Tj6EjI+IMy+QOQWvTM016X9xTiLrPEJMU2RatfeG9VvcCPeQxPCbQE7uuYvCa3SAeJ3CTSL6kTE/4gp4uIq/XZEgZZO/4vuWF+1cNRYhePyJm9tlIU1o5AHHL2I8FJUlQJAe/+gRd/irfzRGDhiYw3fa02nFXsPY4mlEjIdjAd7JYRv1D3X2LBS+62PjqRC3NoNLodfywd3pVsiO3l3QsQKMRGxbyA9jSelSORNftGNeIQJWgJXW0ws42aCYmdcarCpLIil5QfV3WSfXz+a+wd5y7OCW19+sl3j1RHJhIuttsAZQOIGisCfDgstxhY08yuqA2DcZCdNL50JJzN2AQyeVzGRNEhFFEELBdRMAOf7L61Qie3Y+s9aN0do0xDInOkYQ== fs@home"
  ssh_public_key_ed25519 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmL9dMflzH1HaL3Nx3ZYxZDHud0Cbd0N3B+2ZUXiHXT"

  # Initialization Configuration
  initialization_datastore_id = "vm-storage"
  dns_servers                 = local.quad9_dns_servers
  ipv4_address                = "10.0.30.11/24"
  ipv4_gateway                = "10.0.30.1"

  # VM Lifecycle Settings
  on_boot             = true
  reboot_after_update = false
  started             = true
}
module "dkr_srv_2" {
  source = "./modules/proxmox-vm"

  # Basic Configuration
  name        = "dkr-srv-2"
  description = "Managed by Terraform"
  tags        = ["community-script", "ubuntu", "docker", "controller", "terraformed"]
  node_name   = "pve-2"
  vm_id       = 3012 # vlan 30 / ip .12

  # Clone Configuration
  template_vm_id = 9007
  full_clone     = true

  # Agent Configuration
  agent_enabled = false
  agent_timeout = "5m"

  # Hardware Configuration
  memory_dedicated = 4096
  cpu_cores        = 2
  cpu_sockets      = 1

  # Disk Configuration
  disk_datastore_id = "vm-storage"
  disk_interface    = "scsi0"
  disk_size         = 30 # GB
  disk_iothread     = false

  # Network Configuration
  network_bridge   = "vmbr0"
  network_model    = "virtio"
  network_vlan_id  = 30
  network_firewall = false

  # SSH Keys
  ssh_public_key_rsa     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCpjSKK4qiMx4vIOvX7PHBOOctpYQ/XQQKWinw+v8oIQoI3GWkdRTwZpXJ2QSor/10zk5TZphP6XpfXxJj3caPwZPnu/ZFci/Iy40T6O2PDUFBjzaBLoIRci4lkRgjyEITKt9K1gIiqO8CnrMNBQTYj8gt7pHa3jIv102M1JIVqq4IU6tDTnf6Nku20jQcvxQCuJT0AszLZwMsD8IMOPkOfztnYOeJTXKOvcT+Vff3+ORXtXbVXNvAhobiSdK1MH5dAMsDZs9QcAazJGMfp50BcBUiHCRUo2XRk+IjMt7Tj6EjI+IMy+QOQWvTM016X9xTiLrPEJMU2RatfeG9VvcCPeQxPCbQE7uuYvCa3SAeJ3CTSL6kTE/4gp4uIq/XZEgZZO/4vuWF+1cNRYhePyJm9tlIU1o5AHHL2I8FJUlQJAe/+gRd/irfzRGDhiYw3fa02nFXsPY4mlEjIdjAd7JYRv1D3X2LBS+62PjqRC3NoNLodfywd3pVsiO3l3QsQKMRGxbyA9jSelSORNftGNeIQJWgJXW0ws42aCYmdcarCpLIil5QfV3WSfXz+a+wd5y7OCW19+sl3j1RHJhIuttsAZQOIGisCfDgstxhY08yuqA2DcZCdNL50JJzN2AQyeVzGRNEhFFEELBdRMAOf7L61Qie3Y+s9aN0do0xDInOkYQ== fs@home"
  ssh_public_key_ed25519 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJmL9dMflzH1HaL3Nx3ZYxZDHud0Cbd0N3B+2ZUXiHXT"

  # Initialization Configuration
  initialization_datastore_id = "vm-storage"
  dns_servers                 = local.quad9_dns_servers
  ipv4_address                = "10.0.30.12/24"
  ipv4_gateway                = "10.0.30.1"

  # VM Lifecycle Settings
  on_boot             = true
  reboot_after_update = false
  started             = true
}

# Output the VM information
output "dkr_srv_1_vm_id" {
  description = "The ID of the dkr-srv-1 VM"
  value       = module.dkr_srv_1.vm_id
}

output "dkr_srv_1_vm_name" {
  description = "The name of the dkr-srv-1 VM"
  value       = module.dkr_srv_1.vm_name
}

output "dkr_srv_1_vm_node" {
  description = "The Proxmox node where dkr-srv-1 is running"
  value       = module.dkr_srv_1.vm_node_name
}

# Output the VM information
output "dkr_srv_2_vm_id" {
  description = "The ID of the dkr-srv-2 VM"
  value       = module.dkr_srv_2.vm_id
}

output "dkr_srv_2_vm_name" {
  description = "The name of the dkr-srv-2 VM"
  value       = module.dkr_srv_2.vm_name
}

output "dkr_srv_2_vm_node" {
  description = "The Proxmox node where dkr-srv-2 is running"
  value       = module.dkr_srv_2.vm_node_name
}
