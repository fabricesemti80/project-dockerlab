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

### Personal Access Token (Required)

| Secret | Description | Where to Get |
|--------|-------------|--------------|
| `GH_RUNNER_REPO_URL` | Full URL to the GitHub repository | Repository page |
| `GH_PAT_TOKEN` | Personal Access Token with `repo` scope | GitHub Settings → Developer settings → Personal access tokens |

**Creating a PAT:**
1. Go to GitHub → Settings → Developer settings → Personal access tokens → Tokens (classic)
2. Click **Generate new token (classic)**
3. Give it a name like "Self-hosted runner management"
4. Select scope: **`repo`** (full control of private repositories)
5. For organization runners, also select: **`admin:org`**
6. Set expiration as needed (recommend at least 90 days)
7. Generate and copy the token

**Set in Doppler:**
```bash
doppler secrets set GH_RUNNER_REPO_URL="https://github.com/yourusername/repo"
doppler secrets set GH_PAT_TOKEN="ghp_xxxxxxxxxxxx"
```

### Alternative: Organization-Level Runners

For organization-level runners, use:
- `GH_RUNNER_REPO_URL`: Organization URL (e.g., `https://github.com/my-org`)

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
