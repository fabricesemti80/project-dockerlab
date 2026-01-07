#!/bin/bash
export DOMAIN=krapulax.dev
export TZ=Europe/London
export DISCORD_WATCHTOWER_WEBHOOK=https://discord.com/api/webhooks/1103950255784988724/L1795lab5NlGD7XzMpbcSBrtMXOjvtaooA5rDkuIxRyiQHhigPuWDujH6xOrM85Itqvb/slack

# Deploy Maintenance
docker stack deploy -c /tmp/maintenance-stack.yml maintenance

# Deploy Gatus
docker stack deploy -c /tmp/gatus-stack.yml gatus
