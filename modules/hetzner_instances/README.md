# Hetzner Cloud Instances Module

This Terraform module creates Hetzner Cloud server instances with primary IP addresses and firewall rules. It follows a defaults/overrides pattern, allowing you to define common configuration for all instances while providing flexibility to override settings for specific instances.

## Features

- **Multiple Instances**: Create multiple Hetzner Cloud servers from a single module call
- **Primary IPs**: Automatically creates and assigns primary IP addresses to each instance
- **Firewall Rules**: Create and manage firewall rules with defaults and overrides
- **Firewall Attachments**: Uses `hcloud_firewall_attachment` resources for flexible firewall management
- **Network Support**: Optional private network configuration
- **IPv4/IPv6**: Support for both IPv4 and IPv6
- **Flexible Configuration**: Defaults/overrides pattern for easy management

## Usage

### Basic Example

```hcl
module "hetzner_instances" {
  source = "../../modules/hetzner_instances"

  instances = {
    main = {
      name = "cx22-ubuntu-01"
    }
    worker1 = {
      name       = "cx32-ubuntu-02"
      network_ip = "10.163.1.15"
    }
  }

  defaults = {
    server_type            = "cx22"
    image                  = "ubuntu-22.04"
    location               = "nbg1"
    ssh_keys               = [hcloud_ssh_key.my_ssh_key.id]
    network_id             = hcloud_network.internal.id
    firewall_ids           = [module.hetzner_instances.firewall_ids["basic-access"]]
    shutdown_before_deletion = true
    ipv4_enabled           = true
    ipv6_enabled           = true
    primary_ip_auto_delete  = false
    labels = {
      "app" = "docker"
    }
  }

  overrides = {
    worker1 = {
      server_type = "cx32"
      labels = {
        "app"  = "docker"
        "role" = "worker"
      }
    }
  }

  firewalls = {
    "basic-access" = {
      name = "my-firewall"
    }
  }

  firewall_defaults = {
    rules = [
      {
        description = "Allow inbound ICMP"
        direction   = "in"
        protocol    = "icmp"
        source_ips  = ["0.0.0.0/0", "::/0"]
      },
      {
        description = "Allow inbound SSH"
        direction   = "in"
        protocol    = "tcp"
        port        = "22"
        source_ips  = ["0.0.0.0/0"]
      }
    ]
    labels = {
      "environment" = "production"
    }
  }
}
```

### Advanced Example with Firewall Overrides

```hcl
module "hetzner_instances" {
  source = "../../modules/hetzner_instances"

  instances = {
    web = {
      name       = "web-server-01"
      network_ip = "10.163.1.10"
    }
    db = {
      name       = "db-server-01"
      network_ip = "10.163.1.20"
    }
  }

  defaults = {
    server_type            = "cx22"
    image                  = "ubuntu-22.04"
    datacenter             = "nbg1-dc3"
    ssh_keys               = [hcloud_ssh_key.my_ssh_key.id]
    network_id             = hcloud_network.internal.id
    shutdown_before_deletion = true
    ipv4_enabled           = true
    ipv6_enabled           = true
    primary_ip_auto_delete  = false
    primary_ip_labels = {
      "dc"       = "nuremberg"
      "permanent" = "yes"
    }
    labels = {
      "environment" = "production"
    }
  }

  overrides = {
    db = {
      server_type = "cx32"
      labels = {
        "environment" = "production"
        "role"        = "database"
      }
      primary_ip_auto_delete = true
    }
  }

  firewalls = {
    "web-firewall" = {
      name = "web-server-firewall"
    }
    "db-firewall" = {
      name = "db-server-firewall"
    }
  }

  firewall_defaults = {
    rules = [
      {
        description = "Allow inbound SSH"
        direction   = "in"
        protocol    = "tcp"
        port        = "22"
        source_ips  = ["10.0.0.0/8"]
      }
    ]
  }

  firewall_overrides = {
    "web-firewall" = {
      rules = [
        {
          description = "Allow inbound SSH"
          direction   = "in"
          protocol    = "tcp"
          port        = "22"
          source_ips  = ["10.0.0.0/8"]
        },
        {
          description = "Allow inbound HTTP"
          direction   = "in"
          protocol    = "tcp"
          port        = "80"
          source_ips  = ["0.0.0.0/0"]
        },
        {
          description = "Allow inbound HTTPS"
          direction   = "in"
          protocol    = "tcp"
          port        = "443"
          source_ips  = ["0.0.0.0/0"]
        }
      ]
    }
    "db-firewall" = {
      rules = [
        {
          description = "Allow inbound SSH"
          direction   = "in"
          protocol    = "tcp"
          port        = "22"
          source_ips  = ["10.0.0.0/8"]
        },
        {
          description = "Allow MySQL from internal network"
          direction   = "in"
          protocol    = "tcp"
          port        = "3306"
          source_ips  = ["10.163.1.0/24"]
        }
      ]
    }
  }
}
```

## Inputs

### Required Variables

| Name | Description | Type |
|------|-------------|------|
| `instances` | Map of instances to create. Key is used as instance identifier. | `map(object({ name = string, network_ip = optional(string) }))` |
| `defaults` | Default configuration for all instances. | `object` (see below) |

