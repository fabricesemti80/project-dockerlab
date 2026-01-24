resource "portainer_stack" "filebrowser" {
  name            = "filebrowser"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = data.portainer_environment.local_swarm.id

  repository_url            = var.repo_url
  repository_reference_name = var.repo_branch
  file_path_in_repository   = "docker/filebrowser/filebrowser-stack.yml"

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

  env {
    name  = "PUID"
    value = var.puid
  }

  env {
    name  = "PGID"
    value = var.pgid
  }

  env {
    name  = "FILEBROWSER_ADMIN_PASSWORD"
    value = var.filebrowser_admin_password
  }
}
