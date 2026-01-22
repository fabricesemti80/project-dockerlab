# Ansible Documentation

This document explains the Ansible setup for the Dokploy Homelab project.

## Main Playbook

The [`ansible/site.yml`](../ansible/site.yml:1) file is the main playbook that orchestrates the entire deployment process. It imports other playbooks in a specific order to set up the infrastructure.

1.  [`00-base.yml`](../ansible/00-base.yml:1): Sets up the base system configuration.
2.  [`10-tailscale.yml`](../ansible/10-tailscale.yml:1): Installs and configures Tailscale.

## Base Configuration

The [`ansible/00-base.yml`](../ansible/00-base.yml:1) playbook is responsible for the initial system setup. It runs the `common_base` role on all hosts to perform common system configurations.

### Common Base Role

The [`ansible/roles/common_base/`](../ansible/roles/common_base:1) role contains tasks for basic server setup. The main tasks are defined in [`tasks/main.yml`](../ansible/roles/common_base/tasks/main.yml:1):

*   **Set hostname:** Sets the hostname of the server from the inventory.
*   **Ensure /etc/hosts consistency:** Uses a template to create a consistent `/etc/hosts` file.
*   **Enable IP forwarding:** Enables IP forwarding, which is required for Docker.
*   **Disable swap:** Disables swap, as it's a requirement for Kubernetes.
*   **Install chrony:** Installs and enables `chrony` for time synchronization.
*   **Disable IPv6 (optional):** Disables IPv6 if the `disable_ipv6` variable is set.
*   **Install common packages:** Installs a list of common packages defined in the `install_packages` variable.

## Tailscale Configuration

The [`ansible/10-tailscale.yml`](../ansible/10-tailscale.yml:1) playbook is responsible for setting up the Tailscale secure network.

### Tailscale Role

This playbook uses the `artis3n.tailscale.machine` role to install and configure Tailscale on all hosts. It uses an authentication key from the environment variable `vault_tailscale_key` to connect the nodes to your Tailscale network.

### Tailscale Post Role

The [`ansible/roles/tailscale_post/`](../ansible/roles/tailscale_post:1) role contains tasks that are run after Tailscale is installed and configured. The main tasks are in [`tasks/main.yml`](../ansible/roles/tailscale_post/tasks/main.yml:1):

*   **Assert tailscale0 interface exists:** Verifies that the `tailscale0` interface has been created.
*   **Capture Tailscale IP address:** Captures the IP address of the `tailscale0` interface and stores it as a fact.
*   **Write Tailscale IP to hostvars:** Stores the captured Tailscale IP address in `hostvars` for later use.
*   **Validate Tailscale full mesh connectivity:** Pings all other nodes in the inventory to ensure full mesh connectivity over the Tailscale network.
