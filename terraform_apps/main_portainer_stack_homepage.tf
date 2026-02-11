resource "portainer_stack" "homepage" {
  name            = "homepage"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = data.portainer_environment.local_swarm.id

  repository_url            = var.repo_url
  repository_reference_name = var.repo_branch
  file_path_in_repository   = "docker/homepage/homepage-stack.yml"

  force_update    = true
  pull_image      = true
  prune           = true
  update_interval = "5m"
  stack_webhook   = true

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
    name  = "PORTAINER_ACCESS_TOKEN"
    value = var.portainer_token
  }

  env {
    name  = "FILEBROWSER_ADMIN_PASSWORD"
    value = var.filebrowser_admin_password
  }

  # Homepage Widget API Keys
  env {
    name  = "SONARR_API_KEY"
    value = var.sonarr_api_key
  }

  env {
    name  = "RADARR_API_KEY"
    value = var.radarr_api_key
  }

  env {
    name  = "PROWLARR_API_KEY"
    value = var.prowlarr_api_key
  }

  env {
    name  = "JELLYFIN_API_KEY"
    value = var.jellyfin_api_key
  }

  env {
    name  = "JELLYSEERR_API_KEY"
    value = var.jellyseerr_api_key
  }

  env {
    name  = "IMMICH_API_KEY"
    value = var.immich_api_key
  }

  env {
    name  = "NZBGET_USER"
    value = var.nzbget_user
  }

  env {
    name  = "NZBGET_PASS"
    value = var.nzbget_pass
  }

  env {
    name  = "WALLOS_API_KEY"
    value = var.wallos_api_key
  }

  env {
    name  = "LINKWARDEN_API_KEY"
    value = var.linkwarden_api_key
  }

  depends_on = [portainer_stack.socket-proxy]
}
