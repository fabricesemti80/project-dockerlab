
# Hetzner Cloud Server Module
module "dkr_srv_0" {
  source = "./modules/hetzner-cloud"

  # Server Configuration
  server_name    = "dkr-srv-0"
  server_image   = "ubuntu-22.04"
  server_type    = "cx23" # 2 vCPU, 4GB RAM - Good baseline
  location       = "hel1" # Helsinki
  ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIPaRaLhsPV/6TivJmQ7ulsp/xDHgSuNJUHqril3Fiu1y fs@macpro-fs"
  ssh_key_name   = "id_fs_hetzner"
  enable_ipv4    = true
  enable_ipv6    = true

  # Firewall Configuration
  firewall_name = "dokply-firewall"
  firewall_rules = [
    {
      direction  = "in"
      protocol   = "tcp"
      port       = "22"
      source_ips = ["0.0.0.0/0", "::/0"] # Recommend restricting this to your IP if possible
    },
    {
      direction  = "in"
      protocol   = "tcp"
      port       = "80"
      source_ips = ["0.0.0.0/0", "::/0"]
    },
    {
      direction  = "in"
      protocol   = "tcp"
      port       = "443"
      source_ips = ["0.0.0.0/0", "::/0"]
    },
    {
      direction  = "in"
      protocol   = "tcp"
      port       = "3000" # dokply UI default port
      source_ips = ["0.0.0.0/0", "::/0"]
    }
  ]

  #   # Optional simple user data (example)
  #   user_data = <<-EOF
  # #cloud-config
  # runcmd:
  #   - echo "Simple Hetzner initialization script"
  #   - apt-get update
  #   - echo "Hetzner initialization complete"
  # EOF

}

# Outputs
output "dkr_srv_0_name" {
  description = "The name of the dkr_srv_0 server"
  value       = module.dkr_srv_0.server_name
}

output "dkr_srv_0_ipv4" {
  description = "The public IPv4 address of the dkr_srv_0 server"
  value       = module.dkr_srv_0.server_ipv4_address
}

output "dkr_srv_0_ipv6" {
  description = "The public IPv6 address of the dkr_srv_0 server"
  value       = module.dkr_srv_0.server_ipv6_address
}

# MANUAL SSH DIAGNOSTIC COMMANDS (run these after server deployment):
# ssh root@<SERVER_IP> -i ~/.ssh/id_fs_hetzner "cat /var/log/tailscale-install.log"
# ssh root@<SERVER_IP> -i ~/.ssh/id_fs_hetzner "which tailscale || echo 'Tailscale not found in PATH'"
# ssh root@<SERVER_IP> -i ~/.ssh/id_fs_hetzner "tailscale status --json"
# ssh root@<SERVER_IP> -i ~/.ssh/id_fs_hetzner "tailscale ip -4 && tailscale ip -6"
# ssh root@<SERVER_IP> -i ~/.ssh/id_fs_hetzner "tailscale capabilities list"
