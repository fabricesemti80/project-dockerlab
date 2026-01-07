# Cloudflare Access (Zero Trust) Configuration
# Secures the entire wildcard domain (*.krapulax.dev) behind an identity check.

# 1. Access Application & Policy
# Protects all subdomains (*.krapulax.dev)
resource "cloudflare_zero_trust_access_application" "lab_wildcard" {
  account_id = var.CLOUDFLARE_ACCOUNT_ID
  name       = "Lab Wildcard Access"
  domain     = "*.krapulax.dev" # Using hardcoded domain as data source is not in variables.tf
  type       = "self_hosted"

  # Session duration (24h)
  session_duration = "24h"

  # Show the "Cloudflare Access" launcher
  auto_redirect_to_identity = false

  # Inline Policy Definition
  policies {
    name       = "Allow Admin"
    decision   = "allow"
    precedence = 1
    include {
      email = {
        email = var.ACCESS_EMAIL
      }
    }
    include {
      email = {
        email = "gabriellagungl@gmail.com"
      }
    }
    include {
      email = {
        email = "fabrice.semti@gmail.com" # Github
      }
    }
    include {
      email = {
        email = "fabrice@fabricesemti.com"
      }
    }
  }
}
