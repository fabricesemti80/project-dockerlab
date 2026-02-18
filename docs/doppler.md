# Doppler Documentation

This document explains how Doppler is used for secrets management in the project-dockerlab setup.

## Overview

Doppler is a secrets management platform that provides a secure way to manage environment variables and secrets across development, staging, and production environments.

In this project, Doppler is used to:
- Store API tokens and credentials
- Inject secrets into Terraform and Ansible commands
- Maintain consistent secret management across all tools

## Project Configuration

| Setting | Value |
|---------|-------|
| Project | `project-dockerlab` |
| Config | `dev` |

## Managed Secrets

The following secrets are stored in Doppler:

### Infrastructure Tokens

| Secret | Description | Used By |
|--------|-------------|---------|
| `HCLOUD_TOKEN` | Hetzner Cloud API token | Terraform |
| `PROXMOX_AUTH_TOKEN` | Proxmox VE API token | Terraform |
| `CLOUDFLARE_API_TOKEN` | Cloudflare API token | Terraform |
| `CLOUDFLARE_ACCOUNT_ID` | Cloudflare account ID | Terraform |
| `CLOUDFLARE_ZONE_ID` | Cloudflare zone ID | Terraform |

### Network Tokens

| Secret | Description | Used By |
|--------|-------------|---------|
| `TAILSCALE_AUTH_KEY` | Tailscale authentication key | Terraform, Ansible |

### Application Secrets

| Secret | Description | Used By |
|--------|-------------|---------|
| `IMMICH_DB_PASSWORD` | Immich PostgreSQL database password | Docker Stack |
| `LINKWARDEN_POSTGRES_PASSWORD` | Linkwarden PostgreSQL database password | Docker Stack |
| `LINKWARDEN_NEXTAUTH_SECRET` | Linkwarden NextAuth secret | Docker Stack |
| `LINKWARDEN_MEILI_KEY` | Linkwarden Meilisearch master key | Docker Stack |
| `GH_RUNNER_REPO_URL` | GitHub repository URL for self-hosted runner | Ansible |
| `GH_PAT_TOKEN` | GitHub Personal Access Token with `repo` scope | Ansible |

## Setup

### Install Doppler CLI

```bash
# macOS
brew install dopplerhq/cli/doppler

# Linux
curl -Ls https://cli.doppler.com/install.sh | sh
```

### Authenticate

```bash
doppler login
```

### Configure Project

```bash
doppler setup
# Select project: project-dockerlab
# Select config: dev
```

## Usage

### Running Commands with Secrets

All commands in this project use `doppler run` to inject secrets:

```bash
# Ansible commands
doppler run -- ansible-playbook site.yml

# Terraform commands
doppler run -- terraform plan
doppler run -- terraform apply
```

### Taskfile Integration

The Taskfile wraps commands with `doppler run`:

```yaml
tasks:
  site:apply:
    dir: ansible
    cmds:
      - doppler run -- ansible-playbook site.yml
```

So you can simply run:
```bash
task ansible:site:apply
```

### Viewing Secrets

```bash
# List all secrets (masked)
doppler secrets

# View a specific secret
doppler secrets get HCLOUD_TOKEN
```

### direnv Integration

The project uses `.envrc` for automatic environment setup:

```bash
# Enable direnv
direnv allow
```

This automatically loads Doppler secrets when you enter the project directory.

## Environment Configurations

Doppler supports multiple environments:

| Config | Purpose |
|--------|---------|
| `dev` | Development environment (current) |
| `stg` | Staging environment |
| `prd` | Production environment |

To switch environments:
```bash
doppler setup --config stg
```

## Adding New Secrets

### Via CLI

```bash
doppler secrets set NEW_SECRET_NAME="value"
```

### Via Web Dashboard

1. Go to [dashboard.doppler.com](https://dashboard.doppler.com)
2. Select `project-dockerlab`
3. Select the config (`dev`)
4. Click "Add Secret"

## Best Practices

1. **Never commit secrets to git** - All secrets should be in Doppler
2. **Use different configs for environments** - Separate dev/stg/prd secrets
3. **Rotate tokens regularly** - Update API tokens periodically
4. **Audit access** - Review who has access to secrets
5. **Use service tokens for CI/CD** - Don't use personal tokens in automation

## Troubleshooting

### Authentication Issues

```bash
# Re-authenticate
doppler logout
doppler login
```

### Project Not Found

```bash
# Reconfigure project
doppler setup
```

### Secrets Not Injecting

```bash
# Verify secrets are accessible
doppler secrets

# Test with a simple command
doppler run -- env | grep HCLOUD
```

## Security Considerations

- Doppler encrypts all secrets at rest and in transit
- Access is controlled through Doppler's permission system
- Secrets are never written to disk when using `doppler run`
- Audit logs track all secret access

## Integration with CI/CD

For GitHub Actions or other CI/CD:

```yaml
- name: Install Doppler CLI
  uses: dopplerhq/cli-action@v3

- name: Run with secrets
  run: doppler run -- your-command
  env:
    DOPPLER_TOKEN: ${{ secrets.DOPPLER_TOKEN }}
```

## GitHub Actions Runner Secrets

For the self-hosted GitHub Actions runner (gh-runner-1), you have two authentication options:

### Option 1: Personal Access Token (Recommended)

Use a PAT to automatically generate registration tokens. This is the **recommended approach** as PATs don't expire quickly.

| Secret | Description | How to Obtain |
|--------|-------------|---------------|
| `GITHUB_RUNNER_REPO_URL` | Full URL to your GitHub repository | Repository page |
| `GH_PAT_TOKEN` | Personal Access Token with `repo` scope | GitHub Settings → Developer settings → Tokens (classic) |

**Creating a PAT:**
1. Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Click **Generate new token (classic)**
3. Name: "Self-hosted runner management"
4. Select scope: **`repo`** (for repository runners)
5. Set expiration: 90 days or as needed
6. Generate and copy the token

**Set in Doppler:**
```bash
doppler secrets set GH_RUNNER_REPO_URL="https://github.com/yourusername/project-dockerlab"
doppler secrets set GH_PAT_TOKEN="ghp_xxxxxxxxxxxx"
```

### Deploying the Runner

After configuring secrets in Doppler:

```bash
# Run Ansible to configure the runner
task ansible:runner:apply

# Or use the full site deployment
task ansible:site:apply
```

The runner will automatically register with GitHub and appear in your repository's Actions settings.
