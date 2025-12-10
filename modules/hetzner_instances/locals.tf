locals {
  # Merge defaults with overrides for each instance
  instances = {
    for k, v in var.instances : k => {
      name                     = v.name
      server_type              = var.defaults.server_type
      image                    = var.defaults.image
      location                 = var.defaults.location
      datacenter               = var.defaults.datacenter
      ssh_keys                 = var.defaults.ssh_keys
      labels                   = coalesce(var.defaults.labels, {})
      user_data                = var.defaults.user_data
      networks                 = length(v.networks) > 0 ? v.networks : coalesce(var.defaults.networks, [])
      firewall_ids             = try(var.defaults.firewall_ids, [])
      shutdown_before_deletion = var.defaults.shutdown_before_deletion
      ipv4_enabled             = try(var.defaults.ipv4_enabled, true)
      ipv4                     = var.defaults.ipv4
      ipv6_enabled             = try(var.defaults.ipv6_enabled, true)
    }
  }

  # Apply overrides from var.overrides
  instances_with_overrides = {
    for k, v in local.instances : k => {
      name                     = v.name
      server_type              = try(var.overrides[k].server_type, v.server_type)
      image                    = try(var.overrides[k].image, v.image)
      location                 = try(var.overrides[k].location, null) != null ? var.overrides[k].location : v.location
      datacenter               = try(var.overrides[k].datacenter, null) != null ? var.overrides[k].datacenter : v.datacenter
      ssh_keys                 = try(var.overrides[k].ssh_keys, v.ssh_keys)
      labels                   = try(var.overrides[k].labels, null) != null ? var.overrides[k].labels : coalesce(v.labels, {})
      user_data                = try(var.overrides[k].user_data, v.user_data)
      networks                 = try(var.overrides[k].networks, null) != null ? var.overrides[k].networks : v.networks
      firewall_ids             = try(var.overrides[k].firewall_ids, v.firewall_ids, [])
      shutdown_before_deletion = try(var.overrides[k].shutdown_before_deletion, v.shutdown_before_deletion)
      ipv4_enabled             = try(var.overrides[k].ipv4_enabled, null) != null ? var.overrides[k].ipv4_enabled : v.ipv4_enabled
      ipv4                     = try(var.overrides[k].ipv4, null) != null ? var.overrides[k].ipv4 : v.ipv4
      ipv6_enabled             = try(var.overrides[k].ipv6_enabled, null) != null ? var.overrides[k].ipv6_enabled : v.ipv6_enabled
    }
  }

  # Merge firewall defaults with overrides
  firewall_config = {
    for k, v in var.firewalls : k => {
      name   = v.name
      rules  = try(var.firewall_overrides[k].rules, null) != null ? var.firewall_overrides[k].rules : var.firewall_defaults.rules
      labels = try(var.firewall_overrides[k].labels, null) != null ? var.firewall_overrides[k].labels : var.firewall_defaults.labels
    }
  }
}

