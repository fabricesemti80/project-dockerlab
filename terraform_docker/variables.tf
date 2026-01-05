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
