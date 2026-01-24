resource "portainer_stack" "maintenance" {
  name            = "maintenance"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = data.portainer_environment.local_swarm.id

  repository_url            = var.repo_url
  repository_reference_name = var.repo_branch
  file_path_in_repository   = "docker/maintenance/maintenance-stack.yml"

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
    name  = "DISCORD_WATCHTOWER_WEBHOOK"
    value = var.discord_watchtower_webhook
  }

  env {
    name  = "FORCE_UPDATE"
    value = "1"
  }
}
