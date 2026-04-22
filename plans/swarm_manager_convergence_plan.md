# Swarm Manager Convergence Plan

## Goal

Converge the current Docker Swarm workloads onto the three manager VMs so the three worker VMs can eventually be removed and their Proxmox capacity reused for a three-node Talos/Kubernetes cluster.

## Assumptions

- The target Swarm manager set is `dkr-srv-1`, `dkr-srv-2`, and `dkr-srv-3`.
- Each manager should have 12 GiB dedicated memory.
- Worker VMs remain at their current size until services are drained and the VMs are removed.
- Stateful app data remains available from shared CephFS/NFS mounts on the manager nodes.

## Current Terraform Change

- Set Docker Swarm managers to `12288` MB dedicated memory.
- Leave Docker workers on the shared `8192` MB default.
- Leave the GitHub runner at `2048` MB.

## Validation

- Run Terraform formatting and validation.
- Run a Terraform plan and confirm only `dkr-srv-1`, `dkr-srv-2`, and `dkr-srv-3` memory change.
- Apply one maintenance window at a time if Proxmox requires VM restarts for memory changes.
- After apply, confirm each manager reports approximately 12 GiB RAM from the guest OS.

## Rollback

- Restore manager memory to the shared default by pointing the manager modules back to `local.vm_common.memory_dedicated`.
- Re-run Terraform plan/apply.
- If a guest fails after resizing, revert the Proxmox VM memory to 8 GiB from Terraform and restart the VM.
