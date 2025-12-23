# Monitoring Setup (Prometheus & Grafana)

This stack deploys a complete monitoring solution for Docker Swarm.

## 1. Components
- **Grafana:** Visualization Dashboard (`grafana.yourdomain.com`).
- **Prometheus:** Metrics database.
- **Node Exporter:** Collects Host metrics (CPU, RAM, Disk) from *every* node.
- **cAdvisor:** Collects Container metrics from *every* node.

## 2. Deployment
1.  Create a new Stack in Portainer pointing to `docker/monitoring`.
2.  **Environment Variables:**
    - `DOMAIN`: Your domain (e.g. `krapulax.dev`).
    - `GF_SECURITY_ADMIN_PASSWORD`: Set a secure password for the `admin` user.
3.  Deploy.

## 3. Configuration
- **Access:** `https://grafana.yourdomain.com`
- **Login:** User `admin`, Password (what you set above).
- **Auto-Provisioning:** 
    - Datasources and Dashboards are automatically provisioned using **Docker Configs**.
    - No manual import required.

## 4. Notes
- `node-exporter` and `cadvisor` run in `global` mode to cover the entire cluster.
- Prometheus configuration uses DNS Service Discovery (`tasks.node-exporter`) to automatically find new nodes.
