# resource "portainer_stack" "swarm_nginx" {
#   name            = "swarm_nginx"
#   deployment_type = "swarm"
#   method          = "string"
#   endpoint_id     = 1

#   stack_file_content = <<-EOT
#     version: "3"
#     services:
#       web:
#         image: nginx
#   EOT

#   env {
#     name  = "MY_VAR"
#     value = "value"
#   }
# }