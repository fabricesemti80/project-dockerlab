resource "portainer_stack" "alloy" {
  name            = "alloy"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = data.portainer_environment.local_swarm.id

  repository_url            = var.REPO_URL
  repository_reference_name = var.REPO_BRANCH
  file_path_in_repository   = "docker/alloy/alloy-stack.yml"

  force_update    = true
  pull_image      = true
  prune           = true
  update_interval = "5m"
  stack_webhook   = true

  env {
    name  = "GRAFANA_CLOUD_PROMETHEUS_URL"
    value = var.GRAFANA_CLOUD_PROMETHEUS_URL
  }

  env {
    name  = "GRAFANA_CLOUD_PROMETHEUS_USERNAME"
    value = var.GRAFANA_CLOUD_PROMETHEUS_USERNAME
  }

  env {
    name  = "GRAFANA_CLOUD_LOKI_URL"
    value = var.GRAFANA_CLOUD_LOKI_URL
  }

  env {
    name  = "GRAFANA_CLOUD_LOKI_USERNAME"
    value = var.GRAFANA_CLOUD_LOKI_USERNAME
  }

  env {
    name  = "GRAFANA_CLOUD_API_KEY"
    value = var.GRAFANA_CLOUD_API_KEY
  }
}
