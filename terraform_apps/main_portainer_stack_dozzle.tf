resource "portainer_stack" "dozzle" {
  name            = "dozzle"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = data.portainer_environment.local_swarm.id

  repository_url            = var.repo_url
  repository_reference_name = var.repo_branch
  file_path_in_repository   = "docker/dozzle/dozzle-stack.yml"

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

  depends_on = [portainer_stack.socket-proxy]
}
