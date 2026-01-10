resource "portainer_stack" "ghost" {
  name            = "ghost"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = 1

  repository_url            = var.REPO_URL
  repository_reference_name = var.REPO_BRANCH
  file_path_in_repository   = "docker/ghost/ghost-stack.yml"

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
    name  = "GHOST_DB_PASSWORD"
    value = var.GHOST_DB_PASSWORD
  }

  env {
    name  = "GHOST_DB_ROOT_PASSWORD"
    value = var.GHOST_DB_ROOT_PASSWORD
  }

  env {
    name  = "GHOST_MAIL_TRANSPORT"
    value = var.GHOST_MAIL_TRANSPORT
  }

  env {
    name  = "GHOST_MAIL_HOST"
    value = var.GHOST_MAIL_HOST
  }

  env {
    name  = "GHOST_MAIL_PORT"
    value = var.GHOST_MAIL_PORT
  }

  env {
    name  = "GHOST_MAIL_USER"
    value = var.GHOST_MAIL_USER
  }

  env {
    name  = "GHOST_MAIL_PASSWORD"
    value = var.GHOST_MAIL_PASSWORD
  }

  env {
    name  = "GHOST_MAIL_FROM"
    value = var.GHOST_MAIL_FROM
  }
}
