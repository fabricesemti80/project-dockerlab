resource "portainer_stack" "tailscale" {
  name            = "tailscale"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = data.portainer_environment.local_swarm.id

  repository_url            = var.repo_url
  repository_reference_name = var.repo_branch
  file_path_in_repository   = "docker/tailscale/tailscale-stack.yml"

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
    name  = "HOSTNAME"
    value = var.domain
  }

  env {
    name  = "TS_AUTH_KEY"
    value = var.tailscale_auth_key
  }
}
