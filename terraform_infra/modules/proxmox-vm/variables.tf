# Basic Configuration
variable "name" {
  description = "The name of the VM."
  type        = string
}

variable "description" {
  description = "The description of the VM."
  type        = string
  default     = ""
}

variable "tags" {
  description = "A list of tags to apply to the VM."
  type        = list(string)
  default     = []
}

variable "node_name" {
  description = "The Proxmox node to create the VM on."
  type        = string
}

variable "vm_id" {
  description = "The ID of the VM."
  type        = number
}

# Clone Configuration
variable "template_vm_id" {
  description = "The ID of the template to clone."
  type        = number
}

variable "template_node_name" {
  description = "The name of the node where the template resides."
  type        = string
  default     = null
}

variable "full_clone" {
  description = "Whether to create a full clone or a linked clone."
  type        = bool
  default     = true
}

# Agent Configuration
variable "agent_enabled" {
  description = "Enable/disable the QEMU guest agent."
  type        = bool
  default     = true
}

variable "agent_timeout" {
  description = "The timeout for the QEMU guest agent."
  type        = string
  default     = "15m"
}

variable "agent_trim" {
  description = "Enable/disable trim for the QEMU guest agent."
  type        = bool
  default     = true
}

variable "agent_type" {
  description = "The type of QEMU guest agent."
  type        = string
  default     = "virtio"
}

# Hardware Configuration
variable "memory_dedicated" {
  description = "The amount of dedicated memory in MB."
  type        = number
}

variable "cpu_cores" {
  description = "The number of CPU cores."
  type        = number
}

variable "cpu_sockets" {
  description = "The number of CPU sockets."
  type        = number
}

variable "cpu_type" {
  description = "The CPU type."
  type        = string
  default     = "host"
}

variable "scsi_hardware" {
  description = "The SCSI hardware controller model."
  type        = string
  default     = "virtio-scsi-pci"
}

# Disk Configuration
variable "disk_datastore_id" {
  description = "The datastore ID for the primary disk."
  type        = string
}

variable "disk_interface" {
  description = "The interface for the primary disk."
  type        = string
}

variable "disk_size" {
  description = "The size of the primary disk in GB."
  type        = number
}

variable "disk_file_format" {
  description = "The file format for the primary disk."
  type        = string
  default     = "raw"
}

variable "disk_iothread" {
  description = "Enable/disable iothread for the primary disk."
  type        = bool
  default     = false
}

variable "disk_cache" {
  description = "The cache mode for the primary disk."
  type        = string
  default     = "none"
}

variable "additional_disks" {
  description = "A list of additional disks to create."
  type        = any
  default     = []
}

# EFI and TPM
variable "efi_disk_enabled" {
  description = "Enable/disable EFI disk."
  type        = bool
  default     = false
}

variable "tpm_state_enabled" {
  description = "Enable/disable TPM state."
  type        = bool
  default     = false
}

# PCI and USB Devices
variable "pci_devices" {
  description = "A list of PCI devices to pass through."
  type        = any
  default     = []
}

variable "usb_devices" {
  description = "A list of USB devices to pass through."
  type        = any
  default     = []
}

# Network Configuration
variable "network_bridge" {
  description = "The network bridge to connect the VM to."
  type        = string
}

variable "network_model" {
  description = "The network model."
  type        = string
  default     = "virtio"
}

variable "network_vlan_id" {
  description = "The VLAN ID for the network interface."
  type        = number
  default     = -1 # -1 means no VLAN
}

variable "network_firewall" {
  description = "Enable/disable the firewall for the network interface."
  type        = bool
  default     = false
}

variable "additional_network_devices" {
  description = "A list of additional network devices to connect the VM to."
  type = list(object({
    bridge   = string
    model    = optional(string, "virtio")
    vlan_id  = optional(number, -1)
    firewall = optional(bool, false)
  }))
  default = []
}

# Initialization Configuration
variable "initialization_datastore_id" {
  description = "The datastore ID for initialization."
  type        = string
}

variable "dns_servers" {
  description = "A list of DNS servers."
  type        = list(string)
  default     = null
}

variable "user_data" {
  description = "The user data for cloud-init."
  type        = string
  default     = null
}

variable "initialization_user_data_file_id" {
  description = "The user data file ID for cloud-init."
  type        = string
  default     = null
}

variable "ipv4_address" {
  description = "The IPv4 address of the VM."
  type        = string
  default     = null
}

variable "ipv4_gateway" {
  description = "The IPv4 gateway of the VM."
  type        = string
  default     = null
}

variable "additional_ipv4_configs" {
  description = "A list of additional IPv4 configurations."
  type = list(object({
    address = string
    gateway = optional(string)
  }))
  default = []
}

variable "ipv6_address" {
  description = "The IPv6 address of the VM."
  type        = string
  default     = null
}

variable "ipv6_gateway" {
  description = "The IPv6 gateway of the VM."
  type        = string
  default     = null
}

variable "username" {
  description = "The username for the VM."
  type        = string
  default     = null
}

variable "password" {
  description = "The password for the user."
  type        = string
  default     = null
}

variable "ssh_keys" {
  description = "A list of SSH public keys."
  type        = list(string)
  default     = []
}

variable "ssh_public_key_rsa" {
  description = "The RSA SSH public key."
  type        = string
  default     = ""
}

variable "ssh_public_key_ed25519" {
  description = "The Ed25519 SSH public key."
  type        = string
  default     = ""
}

# VM Lifecycle Settings
variable "on_boot" {
  description = "Whether to start the VM on boot."
  type        = bool
  default     = true
}

variable "reboot_after_update" {
  description = "Whether to reboot the VM after an update."
  type        = bool
  default     = false
}

variable "started" {
  description = "Whether the VM should be started."
  type        = bool
  default     = true
}

variable "pool_id" {
  description = "The ID of the resource pool to assign the VM to."
  type        = string
  default     = null
}