### Optional Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| `overrides` | Overrides for specific instances. Key must match instance key. | `map(object)` | `{}` |
| `firewalls` | Map of firewalls to create. | `map(object({ name = string }))` | `{}` |
| `firewall_defaults` | Default configuration for all firewalls. | `object` | `{ rules = [], labels = {} }` |
| `firewall_overrides` | Overrides for specific firewalls. | `map(object)` | `{}` |

### Defaults Object

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `server_type` | Hetzner Cloud server type (e.g., "cx22", "cx32") | `string` | Yes |
| `image` | Operating system image (e.g., "ubuntu-22.04") | `string` | Yes |
| `ssh_keys` | List of SSH key IDs to attach to instances | `list(string)` | Yes |
| `location` | Location name (e.g., "nbg1", "fsn1") | `string` | No |
| `datacenter` | Datacenter name (e.g., "nbg1-dc3") | `string` | No |
| `labels` | Labels to apply to instances | `map(string)` | No |
| `user_data` | Cloud-init user data script | `string` | No |
| `network_id` | Private network ID to attach instances to | `number` | No |
| `firewall_ids` | List of firewall IDs to attach | `list(number)` | No |
| `shutdown_before_deletion` | Shutdown server before deletion | `bool` | No (default: `true`) |
| `ipv4_enabled` | Enable IPv4 | `bool` | No (default: `true`) |
| `ipv6_enabled` | Enable IPv6 | `bool` | No (default: `true`) |
| `primary_ip_auto_delete` | Auto-delete primary IP when server is deleted | `bool` | No (default: `false`) |
| `primary_ip_labels` | Labels for primary IPs | `map(string)` | No |

**Note**: Either `location` or `datacenter` must be specified, but not both.

### Overrides Object

The overrides object supports all fields from defaults, plus:
- `primary_ip_name`: Custom name for the primary IP (default: `"{instance_name}-primary-ip"`)

### Firewall Rules

Firewall rules support the following fields:

| Name | Description | Type | Required |
|------|-------------|------|----------|
| `direction` | Rule direction: "in" or "out" | `string` | Yes |
| `protocol` | Protocol: "tcp", "udp", "icmp" | `string` | No |
| `port` | Port number or "any" | `string` | No |
| `source_ips` | List of source IP addresses/CIDRs | `list(string)` | No |
| `destination_ips` | List of destination IP addresses/CIDRs | `list(string)` | No |
| `description` | Rule description | `string` | No |

### Firewall Attachment

This module uses `hcloud_firewall_attachment` resources to attach firewalls to servers, rather than direct assignment via the `firewall_ids` attribute on the server resource. This approach provides:

- **Better separation of concerns**: Firewall attachments are managed as independent resources
- **More flexibility**: Easier to manage and modify firewall attachments independently
- **Future extensibility**: Can be extended to support label selectors for dynamic firewall assignment

The module automatically creates one `hcloud_firewall_attachment` resource for each firewall-server pair specified in `firewall_ids`. From the caller's perspective, the interface remains the same - you still pass `firewall_ids` as a list, and the module handles the attachment internally.

## Outputs

| Name | Description |
|------|-------------|
| `server_ids` | Map of instance keys to server IDs |
| `server_ipv4_addresses` | Map of instance keys to IPv4 addresses |
| `server_ipv6_addresses` | Map of instance keys to IPv6 addresses |
| `primary_ip_ids` | Map of instance keys to primary IP IDs |
| `primary_ip_addresses` | Map of instance keys to primary IP addresses |
| `firewall_ids` | Map of firewall keys to firewall IDs |
| `servers` | Complete server objects |
| `firewalls` | Complete firewall objects |

## Examples

### Using Firewall IDs from Module Output

```hcl
module "hetzner_instances" {
  source = "../../modules/hetzner_instances"

  instances = {
    server1 = { name = "server-01" }
    server2 = { name = "server-02" }
  }

  defaults = {
    server_type = "cx22"
    image       = "ubuntu-22.04"
    location    = "nbg1"
    ssh_keys    = [hcloud_ssh_key.my_ssh_key.id]
  }

  firewalls = {
    "web" = { name = "web-firewall" }
  }

  firewall_defaults = {
    rules = [
      {
        direction  = "in"
        protocol   = "tcp"
        port       = "80"
        source_ips = ["0.0.0.0/0"]
      }
    ]
  }
}

# Use the firewall ID in another resource
resource "hcloud_server" "additional_server" {
  # ...
  firewall_ids = [module.hetzner_instances.firewall_ids["web"]]
}
```

## Requirements

- Terraform >= 1.0
- Hetzner Cloud Provider >= 1.0

## Notes

- Primary IPs are automatically created for each instance when `ipv4_enabled` is `true`
- Either `location` or `datacenter` must be specified in defaults (or overrides), but not both
- **Firewall Attachment**: Firewalls are attached to servers using `hcloud_firewall_attachment` resources instead of direct assignment. This provides better separation of concerns and more flexible firewall management. The `firewall_ids` parameter works the same way from the caller's perspective, but internally uses separate attachment resources.
- **Circular Dependency Warning**: You cannot reference firewall IDs from this module's output (`firewall_ids`) within the same module call's `defaults` or `overrides`. If you need to use firewalls created by this module, either:
  - Create firewalls separately outside the module and reference them
  - Use a two-stage approach: create firewalls first, then reference them in a subsequent apply
  - Attach firewalls manually after creation using the `firewall_ids` output
- Network IP addresses are optional and only used when `network_id` is specified

