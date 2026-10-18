output "storage_boxes" {
  description = "Storage Box details by key"
  value = {
    for k, v in hcloud_storage_box.box : k => {
      id       = v.id
      server   = v.server
      username = v.username
    }
  }
}

output "subaccounts" {
  description = "Subaccount details by \"<box>/<subaccount>\" key"
  value = {
    for k, v in hcloud_storage_box_subaccount.subaccount : k => {
      id       = v.id
      server   = v.server
      username = v.username
    }
  }
}

output "storage_box_passwords" {
  description = "Main account passwords by key; pipe them, never print"
  value       = { for k, v in random_password.storage_box : k => v.result }
  sensitive   = true
}

output "subaccount_passwords" {
  description = "Subaccount passwords by \"<box>/<subaccount>\" key; pipe them, never print"
  value       = { for k, v in random_password.subaccount : k => v.result }
  sensitive   = true
}
