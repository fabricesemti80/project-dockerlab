variable "PORTAINER_TOKEN" {
  description = "Portainer API Key for authentication"
  type        = string
  sensitive   = true
}

variable "CLOUDFLARE_API_TOKEN" {
  description = "Cloudflare API Token"
  type        = string
  sensitive   = true
}

variable "CLOUDFLARE_ACCOUNT_ID" {
  description = "Cloudflare Account ID"
  type        = string
  sensitive   = true
}

variable "CLOUDFLARE_ZONE_ID" {
  description = "Cloudflare Zone ID"
  type        = string
  sensitive   = true
}

variable "ACCESS_EMAIL" {
  description = "The email address allowed to access the lab services"
  type        = string
  default     = "emilfabrice@gmail.com"
}

variable "ACME_EMAIL" {
  description = "The email address for Let's Encrypt"
  type        = string
}

variable "DOMAIN" {
  description = "The domain name"
  type        = string
  default     = "krapulax.dev"
}

variable "TZ" {
  description = "The timezone"
  type        = string
  default     = "Europe/London"
}

variable "PUID" {
  description = "The user ID"
  type        = string
  default     = "1000"
}

variable "PGID" {
  description = "The group ID"
  type        = string
  default     = "1000"
}

variable "REPO_URL" {
  description = "The URL of the Git repository"
  type        = string
  default     = "https://github.com/fabricesemti80/project-dockerlab.git"
}

variable "REPO_BRANCH" {
  description = "The branch of the Git repository"
  type        = string
  default     = "refs/heads/main"
}

variable "BESZEL_AGENT_KEY" {
  description = "The agent key for Beszel"
  type        = string
  sensitive   = true
  default     = ""
}

variable "FILEBROWSER_ADMIN_PASSWORD" {
  description = "Admin password for Filebrowser"
  type        = string
  sensitive   = true
}

variable "DOCMOST_APP_SECRET" {
  description = "App secret for Docmost"
  type        = string
  sensitive   = true
}

variable "DOCMOST_POSTGRES_PASSWORD" {
  description = "Postgres password for Docmost"
  type        = string
  sensitive   = true
}

variable "DISCORD_WATCHTOWER_WEBHOOK" {
  description = "Discord Webhook URL for Watchtower notifications"
  type        = string
  sensitive   = true
}

variable "DOPPLER_TOKEN" {
  description = "The Doppler token for authentication"
  type        = string
  sensitive   = true
}

variable "DOPPLER_PROJECT" {
  description = "The Doppler project name"
  type        = string
}

variable "DOPPLER_CONFIG" {
  description = "The Doppler config name"
  type        = string
}

variable "GHOST_DB_PASSWORD" {
  description = "MySQL password for Ghost database user"
  type        = string
  sensitive   = true
}

variable "GHOST_DB_ROOT_PASSWORD" {
  description = "MySQL root password for Ghost database"
  type        = string
  sensitive   = true
}

variable "GHOST_MAIL_TRANSPORT" {
  description = "Mail transport for Ghost (e.g., SMTP)"
  type        = string
  default     = "SMTP"
}

variable "GHOST_MAIL_HOST" {
  description = "SMTP host for Ghost mail"
  type        = string
  default     = "smtp.gmail.com"
}

variable "GHOST_MAIL_PORT" {
  description = "SMTP port for Ghost mail"
  type        = string
  default     = "587"
}

variable "GHOST_MAIL_USER" {
  description = "SMTP username for Ghost mail"
  type        = string
  default     = ""
}

variable "GHOST_MAIL_PASSWORD" {
  description = "SMTP password for Ghost mail"
  type        = string
  sensitive   = true
  default     = ""
}

variable "GHOST_MAIL_FROM" {
  description = "From address for Ghost emails"
  type        = string
  default     = "noreply@krapulax.net"
}

variable "S3_ACCESS_KEY_ID" {
  description = "Access key for S3-compatible storage (Cloudflare R2, AWS S3, Wasabi, MinIO)"
  type        = string
  sensitive   = true
}

variable "S3_SECRET_ACCESS_KEY" {
  description = "Secret key for S3-compatible storage (Cloudflare R2, AWS S3, Wasabi, MinIO)"
  type        = string
  sensitive   = true
}

variable "PLEX_CLAIM" {
  description = "Plex claim token from https://plex.tv/claim"
  type        = string
  sensitive   = true
  default     = ""
}

# Grafana Cloud
variable "GRAFANA_CLOUD_PROMETHEUS_URL" {
  description = "Grafana Cloud Prometheus remote write URL (e.g., https://prometheus-prod-xx-xxx.grafana.net/api/prom/push)"
  type        = string
  default     = ""
}

variable "GRAFANA_CLOUD_PROMETHEUS_USERNAME" {
  description = "Grafana Cloud Prometheus username (numeric ID)"
  type        = string
  default     = ""
}

variable "GRAFANA_CLOUD_LOKI_URL" {
  description = "Grafana Cloud Loki push URL (e.g., https://logs-prod-xxx.grafana.net/loki/api/v1/push)"
  type        = string
  default     = ""
}

variable "GRAFANA_CLOUD_LOKI_USERNAME" {
  description = "Grafana Cloud Loki username (numeric ID)"
  type        = string
  default     = ""
}

variable "GRAFANA_CLOUD_API_KEY" {
  description = "Grafana Cloud API key with MetricsPublisher and LogsPublisher permissions"
  type        = string
  sensitive   = true
  default     = ""
}

# Linkwarden
variable "LINKWARDEN_POSTGRES_PASSWORD" {
  description = "PostgreSQL password for Linkwarden database"
  type        = string
  sensitive   = true
}

variable "LINKWARDEN_NEXTAUTH_SECRET" {
  description = "NextAuth secret for Linkwarden session encryption"
  type        = string
  sensitive   = true
}

variable "LINKWARDEN_MEILI_KEY" {
  description = "Meilisearch master key for Linkwarden search"
  type        = string
  sensitive   = true
}
