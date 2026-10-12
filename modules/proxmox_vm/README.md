# Proxmox VM Terraform Module

This module provisions and manages QEMU virtual machines on a Proxmox cluster using the [Telmate/proxmox](https://registry.terraform.io/providers/Telmate/proxmox/latest) provider.

## Features

- Creates VMs from a template with customizable resources (CPU, memory, disks, networks, etc.)
- Supports default and per-VM override configuration
- Handles disk and network device mapping dynamically
- Outputs VM ID, name, and main IPv4 address

## Usage

```hcl
module "proxmox_vm" {
  source    = "path/to/modules/proxmox_vm"
  name      = "example-vm"
  defaults  = { ... }   # See variables.tf for structure
  overrides = { ... }   # Optional, per-VM overrides
}
```

## Inputs

- `name` (string): Unique name for the VM.
- `defaults` (object): Default configuration for the VM (CPU, memory, disks, networks, etc.).
- `overrides` (object): Per-VM override configuration (optional).

See `variables.tf` for the full schema.

## Outputs

- `vm_id`: The Proxmox VM ID.
- `vm_name`: The name of the VM.
- `ip_addresses`: Main IPv4 address (if available).

## Provider

Requires the `Telmate/proxmox` provider (see `provider.tf` for version). 
## Disks are create-only (since 2026-10-12)

`lifecycle.ignore_changes` includes `disk`. The Proxmox CSI plugin hot-plugs
one disk per PersistentVolume into the k8s VMs; without the ignore, the
provider treats those disks as drift and plans to remove them, together with
the volume's data.

Consequence: changing `size` (or any other disk setting) of an existing VM in
the config no longer reaches Proxmox. To grow a disk:

1. Resize it in Proxmox (`qm resize <vmid> scsi0 <size>` or the API).
2. On the guest: rescan, `growpart`, `resize2fs`.
3. Update `size` in the config so the code still documents reality.

New VMs still get their disks from the config.
