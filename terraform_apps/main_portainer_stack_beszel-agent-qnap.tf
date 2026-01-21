resource "portainer_stack" "beszel_agent_qnap" {
  name            = "beszel-agent"
  deployment_type = "standalone"
  method          = "repository"
  endpoint_id     = portainer_environment.remote_qnap.id

  repository_url            = var.REPO_URL
  repository_reference_name = var.REPO_BRANCH
  file_path_in_repository   = "docker/beszel-agent/beszel-agent-stack.yml"

  force_update    = true
  pull_image      = true
  prune           = true
  update_interval = "5m"
  stack_webhook   = true

  env {
    name  = "BESZEL_AGENT_KEY"
    value = var.BESZEL_AGENT_KEY
  }
}
