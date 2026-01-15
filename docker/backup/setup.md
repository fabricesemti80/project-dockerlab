# Backup Stack Setup Guide

This stack provides automated backups of all Docker Swarm data using [Restic](https://restic.net/).

## Features

- **Pre-backup database dumps** for Ghost (MySQL) and Docmost (Postgres)
- **Incremental backups** with deduplication
- **Encrypted** at rest
- **Flexible storage backends**: Backblaze B2, AWS S3, SFTP, local
- **Automatic retention**: 7 daily, 4 weekly, 3 monthly snapshots
- **Discord notifications** (optional)

## What Gets Backed Up

| Data | Path | Notes |
|------|------|-------|
| Traefik ACME | `/data/traefik/acme/` | SSL certificates |
| Ghost content | `/data/ghost/content/` | Themes, images, uploads |
| Ghost MySQL | `/data/ghost/mysql/` | Database files |
| Ghost dump | `/data/ghost/ghost-dump.sql` | SQL dump (pre-backup) |
| Docmost storage | `/data/docmost/storage/` | Attachments |
| Docmost Postgres | `/data/docmost/postgres/` | Database files |
| Docmost dump | `/data/docmost/docmost-dump.sql` | SQL dump (pre-backup) |
| Docmost Redis | `/data/docmost/redis/` | Cache data |
| Wallos | `/data/wallos/` | SQLite DB + logos |
| Beszel | `/data/beszel/data/` | Monitoring data |
| Gatus | `/data/gatus/data/` | Status history |
| FileBrowser | `/data/filebrowser/` | Config + user files |

## Prerequisites

### 1. Choose a Storage Backend

#### Cloudflare R2 (Recommended - no egress fees)
- $0.015/GB/month storage
- **Free egress** (no bandwidth charges)
- Create a bucket and API token at https://dash.cloudflare.com → R2

#### Other S3-compatible options
- **AWS S3**: Create a bucket and IAM credentials
- **Wasabi**: $0.0069/GB/month, no egress fees
- **MinIO**: Self-hosted S3-compatible storage
- **Backblaze B2**: $0.005/GB/month storage

#### SFTP (self-hosted)
- Any server with SSH access

### 2. Initialize the Repository

Run once to initialize the backup repository:

```bash
# Set environment variables (example for Cloudflare R2)
export RESTIC_REPOSITORY="s3:https://<account-id>.r2.cloudflarestorage.com/docker-backups"
export RESTIC_PASSWORD="your-secure-password"
export AWS_ACCESS_KEY_ID="your-r2-access-key"
export AWS_SECRET_ACCESS_KEY="your-r2-secret-key"

# Initialize (run from a swarm node or with docker context)
docker run --rm \
  -e RESTIC_REPOSITORY \
  -e RESTIC_PASSWORD \
  -e AWS_ACCESS_KEY_ID \
  -e AWS_SECRET_ACCESS_KEY \
  restic/restic init
```

## Environment Variables

| Variable | Required | Description |
|----------|----------|-------------|
| `RESTIC_REPOSITORY` | Yes | Repository URL (see examples below) |
| `RESTIC_PASSWORD` | Yes | Encryption password (SAVE THIS!) |
| `S3_ACCESS_KEY_ID` | S3/R2 | Access key for S3-compatible storage |
| `S3_SECRET_ACCESS_KEY` | S3/R2 | Secret key for S3-compatible storage |
| `GHOST_DB_PASSWORD` | Yes | For MySQL dump |
| `DOCMOST_POSTGRES_PASSWORD` | Yes | For Postgres dump |
| `DISCORD_WEBHOOK_URL` | No | For notifications |

### Repository URL Examples

```bash
# Cloudflare R2
RESTIC_REPOSITORY="s3:https://<account-id>.r2.cloudflarestorage.com/bucket-name"

# AWS S3
RESTIC_REPOSITORY="s3:s3.amazonaws.com/bucket-name"

# Wasabi
RESTIC_REPOSITORY="s3:https://s3.wasabisys.com/bucket-name"

# MinIO (self-hosted)
RESTIC_REPOSITORY="s3:https://minio.example.com/bucket-name"

# Backblaze B2
RESTIC_REPOSITORY="b2:bucket-name:path/to/backups"

# SFTP
RESTIC_REPOSITORY="sftp:user@backup-server.com:/backups/docker"

# Local path (for testing)
RESTIC_REPOSITORY="/backups"
```

## Running Backups

### Manual Backup

```bash
# 1. Run database dumps
docker service scale backup_db-dump=1
# Wait for completion, then:
docker service scale backup_db-dump=0

# 2. Run backup
docker service scale backup_backup=1
# Wait for completion, then:
docker service scale backup_backup=0

# 3. Send notification (optional)
docker service scale backup_notify=1
docker service scale backup_notify=0
```

### Scheduled Backups (Cron on Manager Node)

Add to `/etc/crontab` on a manager node:

```bash
# Daily backup at 3:00 AM
0 3 * * * root docker service scale backup_db-dump=1 && sleep 60 && docker service scale backup_db-dump=0 && docker service scale backup_backup=1
```

Or use a cron container like `mcuadros/ofelia`.

## Restore Procedures

### List Available Snapshots

```bash
docker run --rm \
  -e RESTIC_REPOSITORY -e RESTIC_PASSWORD -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY \
  restic/restic snapshots
```

### Restore Specific Files

```bash
# Restore to /tmp/restore
docker run --rm \
  -v /tmp/restore:/restore \
  -e RESTIC_REPOSITORY -e RESTIC_PASSWORD -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY \
  restic/restic restore latest --target /restore --include "/data/ghost"
```

### Full Restore

```bash
# Stop affected services first!
docker service scale ghost_ghost=0 ghost_ghost-db=0

# Restore
docker run --rm \
  -v /mnt/cephfs/docker-shared-data:/data \
  -e RESTIC_REPOSITORY -e RESTIC_PASSWORD -e AWS_ACCESS_KEY_ID -e AWS_SECRET_ACCESS_KEY \
  restic/restic restore latest --target /

# Restart services
docker service scale ghost_ghost=1 ghost_ghost-db=1
```

### Restore Database from Dump

```bash
# Ghost MySQL
docker exec -i $(docker ps -q -f name=ghost_ghost-db) \
  mysql -u ghost -p$GHOST_DB_PASSWORD ghost < /mnt/cephfs/docker-shared-data/ghost/ghost-dump.sql

# Docmost Postgres
docker exec -i $(docker ps -q -f name=docmost_db) \
  psql -U docmost docmost < /mnt/cephfs/docker-shared-data/docmost/docmost-dump.sql
```

## Monitoring

### Check Backup Status

```bash
# List recent snapshots
restic snapshots --last 10

# Check repository health
restic check

# Show repository stats
restic stats
```

### Disk Usage

```bash
restic stats --mode raw-data
```

## Troubleshooting

### "repository does not exist"
Run `restic init` first (see Prerequisites).

### "wrong password"
Ensure `RESTIC_PASSWORD` matches what was used during `init`.

### Backup is slow
- Check network bandwidth to storage backend
- Consider excluding large unnecessary files
- Use `--verbose` to see progress

### Out of memory
Increase memory limit in stack file:
```yaml
resources:
  limits:
    memory: 1G
```

## Security Notes

- **SAVE YOUR RESTIC_PASSWORD** - without it, backups are unrecoverable
- Store credentials in a secrets manager (Doppler, Vault, etc.)
- Consider encrypting the password in your CI/CD pipeline
- Regularly test restores to verify backup integrity
