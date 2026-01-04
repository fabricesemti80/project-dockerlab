# --- Global / Common ---

variable "proxmox_ssh_private_key_file" {
  description = "Path to the SSH private key for Proxmox"
  type        = string
  default     = "~/.ssh/fs_home_rsa"
}

# --- Hetzner Cloud ---

variable "HCLOUD_TOKEN" {
  description = "Hetzner Cloud API Token"
  type        = string
  sensitive   = true
}

# --- Proxmox ---

variable "PROXMOX_AUTH_TOKEN" {
  description = "Proxmox VE API Token (terraform@pve!provider=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)"
  type        = string
  sensitive   = true
}

# --- Cloudflare ---

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
  description = "Cloudflare Zone ID for krapulax.dev"
  type        = string
  sensitive   = true
}

variable "ACCESS_EMAIL" {
  description = "The email address allowed to access the lab services"
  type        = string
  default     = "emilfabrice@gmail.com"
}

# --- Portainer ---

variable "PORTAINER_API_KEY" {
  description = "Portainer API Key for authentication"
  type        = string
  sensitive   = true
}
