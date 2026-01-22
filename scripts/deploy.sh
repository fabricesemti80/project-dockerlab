#!/bin/bash

# Deployment pipeline script
# Runs the three stages sequentially with error checking

set -e  # Exit on any error

# Colors for terminal output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
RESET='\033[0m'

# Function to print a visual separator
print_separator() {
    echo -e "${CYAN}════════════════════════════════════════════════════════════${RESET}"
}

# Function to print a stage header
print_stage_header() {
    local stage_num=$1
    local stage_name=$2
    local icon=$3
    print_separator
    echo -e "${BOLD}${BLUE}  $icon  STAGE $stage_num: $stage_name${RESET}"
    print_separator
}

# Function to print success message
print_success() {
    echo -e "${GREEN}✓ $1${RESET}"
}

# Function to print error message
print_error() {
    echo -e "${RED}✗ $1${RESET}"
}

echo ""
echo -e "${BOLD}${CYAN}🚀 STARTING DEPLOYMENT PIPELINE${RESET}"
echo ""

# Stage 1: Terraform Infrastructure Provisioning
print_stage_header "1" "TERRAFORM INFRASTRUCTURE" "📦"
echo "Provisioning infrastructure with Terraform..."
echo ""
if task tf:apply; then
    echo ""
    print_success "Infrastructure provisioning completed successfully."
else
    echo ""
    print_error "Infrastructure provisioning failed. Aborting deployment."
    exit 1
fi
echo ""

# Stage 2: Ansible Configuration
print_stage_header "2" "ANSIBLE CONFIGURATION" "🔧"
echo "Configuring systems with Ansible..."
echo ""
if task ansible:apply; then
    echo ""
    print_success "System configuration completed successfully."
else
    echo ""
    print_error "System configuration failed. Aborting deployment."
    exit 1
fi
echo ""

# Stage 3: Terraform App Deployment
print_stage_header "3" "TERRAFORM APP DEPLOYMENT" "🐳"
echo "Deploying applications with Terraform..."
echo ""
if task tfa:apply; then
    echo ""
    print_success "Application deployment completed successfully."
else
    echo ""
    print_error "Application deployment failed. Aborting deployment."
    exit 1
fi
echo ""

echo -e "${BOLD}${GREEN}"
echo "╔════════════════════════════════════════════════════════════╗"
echo "║                                                            ║"
echo "║        🎉 DEPLOYMENT PIPELINE COMPLETED! 🎉                ║"
echo "║                                                            ║"
echo "╚════════════════════════════════════════════════════════════╝"
echo -e "${RESET}"
