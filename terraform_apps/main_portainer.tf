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

  env {
    name  = "FORCE_REDEPLOY"
    value = "1"
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

resource "portainer_stack" "socket-proxy" {
  name            = "socket-proxy"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = 1

  repository_url            = var.REPO_URL
  repository_reference_name = var.REPO_BRANCH
  file_path_in_repository   = "docker/socket-proxy/socket-proxy-stack.yml"

  force_update    = true
  pull_image      = true
  prune           = true
  update_interval = "5m"
  stack_webhook   = true

  env {
    name  = "TZ"
    value = var.TZ
  }
}

resource "portainer_stack" "homepage" {
  name            = "homepage"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = 1

  repository_url            = var.REPO_URL
  repository_reference_name = var.REPO_BRANCH
  file_path_in_repository   = "docker/homepage/homepage-stack.yml"

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

  env {
    name  = "PORTAINER_ACCESS_TOKEN"
    value = var.PORTAINER_TOKEN
  }

  depends_on = [portainer_stack.socket-proxy]
}

resource "portainer_stack" "gitlab" {
  name            = "gitlab"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = 1

  repository_url            = var.REPO_URL
  repository_reference_name = var.REPO_BRANCH
  file_path_in_repository   = "docker/gitlab/gitlab-stack.yml"

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
    name  = "TZ"
    value = var.TZ
  }

  env {
    name  = "FORCE_REDEPLOY"
    value = "4"
  }
}

resource "portainer_stack" "filebrowser" {
  name            = "filebrowser"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = 1

  repository_url            = var.REPO_URL
  repository_reference_name = var.REPO_BRANCH
  file_path_in_repository   = "docker/filebrowser/filebrowser-stack.yml"

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

  env {
    name  = "FILEBROWSER_ADMIN_PASSWORD"
    value = var.FILEBROWSER_ADMIN_PASSWORD
  }
}

resource "portainer_stack" "gatus" {
  name            = "gatus"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = 1

  repository_url            = var.REPO_URL
  repository_reference_name = var.REPO_BRANCH
  file_path_in_repository   = "docker/gatus/gatus-stack.yml"

  force_update    = true
  pull_image      = true
  prune           = true
  update_interval = "5m"
  stack_webhook   = true

  env {
    name  = "TZ"
    value = var.TZ
  }

  env {
    name  = "DOMAIN"
    value = var.DOMAIN
  }
}

resource "portainer_stack" "docmost" {
  name            = "docmost"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = 1

  repository_url            = var.REPO_URL
  repository_reference_name = var.REPO_BRANCH
  file_path_in_repository   = "docker/docmost/docmost-stack.yml"

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
    name  = "TZ"
    value = var.TZ
  }

  env {
    name  = "DOCMOST_APP_SECRET"
    value = var.DOCMOST_APP_SECRET
  }

  env {
    name  = "DOCMOST_POSTGRES_PASSWORD"
    value = var.DOCMOST_POSTGRES_PASSWORD
  }
}

resource "portainer_stack" "maintenance" {
  name            = "maintenance"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = 1

  repository_url            = var.REPO_URL
  repository_reference_name = var.REPO_BRANCH
  file_path_in_repository   = "docker/maintenance/maintenance-stack.yml"

  force_update    = true
  pull_image      = true
  prune           = true
  update_interval = "5m"
  stack_webhook   = true

  env {
    name  = "TZ"
    value = var.TZ
  }

  env {
    name  = "DISCORD_WATCHTOWER_WEBHOOK"
    value = var.DISCORD_WATCHTOWER_WEBHOOK
  }

  env {
    name  = "FORCE_UPDATE"
    value = "1"
  }
}

resource "portainer_stack" "glance" {
  name            = "glance"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = 1

  repository_url            = var.REPO_URL
  repository_reference_name = var.REPO_BRANCH
  file_path_in_repository   = "docker/glance/glance-stack.yml"

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
    name  = "TZ"
    value = var.TZ
  }
}