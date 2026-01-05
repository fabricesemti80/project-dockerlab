terraform {
  required_providers {
    portainer = {
      source  = "portainer/portainer"
      version = "1.20.1"
    }
  }
}

provider "portainer" {
  endpoint = "https://10.0.30.21:9443"

  # API key authentication
  api_key = var.PORTAINER_TOKEN

  skip_ssl_verify = true # Skip TLS verification
}
