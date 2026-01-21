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
