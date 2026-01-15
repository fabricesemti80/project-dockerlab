# Backrest - Backup Management

[Backrest](https://github.com/garethgeorge/backrest) is a web UI and orchestrator for [Restic](https://restic.net/) backups.

## Features

- **Web UI** for managing repositories, backups, and restores
- **Built-in scheduling** - no manual intervention needed
- **Browse snapshots** and restore individual files
- **Notifications** - Discord, Slack, Gotify, Healthchecks
- **All restic backends** - S3, R2, B2, SFTP, local, and more

## What Gets Backed Up

The stack mounts `/mnt/cephfs/docker-shared-data` as read-only at `/backups/docker-data` inside the container.

| Data | Container Path |
|------|----------------|
| Traefik ACME | `/backups/docker-data/traefik/` |
| Ghost | `/backups/docker-data/ghost/` |
| Docmost | `/backups/docker-data/docmost/` |
| Wallos | `/backups/docker-data/wallos/` |
| Beszel | `/backups/docker-data/beszel/` |
| Gatus | `/backups/docker-data/gatus/` |
| FileBrowser | `/backups/docker-data/filebrowser/` |

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `TZ` | Yes | Timezone |
| `S3_ACCESS_KEY_ID` | Yes | Access key for S3-compatible storage |
| `S3_SECRET_ACCESS_KEY` | Yes | Secret key for S3-compatible storage |
| `DOMAIN` | Yes | Domain for Traefik routing |

## Initial Setup

### 1. Deploy the Stack

Deploy via Portainer or Terraform. The stack will be available at `https://backrest.${DOMAIN}`.

### 2. First Login

On first access, you'll be prompted to create an admin username and password.

### 3. Add a Repository

1. Go to **Settings** → **Repositories** → **Add Repository**
2. Configure your S3/R2 storage:

   | Field | Value |
   |-------|-------|
   | **Name** | `docker-backups` |
   | **Repository URI** | `s3:https://<account-id>.r2.cloudflarestorage.com/docker-backups` |
   | **Password** | Create a strong encryption password (**SAVE THIS!**) |

   The `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` are already set via environment variables.

3. Click **Add Repository**

### 4. Add a Backup Plan

1. Go to **Settings** → **Plans** → **Add Plan**
2. Configure:

   | Field | Value |
   |-------|-------|
   | **Name** | `docker-swarm-daily` |
   | **Repository** | `docker-backups` |
   | **Paths** | `/backups/docker-data` |
   | **Schedule** | `0 3 * * *` (daily at 3 AM) |
   | **Retention** | Keep 7 daily, 4 weekly, 3 monthly |

3. Optionally add exclusions:
   ```
   *.log
   *.tmp
   cache/
   ```

4. Click **Save**

### 5. Configure Notifications (Optional)

1. Go to **Settings** → **Notifications**
2. Add Discord webhook:
   - **Type**: Discord
   - **Webhook URL**: Your Discord webhook URL
   - **Events**: Backup Success, Backup Failure

## Repository URL Examples

```
# Cloudflare R2
s3:https://<account-id>.r2.cloudflarestorage.com/bucket-name

# AWS S3
s3:s3.amazonaws.com/bucket-name

# Wasabi
s3:https://s3.wasabisys.com/bucket-name

# Backblaze B2
b2:bucket-name:path

# SFTP
sftp:user@host:/path/to/backups

# Local (for testing)
/backups/local
```

## Restore Procedures

### Via Web UI

1. Go to **Snapshots**
2. Select a snapshot
3. Browse files
4. Click **Restore** on files/folders you need
5. Choose restore location

### Manual Restore (CLI)

```bash
# SSH into a swarm manager
docker exec -it $(docker ps -q -f name=backup_backrest) sh

# List snapshots
restic -r "s3:https://<account-id>.r2.cloudflarestorage.com/docker-backups" snapshots

# Restore specific path
restic -r "s3:https://<account-id>.r2.cloudflarestorage.com/docker-backups" \
  restore latest --target /tmp/restore --include "/backups/docker-data/ghost"
```

## Database Backups

For consistent database backups, consider adding pre-backup hooks in Backrest:

### Ghost MySQL Dump

Add a **Command Hook** (before backup):
```bash
docker exec $(docker ps -q -f name=ghost_ghost-db) \
  mysqldump -u ghost -p$GHOST_DB_PASSWORD ghost > /backups/docker-data/ghost/ghost-dump.sql
```

### Docmost Postgres Dump

```bash
docker exec $(docker ps -q -f name=docmost_db) \
  pg_dump -U docmost docmost > /backups/docker-data/docmost/docmost-dump.sql
```

Note: This requires mounting the Docker socket to the Backrest container, which has security implications. An alternative is to run dumps via a separate cron job on the host.

## Monitoring

- Access the dashboard at `https://backrest.${DOMAIN}`
- View backup history and status
- Check repository health via **Repository** → **Check**

## Troubleshooting

### "repository does not exist"

Initialize the repository first:
1. Go to **Repositories** → Select your repo → **Initialize**

### "wrong password"

The repository password is set when creating the repository in Backrest. This is different from your S3 credentials.

### Backup is slow

- Check network bandwidth to storage
- Exclude large unnecessary files
- Consider running during off-peak hours

### Permission denied

Ensure the paths are mounted correctly and readable by the container.

## Security Notes

- **SAVE YOUR REPOSITORY PASSWORD** - without it, backups are unrecoverable
- Backrest stores its config in `/config/config.json` - this is also backed up on CephFS
- Consider restricting access via Traefik middleware (IP whitelist, basic auth)
