resource "portainer_stack" "linkwarden" {
  name            = "linkwarden"
  deployment_type = "swarm"
  method          = "repository"
  endpoint_id     = data.portainer_environment.local_swarm.id

  repository_url            = var.REPO_URL
  repository_reference_name = var.REPO_BRANCH
  file_path_in_repository   = "docker/linkwarden/linkwarden-stack.yml"

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
    name  = "LINKWARDEN_POSTGRES_PASSWORD"
    value = var.LINKWARDEN_POSTGRES_PASSWORD
  }

  env {
    name  = "LINKWARDEN_NEXTAUTH_SECRET"
    value = var.LINKWARDEN_NEXTAUTH_SECRET
  }

  env {
    name  = "LINKWARDEN_MEILI_KEY"
    value = var.LINKWARDEN_MEILI_KEY
  }

  depends_on = [portainer_stack.traefik]
}
