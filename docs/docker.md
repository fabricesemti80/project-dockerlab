# Setting up GitOps Deployment in Portainer Business Edition from a Private Repository

This document outlines the steps to configure GitOps deployment in Portainer Business Edition using a private Git repository. This setup allows for automated deployments whenever changes are pushed to the repository.

## Prerequisites

*   Portainer Business Edition instance
*   Private Git repository (e.g., GitHub, GitLab, Bitbucket)
*   Docker Swarm cluster managed by Portainer

## Steps

### 1. Generate an SSH Key Pair

First, generate an SSH key pair that Portainer will use to authenticate with the private Git repository.

```bash
ssh-keygen -t rsa -b 4096 -N "" -f portainer_deploy_key
```

This command creates two files: `portainer_deploy_key` (private key) and `portainer_deploy_key.pub` (public key).

### 2. Add the Public Key to Your Git Repository

Add the contents of `portainer_deploy_key.pub` to your Git repository as a deploy key.

*   **GitHub:** Go to your repository's "Settings" tab, then "Deploy keys". Add a new deploy key, paste the contents of `portainer_deploy_key.pub`, and grant write access.
*   **GitLab:** Go to your repository's "Settings" > "Repository" > "Deploy keys". Add a new deploy key, paste the contents of `portainer_deploy_key.pub`, and grant write access.
*   **Bitbucket:** Go to your repository's "Settings" > "Deploy keys". Add a new key and paste the contents of `portainer_deploy_key.pub`.

### 3. Create a New Stack in Portainer

In the Portainer UI, navigate to "Stacks" and click "Add stack". Choose the "Git repository" deployment method.

### 4. Configure the Stack

*   **Name:** Give your stack a descriptive name.
*   **Repository URL:** Enter the SSH URL of your Git repository. For example: `git@github.com:<username>/<repository>.git`
*   **Branch:** Specify the branch to deploy from (e.g., `main` or `master`).
*   **Use SSH key:** Enable this option.
*   **SSH Private Key:** Paste the contents of the `portainer_deploy_key` file (the private key) into this field.
*   **Compose path:** Specify the path to your `docker-compose.yml` file within the repository.
*   **Auto update:** Configure the auto-update settings as desired. You can set an interval to automatically redeploy the stack whenever changes are pushed to the repository.

### 5. Deploy the Stack

Click the "Deploy stack" button to deploy your application. Portainer will use the SSH key to authenticate with the Git repository, retrieve the `docker-compose.yml` file, and deploy the stack to your Docker Swarm cluster.

## Verifying the Deployment

*   Check the stack's logs in Portainer for any errors.
*   Verify that the services are running correctly in your Docker Swarm cluster.
*   Access your application through the exposed ports.

## Troubleshooting

*   **Authentication errors:** Ensure that the SSH private key is correctly pasted into Portainer and that the corresponding public key has been added to your Git repository with write access.
*   **Deployment failures:** Check the stack's logs for any errors related to the `docker-compose.yml` file or the Docker Swarm cluster.
*   **Auto-update issues:** Verify that the auto-update settings are correctly configured and that Portainer has the necessary permissions to access the Git repository.

This setup provides a streamlined GitOps workflow for deploying applications to Docker Swarm using Portainer Business Edition.