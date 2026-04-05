#!/usr/bin/env bash

# Add all hosts to Beszel monitoring
# Usage: ./beszel-add-hosts.sh <AGENT_KEY> [BESZEL_URL]

set -euo pipefail

AGENT_KEY="${1:-}"
BESZEL_URL="${2:-https://beszel.krapulax.net}"

if [[ -z "$AGENT_KEY" ]]; then
    echo "Error: Agent key required"
    echo "Usage: $0 <AGENT_KEY> [BESZEL_URL]"
    echo ""
    echo "Get agent key from: $BESZEL_URL/settings"
    exit 1
fi

# Host configuration: name:ip:port
hosts=(
    "dkr-srv-1:10.0.30.21:45876"
    "dkr-srv-2:10.0.30.22:45876"
    "dkr-srv-3:10.0.30.23:45876"
    "dkr-wrkr-1:10.0.30.31:45876"
    "dkr-wrkr-2:10.0.30.32:45876"
    "dkr-wrkr-3:10.0.30.33:45876"
    "gh-runner-1:10.0.30.40:45876"
    "pve-0:10.0.40.10:45876"
    "pve-1:10.0.40.11:45876"
    "pve-2:10.0.40.12:45876"
)

echo "Adding hosts to Beszel at $BESZEL_URL..."
echo ""

for host_config in "${hosts[@]}"; do
    IFS=':' read -r name ip port <<< "$host_config"

    echo "Adding $name ($ip:$port)..."

    if curl -s -X POST "$BESZEL_URL/api/v1/systems" \
        -H "Authorization: Bearer $AGENT_KEY" \
        -H "Content-Type: application/json" \
        -d "{
            \"name\": \"$name\",
            \"host\": \"$ip\",
            \"port\": $port,
            \"public_port\": $port
        }" | grep -q '"id"'; then
        echo "  ✓ Added successfully"
    else
        echo "  ✗ Failed to add"
    fi
done

echo ""
echo "Done! Check dashboard at $BESZEL_URL"
