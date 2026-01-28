<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_cloudflare"></a> [cloudflare](#requirement\_cloudflare) | ~> 5.0 |
| <a name="requirement_doppler"></a> [doppler](#requirement\_doppler) | ~> 1.3 |
| <a name="requirement_portainer"></a> [portainer](#requirement\_portainer) | 1.21.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | ~> 3.6 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_cloudflare"></a> [cloudflare](#provider\_cloudflare) | ~> 5.0 |
| <a name="provider_doppler"></a> [doppler](#provider\_doppler) | ~> 1.3 |
| <a name="provider_portainer"></a> [portainer](#provider\_portainer) | 1.21.0 |
| <a name="provider_random"></a> [random](#provider\_random) | ~> 3.6 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [cloudflare_dns_record.beszel](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.homelab_root](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_dns_record.homelab_wildcard](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/dns_record) | resource |
| [cloudflare_zero_trust_access_application.apps](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zero_trust_access_application) | resource |
| [cloudflare_zero_trust_tunnel_cloudflared.homelab](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zero_trust_tunnel_cloudflared) | resource |
| [cloudflare_zero_trust_tunnel_cloudflared_config.homelab](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/resources/zero_trust_tunnel_cloudflared_config) | resource |
| [doppler_secret.tunnel_token](https://registry.terraform.io/providers/dopplerhq/doppler/latest/docs/resources/secret) | resource |
| [portainer_environment.remote_qnap](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/environment) | resource |
| [portainer_stack.alloy](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.backup](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.beszel](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.beszel_agent_qnap](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.cloudflared](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.dozzle](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.filebrowser](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.gatus](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.glance](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.homepage](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.jellyfin](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.jellyseerr](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.linkwarden](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.maintenance](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.nzbget](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.otterwiki](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.plex](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.prowlarr](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.radarr](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.socket-proxy](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.sonarr](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.traefik](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.wallos](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.whoami](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [random_id.tunnel_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [cloudflare_zone.main](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/zone) | data source |
| [portainer_environment.local_swarm](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/data-sources/environment) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_email"></a> [access\_email](#input\_access\_email) | The email address allowed to access the lab services | `string` | `"emilfabrice@gmail.com"` | no |
| <a name="input_acme_email"></a> [acme\_email](#input\_acme\_email) | The email address for Let's Encrypt | `string` | n/a | yes |
| <a name="input_beszel_agent_key"></a> [beszel\_agent\_key](#input\_beszel\_agent\_key) | The agent key for Beszel | `string` | `""` | no |
| <a name="input_cloudflare_account_id"></a> [cloudflare\_account\_id](#input\_cloudflare\_account\_id) | Cloudflare Account ID | `string` | n/a | yes |
| <a name="input_cloudflare_api_token"></a> [cloudflare\_api\_token](#input\_cloudflare\_api\_token) | Cloudflare API Token | `string` | n/a | yes |
| <a name="input_cloudflare_zone_id"></a> [cloudflare\_zone\_id](#input\_cloudflare\_zone\_id) | Cloudflare Zone ID | `string` | n/a | yes |
| <a name="input_discord_watchtower_webhook"></a> [discord\_watchtower\_webhook](#input\_discord\_watchtower\_webhook) | Discord Webhook URL for Watchtower notifications | `string` | n/a | yes |
| <a name="input_docmost_app_secret"></a> [docmost\_app\_secret](#input\_docmost\_app\_secret) | App secret for Docmost | `string` | n/a | yes |
| <a name="input_docmost_postgres_password"></a> [docmost\_postgres\_password](#input\_docmost\_postgres\_password) | Postgres password for Docmost | `string` | n/a | yes |
| <a name="input_domain"></a> [domain](#input\_domain) | The domain name | `string` | `"krapulax.dev"` | no |
| <a name="input_doppler_config"></a> [doppler\_config](#input\_doppler\_config) | The Doppler config name | `string` | n/a | yes |
| <a name="input_doppler_project"></a> [doppler\_project](#input\_doppler\_project) | The Doppler project name | `string` | n/a | yes |
| <a name="input_doppler_token"></a> [doppler\_token](#input\_doppler\_token) | The Doppler token for authentication | `string` | n/a | yes |
| <a name="input_filebrowser_admin_password"></a> [filebrowser\_admin\_password](#input\_filebrowser\_admin\_password) | Admin password for Filebrowser | `string` | n/a | yes |
| <a name="input_ghost_db_password"></a> [ghost\_db\_password](#input\_ghost\_db\_password) | MySQL password for Ghost database user | `string` | n/a | yes |
| <a name="input_ghost_db_root_password"></a> [ghost\_db\_root\_password](#input\_ghost\_db\_root\_password) | MySQL root password for Ghost database | `string` | n/a | yes |
| <a name="input_ghost_mail_from"></a> [ghost\_mail\_from](#input\_ghost\_mail\_from) | From address for Ghost emails | `string` | `"noreply@krapulax.net"` | no |
| <a name="input_ghost_mail_host"></a> [ghost\_mail\_host](#input\_ghost\_mail\_host) | SMTP host for Ghost mail | `string` | `"smtp.gmail.com"` | no |
| <a name="input_ghost_mail_password"></a> [ghost\_mail\_password](#input\_ghost\_mail\_password) | SMTP password for Ghost mail | `string` | `""` | no |
| <a name="input_ghost_mail_port"></a> [ghost\_mail\_port](#input\_ghost\_mail\_port) | SMTP port for Ghost mail | `string` | `"587"` | no |
| <a name="input_ghost_mail_transport"></a> [ghost\_mail\_transport](#input\_ghost\_mail\_transport) | Mail transport for Ghost (e.g., SMTP) | `string` | `"SMTP"` | no |
| <a name="input_ghost_mail_user"></a> [ghost\_mail\_user](#input\_ghost\_mail\_user) | SMTP username for Ghost mail | `string` | `""` | no |
| <a name="input_grafana_cloud_api_key"></a> [grafana\_cloud\_api\_key](#input\_grafana\_cloud\_api\_key) | Grafana Cloud API key with MetricsPublisher and LogsPublisher permissions | `string` | `""` | no |
| <a name="input_grafana_cloud_loki_url"></a> [grafana\_cloud\_loki\_url](#input\_grafana\_cloud\_loki\_url) | Grafana Cloud Loki push URL (e.g., https://logs-prod-xxx.grafana.net/loki/api/v1/push) | `string` | `""` | no |
| <a name="input_grafana_cloud_loki_username"></a> [grafana\_cloud\_loki\_username](#input\_grafana\_cloud\_loki\_username) | Grafana Cloud Loki username (numeric ID) | `string` | `""` | no |
| <a name="input_grafana_cloud_prometheus_url"></a> [grafana\_cloud\_prometheus\_url](#input\_grafana\_cloud\_prometheus\_url) | Grafana Cloud Prometheus remote write URL (e.g., https://prometheus-prod-xx-xxx.grafana.net/api/prom/push) | `string` | `""` | no |
| <a name="input_grafana_cloud_prometheus_username"></a> [grafana\_cloud\_prometheus\_username](#input\_grafana\_cloud\_prometheus\_username) | Grafana Cloud Prometheus username (numeric ID) | `string` | `""` | no |
| <a name="input_linkwarden_meili_key"></a> [linkwarden\_meili\_key](#input\_linkwarden\_meili\_key) | Meilisearch master key for Linkwarden search | `string` | n/a | yes |
| <a name="input_linkwarden_nextauth_secret"></a> [linkwarden\_nextauth\_secret](#input\_linkwarden\_nextauth\_secret) | NextAuth secret for Linkwarden session encryption | `string` | n/a | yes |
| <a name="input_linkwarden_postgres_password"></a> [linkwarden\_postgres\_password](#input\_linkwarden\_postgres\_password) | PostgreSQL password for Linkwarden database | `string` | n/a | yes |
| <a name="input_media_pgid"></a> [media\_pgid](#input\_media\_pgid) | PGID for media apps (Sonarr, Radarr, Prowlarr, NZBGet) | `string` | `"0"` | no |
| <a name="input_media_puid"></a> [media\_puid](#input\_media\_puid) | PUID for media apps (Sonarr, Radarr, Prowlarr, NZBGet) | `string` | `"0"` | no |
| <a name="input_nzbget_pass"></a> [nzbget\_pass](#input\_nzbget\_pass) | NZBGet web interface password | `string` | n/a | yes |
| <a name="input_nzbget_user"></a> [nzbget\_user](#input\_nzbget\_user) | NZBGet web interface username | `string` | `"nzbget"` | no |
| <a name="input_pgid"></a> [pgid](#input\_pgid) | The group ID (100 = users group on QNAP) | `string` | `"100"` | no |
| <a name="input_plex_claim"></a> [plex\_claim](#input\_plex\_claim) | Plex claim token from https://plex.tv/claim | `string` | `""` | no |
| <a name="input_portainer_token"></a> [portainer\_token](#input\_portainer\_token) | Portainer API Key for authentication | `string` | n/a | yes |
| <a name="input_puid"></a> [puid](#input\_puid) | The user ID (1000 = QNAP admin-fabrice) | `string` | `"1000"` | no |
| <a name="input_repo_branch"></a> [repo\_branch](#input\_repo\_branch) | The branch of the Git repository | `string` | `"refs/heads/main"` | no |
| <a name="input_repo_url"></a> [repo\_url](#input\_repo\_url) | The URL of the Git repository | `string` | `"https://github.com/fabricesemti80/project-dockerlab.git"` | no |
| <a name="input_s3_access_key_id"></a> [s3\_access\_key\_id](#input\_s3\_access\_key\_id) | Access key for S3-compatible storage (Cloudflare R2, AWS S3, Wasabi, MinIO) | `string` | n/a | yes |
| <a name="input_s3_secret_access_key"></a> [s3\_secret\_access\_key](#input\_s3\_secret\_access\_key) | Secret key for S3-compatible storage (Cloudflare R2, AWS S3, Wasabi, MinIO) | `string` | n/a | yes |
| <a name="input_tz"></a> [tz](#input\_tz) | The timezone | `string` | `"Europe/London"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_qnap_environment_id"></a> [qnap\_environment\_id](#output\_qnap\_environment\_id) | n/a |
| <a name="output_swarm_environment_id"></a> [swarm\_environment\_id](#output\_swarm\_environment\_id) | n/a |
<!-- END_TF_DOCS -->
