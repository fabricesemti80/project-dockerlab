terraform {
  required_providers {
    portainer = {
      source  = "portainer/portainer"
      version = "1.20.1"
    }
    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.6"
    }
    doppler = {
      source  = "dopplerhq/doppler"
      version = "~> 1.3"
    }
  }
}

provider "cloudflare" {
  api_token = var.CLOUDFLARE_API_TOKEN
}

provider "doppler" {
  doppler_token = var.DOPPLER_TOKEN
}

provider "portainer" {
  endpoint = "https://10.0.30.21:9443"

  # API key authentication
  api_key = var.PORTAINER_TOKEN

  skip_ssl_verify = true # Skip TLS verification
}
