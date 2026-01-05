resource "portainer_stack" "traefik" {
  name            = "traefik"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = 1

  repository_url            = var.REPO_URL
  repository_reference_name = var.REPO_BRANCH
  file_path_in_repository   = "docker/traefik/traefik-stack.yml"

  force_update    = true
  pull_image      = true
  prune           = true
  update_interval = "5m"
  stack_webhook   = true

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

  env {
    name  = "TZ"
    value = var.TZ
  }

  env {
    name  = "PUID"
    value = var.PUID
  }

  env {
    name  = "PGID"
    value = var.PGID
  }
}

resource "portainer_stack" "cloudflared" {
  name            = "cloudflared"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = 1

  repository_url            = var.REPO_URL
  repository_reference_name = var.REPO_BRANCH
  file_path_in_repository   = "docker/cloudflared/cloudflared-stack.yml"

  force_update    = true
  pull_image      = true
  prune           = true
  update_interval = "5m"
  stack_webhook   = true

  env {
    name  = "TUNNEL_TOKEN"
    value = local.tunnel_token
  }
}

resource "portainer_stack" "whoami" {
  name            = "whoami"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = 1

  repository_url            = var.REPO_URL
  repository_reference_name = var.REPO_BRANCH
  file_path_in_repository   = "docker/traefik/whoami-stack.yml"

  force_update    = true
  pull_image      = true
  prune           = true
  update_interval = "5m"
  stack_webhook   = true

  env {
    name  = "DOMAIN"
    value = var.DOMAIN
  }
}

resource "portainer_stack" "beszel" {
  name            = "beszel"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = 1

  repository_url            = var.REPO_URL
  repository_reference_name = var.REPO_BRANCH
  file_path_in_repository   = "docker/beszel/beszel-stack.yml"

  force_update    = true
  pull_image      = true
  prune           = true
  update_interval = "5m"
  stack_webhook   = true

  env {
    name  = "DOMAIN"
    value = var.DOMAIN
  }

  env {
    name  = "BESZEL_AGENT_KEY"
    value = var.BESZEL_AGENT_KEY
  }
}
