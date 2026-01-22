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
| [portainer_stack.linkwarden](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.maintenance](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.otterwiki](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.plex](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.socket-proxy](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.traefik](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.wallos](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [portainer_stack.whoami](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/resources/stack) | resource |
| [random_id.tunnel_secret](https://registry.terraform.io/providers/hashicorp/random/latest/docs/resources/id) | resource |
| [cloudflare_zone.main](https://registry.terraform.io/providers/cloudflare/cloudflare/latest/docs/data-sources/zone) | data source |
| [portainer_environment.local_swarm](https://registry.terraform.io/providers/portainer/portainer/1.21.0/docs/data-sources/environment) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ACCESS_EMAIL"></a> [ACCESS\_EMAIL](#input\_ACCESS\_EMAIL) | The email address allowed to access the lab services | `string` | `"emilfabrice@gmail.com"` | no |
| <a name="input_ACME_EMAIL"></a> [ACME\_EMAIL](#input\_ACME\_EMAIL) | The email address for Let's Encrypt | `string` | n/a | yes |
| <a name="input_BESZEL_AGENT_KEY"></a> [BESZEL\_AGENT\_KEY](#input\_BESZEL\_AGENT\_KEY) | The agent key for Beszel | `string` | `""` | no |
| <a name="input_CLOUDFLARE_ACCOUNT_ID"></a> [CLOUDFLARE\_ACCOUNT\_ID](#input\_CLOUDFLARE\_ACCOUNT\_ID) | Cloudflare Account ID | `string` | n/a | yes |
| <a name="input_CLOUDFLARE_API_TOKEN"></a> [CLOUDFLARE\_API\_TOKEN](#input\_CLOUDFLARE\_API\_TOKEN) | Cloudflare API Token | `string` | n/a | yes |
| <a name="input_CLOUDFLARE_ZONE_ID"></a> [CLOUDFLARE\_ZONE\_ID](#input\_CLOUDFLARE\_ZONE\_ID) | Cloudflare Zone ID | `string` | n/a | yes |
| <a name="input_DISCORD_WATCHTOWER_WEBHOOK"></a> [DISCORD\_WATCHTOWER\_WEBHOOK](#input\_DISCORD\_WATCHTOWER\_WEBHOOK) | Discord Webhook URL for Watchtower notifications | `string` | n/a | yes |
| <a name="input_DOCMOST_APP_SECRET"></a> [DOCMOST\_APP\_SECRET](#input\_DOCMOST\_APP\_SECRET) | App secret for Docmost | `string` | n/a | yes |
| <a name="input_DOCMOST_POSTGRES_PASSWORD"></a> [DOCMOST\_POSTGRES\_PASSWORD](#input\_DOCMOST\_POSTGRES\_PASSWORD) | Postgres password for Docmost | `string` | n/a | yes |
| <a name="input_DOMAIN"></a> [DOMAIN](#input\_DOMAIN) | The domain name | `string` | `"krapulax.dev"` | no |
| <a name="input_DOPPLER_CONFIG"></a> [DOPPLER\_CONFIG](#input\_DOPPLER\_CONFIG) | The Doppler config name | `string` | n/a | yes |
| <a name="input_DOPPLER_PROJECT"></a> [DOPPLER\_PROJECT](#input\_DOPPLER\_PROJECT) | The Doppler project name | `string` | n/a | yes |
| <a name="input_DOPPLER_TOKEN"></a> [DOPPLER\_TOKEN](#input\_DOPPLER\_TOKEN) | The Doppler token for authentication | `string` | n/a | yes |
| <a name="input_FILEBROWSER_ADMIN_PASSWORD"></a> [FILEBROWSER\_ADMIN\_PASSWORD](#input\_FILEBROWSER\_ADMIN\_PASSWORD) | Admin password for Filebrowser | `string` | n/a | yes |
| <a name="input_GHOST_DB_PASSWORD"></a> [GHOST\_DB\_PASSWORD](#input\_GHOST\_DB\_PASSWORD) | MySQL password for Ghost database user | `string` | n/a | yes |
| <a name="input_GHOST_DB_ROOT_PASSWORD"></a> [GHOST\_DB\_ROOT\_PASSWORD](#input\_GHOST\_DB\_ROOT\_PASSWORD) | MySQL root password for Ghost database | `string` | n/a | yes |
| <a name="input_GHOST_MAIL_FROM"></a> [GHOST\_MAIL\_FROM](#input\_GHOST\_MAIL\_FROM) | From address for Ghost emails | `string` | `"noreply@krapulax.net"` | no |
| <a name="input_GHOST_MAIL_HOST"></a> [GHOST\_MAIL\_HOST](#input\_GHOST\_MAIL\_HOST) | SMTP host for Ghost mail | `string` | `"smtp.gmail.com"` | no |
| <a name="input_GHOST_MAIL_PASSWORD"></a> [GHOST\_MAIL\_PASSWORD](#input\_GHOST\_MAIL\_PASSWORD) | SMTP password for Ghost mail | `string` | `""` | no |
| <a name="input_GHOST_MAIL_PORT"></a> [GHOST\_MAIL\_PORT](#input\_GHOST\_MAIL\_PORT) | SMTP port for Ghost mail | `string` | `"587"` | no |
| <a name="input_GHOST_MAIL_TRANSPORT"></a> [GHOST\_MAIL\_TRANSPORT](#input\_GHOST\_MAIL\_TRANSPORT) | Mail transport for Ghost (e.g., SMTP) | `string` | `"SMTP"` | no |
| <a name="input_GHOST_MAIL_USER"></a> [GHOST\_MAIL\_USER](#input\_GHOST\_MAIL\_USER) | SMTP username for Ghost mail | `string` | `""` | no |
| <a name="input_GRAFANA_CLOUD_API_KEY"></a> [GRAFANA\_CLOUD\_API\_KEY](#input\_GRAFANA\_CLOUD\_API\_KEY) | Grafana Cloud API key with MetricsPublisher and LogsPublisher permissions | `string` | `""` | no |
| <a name="input_GRAFANA_CLOUD_LOKI_URL"></a> [GRAFANA\_CLOUD\_LOKI\_URL](#input\_GRAFANA\_CLOUD\_LOKI\_URL) | Grafana Cloud Loki push URL (e.g., https://logs-prod-xxx.grafana.net/loki/api/v1/push) | `string` | `""` | no |
| <a name="input_GRAFANA_CLOUD_LOKI_USERNAME"></a> [GRAFANA\_CLOUD\_LOKI\_USERNAME](#input\_GRAFANA\_CLOUD\_LOKI\_USERNAME) | Grafana Cloud Loki username (numeric ID) | `string` | `""` | no |
| <a name="input_GRAFANA_CLOUD_PROMETHEUS_URL"></a> [GRAFANA\_CLOUD\_PROMETHEUS\_URL](#input\_GRAFANA\_CLOUD\_PROMETHEUS\_URL) | Grafana Cloud Prometheus remote write URL (e.g., https://prometheus-prod-xx-xxx.grafana.net/api/prom/push) | `string` | `""` | no |
| <a name="input_GRAFANA_CLOUD_PROMETHEUS_USERNAME"></a> [GRAFANA\_CLOUD\_PROMETHEUS\_USERNAME](#input\_GRAFANA\_CLOUD\_PROMETHEUS\_USERNAME) | Grafana Cloud Prometheus username (numeric ID) | `string` | `""` | no |
| <a name="input_LINKWARDEN_MEILI_KEY"></a> [LINKWARDEN\_MEILI\_KEY](#input\_LINKWARDEN\_MEILI\_KEY) | Meilisearch master key for Linkwarden search | `string` | n/a | yes |
| <a name="input_LINKWARDEN_NEXTAUTH_SECRET"></a> [LINKWARDEN\_NEXTAUTH\_SECRET](#input\_LINKWARDEN\_NEXTAUTH\_SECRET) | NextAuth secret for Linkwarden session encryption | `string` | n/a | yes |
| <a name="input_LINKWARDEN_POSTGRES_PASSWORD"></a> [LINKWARDEN\_POSTGRES\_PASSWORD](#input\_LINKWARDEN\_POSTGRES\_PASSWORD) | PostgreSQL password for Linkwarden database | `string` | n/a | yes |
| <a name="input_PGID"></a> [PGID](#input\_PGID) | The group ID | `string` | `"1000"` | no |
| <a name="input_PLEX_CLAIM"></a> [PLEX\_CLAIM](#input\_PLEX\_CLAIM) | Plex claim token from https://plex.tv/claim | `string` | `""` | no |
| <a name="input_PORTAINER_TOKEN"></a> [PORTAINER\_TOKEN](#input\_PORTAINER\_TOKEN) | Portainer API Key for authentication | `string` | n/a | yes |
| <a name="input_PUID"></a> [PUID](#input\_PUID) | The user ID | `string` | `"1000"` | no |
| <a name="input_REPO_BRANCH"></a> [REPO\_BRANCH](#input\_REPO\_BRANCH) | The branch of the Git repository | `string` | `"refs/heads/main"` | no |
| <a name="input_REPO_URL"></a> [REPO\_URL](#input\_REPO\_URL) | The URL of the Git repository | `string` | `"https://github.com/fabricesemti80/project-dockerlab.git"` | no |
| <a name="input_S3_ACCESS_KEY_ID"></a> [S3\_ACCESS\_KEY\_ID](#input\_S3\_ACCESS\_KEY\_ID) | Access key for S3-compatible storage (Cloudflare R2, AWS S3, Wasabi, MinIO) | `string` | n/a | yes |
| <a name="input_S3_SECRET_ACCESS_KEY"></a> [S3\_SECRET\_ACCESS\_KEY](#input\_S3\_SECRET\_ACCESS\_KEY) | Secret key for S3-compatible storage (Cloudflare R2, AWS S3, Wasabi, MinIO) | `string` | n/a | yes |
| <a name="input_TZ"></a> [TZ](#input\_TZ) | The timezone | `string` | `"Europe/London"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_qnap_environment_id"></a> [qnap\_environment\_id](#output\_qnap\_environment\_id) | n/a |
| <a name="output_swarm_environment_id"></a> [swarm\_environment\_id](#output\_swarm\_environment\_id) | n/a |
<!-- END_TF_DOCS -->