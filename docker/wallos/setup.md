# Wallos Setup

[Wallos](https://github.com/iteam1337/Wallos) is an open-source personal subscription tracker.

## Environment Variables

| Variable | Description | Required |
|:---|:---|:---|
| `TZ` | Timezone (e.g., `Europe/London`) | Yes |
| `BASE_URL` | The URL where Wallos is accessible (e.g., `https://wallos.domain.com`) | Yes |

## Volumes

| Host Path | Container Path | Description |
|:---|:---|:---|
| `/mnt/cephfs/docker-shared-data/wallos/db` | `/var/www/html/db` | Database storage |
| `/mnt/cephfs/docker-shared-data/wallos/logos` | `/var/www/html/images/uploads/logos` | Uploaded logos |

## Deployment

1. Ensure Ansible has created the directories:
   ```bash
   task ansible:playbook
   ```

2. Deploy the stack:
   ```bash
   docker stack deploy -c docker/wallos/wallos-stack.yml wallos
   ```
