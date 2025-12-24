# Proxmox VMs using the proxmox-vm module

locals {
  # Shared DNS configuration
  dns_servers = [
    "9.9.9.9",
    "149.112.112.112"
  ]

  # Shared SSH keys
  ssh_public_key_rsa     = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCpjSKK4qiMx4vIOvX7PHBOOctpYQ/XQQKWinw+v8oIQoI3GWkdRTwZpXJ2QSor/10zk5TZphP6XpfXxJj3caPwZPnu/ZFci/Iy40T6O2PDUFBjzaBLoIRci4lkRgjyEITKt9K1gIiqO8CnrMNBQTYj8gt7pHa3jIv102M1JIVqq4IU6tDTnf6Nku20jQcvxQCuJT0AszLZwMsD8IMOPkOfztnYOeJTXKOvcT+Vff3+ORXtXbVXNvAhobiSdK1MH5dAMsDZs9QcAazJGMfp50BcBUiHCRUo2XRk+IjMt7Tj6EjI+IMy+QOQWvTM016X9xTiLrPEJMU2RatfeG9VvcCPeQxPCbQE7uuYvCa3SAeJ3CTSL6kTE/4gp4uIq/XZEgZZO/4vuWF+1cNRYhePyJm9tlIU1o5AHHL2I8FJUlQJAe/+gRd/irfzRGDhiYw3fa02nFXsPY4mlEjIdjAd7JYRv1D3X2LBS+62PjqRC3NoNLodfywd3pVsiO3l3QsQKMRGxbyA9jSelSORNftGNeIQJWgJXW0ws42aCYmdcarCpLIil5QfV3WSfXz+a+wd5y7OCW19+sl3j1RHJhIuttsAZQOIGisCfDgstxhY08yuqA2DcZCdNL50JJzN2AQyeVzGRNEhFFEELBdRMAOf7L61Qie3Y+s9aN0do0xDInOkYQ== fs@home"
  ssh_public_key_ed25519 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZNMQ9ZBT1pxZCjNHGI9fE3MaFJPy8gOfOjrA+PclVk fs@Fabrices-MBP"

  # Shared user configuration
  username = "fs"

  # Shared VM configuration
  vm_common = {
    description    = "Terraform Managed Docker Controller VM"
    tags           = ["community-script", "debian13", "docker", "controller", "terraform"]
    node_name      = "pve-2"
    template_vm_id = 9008
    full_clone     = true

    # Agent Configuration
    agent_enabled = false
    agent_timeout = "5m"

    # Hardware Configuration
    memory_dedicated = 8192
    cpu_cores        = 4
    cpu_sockets      = 2

    # Disk Configuration
    disk_datastore_id = "vm-storage"
    disk_interface    = "virtio0"
    disk_size         = 32
    disk_iothread     = true

    # Additional Disks (GlusterFS)
    additional_disks = [
      {
        datastore_id = "vm-storage"
        interface    = "scsi0"
        size         = 30
        file_format  = "raw"
        iothread     = true
        cache        = "none"
        backup       = true
      }
    ]

    # Network Configuration
    network_bridge   = "vmbr0"
    network_model    = "virtio"
    network_vlan_id  = 30
    network_firewall = false

    # Initialization Configuration
    initialization_datastore_id = "vm-storage"
    dns_servers                 = local.dns_servers

    # VM Lifecycle Settings
    on_boot             = true
    reboot_after_update = false
    started             = true

    # EFI and TPM
    efi_disk_enabled  = true
    tpm_state_enabled = true
  }

  # VM-specific configurations
  dkr_srv_1 = {
    name         = "dkr-srv-1"
    vm_id        = 3011
    ipv4_address = "10.0.30.11/24"
    ipv4_gateway = "10.0.30.1"
  }

  dkr_srv_2 = {
    name         = "dkr-srv-2"
    vm_id        = 3012
    ipv4_address = "10.0.30.12/24"
    ipv4_gateway = "10.0.30.1"
  }

  dkr_srv_3 = {
    name         = "dkr-srv-3"
    vm_id        = 3013
    ipv4_address = "10.0.30.13/24"
    ipv4_gateway = "10.0.30.1"
  }
}

module "dkr_srv_1" {
  source = "./modules/proxmox-vm"

  # Basic Configuration
  name        = local.dkr_srv_1.name
  description = local.vm_common.description
  tags        = local.vm_common.tags
  node_name   = local.vm_common.node_name
  vm_id       = local.dkr_srv_1.vm_id

  # Clone Configuration
  template_vm_id = local.vm_common.template_vm_id
  full_clone     = local.vm_common.full_clone

  # Agent Configuration
  agent_enabled = local.vm_common.agent_enabled
  agent_timeout = local.vm_common.agent_timeout

  # Hardware Configuration
  memory_dedicated = local.vm_common.memory_dedicated
  cpu_cores        = local.vm_common.cpu_cores
  cpu_sockets      = local.vm_common.cpu_sockets

  # Disk Configuration
  disk_datastore_id = local.vm_common.disk_datastore_id
  disk_interface    = local.vm_common.disk_interface
  disk_size         = local.vm_common.disk_size
  disk_iothread     = local.vm_common.disk_iothread
  additional_disks  = local.vm_common.additional_disks

  # Network Configuration
  network_bridge   = local.vm_common.network_bridge
  network_model    = local.vm_common.network_model
  network_vlan_id  = local.vm_common.network_vlan_id
  network_firewall = local.vm_common.network_firewall

