# Backrest - Web UI for Restic backups
# https://github.com/garethgeorge/backrest

resource "portainer_stack" "backup" {
  name            = "backup"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = 1

  repository_url            = var.repo_url
  repository_reference_name = var.repo_branch
  file_path_in_repository   = "docker/backup/backup-stack.yml"

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
    name  = "DOMAIN"
    value = var.domain
  }

  # S3-compatible storage credentials (Cloudflare R2, AWS S3, Wasabi, MinIO, etc.)
  # These are passed to restic for repository access
  env {
    name  = "S3_ACCESS_KEY_ID"
    value = var.s3_access_key_id
  }

  env {
    name  = "S3_SECRET_ACCESS_KEY"
    value = var.s3_secret_access_key
  }
}
