locals {
  # Merge defaults into each box
  storage_boxes = {
    for k, v in var.storage_boxes : k => {
      name              = v.name
      storage_box_type  = coalesce(v.storage_box_type, var.defaults.storage_box_type)
      location          = coalesce(v.location, var.defaults.location)
      ssh_keys          = v.ssh_keys != null ? v.ssh_keys : var.defaults.ssh_keys
      labels            = v.labels != null ? v.labels : var.defaults.labels
      delete_protection = v.delete_protection != null ? v.delete_protection : var.defaults.delete_protection
      access_settings   = v.access_settings != null ? v.access_settings : var.defaults.access_settings
      snapshot_plan     = v.snapshot_plan != null ? v.snapshot_plan : var.defaults.snapshot_plan
    }
  }

  # Flatten subaccounts to "<box>/<subaccount>" keys
  subaccounts = merge([
    for bk, b in var.storage_boxes : {
      for sk, s in b.subaccounts : "${bk}/${sk}" => merge(s, {
        box  = bk
        name = coalesce(s.name, sk)
      })
    }
  ]...)
}
