resource "proxmox_vm_qemu" "this" {
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
    # New VMs will still get bootdisk set from defaults
    ignore_changes = [
      bootdisk
    ]
  }

}
