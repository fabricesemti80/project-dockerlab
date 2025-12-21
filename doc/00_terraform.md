# Terraform Documentation

This document explains the Terraform setup for the Dokploy Homelab project.

## Providers

The [`terraform/providers.tf`](../terraform/providers.tf:1) file defines the required Terraform providers for this project:

*   **hcloud:** Used to manage resources in Hetzner Cloud.
*   **proxmox:** Used to manage resources in Proxmox.
*   **cloudflare:** Used to manage Cloudflare resources.

## Hetzner Cloud Setup

The [`terraform/main_hcloud.tf`](../terraform/main_hcloud.tf:1) file is responsible for creating the infrastructure on Hetzner Cloud.

### Dokploy Server Module

This module, sourced from [`./modules/hetzner-cloud`](../terraform/modules/hetzner-cloud:1), creates the main Dokploy server with the following configuration:

*   **Server Name:** `dkr-srv-0`
*   **Image:** Ubuntu 22.04
*   **Server Type:** `cx23` (2 vCPU, 4GB RAM)
*   **Location:** Helsinki
*   **SSH Key:** An SSH key is configured for access.
*   **Firewall:** A firewall named `dokply-firewall` is created with rules to allow traffic on ports 22 (SSH), 80 (HTTP), 443 (HTTPS), and 3000 (Dokploy UI).

### User Data

The `user_data` script in this file automates the installation of Tailscale on the server upon creation. It connects the server to your Tailscale network using the provided authentication key.

## Proxmox Setup

The [`terraform/main_proxmox.tf`](../terraform/main_proxmox.tf:1) file is responsible for creating the infrastructure on Proxmox. It creates two VMs, `dokploy-ctrl1` and `dokploy-ctrl2`, using the `proxmox-vm` module.

### Cloud-Init

This file uses `proxmox_virtual_environment_file` to create cloud-init snippets for the VMs. These snippets are generated from the [`data/vm_userdata.tftpl`](../data/vm_userdata.tftpl:1) template and contain the necessary configuration to set up the VMs, including Tailscale installation.

### Proxmox VM Module

The [`modules/proxmox-vm`](../terraform/modules/proxmox-vm:1) module is a reusable module to create a VM in Proxmox. It defines the VM resources and outputs.

### Ansible Inventory

A `local_file` resource is used to generate an Ansible inventory file at [`ansible/inventory.yml`](../ansible/inventory.yml:1). This inventory is dynamically populated with the IP addresses of the created VMs, making it easy to run Ansible playbooks against them.

## Coolify User Data

The [`terraform/coolify_userdata.tftpl`](../terraform/coolify_userdata.tftpl:1) file is a cloud-config template used for setting up Coolify worker nodes. It performs the following actions:

*   **Disables unattended-upgrades:** to prevent conflicts with other package management operations.
*   **Installs prerequisites:** `curl` and `jq`.
*   **Installs Tailscale:** using the official script.
*   **Connects to Tailscale:** using the provided authentication key.

## Modules

### Hetzner Cloud Module

The [`terraform/modules/hetzner-cloud/`](../terraform/modules/hetzner-cloud:1) module is a reusable module to create a server in Hetzner Cloud. It defines the server resources, firewall, and outputs.

### Proxmox VM Module

The [`terraform/modules/proxmox-vm/`](../terraform/modules/proxmox-vm:1) module is a reusable module to create a VM in Proxmox. It defines the VM resources and outputs.