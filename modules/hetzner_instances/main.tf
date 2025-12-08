# Create primary IPs for each instance (only if external_ip is true, ipv4 is enabled and not explicitly set)
resource "hcloud_primary_ip" "instance" {
  for_each = {
    for k, v in local.instances_with_overrides : k => v
    if v.external_ip == true && v.ipv4_enabled == true && v.ipv4 == null
  }

  name          = each.value.primary_ip_name
  datacenter    = try(each.value.datacenter, null)
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = coalesce(each.value.primary_ip_auto_delete, false)
  labels        = coalesce(each.value.primary_ip_labels, {})
}

# Create firewalls
resource "hcloud_firewall" "firewall" {
  for_each = local.firewall_config

  name   = each.value.name
  labels = each.value.labels

  dynamic "rule" {
    for_each = each.value.rules
    content {
      description     = rule.value.description
      direction       = rule.value.direction
      protocol        = rule.value.protocol
      port            = rule.value.port
      source_ips      = rule.value.source_ips
      destination_ips = rule.value.destination_ips
    }
  }
}

# Create servers
resource "hcloud_server" "instance" {
  for_each = local.instances_with_overrides

  name        = each.value.name
  server_type = coalesce(each.value.server_type, var.defaults.server_type)
  image       = coalesce(each.value.image, var.defaults.image)
  ssh_keys    = each.value.ssh_keys
  labels      = each.value.labels
  user_data   = each.value.user_data

  location   = try(each.value.location, null)
  datacenter = try(each.value.datacenter, null)

  public_net {
    ipv4_enabled = coalesce(each.value.ipv4_enabled, true)
    ipv4         = each.value.ipv4 != null ? each.value.ipv4 : (coalesce(each.value.ipv4_enabled, true) ? try(hcloud_primary_ip.instance[each.key].id, null) : null)
    ipv6_enabled = coalesce(each.value.ipv6_enabled, true)
  }

  dynamic "network" {
    for_each = each.value.networks
    content {
      network_id = network.value.network_id
      ip         = try(network.value.ip, null)
      alias_ips  = try(network.value.alias_ips, [])
    }
  }

  shutdown_before_deletion = each.value.shutdown_before_deletion

  depends_on = [hcloud_primary_ip.instance]
}

# Attach firewalls to servers using firewall_attachment resource
# This creates separate attachment resources instead of using firewall_ids in the server resource
resource "hcloud_firewall_attachment" "server" {
  for_each = {
    for pair in flatten([
      for server_key, server in hcloud_server.instance : [
        for firewall_id in coalesce(local.instances_with_overrides[server_key].firewall_ids, []) : {
          key         = "${server_key}-${firewall_id}"
          server_id   = server.id
          firewall_id = firewall_id
        }
      ]
    ]) : pair.key => pair
  }

  firewall_id = each.value.firewall_id
  server_ids  = [each.value.server_id]
}

