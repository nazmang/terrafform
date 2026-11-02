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
## Disks: managed, except on CSI nodes (since 2026-11-02)

Two resources, selected by `csi_hotplug_disks`:

- `proxmox_vm_qemu.this[0]` (default) -- disks are managed: adding a slot or
  growing `size` in the config is applied to the VM. Growing still needs
  `growpart` + `resize2fs` in the guest.
- `proxmox_vm_qemu.csi[0]` (`csi_hotplug_disks = true`, the k8s nodes) --
  `lifecycle.ignore_changes = all`: create-only. The Proxmox CSI plugin
  hot-plugs one disk per PersistentVolume. Ignoring only `disk` (2026-10-12)
  was not enough: on 2026-11-02 an in-place update of `ciupgrade` made the
  provider rewrite the VM config and detach the PVC disks (Vault went down).
  Change running k8s nodes in Proxmox directly, or drain the node first.

A lifecycle block cannot be conditional, hence the split. Switching a VM
between the two needs a `moved` block in the root module (see
`infra/proxmox/moved.tf`).
