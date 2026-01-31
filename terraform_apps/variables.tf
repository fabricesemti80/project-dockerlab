variable "portainer_token" {
  description = "Portainer API Key for authentication"
  type        = string
  sensitive   = true
}

variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  type        = string
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "Cloudflare Account ID"
  type        = string
  sensitive   = true
}

variable "cloudflare_zone_id" {
  description = "Cloudflare Zone ID"
  type        = string
  sensitive   = true
}

variable "access_email" {
  description = "The email address allowed to access the lab services"
  type        = string
  default     = "emilfabrice@gmail.com"
}

variable "acme_email" {
  description = "The email address for Let's Encrypt"
  type        = string
}

variable "domain" {
  description = "The domain name"
  type        = string
  default     = "krapulax.dev"
}

variable "tz" {
  description = "The timezone"
  type        = string
  default     = "Europe/London"
}

variable "puid" {
  description = "The user ID (1000 = QNAP admin-fabrice)"
  type        = string
  default     = "1000"
}

variable "pgid" {
  description = "The group ID (100 = users group on QNAP)"
  type        = string
  default     = "100"
}

variable "repo_url" {
  description = "The URL of the Git repository"
  type        = string
  default     = "https://github.com/fabricesemti80/project-dockerlab.git"
}

variable "repo_branch" {
  description = "The branch of the Git repository"
  type        = string
  default     = "refs/heads/main"
}

variable "beszel_agent_key" {
  description = "The agent key for Beszel"
  type        = string
  sensitive   = true
  default     = ""
}

variable "filebrowser_admin_password" {
  description = "Admin password for Filebrowser"
  type        = string
  sensitive   = true
}

variable "docmost_app_secret" {
  description = "App secret for Docmost"
  type        = string
  sensitive   = true
}

variable "docmost_postgres_password" {
  description = "Postgres password for Docmost"
  type        = string
  sensitive   = true
}

variable "discord_watchtower_webhook" {
  description = "Discord Webhook URL for Watchtower notifications"
  type        = string
  sensitive   = true
}

variable "doppler_token" {
  description = "The Doppler token for authentication"
  type        = string
  sensitive   = true
}

variable "doppler_project" {
  description = "The Doppler project name"
  type        = string
}

variable "doppler_config" {
  description = "The Doppler config name"
  type        = string
}

variable "ghost_db_password" {
  description = "MySQL password for Ghost database user"
  type        = string
  sensitive   = true
}

variable "ghost_db_root_password" {
  description = "MySQL root password for Ghost database"
  type        = string
  sensitive   = true
}

variable "ghost_mail_transport" {
  description = "Mail transport for Ghost (e.g., SMTP)"
  type        = string
  default     = "SMTP"
}

variable "ghost_mail_host" {
  description = "SMTP host for Ghost mail"
  type        = string
  default     = "smtp.gmail.com"
}

variable "ghost_mail_port" {
  description = "SMTP port for Ghost mail"
  type        = string
  default     = "587"
}

variable "ghost_mail_user" {
  description = "SMTP username for Ghost mail"
  type        = string
  default     = ""
}

variable "ghost_mail_password" {
  description = "SMTP password for Ghost mail"
  type        = string
  sensitive   = true
  default     = ""
}

variable "ghost_mail_from" {
  description = "From address for Ghost emails"
  type        = string
  default     = "noreply@krapulax.net"
}

variable "s3_access_key_id" {
  description = "Access key for S3-compatible storage (Cloudflare R2, AWS S3, Wasabi, MinIO)"
  type        = string
  sensitive   = true
}

variable "s3_secret_access_key" {
  description = "Secret key for S3-compatible storage (Cloudflare R2, AWS S3, Wasabi, MinIO)"
  type        = string
  sensitive   = true
}

variable "plex_claim" {
  description = "Plex claim token from https://plex.tv/claim"
  type        = string
  sensitive   = true
  default     = ""
}

# Grafana Cloud
variable "grafana_cloud_prometheus_url" {
  description = "Grafana Cloud Prometheus remote write URL (e.g., https://prometheus-prod-xx-xxx.grafana.net/api/prom/push)"
  type        = string
  default     = ""
}

variable "grafana_cloud_prometheus_username" {
  description = "Grafana Cloud Prometheus username (numeric ID)"
  type        = string
  default     = ""
}

variable "grafana_cloud_loki_url" {
  description = "Grafana Cloud Loki push URL (e.g., https://logs-prod-xxx.grafana.net/loki/api/v1/push)"
  type        = string
  default     = ""
}

variable "grafana_cloud_loki_username" {
  description = "Grafana Cloud Loki username (numeric ID)"
  type        = string
  default     = ""
}

variable "grafana_cloud_api_key" {
  description = "Grafana Cloud API key with MetricsPublisher and LogsPublisher permissions"
  type        = string
  sensitive   = true
  default     = ""
}

# Linkwarden
variable "linkwarden_postgres_password" {
  description = "PostgreSQL password for Linkwarden database"
  type        = string
  sensitive   = true
}

variable "linkwarden_nextauth_secret" {
  description = "NextAuth secret for Linkwarden session encryption"
  type        = string
  sensitive   = true
}

variable "linkwarden_meili_key" {
  description = "Meilisearch master key for Linkwarden search"
  type        = string
  sensitive   = true
}

# NZBGet
variable "nzbget_user" {
  description = "NZBGet web interface username"
  type        = string
  default     = "nzbget"
}

variable "nzbget_pass" {
  description = "NZBGet web interface password"
  type        = string
  sensitive   = true
}

# Media stack overrides (run as root for NFS compatibility)
variable "media_puid" {
  description = "PUID for media apps (Sonarr, Radarr, Prowlarr, NZBGet)"
  type        = string
  default     = "0"
}

variable "media_pgid" {
  description = "PGID for media apps (Sonarr, Radarr, Prowlarr, NZBGet)"
  type        = string
  default     = "0"
}

# Immich
variable "immich_db_password" {
  description = "PostgreSQL password for Immich database"
  type        = string
  sensitive   = true
}
