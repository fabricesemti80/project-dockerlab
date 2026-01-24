resource "portainer_stack" "cloudflared" {
  name            = "cloudflared"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = data.portainer_environment.local_swarm.id

  repository_url            = var.repo_url
  repository_reference_name = var.repo_branch
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
