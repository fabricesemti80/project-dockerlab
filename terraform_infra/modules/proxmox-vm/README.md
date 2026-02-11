# Proxmox VM Module

This Terraform module creates and manages Proxmox virtual machines with flexible configuration options.

## Features

- Clone from existing VM templates
- Configurable hardware specifications (CPU, memory, disks)
- Network configuration with VLAN support
- Cloud-init integration for OS configuration
- Support for PCI and USB device passthrough
- Multiple disk configurations
- Comprehensive lifecycle management

## Usage

```hcl
module "worker_vm" {
  source = "./modules/proxmox-vm"

  # Basic Configuration
  name        = "coolify-worker0"
  description = "Managed by Terraform"
  tags        = ["community-script", "ubuntu"]
  node_name   = "pve-2"
  vm_id       = 3010

  # Clone Configuration
  template_vm_id = 9007
  full_clone     = true

  # Hardware
  memory_dedicated = 4096
  cpu_cores        = 2
  cpu_sockets      = 1

  # Disk Configuration
  disk_datastore_id = "ceph-proxmox-rbd"
  disk_interface    = "scsi0"
  disk_size         = 30

  # Network Configuration
  network_bridge   = "vmbr0"
  network_model    = "virtio"
  network_vlan_id  = 30
  network_firewall = false

  # Initialization
  initialization_datastore_id = "ceph-proxmox-rbd"
  dns_servers                 = ["9.9.9.9", "149.112.112.112"] # Quad9 DNS
  ipv4_address                = "10.0.30.10/24"
  ipv4_gateway                = "10.0.30.1"

  # Agent
  agent_enabled = false
  agent_timeout = "5m"
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_proxmox"></a> [proxmox](#requirement\_proxmox) | 0.95.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_proxmox"></a> [proxmox](#provider\_proxmox) | 0.95.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [proxmox_virtual_environment_file.user_data](https://registry.terraform.io/providers/bpg/proxmox/0.95.0/docs/resources/virtual_environment_file) | resource |
| [proxmox_virtual_environment_vm.vm](https://registry.terraform.io/providers/bpg/proxmox/0.95.0/docs/resources/virtual_environment_vm) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_additional_disks"></a> [additional\_disks](#input\_additional\_disks) | A list of additional disks to create. | `any` | `[]` | no |
| <a name="input_additional_ipv4_configs"></a> [additional\_ipv4\_configs](#input\_additional\_ipv4\_configs) | A list of additional IPv4 configurations. | <pre>list(object({<br/>    address = string<br/>    gateway = optional(string)<br/>  }))</pre> | `[]` | no |
| <a name="input_additional_network_devices"></a> [additional\_network\_devices](#input\_additional\_network\_devices) | A list of additional network devices to connect the VM to. | <pre>list(object({<br/>    bridge   = string<br/>    model    = optional(string, "virtio")<br/>    vlan_id  = optional(number, -1)<br/>    firewall = optional(bool, false)<br/>  }))</pre> | `[]` | no |
| <a name="input_agent_enabled"></a> [agent\_enabled](#input\_agent\_enabled) | Enable/disable the QEMU guest agent. | `bool` | `true` | no |
| <a name="input_agent_timeout"></a> [agent\_timeout](#input\_agent\_timeout) | The timeout for the QEMU guest agent. | `string` | `"15m"` | no |
| <a name="input_agent_trim"></a> [agent\_trim](#input\_agent\_trim) | Enable/disable trim for the QEMU guest agent. | `bool` | `true` | no |
| <a name="input_agent_type"></a> [agent\_type](#input\_agent\_type) | The type of QEMU guest agent. | `string` | `"virtio"` | no |
| <a name="input_cpu_cores"></a> [cpu\_cores](#input\_cpu\_cores) | The number of CPU cores. | `number` | n/a | yes |
| <a name="input_cpu_sockets"></a> [cpu\_sockets](#input\_cpu\_sockets) | The number of CPU sockets. | `number` | n/a | yes |
| <a name="input_cpu_type"></a> [cpu\_type](#input\_cpu\_type) | The CPU type. | `string` | `"host"` | no |
| <a name="input_description"></a> [description](#input\_description) | The description of the VM. | `string` | `""` | no |
| <a name="input_disk_cache"></a> [disk\_cache](#input\_disk\_cache) | The cache mode for the primary disk. | `string` | `"none"` | no |
| <a name="input_disk_datastore_id"></a> [disk\_datastore\_id](#input\_disk\_datastore\_id) | The datastore ID for the primary disk. | `string` | n/a | yes |
| <a name="input_disk_file_format"></a> [disk\_file\_format](#input\_disk\_file\_format) | The file format for the primary disk. | `string` | `"raw"` | no |
| <a name="input_disk_interface"></a> [disk\_interface](#input\_disk\_interface) | The interface for the primary disk. | `string` | n/a | yes |
| <a name="input_disk_iothread"></a> [disk\_iothread](#input\_disk\_iothread) | Enable/disable iothread for the primary disk. | `bool` | `false` | no |
| <a name="input_disk_size"></a> [disk\_size](#input\_disk\_size) | The size of the primary disk in GB. | `number` | n/a | yes |
| <a name="input_dns_servers"></a> [dns\_servers](#input\_dns\_servers) | A list of DNS servers. | `list(string)` | `null` | no |
| <a name="input_efi_disk_enabled"></a> [efi\_disk\_enabled](#input\_efi\_disk\_enabled) | Enable/disable EFI disk. | `bool` | `false` | no |
| <a name="input_full_clone"></a> [full\_clone](#input\_full\_clone) | Whether to create a full clone or a linked clone. | `bool` | `true` | no |
| <a name="input_initialization_datastore_id"></a> [initialization\_datastore\_id](#input\_initialization\_datastore\_id) | The datastore ID for initialization. | `string` | n/a | yes |
| <a name="input_initialization_user_data_file_id"></a> [initialization\_user\_data\_file\_id](#input\_initialization\_user\_data\_file\_id) | The user data file ID for cloud-init. | `string` | `null` | no |
| <a name="input_ipv4_address"></a> [ipv4\_address](#input\_ipv4\_address) | The IPv4 address of the VM. | `string` | `null` | no |
| <a name="input_ipv4_gateway"></a> [ipv4\_gateway](#input\_ipv4\_gateway) | The IPv4 gateway of the VM. | `string` | `null` | no |
| <a name="input_ipv6_address"></a> [ipv6\_address](#input\_ipv6\_address) | The IPv6 address of the VM. | `string` | `null` | no |
| <a name="input_ipv6_gateway"></a> [ipv6\_gateway](#input\_ipv6\_gateway) | The IPv6 gateway of the VM. | `string` | `null` | no |
| <a name="input_memory_dedicated"></a> [memory\_dedicated](#input\_memory\_dedicated) | The amount of dedicated memory in MB. | `number` | n/a | yes |
| <a name="input_name"></a> [name](#input\_name) | The name of the VM. | `string` | n/a | yes |
| <a name="input_network_bridge"></a> [network\_bridge](#input\_network\_bridge) | The network bridge to connect the VM to. | `string` | n/a | yes |
| <a name="input_network_firewall"></a> [network\_firewall](#input\_network\_firewall) | Enable/disable the firewall for the network interface. | `bool` | `false` | no |
| <a name="input_network_model"></a> [network\_model](#input\_network\_model) | The network model. | `string` | `"virtio"` | no |
| <a name="input_network_vlan_id"></a> [network\_vlan\_id](#input\_network\_vlan\_id) | The VLAN ID for the network interface. | `number` | `-1` | no |
| <a name="input_node_name"></a> [node\_name](#input\_node\_name) | The Proxmox node to create the VM on. | `string` | n/a | yes |
| <a name="input_on_boot"></a> [on\_boot](#input\_on\_boot) | Whether to start the VM on boot. | `bool` | `true` | no |
| <a name="input_password"></a> [password](#input\_password) | The password for the user. | `string` | `null` | no |
| <a name="input_pci_devices"></a> [pci\_devices](#input\_pci\_devices) | A list of PCI devices to pass through. | `any` | `[]` | no |
| <a name="input_pool_id"></a> [pool\_id](#input\_pool\_id) | The ID of the resource pool to assign the VM to. | `string` | `null` | no |
| <a name="input_reboot_after_update"></a> [reboot\_after\_update](#input\_reboot\_after\_update) | Whether to reboot the VM after an update. | `bool` | `false` | no |
| <a name="input_scsi_hardware"></a> [scsi\_hardware](#input\_scsi\_hardware) | The SCSI hardware controller model. | `string` | `"virtio-scsi-pci"` | no |
| <a name="input_ssh_keys"></a> [ssh\_keys](#input\_ssh\_keys) | A list of SSH public keys. | `list(string)` | `[]` | no |
| <a name="input_ssh_public_key_ed25519"></a> [ssh\_public\_key\_ed25519](#input\_ssh\_public\_key\_ed25519) | The Ed25519 SSH public key. | `string` | `""` | no |
| <a name="input_ssh_public_key_rsa"></a> [ssh\_public\_key\_rsa](#input\_ssh\_public\_key\_rsa) | The RSA SSH public key. | `string` | `""` | no |
| <a name="input_started"></a> [started](#input\_started) | Whether the VM should be started. | `bool` | `true` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A list of tags to apply to the VM. | `list(string)` | `[]` | no |
| <a name="input_template_node_name"></a> [template\_node\_name](#input\_template\_node\_name) | The name of the node where the template resides. | `string` | `null` | no |
| <a name="input_template_vm_id"></a> [template\_vm\_id](#input\_template\_vm\_id) | The ID of the template to clone. | `number` | n/a | yes |
| <a name="input_tpm_state_enabled"></a> [tpm\_state\_enabled](#input\_tpm\_state\_enabled) | Enable/disable TPM state. | `bool` | `false` | no |
| <a name="input_usb_devices"></a> [usb\_devices](#input\_usb\_devices) | A list of USB devices to pass through. | `any` | `[]` | no |
| <a name="input_user_data"></a> [user\_data](#input\_user\_data) | The user data for cloud-init. | `string` | `null` | no |
| <a name="input_username"></a> [username](#input\_username) | The username for the VM. | `string` | `null` | no |
| <a name="input_vm_id"></a> [vm\_id](#input\_vm\_id) | The ID of the VM. | `number` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vm_id"></a> [vm\_id](#output\_vm\_id) | The ID of the created VM |
| <a name="output_vm_ipv4_address"></a> [vm\_ipv4\_address](#output\_vm\_ipv4\_address) | The IPv4 address of the VM |
| <a name="output_vm_name"></a> [vm\_name](#output\_vm\_name) | The name of the created VM |
| <a name="output_vm_node_name"></a> [vm\_node\_name](#output\_vm\_node\_name) | The Proxmox node where the VM is running |
| <a name="output_vm_tags"></a> [vm\_tags](#output\_vm\_tags) | The tags assigned to the VM |
<!-- END_TF_DOCS -->

## Examples

### Basic Worker Node
```hcl
module "worker0" {
  source = "./modules/proxmox-vm"

  name      = "coolify-worker0"
  node_name = "pve-2"
  vm_id     = 3010

  template_vm_id = 9007
  memory_dedicated = 4096
  disk_size = 30
  disk_datastore_id = "ceph-proxmox-rbd"

  network_bridge  = "vmbr0"
  network_vlan_id = 30
  ipv4_address    = "10.0.30.10/24"
  ipv4_gateway    = "10.0.30.1"
}
