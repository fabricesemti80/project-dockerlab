# Cloudflare Tunnel & Access Configuration for Homelab

locals {
  access_allowed_emails = [
    "emilfabrice@gmail.com",
    "gabriellagungl@gmail.com",
    "fabrice.semti@gmail.com",
    "fabrice@fabricesemti.com"
  ]
}

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

  session_duration          = "720h"
  auto_redirect_to_identity = false

  policies = [
    {
      name     = "Allow Admin"
      decision = "allow"

      include = [
        for email in local.access_allowed_emails : {
          email = {
            email = email
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

  session_duration          = "720h"
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
    #? Bypass for Beszel agents from local network (10.0.0.0/16)
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

resource "cloudflare_zero_trust_access_application" "blog_access" {
  account_id = var.CLOUDFLARE_ACCOUNT_ID
  name       = "Blog Access"
  domain     = "blog.${var.DOMAIN}"
  type       = "self_hosted"

  session_duration          = "720h"
  auto_redirect_to_identity = false

  policies = [
    #? Bypass for blog access from anywhere
    {
      name     = "Allow Everyone"
      decision = "bypass"
      include = [
        {
          ip = {
            ip = "0.0.0.0/0" # Allow from anywhere
          }
        }
      ]
    }
  ]
}

resource "cloudflare_zero_trust_access_application" "otterwiki_git_bypass" {
  account_id = var.CLOUDFLARE_ACCOUNT_ID
  name       = "OtterWiki Git Bypass"
  domain     = "wiki.${var.DOMAIN}/.git/*"
  type       = "self_hosted"

  session_duration          = "720h"
  auto_redirect_to_identity = false

  policies = [
    #? Bypass for OtterWiki Git access for everyone
    {
      name     = "Bypass Git"
      decision = "bypass"
      include = [
        {
          everyone = {}
        }
      ]
    }
  ]
}

resource "cloudflare_zero_trust_access_application" "jellyfin_access" {
  account_id = var.CLOUDFLARE_ACCOUNT_ID
  name       = "Jellyfin Access"
  domain     = "jelly.${var.DOMAIN}"
  type       = "self_hosted"

  session_duration          = "720h"
  auto_redirect_to_identity = false

  policies = [
    {
      name     = "Allow Admin"
      decision = "allow"
      include = [
        for email in local.access_allowed_emails : {
          email = {
            email = email
          }
        }
      ]
    },


    #? Bypass for Jellyfin from anywhere (includes local network and Tailscale)
    {
      name     = "Bypass from Local & Tailscale for everyone"
      decision = "bypass"
      include = [
        {
          ip = {
            ip = "10.0.0.0/16"
          }
        },
        {
          ip = {
            ip = "100.64.0.0/10"
          }
        },
        {
          everyone = {}
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

# 7. Sync the Tunnel Token to Doppler
# This ensures Doppler remains the source of truth for all secrets
resource "doppler_secret" "tunnel_token" {
  project = var.DOPPLER_PROJECT
  config  = var.DOPPLER_CONFIG
  name    = "TUNNEL_TOKEN"
  value   = local.tunnel_token
}
