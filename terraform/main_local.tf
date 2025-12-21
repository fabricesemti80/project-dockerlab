# resource "local_file" "ansible_inventory" {
#   filename = "../ansible/inventory.yml"
#   content  = <<-EOT
# ---
# all:
#   children:
#     home_vms:
#       hosts:
#         ${module.dkr_srv_1.vm_name}:
#           ansible_host: ${split("/", module.dkr_srv_1.vm_ipv4_address)[0]}
#         ${module.dkr_srv_2.vm_name}:
#           ansible_host: ${split("/", module.dkr_srv_2.vm_ipv4_address)[0]}
#       vars:
#         ansible_user: fs
#         ansible_ssh_private_key_file: ~/.ssh/id_macbook_fs
#         # Both SSH keys available: fs_home_rsa and id_macbook_fs
#     cloud_vms:
#       hosts:
#         ${module.dkr_srv_0.server_name}:
#           ansible_host: ${module.dkr_srv_0.server_ipv4_address}
#       vars:
#         ansible_user: fs
#         ansible_ssh_private_key_file: ~/.ssh/id_macbook_fs
#         # Both SSH keys available: fs_home_rsa and id_macbook_fs
#     swarm_managers:
#       children:
#         home_vms:
#         cloud_vms:
# EOT
#   # lifecycle {
#   #   ignore_changes = [content]
#   # }
# }
