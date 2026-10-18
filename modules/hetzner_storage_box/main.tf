# Passwords live only in the state. Read them with
# `terraform output -raw` piped to where they are needed, never printed.
resource "random_password" "storage_box" {
  for_each = local.storage_boxes

  length           = 32
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  override_special = var.password_special
}

resource "random_password" "subaccount" {
  for_each = local.subaccounts

  length           = 32
  min_upper        = 2
  min_lower        = 2
  min_numeric      = 2
  min_special      = 2
  override_special = var.password_special
}

# Create Storage Boxes
resource "hcloud_storage_box" "box" {
  for_each = local.storage_boxes

  name              = each.value.name
  storage_box_type  = each.value.storage_box_type
  location          = each.value.location
  password          = random_password.storage_box[each.key].result
  ssh_keys          = each.value.ssh_keys
  labels            = each.value.labels
  delete_protection = each.value.delete_protection
  access_settings   = each.value.access_settings
  snapshot_plan     = each.value.snapshot_plan

  lifecycle {
    # ssh_keys cannot be updated through the API, a change means a new box.
    ignore_changes  = [ssh_keys]
    prevent_destroy = true
  }
}

# Create subaccounts
resource "hcloud_storage_box_subaccount" "subaccount" {
  for_each = local.subaccounts

  storage_box_id  = hcloud_storage_box.box[each.value.box].id
  name            = each.value.name
  home_directory  = each.value.home_directory
  password        = random_password.subaccount[each.key].result
  description     = each.value.description
  labels          = each.value.labels
  access_settings = each.value.access_settings
}
