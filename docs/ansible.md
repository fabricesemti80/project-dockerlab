# Ansible Documentation

This document provides comprehensive documentation for the Ansible automation in project-dockerlab.

## Overview

Ansible is used to configure and manage all VMs in the homelab environment. It handles everything from base system configuration to Docker Swarm formation.

## Directory Structure

```
ansible/
├── group_vars/           # Group variable definitions
│   └── all.yml          # Variables applied to all hosts
├── inventory/           # Inventory files
│   └── hosts            # Static inventory definition
├── roles/               # Custom roles
│   ├── common_base/     # Base system configuration
│   ├── dokploy/         # Dokploy deployment
│   ├── portainer_be/    # Portainer Business Edition
│   ├── proxmox_template/# Proxmox template creation
│   ├── proxmox_vm/      # Proxmox VM deployment
│   ├── sanitycheck/     # System sanity checks
│   ├── swarm_bootstrap/ # Docker Swarm initialization
│   ├── swarm_labels/    # Swarm node labeling
│   ├── system_update/   # System package updates
│   └── tailscale_post/  # Tailscale post-installation tasks
├── templates/           # Jinja2 templates
├── 00-proxmox-template-creation.yml
├── 01-proxmox-vm-deployment.yml
├── 10-site-preflight.yml
├── 20-site-base.yml
├── 20-site-tailscale.yml
├── 30-site-docker.yml
├── 30-site-docker-user-only.yml
├── 40-site-swarm.yml
├── 40-dokploy.yml
├── ansible.cfg
├── requirements.yml
└── site.yml             # Main orchestration playbook
```

## Playbook Execution Order

The main `site.yml` orchestrates deployment in the following order:

| Order | Playbook | Description |
|-------|----------|-------------|
| 1 | `00-proxmox-template-creation.yml` | Creates VM templates on Proxmox |
| 2 | `10-site-preflight.yml` | System updates and connectivity checks |
| 3 | `20-site-base.yml` | Base system configuration |
| 4 | `20-site-tailscale.yml` | Tailscale mesh network setup |
| 5 | `30-site-docker.yml` | Docker installation and configuration |
| 6 | `40-site-swarm.yml` | Docker Swarm cluster formation |

### Additional Playbooks

| Playbook | Description |
|----------|-------------|
| `30-site-docker-user-only.yml` | Safe playbook to add users to docker group without restarting Docker |
| `40-dokploy.yml` | Deploys Dokploy container management platform |

## Inventory

The inventory is defined in `inventory/hosts` and includes:

### Host Groups

| Group | Description |
|-------|-------------|
| `proxmox` | Proxmox hypervisor hosts |
| `proxmox_vms` | VMs running on Proxmox |
| `cloud_vms` | VMs running in the cloud (Hetzner) |
| `vms` | All VMs (proxmox_vms + cloud_vms) |
| `swarm_managers` | Docker Swarm manager nodes |

### Current Hosts

| Host | IP Address | Environment |
|------|------------|-------------|
| pve-2 | 10.0.40.12 | Proxmox hypervisor |
| dkr-srv-1 | 10.0.30.11 | On-premises VM |
| dkr-srv-2 | 10.0.30.12 | On-premises VM |
| dkr-srv-0 | 157.180.84.140 | Hetzner Cloud |

## Roles

### common_base

Performs base system configuration:
- Sets hostname
- Configures `/etc/hosts`
- Enables IP forwarding (required for Docker)
- Disables swap
- Installs chrony for time sync
- Installs common packages

### swarm_bootstrap

Initializes Docker Swarm cluster:
- Creates swarm on first manager
- Joins additional managers to the swarm
- Configures swarm settings

### swarm_labels

Applies labels to swarm nodes for placement constraints.

### tailscale_post

Post-Tailscale installation tasks:
- Verifies tailscale0 interface exists
- Captures Tailscale IP addresses
- Validates mesh connectivity between all nodes

### system_update

Updates system packages and performs system maintenance.

### dokploy

Deploys and configures Dokploy container management platform.

### portainer_be

Deploys Portainer Business Edition for container management.

## Docker Configuration

Docker installation and daemon configuration is handled by `30-site-docker.yml` using the `geerlingguy.docker` role with the following daemon options:

```yaml
docker_daemon_options:
  mtu: 1280
  hosts:
    - "tcp://{{ ansible_tailscale0.ipv4.address }}:2376"
    - "unix:///var/run/docker.sock"
  log-driver: "json-file"
  log-opts:
    max-size: "10m"
    max-file: "3"
  storage-driver: "overlay2"
  live-restore: false          # Must be false for Swarm
  userland-proxy: false
  default-address-pools:
    - base: "10.20.0.0/16"
      size: 24
```

Key configuration points:
- **MTU 1280**: Compatible with Tailscale tunnel
- **TCP binding**: Docker API exposed on Tailscale IP for secure remote access
- **live-restore: false**: Required for Docker Swarm mode
- **Custom address pools**: Avoids conflicts with home network

## Required Dependencies

Install Galaxy roles and collections before running playbooks:

```bash
# Using task runner (recommended)
task ansible:init

# Or manually
doppler run -- ansible-galaxy install -r requirements.yml
doppler run -- ansible-galaxy collection install -r requirements.yml
```

### External Roles

| Role | Purpose |
|------|---------|
| `geerlingguy.docker` | Docker installation and daemon configuration |
| `geerlingguy.pip` | Python pip installation |

### External Collections

| Collection | Purpose |
|------------|---------|
| `artis3n.tailscale` | Tailscale installation and configuration |

## Common Commands

All commands are run with Doppler for secrets management:

```bash
# Apply entire site configuration
task ansible:site:apply

# Plan (dry-run) entire site
task ansible:site:plan

# Apply specific stages
task ansible:preflight:apply    # System updates
task ansible:base:apply         # Base configuration
task ansible:tailscale:apply    # Tailscale setup
task ansible:docker:apply       # Docker installation

# Proxmox-specific tasks
task ansible:template:apply     # Create VM templates
task ansible:vm:apply           # Deploy VMs from templates
```

## Variables

### Global Variables (group_vars/all.yml)

| Variable | Default | Description |
|----------|---------|-------------|
| `admin_user` | `fs` | Main admin user |
| `sudo_nopasswd` | `true` | Allow sudo without password |
| `install_packages` | (list) | Packages to install on all hosts |

### Default Packages

- apt-transport-https
- ca-certificates
- curl
- gnupg
- lsb-release
- htop
- neofetch
- unzip
- git
- dnsutils

## Environment Variables

The following environment variables are required (managed by Doppler):

| Variable | Description |
|----------|-------------|
| `TAILSCALE_AUTH_KEY` | Tailscale authentication key |

## Troubleshooting

### SSH Connection Issues

```bash
# Test connectivity
ansible -i ansible/inventory/hosts all -m ping

# Verbose mode
doppler run -- ansible-playbook site.yml -vvv
```

### Tailscale Issues

The playbook includes debug tasks that show:
- Tailscale service logs
- Tailscale status
- Tailscale IP address

### Docker Swarm Issues

If Docker restarts and services move between nodes:
- Check volume persistence with `docker volume ls`
- Use placement constraints for stateful services
- See [Portainer multi-manager docs](https://docs.portainer.io/faqs/installing/how-can-i-ensure-portainers-configuration-is-retained)

### Safe Docker User Addition

To add users to the docker group without restarting Docker:
```bash
doppler run -- ansible-playbook 30-site-docker-user-only.yml
```
