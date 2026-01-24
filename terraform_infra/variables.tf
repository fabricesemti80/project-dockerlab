# --- Global / Common ---

variable "proxmox_ssh_private_key_file" {
  description = "Path to the SSH private key for Proxmox"
  type        = string
  default     = "~/.ssh/fs_home_rsa"
}

# --- Hetzner Cloud ---

variable "hcloud_token" {
  description = "Hetzner Cloud API Token"
  type        = string
  sensitive   = true
}

# --- Proxmox ---

variable "proxmox_auth_token" {
  description = "Proxmox VE API Token (terraform@pve!provider=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx)"
  type        = string
  sensitive   = true
}

# --- Cloudflare ---

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
  description = "Cloudflare Zone ID for krapulax.dev"
  type        = string
  sensitive   = true
}

variable "access_email" {
  description = "The email address allowed to access the lab services"
  type        = string
  default     = "emilfabrice@gmail.com"
}

variable "domain" {
  description = "The root domain for the lab"
  type        = string
}
