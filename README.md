# Dokker homelab setup guide

> reference for future-self mainly!

This project provides a comprehensive setup for a hybrid homelab environment that combines cloud and on-premises infrastructure. The setup uses Proxmox for virtualization on-premises and VMs with Docker Swarm for container orchestration across both environments.

## 🏗️ Architecture Overview

- **On-premises**: Proxmox VE for VM management and virtualization
- **Cloud**: Hetzner Cloud instances for additional capacity
- **Orchestration**: Docker Swarm for container management across environments
- **Networking**: Tailscale for secure mesh networking
- **Deployment**: Ansible for configuration management and automation
- **Infrastructure**: Terraform for infrastructure as code

## 📋 Sections

### 00-base image creation 🖼️

This section covers the initial setup of base VM templates using Proxmox VE and community scripts.

#### 📥 Provisioning a Debian 13 VM

To create a base VM template for your homelab, follow these steps:

1. **Access Proxmox Community Scripts**
   - Visit: https://community-scripts.github.io/ProxmoxVE/scripts?id=debian-13-vm&category=Operating+Systems
   - This script automates the creation of a Debian 13 VM with optimal settings for container workloads

2. **Run the Community Script**
   - In your Proxmox web interface, navigate to the Datacenter view
   - Click on "Shell" in the top-right corner
   - Copy and paste the script from the community page
   - Execute the script to create your base VM

3. **VM Configuration Details**
   - **OS**: Debian 13 (Bookworm)
   - **Storage**: Optimized for container workloads
   - **Networking**: Bridge networking for Docker Swarm compatibility
   - **Resources**: Configurable CPU and RAM allocation

4. **Convert to Template**
   - Once the VM is created and configured:
     - Right-click on the VM in the Proxmox interface
     - Select "Convert to Template"
     - This creates a reusable template for quick deployment

5. **Template Benefits**
   - Fast VM deployment from template
   - Consistent base configuration across all nodes
   - Easy scaling by cloning from template
   - Reduced setup time for new swarm nodes

#### 🔄 Template Management

- **Naming Convention**: Use descriptive names like `debian13-docker-template`
- **Updates**: Regularly update the template with security patches
- **Cloning**: Clone from template when adding new nodes to your swarm
- **Backup**: Keep template backups for disaster recovery

This base template will serve as the foundation for all your Docker Swarm nodes, whether they're running on-premises or in the cloud.
