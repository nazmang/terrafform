# Disks managed by Terraform (since 2026-11-02): adding/resizing a disk in the
# config is applied to the VM. Every VM except the k8s nodes.
resource "proxmox_vm_qemu" "this" {
  count = local.csi_hotplug_disks ? 0 : 1

  name        = var.name
  target_node = local.configuration.target_node
  vmid        = local.configuration.vmid
  clone       = local.configuration.template_name
  full_clone  = local.configuration.full_clone

  memory = local.configuration.memory
  scsihw = local.configuration.scsihw

  boot     = local.configuration.boot
  bootdisk = local.configuration.bootdisk
  onboot   = local.configuration.onboot
  agent    = local.configuration.agent
  tags     = local.configuration.tags


  cpu {
    cores   = local.configuration.cpu.cores
    sockets = local.configuration.cpu.sockets
  }

  dynamic "disk" {
    for_each = local.all_disks
    content {
      slot = disk.value.slot
      type = disk.value.disk_type
      # Set format to "raw" for regular disks to match Proxmox default and prevent drift
      # Cloud-init disks don't use format
      format             = disk.value.disk_type == "cloudinit" ? null : try(disk.value.settings.format, "raw")
      backup             = disk.value.disk_type == "cloudinit" ? null : try(disk.value.settings.backup, null)
      cache              = disk.value.disk_type == "cloudinit" ? null : try(disk.value.settings.cache, null)
      discard            = disk.value.disk_type == "cloudinit" ? null : try(disk.value.settings.discard, null)
      emulatessd         = disk.value.disk_type == "cloudinit" ? null : try(disk.value.settings.emulatessd, null)
      iothread           = disk.value.disk_type == "cloudinit" ? null : try(disk.value.settings.iothread, null)
      mbps_r_burst       = disk.value.disk_type == "cloudinit" ? null : try(disk.value.settings.mbps_r_burst, null)
      mbps_r_concurrent  = disk.value.disk_type == "cloudinit" ? null : try(disk.value.settings.mbps_r_concurrent, null)
      mbps_wr_burst      = disk.value.disk_type == "cloudinit" ? null : try(disk.value.settings.mbps_wr_burst, null)
      mbps_wr_concurrent = disk.value.disk_type == "cloudinit" ? null : try(disk.value.settings.mbps_wr_concurrent, null)
      replicate          = disk.value.disk_type == "cloudinit" ? null : try(disk.value.settings.replicate, null)
      size               = disk.value.disk_type == "cloudinit" ? null : try(disk.value.settings.size, null)
      storage            = disk.value.settings.storage
    }
  }

  dynamic "network" {
    for_each = local.configuration.networks
    content {
      id       = network.value.id
      bridge   = lookup(network.value, "bridge", "vmbr0")
      model    = lookup(network.value, "model", "virtio")
      tag      = lookup(network.value, "tag", null)
      macaddr  = network.value.macaddr
      firewall = network.value.firewall
    }
  }

  os_type          = local.configuration.os_type
  pool             = local.configuration.pool
  ciuser           = local.configuration.ciuser
  cipassword       = local.configuration.cipassword
  cicustom         = local.configuration.cicustom
  ciupgrade        = local.configuration.ciupgrade
  ipconfig0        = try(local.configuration.ipconfig0, null)
  ipconfig1        = try(local.configuration.ipconfig1, null)
  skip_ipv6        = local.configuration.skip_ipv6
  sshkeys          = local.configuration.sshkeys
  searchdomain     = local.configuration.searchdomain
  nameserver       = local.configuration.nameserver
  vm_state         = try(local.configuration.vm_state, null)
  automatic_reboot = try(local.configuration.automatic_reboot, null)
  serial {
    id = 0
  }

  lifecycle {
    # Ignore bootdisk changes for existing VMs to prevent unnecessary updates
    ignore_changes = [
      bootdisk,
    ]
  }
}

