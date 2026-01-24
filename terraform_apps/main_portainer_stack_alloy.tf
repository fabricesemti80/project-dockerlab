resource "portainer_stack" "alloy" {
  name            = "alloy"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = data.portainer_environment.local_swarm.id

  repository_url            = var.repo_url
  repository_reference_name = var.repo_branch
  file_path_in_repository   = "docker/alloy/alloy-stack.yml"

  force_update    = true
  pull_image      = true
  prune           = true
  update_interval = "5m"
  stack_webhook   = true

  env {
    name  = "GRAFANA_CLOUD_PROMETHEUS_URL"
    value = var.grafana_cloud_prometheus_url
  }

  env {
    name  = "GRAFANA_CLOUD_PROMETHEUS_USERNAME"
    value = var.grafana_cloud_prometheus_username
  }

  env {
    name  = "GRAFANA_CLOUD_LOKI_URL"
    value = var.grafana_cloud_loki_url
  }

  env {
    name  = "GRAFANA_CLOUD_LOKI_USERNAME"
    value = var.grafana_cloud_loki_username
  }

  env {
    name  = "GRAFANA_CLOUD_API_KEY"
    value = var.grafana_cloud_api_key
  }
}
