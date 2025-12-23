# Dockpeek Setup

[Dockpeek](https://github.com/dockpeek/dockpeek) is a simple Docker container explorer.

## 1. Prerequisites
- `traefik` stack deployed.
- `DOMAIN` environment variable set in Portainer.

## 2. Deployment
1.  Add a new stack in Portainer pointing to this folder (`docker/dockpeek`).
2.  Set `DOMAIN` env var (e.g. `krapulax.dev`).
3.  Deploy.

## 3. Access
- URL: `https://dockpeek.yourdomain.com`
- Secured via **Cloudflare Access** (no internal auth needed).
