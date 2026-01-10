# Ghost Setup

[Ghost](https://ghost.org/) is a powerful open-source blogging and publishing platform.

## Environment Variables

| Variable | Description | Required |
|:---|:---|:---|
| `DOMAIN` | Base domain (e.g., `example.com`) | Yes |
| `GHOST_DB_PASSWORD` | MySQL password for the ghost user | Yes |
| `GHOST_DB_ROOT_PASSWORD` | MySQL root password | Yes |
| `GHOST_MAIL_TRANSPORT` | Mail transport (e.g., `SMTP`) | No |
| `GHOST_MAIL_HOST` | SMTP host (e.g., `smtp.mailgun.org`) | No |
| `GHOST_MAIL_PORT` | SMTP port (e.g., `587`) | No |
| `GHOST_MAIL_USER` | SMTP username | No |
| `GHOST_MAIL_PASSWORD` | SMTP password | No |
| `GHOST_MAIL_FROM` | From address for emails (e.g., `noreply@example.com`) | No |

## Volumes

| Host Path | Container Path | Description |
|:---|:---|:---|
| `/mnt/cephfs/docker-shared-data/ghost/content` | `/var/lib/ghost/content` | Ghost content (themes, images, etc.) |
| `/mnt/cephfs/docker-shared-data/ghost/mysql` | `/var/lib/mysql` | MySQL database storage |

## Deployment

1. Ensure Ansible has created the directories:
   ```bash
   task ansible:playbook
   ```

2. Deploy the stack:
   ```bash
   docker stack deploy -c docker/ghost/ghost-stack.yml ghost
   ```

## Post-Installation

1. Access Ghost admin at `https://ghost.your-domain.com/ghost`
2. Complete the initial setup wizard to create your admin account
3. Configure your blog settings, themes, and integrations
