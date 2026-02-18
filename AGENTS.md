# AGENTS.md - Development Guide for AI Agents

This document provides guidance for AI agents working in this Docker Swarm homelab infrastructure project.

## Project Overview

This is a Docker Swarm homelab running on Proxmox VE using:
- **Terraform** - Infrastructure provisioning
- **Ansible** - Configuration management
- **Docker Swarm** - Container orchestration
- **Taskfile** - Task automation
- **Doppler** - Secrets management
- **GitHub Actions** - CI/CD pipelines

## Build/Lint/Test Commands

### Task Runner (Primary Interface)

```bash
# List all available tasks
task --list-all

# Full deployment pipeline
task deploy

# Individual components
task tf:apply      # Terraform infrastructure
task ansible:apply # Ansible configuration
task tfa:apply     # Terraform apps
```

### Pre-commit (Linting)

```bash
# Install pre-commit hooks
pre-commit install

# Run all pre-commit checks
pre-commit run --all-files --show-diff-on-failure

# Run specific hook
pre-commit run yamllint --all-files
pre-commit run actionlint-docker --all-files
pre-commit run detect-secrets --all-files
```

### Terraform

```bash
# Format and validate
task tf:fmt
task tfa:fmt

# Plan and apply
task tf:plan && task tf:apply
task tfa:plan && task tfa:apply

# Destroy
task tf:destroy
task tfa:destroy
```

### Ansible

```bash
# Dry run and apply
task ansible:plan
task ansible:apply
task ansible:init
```

### Docker Swarm

```bash
# Status
task swarm:status
task swarm:nodes
task swarm:services
task swarm:unhealthy

# Monitoring and control
task swarm:watch
task swarm:logs SERVICE=<name>
task swarm:restart SERVICE=<name>
task swarm:restart-all
```

## Code Style Guidelines

### YAML (Ansible, Docker Compose, GitHub Actions)

- Use 2-space indentation
- Maximum line length: 250 characters
- Use `|` for multiline strings
- Use document start marker `---` at file beginning
- Quote strings that look like booleans (yes/no/true/false)

```yaml
---
environment:
  - TRAEFIK_DASHBOARD_USERPASS="{{ lookup('env', 'TRAEFIK_DASHBOARD_USERPASS') }}"
  - DOMAIN=krapulax.dev
run: |
  echo "Starting service"
  ./start.sh
```

### Terraform

- Use lowercase with underscores for resource names
- Document modules with terraform-docs
- Pin provider versions
- Use local values for reusable expressions

```hcl
variable "manager_ips" {
  type        = list(string)
  description = "List of manager node IPs"
}
```

### Ansible Playbooks

- Use descriptive names for plays and tasks
- Use tags for selective execution
- Always use `become: true` when sudo needed
- Use check mode for testing (`--check`)

```yaml
- name: Configure Docker Swarm
  hosts: swarm_managers
  become: true
  roles:
    - role: docker_swarm
      tags: [swarm]
```

### GitHub Actions

- Pin action versions to specific SHAs (not @main)
- Use consistent naming: `verb-noun` for jobs
- Add `if` conditions to control when jobs run
- Store secrets in GitHub Secrets, never in workflow files

### Shell Scripts

- Use `set -euo pipefail` for error handling
- Use `#!/usr/bin/env bash` shebang
- Quote variables: `"$VAR"` not `$VAR`
- Use `[[ ]]` for conditionals (not `[ ]`)

```bash
#!/usr/bin/env bash
set -euo pipefail

if [[ -z "$VAR" ]]; then
  echo "Error: VAR is required" >&2
  exit 1
fi
```

## Naming Conventions

| Component | Convention | Example |
|-----------|------------|---------|
| Files | kebab-case | `docker-compose.yml` |
| Terraform resources | snake_case | `hcloud_volume` |
| Ansible roles | snake_case | `docker_swarm` |
| Docker services | kebab-case | `traefik-reverse-proxy` |
| GitHub Actions jobs | kebab-case | `lint-and-test` |
| Variables | snake_case | `manager_ips` |

## Secrets Management

- All secrets stored in Doppler
- Never commit secrets to git
- Use `.secrets.baseline` for detect-secrets

## Important File Locations

| Purpose | Path |
|---------|------|
| Main taskfile | `Taskfile.yml` |
| Ansible playbooks | `ansible/*.yml` |
| Ansible roles | `ansible/roles/` |
| Infrastructure Terraform | `terraform_infra/` |
| Apps Terraform | `terraform_apps/` |
| Docker stacks | `docker/*/docker-compose.yml` |
| GitHub workflows | `.github/workflows/` |
| Pre-commit config | `.pre-commit-config.yaml` |

## Common Patterns

### Adding a New Docker Stack
1. Create directory: `docker/<stack-name>/`
2. Create `docker-compose.yml`
3. Add to appropriate Terraform if managed
4. Add secrets to Doppler if needed

### Adding New Ansible Role
1. Create role in `ansible/roles/<role-name>/`
2. Add to appropriate playbook
3. Add tags for selective execution
