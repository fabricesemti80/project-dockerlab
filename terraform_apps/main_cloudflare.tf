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

resource "cloudflare_dns_record" "beszel" {
  zone_id = var.CLOUDFLARE_ZONE_ID
  name    = "beszel"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.homelab.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  ttl     = 1
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

resource "cloudflare_zero_trust_access_application" "beszel_access" {
  account_id = var.CLOUDFLARE_ACCOUNT_ID
  name       = "Beszel Access"
  domain     = "beszel.${var.DOMAIN}"
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
            email = "fabrice.semti@gmail.com"
          }
        }
      ]
    },
    {
      name     = "Bypass for Agents"
      decision = "bypass"
      include = [
        {
          ip = {
            ip = "10.0.0.0/16"
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

# 7. Push the Tunnel Token back to Doppler
# We use local-exec because Doppler Service Tokens (provided to Terraform)
# are read-only and cannot write secrets. This uses your local CLI auth.
resource "null_resource" "push_tunnel_token_to_doppler" {
  triggers = {
    tunnel_token = local.tunnel_token
  }

  provisioner "local-exec" {
    command = "doppler secrets set TUNNEL_TOKEN='${local.tunnel_token}'"
  }
}