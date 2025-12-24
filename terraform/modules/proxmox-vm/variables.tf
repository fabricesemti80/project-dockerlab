# Proxmox VM Module Variables

# Basic VM Configuration
variable "name" {
  description = "The name of the VM"
  type        = string
}

variable "description" {
  description = "Description of the VM"
  type        = string
  default     = "Managed by Terraform"
}

variable "tags" {
  description = "List of tags to assign to the VM"
  type        = list(string)
  default     = []
}

variable "node_name" {
  description = "The Proxmox node where the VM will be created"
  type        = string
}

variable "vm_id" {
  description = "The VM ID (must be unique across all VMs)"
  type        = number
}

# Clone Configuration
variable "template_vm_id" {
  description = "The VM ID of the template to clone from"
  type        = number
}

variable "full_clone" {
  description = "Whether to perform a full clone (creates independent copy)"
  type        = bool
  default     = true
}

# Agent Configuration
variable "agent_enabled" {
  description = "Whether to enable the QEMU guest agent"
  type        = bool
  default     = false
}

variable "agent_timeout" {
  description = "Timeout for the QEMU guest agent"
  type        = string
  default     = "5m"
}

variable "agent_trim" {
  description = "Whether to enable TRIM support for the agent"
  type        = bool
  default     = true
}

variable "agent_type" {
  description = "Type of the QEMU guest agent"
  type        = string
  default     = "virtio"
}

# Hardware Configuration
variable "memory_dedicated" {
  description = "Amount of RAM to allocate to the VM in MB"
  type        = number
  default     = 1024
}

variable "cpu_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 1
}

variable "cpu_sockets" {
  description = "Number of CPU sockets"
  type        = number
  default     = 1
}

variable "cpu_type" {
  description = "CPU type/model"
  type        = string
  default     = "host"
}

# Disk Configuration
variable "disk_datastore_id" {
  description = "The datastore where the disk will be stored"
  type        = string
}

variable "disk_interface" {
  description = "The disk interface type"
  type        = string
  default     = "scsi0"
}

variable "disk_size" {
  description = "Size of the disk in GB"
  type        = number
  default     = 20
}

variable "disk_file_format" {
  description = "Disk file format (raw, qcow2, etc.)"
  type        = string
  default     = "raw"
}

variable "disk_iothread" {
  description = "Whether to enable IO threads for the disk"
  type        = bool
  default     = false
}

variable "disk_cache" {
  description = "Disk cache mode"
  type        = string
  default     = "none"
}

# Network Configuration
variable "network_bridge" {
  description = "The bridge to connect the network device to"
  type        = string
}

variable "network_model" {
  description = "Network device model"
  type        = string
  default     = "virtio"
}

variable "network_vlan_id" {
  description = "VLAN ID for the network device"
  type        = number
  default     = null
}

variable "network_firewall" {
  description = "Whether to enable the firewall for this network device"
  type        = bool
  default     = false
}

# Initialization Configuration
variable "initialization_datastore_id" {
  description = "The datastore for cloud-init configuration"
  type        = string
}

variable "dns_servers" {
  description = "List of DNS servers"
  type        = list(string)
  default     = ["9.9.9.9", "149.112.112.112"]
}

variable "ipv4_address" {
  description = "IPv4 address in CIDR notation (e.g., 10.0.30.10/24)"
  type        = string
  default     = null
}

variable "ipv4_gateway" {
  description = "IPv4 gateway address"
  type        = string
  default     = null
}

variable "ipv6_address" {
  description = "IPv6 address in CIDR notation"
  type        = string
  default     = null
}

variable "ipv6_gateway" {
  description = "IPv6 gateway address"
  type        = string
  default     = null
}

variable "ssh_keys" {
  description = "List of SSH public keys for cloud-init"
  type        = list(string)
  default     = []
}

variable "ssh_public_key_rsa" {
  description = "RSA SSH public key content"
  type        = string
  default     = ""
}

variable "ssh_public_key_ed25519" {
  description = "Ed25519 SSH public key content"
  type        = string
  default     = ""
}

variable "username" {
  description = "Username for cloud-init"
  type        = string
  default     = null
}

variable "password" {
  description = "Password for cloud-init (not recommended for production)"
  type        = string
  default     = null
}

variable "initialization_user_data_file_id" {
  description = "The Proxmox file ID for the user data snippet"
  type        = string
  default     = null
}

variable "user_data" {
  description = <<-EOT
    Optional user data content for cloud-init (simple shell commands).

    Example usage:
    user_data = <<EOF
    #cloud-config
    runcmd:
      - echo "Simple initialization script"
      - apt-get update
      - echo "Initialization complete"
    EOF
    EOT
  type        = string
  default     = null
}

# Optional: Additional disks
variable "additional_disks" {
  description = "List of additional disks to create"
  type = list(object({
    datastore_id = string
    interface    = string
    size         = number
    file_format  = string
    iothread     = bool
    cache        = string
    backup       = bool
  }))
  default = []
}

# Optional: PCI devices
variable "pci_devices" {
  description = "List of PCI devices to passthrough"
  type = list(object({
    device  = string
    mapping = string
    pcie    = bool
    mdev    = string
    rombar  = bool
  }))
  default = []
}

# Optional: USB devices
variable "usb_devices" {
  description = "List of USB devices to passthrough"
  type = list(object({
    mapping = string
    usb3    = bool
  }))
  default = []
}

# VM lifecycle settings
variable "on_boot" {
  description = "Whether the VM should start on boot"
  type        = bool
  default     = true
}

variable "reboot_after_update" {
  description = "Whether to reboot after updates"
  type        = bool
  default     = false
}

variable "started" {
  description = "Whether the VM should be started after creation"
  type        = bool
  default     = true
}

variable "pool_id" {
  description = "Proxmox pool ID to assign the VM to"
  type        = string
  default     = null
}

# EFI and TPM Configuration
variable "efi_disk_enabled" {
  description = "Whether to enable EFI disk"
  type        = bool
  default     = true
}

variable "tpm_state_enabled" {
  description = "Whether to enable TPM state"
  type        = bool
  default     = true
}
