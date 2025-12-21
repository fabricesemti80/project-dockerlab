# Dokploy Homelab Setup Guide

This guide sets up a Dokploy Control Plane on Hetzner Cloud with a Worker Node at home, connected via a secure Tailscale mesh network. This allows Dokploy to manage your home server without exposing ports on your router.

**IMPORTANT:** Based on recent findings, it is critical to install Dokploy on a clean server *before* installing Tailscale or initializing a Docker Swarm. The Dokploy installation script can fail if these are present beforehand.

## Prerequisites

-   Hetzner Cloud account with API token (from [Hetzner Console](https://console.hetzner.com/))
-   Tailscale account with Auth Key (Reusable, from [Tailscale Admin](https://tailscale.com/kb/1017/auth-keys/))
-   Ubuntu/Debian home server with Docker installed
-   GitHub account (for deploying apps)

## Documentation

For a more detailed explanation of the infrastructure and configuration, please refer to the following documents:

-   [Terraform Documentation](./doc/00_terraform.md)
-   [Ansible Documentation](./doc/01_ansible.md)

## Phase 1: Hetzner Infrastructure (Terraform)

1.  Clone or use the provided `main_hcloud.tf` file.
2.  Set environment variables in your `.envrc` file (or export them manually):
    ```bash
    export TF_VAR_hcloud_token="your_hetzner_token"
    export TF_VAR_tailscale_auth_key="your_ts_key"
    ```
3.  Initialize and apply Terraform:
    ```bash
    terraform init
    terraform apply
    ```
    This creates a clean Ubuntu 22.04 server with firewall rules for SSH (22), HTTP (80), HTTPS (443), and Dokploy UI (3000).

## Phase 2: Dokploy Installation & Initial Setup

1.  SSH into the newly created Hetzner server.
2.  Install Dokploy using the official script:
    ```bash
    curl -fsSL https://dokploy.com/install.sh | sh
    ```
3.  Visit `http://<HETZNER_PUBLIC_IP>:3000` and create your admin account.

## Phase 3: Network Setup (Tailscale)

With Dokploy installed, you can now set up the Tailscale network. We install Tailscale directly on the host machine because running it as a container within Dokploy is not possible, as Dokploy does not provide the necessary privileged access required by Tailscale to manage the network stack.

```bash
sudo tailscale up --authkey="tskey-auth-kJBCjRWDNh11CNTRL-Yjtvwn3FdeDsesY6Mwh5fDhpwpqa1RU2" --advertise-exit-node --advertise-routes=10.0.0.0/8,192.168.0.0/16 --accept-routes --ssh

echo 'net.ipv4.ip_forward = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf

echo 'net.ipv6.conf.all.forwarding = 1' | sudo tee -a /etc/sysctl.d/99-tailscale.conf

sudo sysctl -p /etc/sysctl.d/99-tailscale.conf
```

3.  **Approve Routes in Tailscale:**
    Log in to your [Tailscale Admin Console](https://login.tailscale.com/admin/machines) and approve the advertised routes from both of your nodes.

## Phase 4: DNS and Dokploy FQDN

1.  **Create DNS Record:** In your DNS provider (e.g., Cloudflare), create an A record for `dokploy.your-domain.com` that points to the public IP address of your Hetzner server.
2.  **Set Domain in Dokploy:**
    *   In the Dokploy UI, navigate to the "Settings" tab.
    *   Set the "FQDN (URL)" to `https://dokploy.your-domain.com`.
    *   Save the settings. Dokploy will automatically handle the SSL certificate for you.

## Phase 5: Docker Swarm Initialization

1.  **On Hetzner (Manager):** Get the Tailscale IP (`tailscale ip -4`), e.g., `100.1.1.1`.
    ```bash
    docker swarm init --advertise-addr 100.1.1.1
    ```
    Copy the `docker swarm join` command that is outputted.

2.  **On Homelab (Worker):** Get your Tailscale IP (e.g., `100.2.2.2`) and join the swarm using the command from the previous step. You will need to add the `--advertise-addr` flag:
    ```bash
    sudo docker swarm join --token <TOKEN> 100.1.1.1:2377 --advertise-addr 100.2.2.2
    ```

## Phase 6: Final Dokploy Configuration

1.  **Add Homelab Worker to Dokploy:**
    -   Generate an SSH key on the Hetzner server: `ssh-keygen -t ed25519`
    -   On your **home server**, run the following command to add the public key. This ensures Dokploy can access the worker node. Make sure to replace `ssh-ed25519 AAA...` with the actual public key you generated.
        ```bash
        mkdir -p ~/.ssh && echo "ssh-ed25519 AAA..." >> ~/.ssh/authorized_keys
        ```
    -   **Important:** Before adding the worker in the Dokploy UI, you must first establish an SSH connection *from* the Hetzner (Dokploy) server *to* the homelab worker. This is required to complete the Tailscale authentication and accept the host key.
        ```bash
        # From the Hetzner server
        ssh root@<HOMELAB_TAILSCALE_IP>
        ```
    -   In the Dokploy UI, add a new server using the worker's Tailscale IP, `root` user, and the private key you just generated.
2.  **Create Docker Swarm Destination:** In Dokploy, go to "Destinations" and create a new "Docker Swarm" destination, selecting the Hetzner server as the manager.

Your setup is now complete.
