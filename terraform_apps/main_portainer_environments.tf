data "portainer_environment" "local_swarm" {
  name = "primary"
}

resource "portainer_environment" "remote_qnap" {
  name                = "remote_qnap"
  environment_address = "tcp://10.0.40.2:9001"
  type                = 2 # Agent
  group_id            = 1
  # tag_ids             = [portainer_tag.remote_qnap.id]
}


output "swarm_environment_id" {
  value = data.portainer_environment.local_swarm.id
}

output "qnap_environment_id" {
  value = resource.portainer_environment.remote_qnap.id
}