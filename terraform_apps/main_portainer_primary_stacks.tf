/* -------------------------------------------------------------------------- */
/*                                   Stacks                                   */
/* -------------------------------------------------------------------------- */
resource "portainer_stack" "traefik" {
  name            = "traefik"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = data.portainer_environment.local_swarm.id

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
  endpoint_id     = data.portainer_environment.local_swarm.id

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
  endpoint_id     = data.portainer_environment.local_swarm.id

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
  endpoint_id     = data.portainer_environment.local_swarm.id

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
  endpoint_id     = data.portainer_environment.local_swarm.id

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
  endpoint_id     = data.portainer_environment.local_swarm.id

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

  env {
    name  = "FILEBROWSER_ADMIN_PASSWORD"
    value = var.FILEBROWSER_ADMIN_PASSWORD
  }

  depends_on = [portainer_stack.socket-proxy]
}

resource "portainer_stack" "filebrowser" {
  name            = "filebrowser"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = data.portainer_environment.local_swarm.id

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
  endpoint_id     = data.portainer_environment.local_swarm.id

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


resource "portainer_stack" "maintenance" {
  name            = "maintenance"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = data.portainer_environment.local_swarm.id

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
  endpoint_id     = data.portainer_environment.local_swarm.id

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

resource "portainer_stack" "otterwiki" {
  name            = "otterwiki"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = data.portainer_environment.local_swarm.id

  repository_url            = var.REPO_URL
  repository_reference_name = var.REPO_BRANCH
  file_path_in_repository   = "docker/otterwiki/otterwiki-stack.yml"

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

resource "portainer_stack" "alloy" {
  name            = "alloy"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = data.portainer_environment.local_swarm.id

  repository_url            = var.REPO_URL
  repository_reference_name = var.REPO_BRANCH
  file_path_in_repository   = "docker/alloy/alloy-stack.yml"

  force_update    = true
  pull_image      = true
  prune           = true
  update_interval = "5m"
  stack_webhook   = true

  env {
    name  = "GRAFANA_CLOUD_PROMETHEUS_URL"
    value = var.GRAFANA_CLOUD_PROMETHEUS_URL
  }

  env {
    name  = "GRAFANA_CLOUD_PROMETHEUS_USERNAME"
    value = var.GRAFANA_CLOUD_PROMETHEUS_USERNAME
  }

  env {
    name  = "GRAFANA_CLOUD_LOKI_URL"
    value = var.GRAFANA_CLOUD_LOKI_URL
  }

  env {
    name  = "GRAFANA_CLOUD_LOKI_USERNAME"
    value = var.GRAFANA_CLOUD_LOKI_USERNAME
  }

  env {
    name  = "GRAFANA_CLOUD_API_KEY"
    value = var.GRAFANA_CLOUD_API_KEY
  }
}


