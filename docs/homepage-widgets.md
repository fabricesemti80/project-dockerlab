# Homepage Widget API Keys

This document describes the API keys and credentials required for Homepage dashboard widgets.

## Overview

Homepage widgets provide real-time statistics and status information for your services. To enable widgets, you need to generate API keys from each service and add them to your Doppler secrets.

## Services with Widget Support

| Service | Widget Type | Auth Type | Doppler Variable |
|---------|-------------|-----------|------------------|
| Sonarr | `sonarr` | API Key | `SONARR_API_KEY` |
| Radarr | `radarr` | API Key | `RADARR_API_KEY` |
| Prowlarr | `prowlarr` | API Key | `PROWLARR_API_KEY` |
| Jellyfin | `jellyfin` | API Key | `JELLYFIN_API_KEY` |
| Jellyseerr | `jellyseerr` | API Key | `JELLYSEERR_API_KEY` |
| Immich | `immich` | API Key | `IMMICH_API_KEY` |
| NZBGet | `nzbget` | Username/Password | `NZBGET_USER`, `NZBGET_PASS` |
| Traefik | `traefik` | None | N/A |
| Gatus | `gatus` | None | N/A |
| Wallos | `wallos` | API Key | `WALLOS_API_KEY` |
| Linkwarden | `linkwarden` | API Key | `LINKWARDEN_API_KEY` |

## Services WITHOUT Widget Support

The following services do not have Homepage widget integrations:
- Glance
- FileBrowser
- OtterWiki
- Beszel

## How to Generate API Keys

### Sonarr / Radarr / Prowlarr

1. Open the web UI
2. Go to **Settings** → **General**
3. Find the **API Key** field under Security section
4. Copy the API key

### Jellyfin

1. Open Jellyfin web UI
2. Go to **Dashboard** → **Advanced** → **API Keys**
3. Click **+** to create a new API key
4. Give it a name (e.g., "Homepage")
5. Copy the generated key

### Jellyseerr

1. Open Jellyseerr web UI
2. Go to **Settings** → **General**
3. Find the **API Key** section
4. Copy the API key

### Immich

1. Open Immich web UI
2. Click on your profile icon → **Account Settings**
3. Go to **API Keys**
4. Click **New API Key**
5. Name it (e.g., "Homepage") and ensure it has `server.statistics` permission
6. Copy the generated key

### Wallos

1. Open Wallos web UI
2. Click on your **Profile**
3. Find the **API Key** section
4. Copy or generate an API key

### Linkwarden

1. Open Linkwarden web UI
2. Go to **Settings** → **Access Tokens**
3. Click **Generate Token**
4. Name it (e.g., "Homepage")
5. Copy the generated token

### NZBGet

NZBGet uses HTTP Basic Auth (ControlUsername/ControlPassword):
1. Open NZBGet web UI
2. Go to **Settings** → **Security**
3. Note the **ControlUsername** and **ControlPassword** values
4. These are already configured via `NZBGET_USER` and `NZBGET_PASS`

## Adding to Doppler

Add the following secrets to your Doppler project (use snake_case to match Terraform variables):

```
SONARR_API_KEY=<your-sonarr-api-key>
RADARR_API_KEY=<your-radarr-api-key>
PROWLARR_API_KEY=<your-prowlarr-api-key>
JELLYFIN_API_KEY=<your-jellyfin-api-key>
JELLYSEERR_API_KEY=<your-jellyseerr-api-key>
IMMICH_API_KEY=<your-immich-api-key>
WALLOS_API_KEY=<your-wallos-api-key>
LINKWARDEN_API_KEY=<your-linkwarden-api-key>
```

> **Note:** `NZBGET_USER` and `NZBGET_PASS` should already exist in Doppler for the NZBGet service itself.

## Terraform Variables

The following variables have been added to `terraform_apps/variables.tf`:

| Doppler Secret | Terraform Variable |
|----------------|-------------------|
| `SONARR_API_KEY` | `sonarr_api_key` |
| `RADARR_API_KEY` | `radarr_api_key` |
| `PROWLARR_API_KEY` | `prowlarr_api_key` |
| `JELLYFIN_API_KEY` | `jellyfin_api_key` |
| `JELLYSEERR_API_KEY` | `jellyseerr_api_key` |
| `IMMICH_API_KEY` | `immich_api_key` |
| `WALLOS_API_KEY` | `wallos_api_key` |
| `LINKWARDEN_API_KEY` | `linkwarden_api_key` |

All variables have `default = ""` so they're optional until you configure the API keys.

## Deployment

After adding the secrets to Doppler:

1. Run Terraform to update Portainer stack environment variables
2. Redeploy the **Homepage** stack to pick up the new environment variables
3. Redeploy each service stack to apply the widget labels

The widgets will automatically appear on your Homepage dashboard once the API keys are configured correctly.
