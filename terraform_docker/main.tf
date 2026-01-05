resource "portainer_stack" "traefik" {
  name            = "traefik"
  deployment_type = "swarm"
  method          = "string"
  endpoint_id     = 1

  stack_file_content = file("${path.module}/../docker/traefik/traefik-stack.yml")

  env {
    name  = "ACME_EMAIL"
    value = var.ACME_EMAIL
  }

  env {
    name  = "CF_DNS_API_TOKEN"
    value = var.CLOUDFLARE_API_TOKEN
  }

  env {
    name  = "DOMAIN"
    value = var.DOMAIN
  }
}
