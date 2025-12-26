# Komodo Setup Guide (Portainer GitOps)

This guide covers the deployment of [Komodo](https://komodo.dev/), a multi-node Docker management and deployment tool, using Portainer's GitOps functionality.

## 1. Prerequisites

- A running Docker Swarm cluster managed by Portainer.
- Traefik deployed and configured (using the `traefik_traefik-public` network).
- A domain managed by Cloudflare (or another provider supported by your Traefik setup).

## 2. Environment Variables

Define the following environment variables in Portainer when deploying the stack. You can use the values from `.envrc_example` as a template.

| Variable | Description |
| :--- | :--- |
| `DOMAIN` | Your base domain (e.g., `example.com`). Komodo will be at `komodo.${DOMAIN}`. |
| `KOMODO_VERSION` | The version tag for Komodo images (e.g., `1.18.0`). |
| `KOMODO_INIT_ADMIN_USERNAME` | The initial administrator username. |
| `KOMODO_INIT_ADMIN_PASSWORD` | The initial administrator password. |
| `MONGO_ROOT_USER` | Admin username for the MongoDB instance. |
| `MONGO_ROOT_PASSWORD` | Admin password for the MongoDB instance. |
| `KOMODO_JWT_SECRET` | Secret key for JWT token generation. |
| `KOMODO_WEBHOOK_SECRET` | Secret key for incoming webhooks. |
| `KOMODO_PASSKEY` | Passkey used for Core to Periphery authentication. |

## 3. Deployment via Portainer

1. Navigate to **Stacks** > **Add stack**.
2. Select **Repository**.
3. **Name:** `komodo`
4. **Repository URL:** `https://github.com/fs/project-dockerlab` (Update if different)
5. **Compose path:** `docker/komodo/komodo-stack.yml`
6. **Environment variables:** Add all variables listed in section 2.
7. Click **Deploy the stack**.

## 4. Post-Deployment Configuration

1. **Access Komodo**: Visit `https://komodo.${DOMAIN}`.
2. **Initial Setup**: Create your first admin user when prompted.
3. **Add Servers**: 
   - By default, the `periphery` service runs on every node in your swarm (global mode).
   - In Komodo Core, add a new server using the address `http://periphery:8120` (since they are on the same overlay network) or use the node's Tailscale/Internal IP if you prefer.
   - Use the `KOMODO_PASSKEY` you defined for authentication.

## 5. Storage

- MongoDB data is stored in Docker volumes (`mongodb_data`, `mongo-config`).
- Komodo Core caches repositories in `/etc/komodo/repos` on the host (Manager node).
- Periphery configuration and stacks are stored in `/etc/komodo` on each host.
