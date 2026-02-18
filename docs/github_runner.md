# GitHub Actions Self-Hosted Runner

This guide covers the setup and usage of the self-hosted GitHub Actions runner (`gh-runner-1`) for the project-dockerlab repository.

## Overview

The self-hosted runner provides a dedicated CI/CD environment running on your homelab infrastructure. This allows you to:

- Run workflows with access to internal network resources
- Use custom hardware/configurations not available in GitHub-hosted runners
- Keep sensitive operations within your infrastructure
- Reduce GitHub Actions minutes usage

## Architecture

```
GitHub Actions Workflow
        ↓
GitHub API (triggers job)
        ↓
Self-Hosted Runner (gh-runner-1 @ 10.0.30.40)
        ↓
Runs on: Debian 13 with Docker
```

## Runner Specifications

| Property | Value |
|----------|-------|
| **Hostname** | gh-runner-1 |
| **IP Address** | 10.0.30.40 |
| **OS** | Debian 13 (trixie) |
| **Architecture** | x86_64 |
| **Labels** | `self-hosted`, `linux`, `x64`, `homelab` |
| **Location** | Proxmox VM on local network |

## Authentication

The runner uses a **GitHub Personal Access Token (PAT)** for automatic registration token generation:

### Required PAT Scopes

- `repo` - Full control of private repositories

### Creating a PAT

1. Go to [GitHub Settings → Developer settings → Personal access tokens → Tokens (classic)](https://github.com/settings/tokens)
2. Click **"Generate new token (classic)"**
3. Configure:
   - **Note**: `Self-hosted runner management`
   - **Expiration**: 90 days (or as preferred)
   - **Scopes**: Check `repo`
4. Generate and copy the token (starts with `ghp_`)

### Setting up Doppler Secrets

```bash
# Set the repository URL
doppler secrets set GITHUB_RUNNER_REPO_URL="https://github.com/fabricesemti80/project-dockerlab"

# Set the PAT token
doppler secrets set GITHUB_PAT_TOKEN="ghp_YOUR_TOKEN_HERE"
```

## Deployment

### Initial Setup

Deploy the runner using Ansible:

```bash
# Install/update the runner on gh-runner-1
task ansible:runner:apply
```

This will:
- Create the `github-runner` user
- Install Docker and dependencies
- Download and configure the GitHub Actions runner
- Register with GitHub using your PAT
- Start the runner service

### Force Reconfiguration

If you need to re-register the runner (e.g., token expired):

```bash
task ansible:runner:reconfigure
```

### Verification

Check runner status in GitHub:
1. Go to [Repository Settings → Actions → Runners](https://github.com/fabricesemti80/project-dockerlab/settings/actions/runners)
2. Verify `gh-runner-1` shows as **Idle** (green dot)

Or via API:
```bash
curl -H "Authorization: token $GITHUB_PAT_TOKEN" \
  https://api.github.com/repos/fabricesemti80/project-dockerlab/actions/runners
```

## Usage in Workflows

To use the self-hosted runner in your workflows:

```yaml
jobs:
  my-job:
    runs-on: [self-hosted, homelab]
    steps:
      - uses: actions/checkout@v4
      - name: Run on homelab
        run: echo "Running on gh-runner-1!"
```

### Available Labels

Use any of these label combinations:

| Labels | Description |
|--------|-------------|
| `[self-hosted]` | Any self-hosted runner |
| `[self-hosted, linux]` | Linux self-hosted runners |
| `[self-hosted, homelab]` | **Recommended** - Your specific runner |
| `[self-hosted, linux, x64]` | Linux x86_64 runners |

## Current Workflows Using Self-Hosted Runner

### Lint and Test Workflow

The main CI workflow (`.github/workflows/deploy.yml`) uses the self-hosted runner for:

- **Linting**: yamllint, actionlint, detect-secrets
- **Pre-commit hooks**: trailing whitespace, end-of-file fixes
- **Testing**: Validation of Ansible playbooks and Terraform configs

```yaml
lint-and-test:
  runs-on: [self-hosted, homelab]
  steps:
    - uses: actions/checkout@v4
    - name: Install uv and pre-commit
      run: |
        sudo apt-get update
        sudo apt-get install -y python3
        curl -LsSf https://astral.sh/uv/install.sh | sh
        . "$HOME/.local/bin/env"
        uv tool install --force pre-commit
        echo "$HOME/.local/bin" >> "$GITHUB_PATH"
    # ... more steps
```

## Troubleshooting

### Runner Not Appearing in GitHub

1. Check PAT token hasn't expired
2. Verify token has `repo` scope
3. Check runner service status:
   ```bash
   ssh fs@10.0.30.40
   sudo systemctl status actions.runner.fabricesemti80-project-dockerlab.gh-runner-1.service
   ```

### Permission Denied Errors

The runner user has passwordless sudo configured. If sudo prompts for password:

```bash
# Re-run Ansible to fix permissions
task ansible:runner:apply
```

### Service Won't Start

Check logs:
```bash
ssh fs@10.0.30.40
sudo journalctl -u actions.runner.fabricesemti80-project-dockerlab.gh-runner-1.service -f
```

### Manual Cleanup (if needed)

If you need to completely reset the runner:

```bash
ssh fs@10.0.30.40
sudo systemctl stop actions.runner.*
sudo rm -rf /opt/github-runner
sudo rm -f /etc/systemd/system/actions.runner.*
sudo userdel github-runner
sudo systemctl daemon-reload
```

Then re-run:
```bash
task ansible:runner:apply
```

## Security Considerations

- **PAT Token**: Stored in Doppler, rotated every 90 days recommended
- **Runner Permissions**: Has passwordless sudo and Docker access
- **Network Access**: Can access internal resources (10.0.30.0/24 network)
- **Workflow Isolation**: Each job runs in a fresh workspace

## Maintenance

### Updating the Runner

The runner version is defined in:
```yaml
# ansible/roles/github_runner/defaults/main.yml
github_runner_version: "2.331.0"
```

To update:
1. Check latest version at https://github.com/actions/runner/releases
2. Update the version in defaults
3. Run `task ansible:runner:reconfigure`

### Monitoring

Check runner activity:
```bash
# View recent runs
ssh fs@10.0.30.40
sudo journalctl -u actions.runner.* --since "1 hour ago"

# Check disk space (workflows can use significant space)
df -h
```

## Related Documentation

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Self-hosted Runner Security](https://docs.github.com/en/actions/security-guides/security-hardening-for-github-actions#hardening-for-self-hosted-runners)
- [Doppler Secrets Management](./doppler.md)

## Files

- **Ansible Role**: `ansible/roles/github_runner/`
- **Playbook**: `ansible/github_runner.yml`
- **Workflow**: `.github/workflows/deploy.yml`
- **Taskfile**: `taskfile/ansible.yml` (runner tasks)

---

*Last updated: 2026-02-18*
