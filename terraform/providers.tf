terraform {
  required_providers {
    hcloud = {
      source  = "hetznercloud/hcloud"
      version = "~> 1.45"
    }
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.89.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
  }
}

variable "HCLOUD_TOKEN" { sensitive = true }
# variable "TAILSCALE_AUTH_KEY" { sensitive = true }

variable "PROXMOX_AUTH_TOKEN" {
  sensitive   = true
  description = "terraform@pve!provider=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

variable "CLOUDFLARE_API_TOKEN" {
  description = "Cloudflare API Token"
  sensitive   = true
}

variable "CLOUDFLARE_ACCOUNT_ID" {
  description = "Cloudflare Account ID"
  sensitive   = true
}

provider "hcloud" {
  token = var.HCLOUD_TOKEN
}

provider "cloudflare" {
  api_token = var.CLOUDFLARE_API_TOKEN
}

variable "proxmox_ssh_private_key_file" {
  description = "Path to the SSH private key for Proxmox"
  default     = "~/.ssh/fs_home_rsa"
}

provider "proxmox" {
  endpoint  = "https://10.0.40.10:8006/"
  api_token = var.PROXMOX_AUTH_TOKEN
  insecure  = true
  ssh {
    username    = "root"
    agent       = false
    private_key = file(pathexpand(var.proxmox_ssh_private_key_file))
    node {
      name    = "pve-2"
      address = "10.0.40.10"
    }
  }
}