  # SSH Keys - include both keys
  ssh_keys = [
    local.ssh_public_key_rsa,
    local.ssh_public_key_ed25519
  ]

  # User Configuration
  username = local.username

  # Initialization Configuration
  initialization_datastore_id = local.vm_common.initialization_datastore_id
  dns_servers                 = local.vm_common.dns_servers
  ipv4_address                = local.dkr_srv_1.ipv4_address
  ipv4_gateway                = local.dkr_srv_1.ipv4_gateway

  # VM Lifecycle Settings
  on_boot             = local.vm_common.on_boot
  reboot_after_update = local.vm_common.reboot_after_update
  started             = local.vm_common.started

  # EFI and TPM
  efi_disk_enabled  = local.vm_common.efi_disk_enabled
  tpm_state_enabled = local.vm_common.tpm_state_enabled
}

module "dkr_srv_2" {
  source = "./modules/proxmox-vm"

  # Basic Configuration
  name        = local.dkr_srv_2.name
  description = local.vm_common.description
  tags        = local.vm_common.tags
  node_name   = local.vm_common.node_name
  vm_id       = local.dkr_srv_2.vm_id

  # Clone Configuration
  template_vm_id = local.vm_common.template_vm_id
  full_clone     = local.vm_common.full_clone

  # Agent Configuration
  agent_enabled = local.vm_common.agent_enabled
  agent_timeout = local.vm_common.agent_timeout

  # Hardware Configuration
  memory_dedicated = local.vm_common.memory_dedicated
  cpu_cores        = local.vm_common.cpu_cores
  cpu_sockets      = local.vm_common.cpu_sockets

  # Disk Configuration
  disk_datastore_id = local.vm_common.disk_datastore_id
  disk_interface    = local.vm_common.disk_interface
  disk_size         = local.vm_common.disk_size
  disk_iothread     = local.vm_common.disk_iothread
  additional_disks  = local.vm_common.additional_disks

  # Network Configuration
  network_bridge   = local.vm_common.network_bridge
  network_model    = local.vm_common.network_model
  network_vlan_id  = local.vm_common.network_vlan_id
  network_firewall = local.vm_common.network_firewall

  # SSH Keys
  ssh_keys = [
    local.ssh_public_key_rsa,
    local.ssh_public_key_ed25519
  ]

  # User Configuration
  username = local.username

  # Initialization Configuration
  initialization_datastore_id = local.vm_common.initialization_datastore_id
  dns_servers                 = local.vm_common.dns_servers
  ipv4_address                = local.dkr_srv_2.ipv4_address
  ipv4_gateway                = local.dkr_srv_2.ipv4_gateway

  # VM Lifecycle Settings
  on_boot             = local.vm_common.on_boot
  reboot_after_update = local.vm_common.reboot_after_update
  started             = local.vm_common.started

  # EFI and TPM
  efi_disk_enabled  = local.vm_common.efi_disk_enabled
  tpm_state_enabled = local.vm_common.tpm_state_enabled
}

module "dkr_srv_3" {
  source = "./modules/proxmox-vm"

  # Basic Configuration
  name        = local.dkr_srv_3.name
  description = local.vm_common.description
  tags        = local.vm_common.tags
  node_name   = local.vm_common.node_name
  vm_id       = local.dkr_srv_3.vm_id

  # Clone Configuration
  template_vm_id = local.vm_common.template_vm_id
  full_clone     = local.vm_common.full_clone

  # Agent Configuration
  agent_enabled = local.vm_common.agent_enabled
  agent_timeout = local.vm_common.agent_timeout

  # Hardware Configuration
  memory_dedicated = local.vm_common.memory_dedicated
  cpu_cores        = local.vm_common.cpu_cores
  cpu_sockets      = local.vm_common.cpu_sockets

  # Disk Configuration
  disk_datastore_id = local.vm_common.disk_datastore_id
  disk_interface    = local.vm_common.disk_interface
  disk_size         = local.vm_common.disk_size
  disk_iothread     = local.vm_common.disk_iothread
  additional_disks  = local.vm_common.additional_disks

  # Network Configuration
  network_bridge   = local.vm_common.network_bridge
  network_model    = local.vm_common.network_model
  network_vlan_id  = local.vm_common.network_vlan_id
  network_firewall = local.vm_common.network_firewall

  # SSH Keys
  ssh_keys = [
    local.ssh_public_key_rsa,
    local.ssh_public_key_ed25519
  ]

  # User Configuration
  username = local.username

  # Initialization Configuration
  initialization_datastore_id = local.vm_common.initialization_datastore_id
  dns_servers                 = local.vm_common.dns_servers
  ipv4_address                = local.dkr_srv_3.ipv4_address
  ipv4_gateway                = local.dkr_srv_3.ipv4_gateway

  # VM Lifecycle Settings
  on_boot             = local.vm_common.on_boot
  reboot_after_update = local.vm_common.reboot_after_update
  started             = local.vm_common.started

  # EFI and TPM
  efi_disk_enabled  = local.vm_common.efi_disk_enabled
  tpm_state_enabled = local.vm_common.tpm_state_enabled
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

# Output the VM information
output "dkr_srv_3_vm_id" {
  description = "The ID of the dkr-srv-3 VM"
  value       = module.dkr_srv_3.vm_id
}

output "dkr_srv_3_vm_name" {
  description = "The name of the dkr-srv-3 VM"
  value       = module.dkr_srv_3.vm_name
}

output "dkr_srv_3_vm_node" {
  description = "The Proxmox node where dkr-srv-3 is running"
  value       = module.dkr_srv_3.vm_node_name
}
