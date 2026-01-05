# Cloudflare Tunnel & Access Configuration for Homelab

data "cloudflare_zone" "main" {
  zone_id = var.CLOUDFLARE_ZONE_ID
}

# 1. Tunnel Secret
resource "random_id" "tunnel_secret" {
  byte_length = 35
}

# 2. Create the Tunnel
resource "cloudflare_zero_trust_tunnel_cloudflared" "homelab" {
  account_id    = var.CLOUDFLARE_ACCOUNT_ID
  name          = replace(data.cloudflare_zone.main.name, ".", "_")
  tunnel_secret = random_id.tunnel_secret.b64_std
}

# 3. Tunnel Configuration (Ingress Rules)
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "homelab" {
  account_id = var.CLOUDFLARE_ACCOUNT_ID
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.homelab.id

  config = {
    ingress = [
      {
        hostname = "*.${var.DOMAIN}"     # Serves *.krapulax.net
        service  = "https://traefik:443" # Point to Traefik service name on the 'proxy' network
        origin_request = {
          no_tls_verify = true
        }
      },
      {
        hostname = var.DOMAIN            # Serves krapulax.net
        service  = "https://traefik:443" # Point to Traefik service name
        origin_request = {
          no_tls_verify = true
        }
      },
      {
        service = "http_status:404"
      }
    ]
  }
}

# 4. DNS Records for the new domain
resource "cloudflare_dns_record" "homelab_wildcard" {
  zone_id = var.CLOUDFLARE_ZONE_ID
  name    = "*"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.homelab.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  ttl     = 1
  comment = "Wildcard Tunnel (Managed by Terraform)"
}

resource "cloudflare_dns_record" "homelab_root" {
  zone_id = var.CLOUDFLARE_ZONE_ID
  name    = "@"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.homelab.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  ttl     = 1
  comment = "Root Tunnel (Managed by Terraform)"
}

# 5. Cloudflare Access Application
resource "cloudflare_zero_trust_access_application" "homelab_access" {
  account_id = var.CLOUDFLARE_ACCOUNT_ID
  name       = "Main Access"
  domain     = "*.${var.DOMAIN}"
  type       = "self_hosted"

  session_duration          = "24h"
  auto_redirect_to_identity = false

  policies = [
    {
      name     = "Allow Admin"
      decision = "allow"
      include = [
        {
          email = {
            email = var.ACCESS_EMAIL
          }
        },
        {
          email = {
            email = "gabriellagungl@gmail.com"
          }
        },
        {
          email = {
            email = "fabrice.semti@gmail.com"
          }
        },
        {
          email = {
            email = "fabrice@fabricesemti.com"
          }
        }
      ]
    }
  ]
}

# 6. Generate Tunnel Token for deployment
locals {
  tunnel_token = base64encode(jsonencode({
    a = var.CLOUDFLARE_ACCOUNT_ID
    t = cloudflare_zero_trust_tunnel_cloudflared.homelab.id
    s = random_id.tunnel_secret.b64_std
  }))
}

# Output the Tunnel Token to a local .env file for the cloudflared stack
resource "local_file" "tunnel_env" {
  content         = "TUNNEL_TOKEN=${local.tunnel_token}"
  filename        = "${path.module}/../docker/cloudflared/.env"
  file_permission = "0600"
}