# Setting up GitOps Deployment in Portainer Business Edition from a Private Repository using a Personal Access Token (PAT)

This document outlines the steps to configure GitOps deployment in Portainer Business Edition using a private Git repository. This setup allows for automated deployments whenever changes are pushed to the repository. This method uses a Personal Access Token (PAT) for authentication, which is generally simpler to configure than SSH keys.

## Prerequisites

*   Portainer Business Edition instance
*   Private Git repository (e.g., GitHub, GitLab, Bitbucket)
*   Docker Swarm cluster managed by Portainer

## Steps

### 1. Generate a Personal Access Token (PAT)

Generate a PAT with the necessary permissions to access your private Git repository.

*   **GitHub:** Go to your "Settings" > "Developer settings" > "Personal access tokens" > "Generate new token". Grant the `repo` scope (or more specific scopes if possible).
*   **GitLab:** Go to your "Settings" > "Access Tokens". Create a new token and grant the `read_repository` scope (or more specific scopes if possible).
*   **Bitbucket:** Go to your "Settings" > "Personal access tokens" > "Create token". Grant the `repository:read` permission (or more specific scopes if possible).

### 2. Create a New Stack in Portainer

In the Portainer UI, navigate to "Stacks" and click "Add stack". Choose the "Git repository" deployment method.

### 3. Configure the Stack

*   **Name:** Give your stack a descriptive name.
*   **Repository URL:** Enter the HTTPS URL of your Git repository. For example: `https://github.com/<username>/<repository>.git`
*   **Branch:** Specify the branch to deploy from (e.g., `main` or `master`).
*   **Authentication:** Choose "Username and password".
*   **Username:** Enter your Git repository username.
*   **Password or Personal Access Token:** Paste the PAT you generated in Step 1 into this field.
*   **Compose path:** Specify the path to your `docker-compose.yml` file within the repository.
*   **Auto update:** Configure the auto-update settings as desired. You can set an interval to automatically redeploy the stack whenever changes are pushed to the repository.

### 4. Deploy the Stack

Click the "Deploy stack" button to deploy your application. Portainer will use the PAT to authenticate with the Git repository, retrieve the `docker-compose.yml` file, and deploy the stack to your Docker Swarm cluster.

## Verifying the Deployment

*   Check the stack's logs in Portainer for any errors.
*   Verify that the services are running correctly in your Docker Swarm cluster.
*   Access your application through the exposed ports.

## Troubleshooting

*   **Authentication errors:** Ensure that the username and PAT are correctly entered into Portainer and that the PAT has the necessary permissions to access the repository.
*   **Deployment failures:** Check the stack's logs for any errors related to the `docker-compose.yml` file or the Docker Swarm cluster.
*   **Auto-update issues:** Verify that the auto-update settings are correctly configured and that Portainer has the necessary permissions to access the Git repository.
*   **Accessibility Issues:** If the application is not accessible on all instances on port 8080, consider the following:
    *   **Firewall:** **Ensure that port 8080 is open on all swarm nodes. Check the firewall rules on each node to verify that incoming traffic on port 8080 is allowed.**
    *   **Swarm Configuration:** Verify that the swarm is configured correctly and that the routing mesh is functioning as expected.
    *   **DNS:** Check that DNS resolution is correctly pointing to all swarm nodes.
    *   **Node Failure:** Check if one or more manager nodes may be failing.
	*   **Service Status:** Verify that the service is running correctly on all nodes by running `docker service ps <service_name>` and ensuring that all replicas are in the `Running` state.

This setup provides a streamlined GitOps workflow for deploying applications to Docker Swarm using Portainer Business Edition.

## Traefik and Homepage Deployment

This section describes how to deploy Traefik and Homepage using Docker Swarm, Traefik for automatic Let's Encrypt certificate management via Cloudflare, and Homepage as the first application to be made available.

### Prerequisites

*   Docker Swarm cluster
*   Cloudflare account
*   A domain name managed by Cloudflare

### Steps

1.  **Create `.envrc` file:**

    Create a `.envrc` file in the `docker/base-apps` directory with the following environment variables:

    ```
    EMAIL=your_email@example.com # Email for Let's Encrypt
    DOMAIN_EXTERNAL=krapulax.dev # External domain name
    DOMAIN_INTERNAL=krapulax.home # Internal domain name
    CF_API_EMAIL=your_cloudflare_email@example.com # Cloudflare API email
    CF_API_KEY=your_cloudflare_api_key # Cloudflare API key
    HOMEPAGE_ALLOWED_HOSTS= # Allowed hosts for Homepage (comma-separated list)
    ```

2.  **Deploy the stack:**

    Navigate to the `docker/base-apps` directory and deploy the stack using Docker Compose:

    ```
    docker stack deploy -c docker-compose.yml traefik-homepage
    ```

3.  **Access Homepage:**

    Once the stack is deployed, access Homepage using the internal domain (`DOMAIN_INTERNAL`) in your browser. Traefik will automatically obtain a Let's Encrypt certificate for the external domain (`DOMAIN_EXTERNAL`) and redirect traffic to the Homepage service.

### Verification

*   Verify that the Traefik and Homepage services are running correctly in the Docker Swarm cluster.
*   Access Homepage using the internal domain in your browser.
*  Check the traefik logs to see if the certs are ok
=======
This setup provides a streamlined GitOps workflow for deploying applications to Docker Swarm using Portainer Business Edition.

## Traefik and Homepage Deployment

This section describes how to deploy Traefik and Homepage using Docker Swarm, Traefik for automatic Let's Encrypt certificate management via Cloudflare, and Homepage as the first application to be made available.

### Prerequisites

*   Docker Swarm cluster
*   Cloudflare account
*   A domain name managed by Cloudflare

### Steps

1.  **Create `.envrc` file:**

    Create a `.envrc` file in the `docker/base-apps` directory with the following environment variables:

    ```
    EMAIL=your_email@example.com # Email for Let's Encrypt
    DOMAIN_EXTERNAL=krapulax.dev # External domain name
    DOMAIN_INTERNAL=krapulax.home # Internal domain name
    CF_API_EMAIL=your_cloudflare_email@example.com # Cloudflare API email
    CF_API_KEY=your_cloudflare_api_key # Cloudflare API key
    ```

2.  **Deploy the stack:**

    Navigate to the `docker/base-apps` directory and deploy the stack using Docker Compose:

    ```
    docker stack deploy -c docker-compose.yml traefik-homepage
    ```

3.  **Access Homepage:**

    Once the stack is deployed, access Homepage using the internal domain (`DOMAIN_INTERNAL`) in your browser. Traefik will automatically obtain a Let's Encrypt certificate for the external domain (`DOMAIN_EXTERNAL`) and redirect traffic to the Homepage service.

### Verification

*   Verify that the Traefik and Homepage services are running correctly in the Docker Swarm cluster.
*   Access Homepage using the internal domain in your browser.
*  Check the traefik logs to see if the certs are ok
