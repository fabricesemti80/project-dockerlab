#!/usr/bin/env bash

# Add hosts directly to Beszel SQLite database via SSH
# No API key needed - modifies data.db directly

set -euo pipefail

MANAGER_IP="10.0.30.21"
SSH_USER="fs"
SSH_KEY="$HOME/.ssh/fs_home_rsa"
DATA_DIR="/mnt/cephfs/docker-shared-data/beszel/data"
DB_FILE="$DATA_DIR/data.db"
TEMP_DB="/tmp/beszel_hosts_$$.db"

# Host configuration: name:ip:port
hosts=(
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

echo "Adding hosts to Beszel database..."
echo ""

# Build SQL INSERT statements
SQL_FILE="/tmp/beszel_insert_$$.sql"
cat > "$SQL_FILE" <<'EOF'
BEGIN TRANSACTION;
EOF

for host_config in "${hosts[@]}"; do
    IFS=':' read -r name ip port <<< "$host_config"

    # Create deterministic UUID based on hostname
    uuid=$(echo -n "$name" | md5sum | awk '{print substr($1,1,8)"-"substr($1,9,4)"-"substr($1,13,4)"-"substr($1,17,4)"-"substr($1,21)}')

    echo "  Adding $name ($ip:$port)..."

    cat >> "$SQL_FILE" <<EOF
INSERT OR IGNORE INTO systems (id, name, host, port, status, created, updated)
VALUES ('$uuid', '$name', '$ip', '$port', 'connected', datetime('now'), datetime('now'));
EOF
done

cat >> "$SQL_FILE" <<'EOF'
COMMIT;
EOF

# Download DB, apply changes, upload back
echo "Downloading database..."
ssh -o StrictHostKeyChecking=no -i "$SSH_KEY" "$SSH_USER@$MANAGER_IP" "sudo cat $DB_FILE" > "$TEMP_DB"

echo "Applying changes..."
sqlite3 "$TEMP_DB" < "$SQL_FILE"

echo "Uploading updated database..."
cat "$TEMP_DB" | ssh -o StrictHostKeyChecking=no -i "$SSH_KEY" "$SSH_USER@$MANAGER_IP" "sudo tee $DB_FILE > /dev/null"

# Cleanup
rm -f "$TEMP_DB" "$SQL_FILE"

echo ""
echo "✓ All hosts added successfully!"
echo "Note: Beszel hub may need restart for changes to appear."
echo "      Run: task swarm:restart SERVICE=beszel_hub"
