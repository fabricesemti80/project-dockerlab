resource "portainer_stack" "wallos" {
  name            = "wallos"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = 1

  repository_url            = var.repo_url
  repository_reference_name = var.repo_branch
  file_path_in_repository   = "docker/wallos/wallos-stack.yml"

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
    name  = "BASE_URL"
    value = "https://wallos.${var.domain}"
  }

  env {
    name  = "DOMAIN"
    value = var.domain
  }
}
