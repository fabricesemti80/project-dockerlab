# Glance Setup

[Glance](https://github.com/glanceapp/glance) is a self-hosted dashboard that puts all your feeds in one place.

## 1. Prerequisites
- `traefik` stack deployed.
- `DOMAIN` environment variable set in Portainer.

## 2. Configuration
The stack uses a **Docker Config** (`glance_config`) to mount the `glance.yml` file found in this directory.

To customize your dashboard:
1.  Edit `docker/glance/glance.yml` in this repository.
2.  Commit and push changes.
3.  In Portainer, pull the latest changes and redeploy the stack.

*Note: Docker Configs are immutable in Swarm. Portainer handles the rotation (creation of a new config version) automatically when you redeploy via GitOps.*

## 3. Access
- URL: `https://glance.yourdomain.com`
- Since you have **Cloudflare Access** configured, you will be prompted to log in with your email first.
