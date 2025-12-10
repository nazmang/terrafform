locals {
  # Merge defaults and overrides, filtering out null values and handling nested objects
  configuration = merge(
    var.defaults,
    { for k, v in var.overrides : k => v if v != null && k != "disks" && k != "cpu" && k != "networks" },
    {
      disks = merge(
        try(var.defaults.disks, {}),
        try(var.overrides.disks, {})
      )
      cpu      = var.overrides.cpu != null ? var.overrides.cpu : var.defaults.cpu
      networks = var.overrides.networks != null ? var.overrides.networks : var.defaults.networks
    }
  )
}

locals {
  # Convert disks to a map keyed by slot for stable identification
  # Using slot as key since it's already unique (e.g., "scsi0", "ide1")
  # Sort by bus type order and slot to ensure consistent ordering
  all_disks = {
    for item in flatten([
      for bus_type in ["scsi", "ide", "virtio", "sata"] : [
        for slot, slot_obj in try(local.configuration.disks[bus_type], {}) : {
          key       = slot # slot is already unique like "scsi0", "ide1"
          slot      = slot
          type      = bus_type
          disk_type = try(slot_obj.cloudinit, null) != null ? "cloudinit" : "disk"
          settings  = try(slot_obj.cloudinit, slot_obj.disk, {})
        }
      ]
    ]) : item.key => item
  }
}
