resource "portainer_stack" "traefik" {
  name            = "traefik"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = data.portainer_environment.local_swarm.id

  repository_url            = var.repo_url
  repository_reference_name = var.repo_branch
  file_path_in_repository   = "docker/traefik/traefik-stack.yml"

  force_update    = true
  pull_image      = true
  prune           = true
  update_interval = "5m"
  stack_webhook   = true

  env {
    name  = "ACME_EMAIL"
    value = var.acme_email
  }

  env {
    name  = "CF_DNS_API_TOKEN"
    value = var.cloudflare_api_token
  }

  env {
    name  = "DOMAIN"
    value = var.domain
  }

  env {
    name  = "TZ"
    value = var.tz
  }

  env {
    name  = "PUID"
    value = var.puid
  }

  env {
    name  = "PGID"
    value = var.pgid
  }

  env {
    name  = "FORCE_REDEPLOY"
    value = "1"
  }
}
