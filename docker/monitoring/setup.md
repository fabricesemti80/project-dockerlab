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

## 3. Configuration (Manual)
Since auto-provisioning can be finicky in Swarm, follow these steps to set up your dashboards:

- **Access:** `https://grafana.yourdomain.com`
- **Login:** User `admin`, Password (what you set above).

- **Data Source Setup:**
    1. Go to **Connections** > **Data Sources** > **Add data source**.
    2. Select **Prometheus**.
    3. URL: `http://prometheus:9090`
    4. Click **Save & Test**.

- **Import Dashboards:**
    1. Go to **Dashboards** > **New** > **Import**.
    2. To monitor **Nodes (Host)**: Enter ID `1860` and click **Load**.
    3. To monitor **Containers (cAdvisor)**: Enter ID `14282` and click **Load**.
    4. Select the **Prometheus** data source created in the previous step and click **Import**.

## 4. Notes
- `node-exporter` and `cadvisor` run in `global` mode to cover the entire cluster.
- Prometheus configuration uses DNS Service Discovery (`tasks.node-exporter`) to automatically find new nodes.