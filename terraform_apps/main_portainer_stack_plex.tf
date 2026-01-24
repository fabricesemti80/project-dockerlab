resource "portainer_stack" "plex" {
  name            = "plex"
  deployment_type = "standalone"
  method          = "repository"
  endpoint_id     = portainer_environment.remote_qnap.id

  repository_url            = var.repo_url
  repository_reference_name = var.repo_branch
  file_path_in_repository   = "docker/plex/plex-stack.yml"

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
    name  = "PLEX_CLAIM"
    value = var.plex_claim
  }
}
