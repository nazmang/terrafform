# SSH Key resource (required for instances)
resource "hcloud_ssh_key" "my_ssh_key" {
  name       = "my-ssh-key"
  public_key = file(var.ssh_public_key_path)
}

# Manager Instances
module "manager_instances" {
  for_each = local.manager_instances
  source   = "../../modules/hetzner_instances"

  instances = {
    (each.key) = {
      name = each.value.name
    }
  }

  defaults = merge(
    local.manager_defaults,
    {
      ssh_keys = [hcloud_ssh_key.my_ssh_key.id]      
      networks = [{
        network_id = hcloud_network.internal.id
      }]
      firewall_ids = [hcloud_firewall.basic_access.id]
    }
  )

  overrides = {
    for k, v in local.manager_instances : k => {
      networks = [{
        network_id = hcloud_network.internal.id
        ip         = v.network_ip
      }]
    }
  }
}

# Worker Instances
module "worker_instances" {
  for_each = local.worker_instances
  source   = "../../modules/hetzner_instances"

  instances = {
    (each.key) = {
      name = each.value.name
    }
  }

  defaults = merge(
    local.worker_defaults,
    {
      ssh_keys = [hcloud_ssh_key.my_ssh_key.id]
      networks = [{
        network_id = hcloud_network.internal.id
      }]
      firewall_ids = [hcloud_firewall.basic_access.id]
    }
  )

  overrides = {
    for k, v in local.worker_instances : k => merge(
      {
        networks = [{
          network_id = hcloud_network.internal.id
          ip         = v.network_ip
        }]
      },
    )
  }
}

# Web Instances (example - can be enabled by adding instances to local.web_instances)
module "web_instances" {
  for_each = local.web_instances
  source   = "../../modules/hetzner_instances"

  instances = {
    (each.key) = {
      name = each.value.name
    }
  }

  defaults = merge(
    local.web_defaults,
    {
      ssh_keys = [hcloud_ssh_key.my_ssh_key.id]
      networks = [{
        network_id = hcloud_network.internal.id
      }]
      firewall_ids = [hcloud_firewall.basic_access.id]
    }
  )

  overrides = {}
}

# Database Instances (example - can be enabled by adding instances to local.db_instances)
module "db_instances" {
  for_each = local.db_instances
  source   = "../../modules/hetzner_instances"

  instances = {
    (each.key) = {
      name = each.value.name
    }
  }

  defaults = merge(
    local.db_defaults,
    {
      ssh_keys = [hcloud_ssh_key.my_ssh_key.id]
      networks = [{
        network_id = hcloud_network.internal.id
      }]
      firewall_ids = [hcloud_firewall.basic_access.id]
    }
  )

  overrides = {}
}

# Network routes (example - adjust gateway IP as needed)
resource "hcloud_network_route" "privNet" {
  for_each    = toset(var.remote_allowed_ips)
  network_id  = hcloud_network.internal.id
  destination = each.value
  gateway     = try(module.manager_instances["main"].server_ipv4_addresses["main"], "10.163.1.5")
}
