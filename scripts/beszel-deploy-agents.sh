#!/usr/bin/env bash

# Deploy Beszel agents to all hosts via SSH
# Requires SSH key at ~/.ssh/fs_home_rsa

set -euo pipefail

SSH_KEY="${SSH_KEY:-$HOME/.ssh/fs_home_rsa}"
SSH_USER="${SSH_USER:-fs}"

# Host configuration: name:ip
hosts=(
    "dkr-srv-1:10.0.30.21"
    "dkr-srv-2:10.0.30.22"
    "dkr-srv-3:10.0.30.23"
    "dkr-wrkr-1:10.0.30.31"
    "dkr-wrkr-2:10.0.30.32"
    "dkr-wrkr-3:10.0.30.33"
    "gh-runner-1:10.0.30.40"
    "pve-0:10.0.40.10"
    "pve-1:10.0.40.11"
    "pve-2:10.0.40.12"
)

echo "Checking Beszel agents on all hosts..."
echo ""

for host_config in "${hosts[@]}"; do
    IFS=':' read -r name ip <<< "$host_config"

    echo "Checking $name ($ip)..."

    if ssh -i "$SSH_KEY" -o StrictHostKeyChecking=no -o ConnectTimeout=5 "$SSH_USER@$ip" \
        "docker ps --format='table {{.Names}}' 2>/dev/null | grep -q beszel" 2>/dev/null; then
        echo "  ✓ Agent running"
    else
        echo "  ✗ Agent not found - needs deployment"
        echo "    Run: ansible-playbook with beszel role"
    fi
done

echo ""
echo "Note: Deploy agents via: task ansible:apply (with beszel-agent enabled)"
echo ""
echo "Once agents are running, access Beszel UI to add systems:"
echo "https://beszel.krapulax.net/settings"
