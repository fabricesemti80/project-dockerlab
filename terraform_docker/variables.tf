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
