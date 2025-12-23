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

## 6. Troubleshooting

### "Too Many Redirects" Error
If you see this error, it is likely because Traefik is configured to redirect all HTTP traffic (Port 80) to HTTPS (Port 443), creating a loop when the Tunnel connects to Port 80.

**The Fix:**
Configure the Tunnel to connect directly to Traefik's **HTTPS port (443)** and ignore the certificate check.

**In Terraform (`main_tunnel.tf`):**
```hcl
    ingress = [
      {
        hostname = "*.yourdomain.com"
        service  = "https://traefik:443"  # Connect to HTTPS
        origin_request = {
          no_tls_verify = true        # Trust Traefik's internal cert
        }
      },
      ...
    ]
```

**In Cloudflare Dashboard:**
1.  Go to **Tunnels** > **Configure**.
2.  Edit the Public Hostname.
3.  Change Service to **HTTPS** and URL to `traefik:443`.
4.  Under **TLS** settings, enable **No TLS Verify**.

