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

variable "hcloud_token" { sensitive = true }
variable "tailscale_auth_key" { sensitive = true }

variable "proxmox_auth_token" {
  sensitive   = true
  description = "terraform@pve!provider=xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx"
}

variable "cloudflare_api_token" {
  description = "Cloudflare API Token"
  sensitive   = true
}

variable "cloudflare_account_id" {
  description = "Cloudflare Account ID"
  sensitive   = true
}

provider "hcloud" {
  token = var.hcloud_token
}

provider "cloudflare" {
  api_token = var.cloudflare_api_token
}

variable "proxmox_ssh_private_key_file" {
  description = "Path to the SSH private key for Proxmox"
  default     = "~/.ssh/fs_home_rsa"
}

provider "proxmox" {
  endpoint  = "https://10.0.40.10:8006/"
  api_token = var.proxmox_auth_token
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
