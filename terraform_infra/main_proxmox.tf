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
    description        = "Terraform Managed Docker Swarm VM"
    tags               = ["debian13", "docker", "swarm", "terraform"]
    node_name          = "pve-2"
    template_node_name = "pve-2"
    template_vm_id     = 9008
    full_clone         = true

    # Agent Configuration
    agent_enabled = false
    agent_timeout = "5m"

    # Hardware Configuration
    memory_dedicated = 8192
    cpu_cores        = 4
    cpu_sockets      = 2
    scsi_hardware    = "virtio-scsi-single"

    # Disk Configuration
    disk_datastore_id = "ceph-proxmox-rbd"
    disk_interface    = "virtio0"
    disk_size         = 32
    disk_iothread     = true

    # Additional Disks (GlusterFS)
    additional_disks = [
      {
        datastore_id = "ceph-proxmox-rbd"
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
    initialization_datastore_id = "ceph-proxmox-rbd"
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
    vm_id        = 3021
    node_name    = "pve-0"
    ipv4_address = "10.0.30.21/24"
    ipv4_gateway = "10.0.30.1"
    additional_network_devices = [
      {
        bridge  = "vmbr0"
        vlan_id = 70
      }
    ]
    additional_ipv4_configs = [
      {
        address = "10.0.70.21/24"
      }
    ]
  }

  dkr_srv_2 = {
    name         = "dkr-srv-2"
    vm_id        = 3022
    node_name    = "pve-1"
    ipv4_address = "10.0.30.22/24"
    ipv4_gateway = "10.0.30.1"
    additional_network_devices = [
      {
        bridge  = "vmbr0"
        vlan_id = 70
      }
    ]
    additional_ipv4_configs = [
      {
        address = "10.0.70.22/24"
      }
    ]
  }

  dkr_srv_3 = {
    name         = "dkr-srv-3"
    vm_id        = 3023
    node_name    = "pve-2"
    ipv4_address = "10.0.30.23/24"
    ipv4_gateway = "10.0.30.1"
    additional_network_devices = [
      {
        bridge  = "vmbr0"
        vlan_id = 70
      }
    ]
    additional_ipv4_configs = [
      {
        address = "10.0.70.23/24"
      }
    ]
  }

  dkr_wrkr_1 = {
    name         = "dkr-wrkr-1"
    vm_id        = 3031
    node_name    = "pve-0"
    ipv4_address = "10.0.30.31/24"
    ipv4_gateway = "10.0.30.1"
    additional_network_devices = [
      {
        bridge  = "vmbr0"
        vlan_id = 70
      }
    ]
    additional_ipv4_configs = [
      {
        address = "10.0.70.31/24"
      }
    ]
  }

  dkr_wrkr_2 = {
    name         = "dkr-wrkr-2"
    vm_id        = 3032
    node_name    = "pve-2"
    ipv4_address = "10.0.30.32/24"
    ipv4_gateway = "10.0.30.1"
    additional_network_devices = [
      {
        bridge  = "vmbr0"
        vlan_id = 70
      }
    ]
    additional_ipv4_configs = [
      {
        address = "10.0.70.32/24"
      }
    ]
  }
}

module "dkr_srv_1" {
  source = "./modules/proxmox-vm"

  # Basic Configuration
  name        = local.dkr_srv_1.name
  description = local.vm_common.description
  tags        = local.vm_common.tags
  node_name   = local.dkr_srv_1.node_name
  vm_id       = local.dkr_srv_1.vm_id

  # Clone Configuration
  template_vm_id     = local.vm_common.template_vm_id
  template_node_name = local.vm_common.template_node_name
  full_clone         = local.vm_common.full_clone

  # Agent Configuration
  agent_enabled = local.vm_common.agent_enabled
  agent_timeout = local.vm_common.agent_timeout

  # Hardware Configuration
  memory_dedicated = local.vm_common.memory_dedicated
  cpu_cores        = local.vm_common.cpu_cores
  cpu_sockets      = local.vm_common.cpu_sockets
  scsi_hardware    = local.vm_common.scsi_hardware

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
  additional_network_devices  = local.dkr_srv_1.additional_network_devices
  additional_ipv4_configs     = local.dkr_srv_1.additional_ipv4_configs

  # VM Lifecycle Settings
  on_boot             = local.vm_common.on_boot
  reboot_after_update = local.vm_common.reboot_after_update
  started             = local.vm_common.started

  # EFI and TPM
  efi_disk_enabled  = local.vm_common.efi_disk_enabled
  tpm_state_enabled = local.vm_common.tpm_state_enabled
}

# Outputs
output "dkr_wrkr_1_ipv4_address" {
  description = "IPv4 address of dkr-wrkr-1"
  value       = local.dkr_wrkr_1.ipv4_address
}

output "dkr_wrkr_1_hostname" {
  description = "Hostname of dkr-wrkr-1"
  value       = local.dkr_wrkr_1.name
}

output "dkr_wrkr_2_ipv4_address" {
  description = "IPv4 address of dkr-wrkr-2"
  value       = local.dkr_wrkr_2.ipv4_address
}

output "dkr_wrkr_2_hostname" {
  description = "Hostname of dkr-wrkr-2"
  value       = local.dkr_wrkr_2.name
}

module "dkr_srv_2" {
  source = "./modules/proxmox-vm"

