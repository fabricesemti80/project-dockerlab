#!/bin/bash

# Deployment pipeline script
# Runs the three stages sequentially with error checking

set -e  # Exit on any error

echo "🚀 Starting full deployment pipeline..."

# Stage 1: Terraform Infrastructure Provisioning
echo "📦 Stage 1: Provisioning infrastructure with Terraform..."
if task tf:apply; then
    echo "✅ Infrastructure provisioning completed successfully."
else
    echo "❌ Infrastructure provisioning failed. Aborting deployment."
    exit 1
fi

# Stage 2: Ansible Configuration
echo "🔧 Stage 2: Configuring systems with Ansible..."
if task ansible:apply; then
    echo "✅ System configuration completed successfully."
else
    echo "❌ System configuration failed. Aborting deployment."
    exit 1
fi

# Stage 3: Terraform App Deployment
echo "🐳 Stage 3: Deploying applications with Terraform..."
if task tfa:apply; then
    echo "✅ Application deployment completed successfully."
else
    echo "❌ Application deployment failed. Aborting deployment."
    exit 1
fi

echo "🎉 Full deployment pipeline completed successfully!"