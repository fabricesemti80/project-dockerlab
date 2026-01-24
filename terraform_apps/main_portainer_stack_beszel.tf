resource "portainer_stack" "beszel" {
  name            = "beszel"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = data.portainer_environment.local_swarm.id

  repository_url            = var.repo_url
  repository_reference_name = var.repo_branch
  file_path_in_repository   = "docker/beszel/beszel-stack.yml"

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
    name  = "BESZEL_AGENT_KEY"
    value = var.beszel_agent_key
  }
}
