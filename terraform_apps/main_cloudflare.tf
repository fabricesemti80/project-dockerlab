# Cloudflare Tunnel & Access Configuration for Homelab

locals {
  access_allowed_emails = [
    "emilfabrice@gmail.com",
    "gabriellagungl@gmail.com",
    "fabrice.semti@gmail.com",
    "fabrice@fabricesemti.com"
  ]

  bypass_local_networks = [
    {
      ip = {
        ip = "10.0.0.0/16"
      }
    },
    {
      ip = {
        ip = "100.64.0.0/10"
      }
    }
  ]

  bypass_everyone = [
    {
      everyone = {}
    }
  ]

  bypass_anywhere = [
    {
      ip = {
        ip = "0.0.0.0/0"
      }
    }
  ]

  access_applications = {
    homelab = {
      name                      = "${var.domain} - default access"
      domain                    = "*.${var.domain}"
      type                      = "self_hosted"
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
    beszel = {
      name                      = "${var.domain} - Beszel access"
      domain                    = "beszel.${var.domain}"
      type                      = "self_hosted"
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
        {
          name     = "${var.domain} - Beszel agent bypass"
          decision = "bypass"
          include  = local.bypass_local_networks
        }
      ]
    }
    blog = {
      name                      = "Blog Access"
      domain                    = "blog.${var.domain}"
      type                      = "self_hosted"
      session_duration          = "720h"
      auto_redirect_to_identity = false
      policies = [
        {
          name     = "Allow Everyone"
          decision = "bypass"
          include  = local.bypass_anywhere
        }
      ]
    }
    otterwiki_git = {
      name                      = "${var.domain} - OtterWiki Git Bypass"
      domain                    = "wiki.${var.domain}/.git/*"
      type                      = "self_hosted"
      session_duration          = "720h"
      auto_redirect_to_identity = false
      policies = [
        {
          name     = "Bypass Git"
          decision = "bypass"
          include  = local.bypass_everyone
        }
      ]
    }
    jellyfin = {
      name                      = "${var.domain} - Jellyfin access"
      domain                    = "jelly.${var.domain}"
      type                      = "self_hosted"
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
        {
          name     = "Bypass from Anywhere"
          decision = "bypass"
          include  = concat(local.bypass_local_networks, local.bypass_everyone)
        }
      ]
    }
    linkwarden = {
      name                      = "${var.domain} - Linkwarden access"
      domain                    = "links.${var.domain}"
      type                      = "self_hosted"
      session_duration          = "720h"
      auto_redirect_to_identity = false
      policies = [
        {
          name     = "Allow Everyone"
          decision = "bypass"
          include  = local.bypass_anywhere
        }
      ]
    }
  }
}

data "cloudflare_zone" "main" {
  zone_id = var.cloudflare_zone_id
}

# 1. Tunnel Secret
resource "random_id" "tunnel_secret" {
  byte_length = 35
}

# 2. Create the Tunnel
resource "cloudflare_zero_trust_tunnel_cloudflared" "homelab" {
  account_id    = var.cloudflare_account_id
  name          = replace(data.cloudflare_zone.main.name, ".", "_")
  tunnel_secret = random_id.tunnel_secret.b64_std
}

# 3. Tunnel Configuration (Ingress Rules)
resource "cloudflare_zero_trust_tunnel_cloudflared_config" "homelab" {
  account_id = var.cloudflare_account_id
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.homelab.id

  config = {
    ingress = [
      {
        hostname = "*.${var.domain}"     # Serves *.krapulax.net
        service  = "https://traefik:443" # Point to Traefik service name on the 'proxy' network
        origin_request = {
          no_tls_verify = true
        }
      },
      {
        hostname = var.domain            # Serves krapulax.net
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
  zone_id = var.cloudflare_zone_id
  name    = "*"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.homelab.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  ttl     = 1
  comment = "Wildcard Tunnel (Managed by Terraform)"
}

resource "cloudflare_dns_record" "homelab_root" {
  zone_id = var.cloudflare_zone_id
  name    = "@"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.homelab.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  ttl     = 1
  comment = "Root Tunnel (Managed by Terraform)"
}

resource "cloudflare_dns_record" "beszel" {
  zone_id = var.cloudflare_zone_id
  name    = "beszel"
  content = "${cloudflare_zero_trust_tunnel_cloudflared.homelab.id}.cfargotunnel.com"
  type    = "CNAME"
  proxied = true
  ttl     = 1
}

# 5. Cloudflare Access Applications
resource "cloudflare_zero_trust_access_application" "apps" {
  for_each = local.access_applications

  account_id = var.cloudflare_account_id
  name       = each.value.name
  domain     = each.value.domain
  type       = each.value.type

  session_duration          = each.value.session_duration
  auto_redirect_to_identity = each.value.auto_redirect_to_identity

  policies = each.value.policies
}

# 6. Generate Tunnel Token for deployment
locals {
  tunnel_token = base64encode(jsonencode({
    a = var.cloudflare_account_id
    t = cloudflare_zero_trust_tunnel_cloudflared.homelab.id
    s = random_id.tunnel_secret.b64_std
  }))
}

# 7. Sync the Tunnel Token to Doppler
# This ensures Doppler remains the source of truth for all secrets
resource "doppler_secret" "tunnel_token" {
  project = var.doppler_project
  config  = var.doppler_config
  name    = "TUNNEL_TOKEN"
  value   = local.tunnel_token
}
