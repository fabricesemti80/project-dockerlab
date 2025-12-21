variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID for krapulax.dev"
  sensitive   = true
}

data "cloudflare_zone" "krapulax_dev" {
  zone_id = var.cloudflare_zone_id
}

# Creates a DNS A record for the Coolify server.
# The `proxied` setting is false (DNS only) to allow direct access to the Coolify UI on port 8000.
# Cloudflare's proxy does not support this port.

#TODO: move this to tunnel when implemented
# resource "cloudflare_record" "coolify_server" {
#   zone_id = data.cloudflare_zone.krapulax_dev.id
#   name    = "coolify"
#   content = module.coolify_server.server_ipv4_address
#   type    = "A"
#   proxied = true
#   ttl     = 1
#   comment = "Managed by Terraform"
# }

# DNS record for ittools subdomain
# resource "cloudflare_record" "ittools" {
#   zone_id = data.cloudflare_zone.krapulax_dev.id
#   name    = "ittools"
#   content = module.coolify_server.server_ipv4_address
#   type    = "A"
#   proxied = true
#   ttl     = 1
#   comment = "Managed by Terraform"
# }