  # Basic Configuration
  name        = local.dkr_srv_2.name
  description = local.vm_common.description
  tags        = local.vm_common.tags
  node_name   = local.dkr_srv_2.node_name
  vm_id       = local.dkr_srv_2.vm_id

  # Clone Configuration
  template_vm_id     = local.vm_common.template_vm_id
  template_node_name = local.vm_common.template_node_name
  full_clone         = local.vm_common.full_clone

  # Agent Configuration
  agent_enabled = local.vm_common.agent_enabled
  agent_timeout = local.vm_common.agent_timeout

  # Hardware Configuration
  memory_dedicated = local.vm_common.memory_dedicated
  cpu_cores        = local.vm_common.cpu_cores
  cpu_sockets      = local.vm_common.cpu_sockets
  scsi_hardware    = local.vm_common.scsi_hardware

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
  additional_network_devices  = local.dkr_srv_2.additional_network_devices
  additional_ipv4_configs     = local.dkr_srv_2.additional_ipv4_configs

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
  node_name   = local.dkr_srv_3.node_name
  vm_id       = local.dkr_srv_3.vm_id

  # Clone Configuration
  template_vm_id     = local.vm_common.template_vm_id
  template_node_name = local.vm_common.template_node_name
  full_clone         = local.vm_common.full_clone

  # Agent Configuration
  agent_enabled = local.vm_common.agent_enabled
  agent_timeout = local.vm_common.agent_timeout

  # Hardware Configuration
  memory_dedicated = local.vm_common.memory_dedicated
  cpu_cores        = local.vm_common.cpu_cores
  cpu_sockets      = local.vm_common.cpu_sockets
  scsi_hardware    = local.vm_common.scsi_hardware

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
  additional_network_devices  = local.dkr_srv_3.additional_network_devices
  additional_ipv4_configs     = local.dkr_srv_3.additional_ipv4_configs

  # VM Lifecycle Settings
  on_boot             = local.vm_common.on_boot
  reboot_after_update = local.vm_common.reboot_after_update
  started             = local.vm_common.started

  # EFI and TPM
  efi_disk_enabled  = local.vm_common.efi_disk_enabled
  tpm_state_enabled = local.vm_common.tpm_state_enabled
}

module "dkr_wrkr_1" {
  source = "./modules/proxmox-vm"

  # Basic Configuration
  name        = local.dkr_wrkr_1.name
  description = local.vm_common.description
  tags        = local.vm_common.tags
  node_name   = local.dkr_wrkr_1.node_name
  vm_id       = local.dkr_wrkr_1.vm_id

  # Clone Configuration
  template_vm_id     = local.vm_common.template_vm_id
  template_node_name = local.vm_common.template_node_name
  full_clone         = local.vm_common.full_clone

  # Agent Configuration
  agent_enabled = local.vm_common.agent_enabled
  agent_timeout = local.vm_common.agent_timeout

  # Hardware Configuration
  memory_dedicated = local.vm_common.memory_dedicated
  cpu_cores        = local.vm_common.cpu_cores
  cpu_sockets      = local.vm_common.cpu_sockets
  scsi_hardware    = local.vm_common.scsi_hardware

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
  ipv4_address                = local.dkr_wrkr_1.ipv4_address
  ipv4_gateway                = local.dkr_wrkr_1.ipv4_gateway
  additional_network_devices  = local.dkr_wrkr_1.additional_network_devices
  additional_ipv4_configs     = local.dkr_wrkr_1.additional_ipv4_configs

  # VM Lifecycle Settings
  on_boot             = local.vm_common.on_boot
  reboot_after_update = local.vm_common.reboot_after_update
  started             = local.vm_common.started

  # EFI and TPM
  efi_disk_enabled  = local.vm_common.efi_disk_enabled
  tpm_state_enabled = local.vm_common.tpm_state_enabled
}

module "dkr_wrkr_2" {
  source = "./modules/proxmox-vm"

  # Basic Configuration
  name        = local.dkr_wrkr_2.name
  description = local.vm_common.description
  tags        = local.vm_common.tags
  node_name   = local.dkr_wrkr_2.node_name
  vm_id       = local.dkr_wrkr_2.vm_id

  # Clone Configuration
  template_vm_id     = local.vm_common.template_vm_id
  template_node_name = local.vm_common.template_node_name
  full_clone         = local.vm_common.full_clone

  # Agent Configuration
  agent_enabled = local.vm_common.agent_enabled
  agent_timeout = local.vm_common.agent_timeout

  # Hardware Configuration
  memory_dedicated = local.vm_common.memory_dedicated
  cpu_cores        = local.vm_common.cpu_cores
  cpu_sockets      = local.vm_common.cpu_sockets
  scsi_hardware    = local.vm_common.scsi_hardware

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
  ipv4_address                = local.dkr_wrkr_2.ipv4_address
  ipv4_gateway                = local.dkr_wrkr_2.ipv4_gateway
  additional_network_devices  = local.dkr_wrkr_2.additional_network_devices
  additional_ipv4_configs     = local.dkr_wrkr_2.additional_ipv4_configs

  # VM Lifecycle Settings
  on_boot             = local.vm_common.on_boot
  reboot_after_update = local.vm_common.reboot_after_update
  started             = local.vm_common.started

  # EFI and TPM
  efi_disk_enabled  = local.vm_common.efi_disk_enabled
  tpm_state_enabled = local.vm_common.tpm_state_enabled
}