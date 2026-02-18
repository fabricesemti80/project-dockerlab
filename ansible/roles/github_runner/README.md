# GitHub Actions Runner Role

This Ansible role installs and configures a self-hosted GitHub Actions runner.

## Overview

The role performs the following actions:
1. Creates a dedicated user for the runner
2. Downloads and extracts the GitHub Actions runner
3. Installs required dependencies
4. Configures the runner with the repository and token
5. Sets up the runner as a systemd service
6. Starts and enables the service

## Requirements

- GitHub repository with Actions enabled
- Registration token from GitHub

## Required Doppler Secrets

Add these secrets to your Doppler project:

| Secret | Description | Where to Get |
|--------|-------------|--------------|
| `GITHUB_RUNNER_REPO_URL` | Full URL to the GitHub repository | Repository page (e.g., `https://github.com/username/repo`) |
| `GITHUB_RUNNER_TOKEN` | Registration token for the runner | GitHub Repository → Settings → Actions → Runners → New self-hosted runner |

### Getting the GitHub Runner Token

1. Go to your GitHub repository
2. Navigate to **Settings** → **Actions** → **Runners**
3. Click **New self-hosted runner**
4. Select **Linux** and architecture **x64**
5. Copy the token from the "Configure" section (looks like `AADZ3W3J7D2L4EXAMPLE`)

**IMPORTANT**: The token expires after approximately **1 hour**. You must run Ansible within this window:

```bash
# Set the token in Doppler first
doppler secrets set GITHUB_RUNNER_TOKEN="YOUR_TOKEN_HERE"

# Run Ansible immediately while token is still valid
task ansible:site:apply
```

### Alternative: Organization-Level Runners

For organization-level runners, use:
- `GITHUB_RUNNER_REPO_URL`: Organization URL (e.g., `https://github.com/my-org`)
- Token from: Organization Settings → Actions → Runners

## Role Variables

See `defaults/main.yml` for default values:

| Variable | Default | Description |
|----------|---------|-------------|
| `github_runner_version` | "2.322.0" | Runner version to install |
| `github_runner_dir` | "/opt/github-runner" | Installation directory |
| `github_runner_user` | "github-runner" | User to run the runner |
| `github_runner_name` | Hostname | Name shown in GitHub Actions |
| `github_runner_labels` | ["self-hosted", "linux", "x64", "homelab"] | Runner labels |

## Usage

```yaml
- hosts: github_runners
  become: yes
  roles:
    - role: github_runner
      tags: [github_runner]
```

## After Installation

Once the runner is registered:
1. Check the runner status in GitHub: Repository → Settings → Actions → Runners
2. The runner should appear as "Idle" when ready
3. Update your workflow files to use the runner:

```yaml
jobs:
  build:
    runs-on: [self-hosted, homelab]
    steps:
      - uses: actions/checkout@v4
      # ... your steps
```

## Troubleshooting

### Runner not appearing in GitHub
- Check that the token hasn't expired (tokens expire after ~1 hour)
- Verify the repository URL is correct
- Check logs: `journalctl -u actions.runner.* -f`

### Service not starting
- Check service status: `systemctl status actions.runner.*`
- Verify permissions in `/opt/github-runner`
- Ensure the user has proper shell access

### Re-registering a runner
Set `github_runner_force_reconfigure: true` to force reconfiguration.

## Security Notes

- The runner token is sensitive - never commit it to version control
- The runner has access to repository secrets during workflow execution
- Consider using branch protection rules for workflows that run on self-hosted runners