# k8s nodes: the Proxmox CSI plugin hot-plugs one disk per PVC. Terraform only
# creates these VMs and never updates them (see lifecycle below).
# A lifecycle block cannot be conditional, hence two resources (2026-11-02).
resource "proxmox_vm_qemu" "csi" {
  count = local.csi_hotplug_disks ? 1 : 0

  name        = var.name
  target_node = local.configuration.target_node
  vmid        = local.configuration.vmid
  clone       = local.configuration.template_name
  full_clone  = local.configuration.full_clone

  memory = local.configuration.memory
  scsihw = local.configuration.scsihw

  boot     = local.configuration.boot
  bootdisk = local.configuration.bootdisk
  onboot   = local.configuration.onboot
  agent    = local.configuration.agent
  tags     = local.configuration.tags


  cpu {
    cores   = local.configuration.cpu.cores
    sockets = local.configuration.cpu.sockets
  }

  dynamic "disk" {
    for_each = local.all_disks
    content {
      slot = disk.value.slot
      type = disk.value.disk_type
      # Set format to "raw" for regular disks to match Proxmox default and prevent drift
      # Cloud-init disks don't use format
      format             = disk.value.disk_type == "cloudinit" ? null : try(disk.value.settings.format, "raw")
      backup             = disk.value.disk_type == "cloudinit" ? null : try(disk.value.settings.backup, null)
      cache              = disk.value.disk_type == "cloudinit" ? null : try(disk.value.settings.cache, null)
      discard            = disk.value.disk_type == "cloudinit" ? null : try(disk.value.settings.discard, null)
      emulatessd         = disk.value.disk_type == "cloudinit" ? null : try(disk.value.settings.emulatessd, null)
      iothread           = disk.value.disk_type == "cloudinit" ? null : try(disk.value.settings.iothread, null)
      mbps_r_burst       = disk.value.disk_type == "cloudinit" ? null : try(disk.value.settings.mbps_r_burst, null)
      mbps_r_concurrent  = disk.value.disk_type == "cloudinit" ? null : try(disk.value.settings.mbps_r_concurrent, null)
      mbps_wr_burst      = disk.value.disk_type == "cloudinit" ? null : try(disk.value.settings.mbps_wr_burst, null)
      mbps_wr_concurrent = disk.value.disk_type == "cloudinit" ? null : try(disk.value.settings.mbps_wr_concurrent, null)
      replicate          = disk.value.disk_type == "cloudinit" ? null : try(disk.value.settings.replicate, null)
      size               = disk.value.disk_type == "cloudinit" ? null : try(disk.value.settings.size, null)
      storage            = disk.value.settings.storage
    }
  }

  dynamic "network" {
    for_each = local.configuration.networks
    content {
      id       = network.value.id
      bridge   = lookup(network.value, "bridge", "vmbr0")
      model    = lookup(network.value, "model", "virtio")
      tag      = lookup(network.value, "tag", null)
      macaddr  = network.value.macaddr
      firewall = network.value.firewall
    }
  }

  os_type          = local.configuration.os_type
  pool             = local.configuration.pool
  ciuser           = local.configuration.ciuser
  cipassword       = local.configuration.cipassword
  cicustom         = local.configuration.cicustom
  ciupgrade        = local.configuration.ciupgrade
  ipconfig0        = try(local.configuration.ipconfig0, null)
  ipconfig1        = try(local.configuration.ipconfig1, null)
  skip_ipv6        = local.configuration.skip_ipv6
  sshkeys          = local.configuration.sshkeys
  searchdomain     = local.configuration.searchdomain
  nameserver       = local.configuration.nameserver
  vm_state         = try(local.configuration.vm_state, null)
  automatic_reboot = try(local.configuration.automatic_reboot, null)
  serial {
    id = 0
  }

  lifecycle {
    # 2026-11-02: `ignore_changes = [disk]` was not enough -- any in-place update
    # of a k8s VM (ciupgrade, automatic_reboot) made the Telmate provider rewrite
    # the VM config and DETACH the CSI-attached PVC disks (Vault in k8s went down,
    # incident 2026-11-02-terraform-detached-csi-disks in homelab-journal).
    # Running k8s nodes are therefore never updated by Terraform: create-only.
    # To change one, edit it in Proxmox, or drain the node first and lift this.
    ignore_changes = all
  }
}

locals {
  vm = local.csi_hotplug_disks ? proxmox_vm_qemu.csi[0] : proxmox_vm_qemu.this[0]
}
