# Dockpeek Setup

[Dockpeek](https://github.com/dockpeek/dockpeek) is a simple Docker container explorer.

## 1. Prerequisites
- `traefik` stack deployed.
- `DOMAIN` environment variable set in Portainer.

## 2. Deployment
1.  Add a new stack in Portainer pointing to this folder (`docker/dockpeek`).
2.  **Environment Variables:**
    - `DOMAIN`: Your domain (e.g. `krapulax.dev`).
    - `SECRET_KEY`: A random string (Generate with `openssl rand -hex 32`).
    - `USERNAME`: (Optional) `admin`.
    - `PASSWORD`: (Optional) Your secure password.
3.  Deploy.

## 3. Access
- URL: `https://dockpeek.yourdomain.com`
- Secured via **Cloudflare Access** (no internal auth needed).
