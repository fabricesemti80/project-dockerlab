# Backrest - Web UI for Restic backups
# https://github.com/garethgeorge/backrest

resource "portainer_stack" "backup" {
  name            = "backup"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = 1

  repository_url            = var.REPO_URL
  repository_reference_name = var.REPO_BRANCH
  file_path_in_repository   = "docker/backup/backup-stack.yml"

  force_update    = true
  pull_image      = true
  prune           = true
  update_interval = "5m"
  stack_webhook   = true

  env {
    name  = "TZ"
    value = var.TZ
  }

  env {
    name  = "DOMAIN"
    value = var.DOMAIN
  }

  # S3-compatible storage credentials (Cloudflare R2, AWS S3, Wasabi, MinIO, etc.)
  # These are passed to restic for repository access
  env {
    name  = "S3_ACCESS_KEY_ID"
    value = var.S3_ACCESS_KEY_ID
  }

  env {
    name  = "S3_SECRET_ACCESS_KEY"
    value = var.S3_SECRET_ACCESS_KEY
  }
}
