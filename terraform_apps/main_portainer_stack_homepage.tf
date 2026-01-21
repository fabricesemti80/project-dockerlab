resource "portainer_stack" "homepage" {
  name            = "homepage"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = data.portainer_environment.local_swarm.id

  repository_url            = var.REPO_URL
  repository_reference_name = var.REPO_BRANCH
  file_path_in_repository   = "docker/homepage/homepage-stack.yml"

  force_update    = true
  pull_image      = true
  prune           = true
  update_interval = "5m"
  stack_webhook   = true

  env {
    name  = "DOMAIN"
    value = var.DOMAIN
  }

  env {
    name  = "TZ"
    value = var.TZ
  }

  env {
    name  = "PUID"
    value = var.PUID
  }

  env {
    name  = "PGID"
    value = var.PGID
  }

  env {
    name  = "PORTAINER_ACCESS_TOKEN"
    value = var.PORTAINER_TOKEN
  }

  env {
    name  = "FILEBROWSER_ADMIN_PASSWORD"
    value = var.FILEBROWSER_ADMIN_PASSWORD
  }

  depends_on = [portainer_stack.socket-proxy]
}
