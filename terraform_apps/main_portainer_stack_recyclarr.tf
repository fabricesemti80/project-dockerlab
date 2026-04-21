resource "portainer_stack" "recyclarr" {
  name            = "recyclarr"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = data.portainer_environment.local_swarm.id

  repository_url            = var.repo_url
  repository_reference_name = var.repo_branch
  file_path_in_repository   = "docker/recyclarr/recyclarr-stack.yml"

  force_update    = true
  pull_image      = true
  prune           = true
  update_interval = "5m"
  stack_webhook   = true

  env {
    name  = "TZ"
    value = var.tz
  }

  env {
    name  = "PUID"
    value = var.media_puid
  }

  env {
    name  = "PGID"
    value = var.media_pgid
  }

  env {
    name  = "RADARR_API_KEY"
    value = var.radarr_api_key
  }

  env {
    name  = "SONARR_API_KEY"
    value = var.sonarr_api_key
  }

  depends_on = [
    portainer_stack.radarr,
    portainer_stack.sonarr,
  ]
}
