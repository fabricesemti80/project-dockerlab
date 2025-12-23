# Cloudflare Tunnel Setup

This stack deploys `cloudflared` connectors to your Swarm, allowing secure remote access without opening external ports.

## 1. Prerequisites

- A Cloudflare account.
- `traefik` stack already deployed (creating the `traefik_traefik-public` network).

## 2. Create the Tunnel (Manual / Dashboard)

Since you plan to use Terraform later, the easiest current method is the **Zero Trust Dashboard** (Remote Managed).

1.  Go to [Cloudflare Zero Trust](https://one.dash.cloudflare.com/).
2.  Navigate to **Networks** > **Tunnels**.
3.  Click **Create a tunnel**.
4.  Select **Cloudflared** connector.
5.  Name it (e.g., `docker-swarm-tunnel`).
6.  **Important:** Copy the tunnel token provided in the "Install and run a connector" section. You only need the token string starting with `ey...`.

## 3. Deployment

### Portainer
1.  Create a new Stack.
2.  Select Repository (GitOps).
3.  Path: `docker/cloudflared/cloudflared-stack.yml`.
4.  **Environment Variables:**
    - `TUNNEL_TOKEN`: Paste the token from Step 2.
5.  Deploy.

The tunnel status in Cloudflare Dashboard should turn **Healthy** (Connected).

### 4. Routing Traffic (DNS & Ingress)

To expose the `whoami` app (and others) via this tunnel, you configure **Public Hostnames** in the Cloudflare Tunnel settings. We will route traffic through Traefik, so Traefik handles the specific routing.

#### Option A: Wildcard (Recommended "Set & Forget")
This allows you to manage everything from Docker Swarm labels. You configure the tunnel once, and then adding new apps requires zero Cloudflare changes.

1.  In the Tunnel configuration (Public Hostnames), add a hostname:
    - **Subdomain:** `*` (Wildcard)
    - **Domain:** `yourdomain.com`
    - **Service:** `HTTP`
    - **URL:** `traefik:80`
2.  Save.
3.  **Note:** Ensure a CNAME record for `*.yourdomain.com` pointing to your tunnel ID exists in your Cloudflare DNS (the UI usually adds this automatically).

**How it works:**
1.  Request to `whoami.yourdomain.com` hits Cloudflare.
2.  Wildcard matches -> Tunnel -> `traefik:80`.
3.  Traefik receives request with Host `whoami.yourdomain.com`.
4.  Traefik matches the container label and routes traffic.

#### Option B: Individual Hostnames
If you prefer explicit control or only want to expose specific subdomains.

1.  Add a Public Hostname:
    - **Subdomain:** `whoami`
    - **Domain:** `yourdomain.com`
    - **Service:** `HTTP`
    - **URL:** `traefik:80`
2.  Repeat for every new app.

### Adding more apps
With **Option A**, you simply deploy the app in Swarm (attached to `traefik_traefik-public`) with Traefik labels. It works instantly.

With **Option B**, you must *also* add the new hostname to the Cloudflare Tunnel config every time.

## 5. Terraform Automation (Recommended)

This project includes a Terraform configuration to automate the Tunnel creation, DNS setup, and Token retrieval.

### Files
- `terraform/main_tunnel.tf`: Defines the Tunnel, Wildcard Ingress Rule, and DNS Record.
- `terraform/main_tunnel.tf`: automatically writes the `TUNNEL_TOKEN` to `docker/cloudflared/.env`.

### Deployment Steps
1.  Navigate to the `terraform/` directory.
2.  Ensure your `terraform.tfvars` or environment variables are set (including `CLOUDFLARE_ACCOUNT_ID`).
3.  Run the plan and apply:
    ```bash
    terraform plan -out=tfplan
    terraform apply tfplan
    ```
4.  **Result:**
    - A new Cloudflare Tunnel is created.
    - A Wildcard DNS record (`*.yourdomain.com`) is pointed to the tunnel.
    - The file `docker/cloudflared/.env` is created containing your `TUNNEL_TOKEN`.

5.  **Update Portainer:**
    - Copy the `TUNNEL_TOKEN` from `docker/cloudflared/.env`.
    - Update your Stack environment variables in Portainer.
    - Redeploy the stack.

