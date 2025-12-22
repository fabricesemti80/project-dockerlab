
# Hetzner Cloud Server Module
module "dkr_srv_0" {
  source = "./modules/hetzner-cloud"

  # Server Configuration
  server_name    = "dkr-srv-0"
  server_image   = "ubuntu-22.04"
  server_type    = "cx23" # 2 vCPU, 4GB RAM - Good baseline
  location       = "hel1" # Helsinki
  ssh_public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZNMQ9ZBT1pxZCjNHGI9fE3MaFJPy8gOfOjrA+PclVk fs@Fabrices-MBP"
  ssh_key_name   = "id_macbook_fs"
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
    },
    {
      direction  = "in"
      protocol   = "tcp"
      port       = "9120" # komodo
      source_ips = ["0.0.0.0/0", "::/0"]
    },
    {
      direction  = "in"
      protocol   = "tcp"
      port       = "9443" # Portainer HTTPs
      source_ips = ["0.0.0.0/0", "::/0"]
    },
    {
      direction  = "in"
      protocol   = "tcp"
      port       = "9000" # Portainer HTTP
      source_ips = ["0.0.0.0/0", "::/0"]
    }
  ]

  # User data to configure fs user with both SSH keys
  user_data = <<-EOF
#cloud-config
users:
  - name: fs
    sudo: ALL=(ALL) NOPASSWD:ALL
    groups: sudo
    shell: /bin/bash
    ssh_authorized_keys:
      - ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQCpjSKK4qiMx4vIOvX7PHBOOctpYQ/XQQKWinw+v8oIQoI3GWkdRTwZpXJ2QSor/10zk5TZphP6XpfXxJj3caPwZPnu/ZFci/Iy40T6O2PDUFBjzaBLoIRci4lkRgjyEITKt9K1gIiqO8CnrMNBQTYj8gt7pHa3jIv102M1JIVqq4IU6tDTnf6Nku20jQcvxQCuJT0AszLZwMsD8IMOPkOfztnYOeJTXKOvcT+Vff3+ORXtXbVXNvAhobiSdK1MH5dAMsDZs9QcAazJGMfp50BcBUiHCRUo2XRk+IjMt7Tj6EjI+IMy+QOQWvTM016X9xTiLrPEJMU2RatfeG9VvcCPeQxPCbQE7uuYvCa3SAeJ3CTSL6kTE/4gp4uIq/XZEgZZO/4vuWF+1cNRYhePyJm9tlIU1o5AHHL2I8FJUlQJAe/+gRd/irfzRGDhiYw3fa02nFXsPY4mlEjIdjAd7JYRv1D3X2LBS+62PjqRC3NoNLodfywd3pVsiO3l3QsQKMRGxbyA9jSelSORNftGNeIQJWgJXW0ws42aCYmdcarCpLIil5QfV3WSfXz+a+wd5y7OCW19+sl3j1RHJhIuttsAZQOIGisCfDgstxhY08yuqA2DcZCdNL50JJzN2AQyeVzGRNEhFFEELBdRMAOf7L61Qie3Y+s9aN0do0xDInOkYQ== fs@home
      - ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDZNMQ9ZBT1pxZCjNHGI9fE3MaFJPy8gOfOjrA+PclVk fs@Fabrices-MBP

# # Update packages
# package_update: true
# package_upgrade: true

# runcmd:
#   - echo "Hetzner VM configured with fs user and both SSH keys"
#   - usermod -aG docker fs
#   - echo "fs user added to docker group"
EOF

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

# Snapshot outputs
output "dkr_srv_0_snapshot_id" {
  description = "The ID of the snapshot created from dkr_srv_0"
  value       = module.dkr_srv_0.snapshot_id
}

output "dkr_srv_0_snapshot_name" {
  description = "The name of the snapshot created from dkr_srv_0"
  value       = module.dkr_srv_0.snapshot_name
}

# MANUAL SSH DIAGNOSTIC COMMANDS (run these after server deployment):
# ssh fs@<SERVER_IP> -i ~/.ssh/id_macbook_fs "cat /var/log/tailscale-install.log"
# ssh fs@<SERVER_IP> -i ~/.ssh/id_macbook_fs "which tailscale || echo 'Tailscale not found in PATH'"
# ssh fs@<SERVER_IP> -i ~/.ssh/id_macbook_fs "tailscale status --json"
# ssh fs@<SERVER_IP> -i ~/.ssh/id_macbook_fs "tailscale ip -4 && tailscale ip -6"
# ssh fs@<SERVER_IP> -i ~/.ssh/id_macbook_fs "tailscale capabilities list"
# ssh root@<SERVER_IP> -i ~/.ssh/id_macbook_fs "cat /var/log/tailscale-install.log" (root login available)
