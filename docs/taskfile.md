# Taskfile Documentation

This document explains the Task runner configuration used in project-dockerlab.

## Overview

[Task](https://taskfile.dev) is a task runner/build tool that serves as a simpler alternative to Make. It uses YAML for configuration and provides a clean interface for running common commands.

## Configuration

The main Taskfile is at the project root with task definitions split into:

```
Taskfile.yml           # Main entry point
taskfile/
├── ansible.yml       # Ansible-related tasks
└── terraform.yml     # Terraform-related tasks
```

## Global Variables

```yaml
vars:
  DOPPLER_PROJECT: "project-dockerlab"
  DOPPLER_CONFIG: "dev"
```

## Available Commands

### List All Tasks

```bash
task              # or
task --list-all
```

### Terraform Tasks

| Command | Description |
|---------|-------------|
| `task tf:init` | Initialize Terraform |
| `task tf:fmt` | Format and validate Terraform files |
| `task tf:plan` | Create execution plan |
| `task tf:apply` | Apply the plan |
| `task tf:destroy` | Destroy all infrastructure |

### Ansible Tasks

| Command | Description |
|---------|-------------|
| `task ansible:init` | Install Galaxy roles and collections |
| `task ansible:site:apply` | Apply entire site configuration |
| `task ansible:site:plan` | Dry-run entire site |
| `task ansible:template:apply` | Create Proxmox templates |
| `task ansible:template:plan` | Dry-run template creation |
| `task ansible:vm:apply` | Deploy Proxmox VMs |
| `task ansible:vm:plan` | Dry-run VM deployment |
| `task ansible:preflight:apply` | Run preflight checks |
| `task ansible:preflight:plan` | Dry-run preflight |
| `task ansible:base:apply` | Apply base configuration |
| `task ansible:base:plan` | Dry-run base configuration |
| `task ansible:tailscale:apply` | Configure Tailscale |
| `task ansible:tailscale:plan` | Dry-run Tailscale setup |
| `task ansible:docker:apply` | Install Docker |
| `task ansible:docker:plan` | Dry-run Docker installation |

## Task Definitions

### Terraform Tasks (taskfile/terraform.yml)

```yaml
tasks:
  fmt:
    desc: "Format and validate Terraform"
    dir: terraform
    cmds:
      - terraform fmt
      - terraform validate

  init:
    desc: "Initialize Terraform"
    dir: terraform
    cmds:
      - terraform init {{.CLI_ARGS}}

  plan:
    desc: "Create execution plan"
    dir: terraform
    cmds:
      - task: fmt
      - terraform plan -out=tfplan

  apply:
    desc: "Apply the plan"
    dir: terraform
    cmds:
      - task: plan
      - terraform apply tfplan

  destroy:
    desc: "Destroy infrastructure"
    dir: terraform
    cmds:
      - terraform destroy -auto-approve
```

### Ansible Tasks (taskfile/ansible.yml)

```yaml
tasks:
  init:
    desc: "Install Galaxy roles and collections"
    dir: ansible
    cmds:
      - doppler run -- ansible-galaxy install -r requirements.yml
      - doppler run -- ansible-galaxy collection install -r requirements.yml

  site:apply:
    desc: "Apply entire site configuration"
    dir: ansible
    cmds:
      - doppler run -- ansible-playbook site.yml

  site:plan:
    desc: "Dry-run entire site"
    dir: ansible
    cmds:
      - doppler run -- ansible-playbook site.yml --check --diff
```

## Usage Patterns

### Typical Deployment Workflow

```bash
# 1. Initialize dependencies
task ansible:init
task tf:init

# 2. Deploy infrastructure
task tf:apply

# 3. Configure systems
task ansible:site:apply
```

### Safe Deployment (with preview)

```bash
# Preview changes first
task tf:plan
task ansible:site:plan

# Then apply
task tf:apply
task ansible:site:apply
```

### Incremental Configuration

```bash
# Run only specific stages
task ansible:preflight:apply
task ansible:base:apply
task ansible:tailscale:apply
task ansible:docker:apply
```

## Passing Arguments

Use `--` to pass additional arguments:

```bash
# Pass arguments to terraform init
task tf:init -- -upgrade

# Run ansible with verbose output
task ansible:site:apply -- -vvv
```

## Benefits of Using Task

1. **Consistent commands** - Same interface across all tools
2. **Documentation** - Each task has a description
3. **Composition** - Tasks can call other tasks
4. **Doppler integration** - Secrets automatically injected
5. **Directory management** - Tasks run in correct directories

## Installation

```bash
# macOS
brew install go-task

# Linux
sh -c "$(curl --location https://taskfile.dev/install.sh)" -- -d

# Or via go
go install github.com/go-task/task/v3/cmd/task@latest
```

## Troubleshooting

### Task Not Found

```bash
# Ensure task is in PATH
which task

# Or use full path
/usr/local/bin/task --list-all
```

### Doppler Not Authenticated

```bash
doppler login
doppler setup
```

### Viewing Task Details

```bash
# Show task details
task --summary ansible:site:apply
```
