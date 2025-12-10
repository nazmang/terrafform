# Hetzner Cloud Infrastructure

This directory contains an example configuration for deploying Hetzner Cloud instances using the `hetzner_instances` module, following a pattern similar to the GCE infrastructure with separate instance types and default configurations.

## Overview

This example creates:
- Multiple Hetzner Cloud server instances organized by type (manager, worker, web, db)
- Primary IP addresses for each server
- A private network with subnet
- Firewall rules for basic access
- Network routes

## Architecture

The infrastructure is organized by instance types, each with their own default configurations:

- **Manager instances**: Docker manager nodes (cx23, permanent IPs)
- **Worker instances**: Docker worker nodes (cx33/cx34, auto-delete IPs)
- **Web instances**: Web servers (cx23, can be enabled)
- **Database instances**: Database servers (cx33, can be enabled)

## Prerequisites

1. Hetzner Cloud account with API token
2. SSH key pair
3. Terraform >= 1.0

## Setup

1. Copy the example variables file:
   ```bash
   cp terraform.tfvars.example terraform.tfvars
   ```

2. Edit `terraform.tfvars` and provide your values:
   - `hcloud_token`: Your Hetzner Cloud API token
   - `ssh_public_key_path`: Path to your SSH public key
   - `firewall_allowed_ips`: IP addresses allowed to access servers
   - `remote_allowed_ips`: IP ranges for network routes

3. Initialize Terraform:
   ```bash
   terraform init
   ```

4. Review the plan:
   ```bash
   terraform plan
   ```

5. Apply the configuration:
   ```bash
   terraform apply
   ```

## Configuration

### Instance Types and Defaults

The configuration uses a `locals.tf` file to define default configurations for different instance types:

#### Manager Defaults
- Server type: `cx23`
- Image: `ubuntu-22.04`
- Primary IP: Permanent (auto_delete = false)
- Labels: `jumphost=true`, `app=docker`, `role=manager`

#### Worker Defaults
- Server type: `cx33`
- Image: `ubuntu-22.04`
- Primary IP: Auto-delete (auto_delete = true)
- Labels: `jumphost=false`, `app=docker`, `role=worker`

#### Web Defaults
- Server type: `cx23`
- Image: `ubuntu-22.04`
- Primary IP: Permanent
- Labels: `app=web`, `role=web-server`

#### Database Defaults
- Server type: `cx33`
- Image: `ubuntu-22.04`
- Primary IP: Permanent
- Labels: `app=database`, `role=db-server`

### Instance Definitions

Instances are defined in `locals.tf`:

```hcl
manager_instances = {
  main = {
    name       = "cx23-ubuntu-01"
    network_ip = "10.163.1.5"
  }
}

worker_instances = {
  worker1 = {
    name       = "cx33-ubuntu-02"
    network_ip = "10.163.1.15"
  }
  worker2 = {
    name       = "cx33-ubuntu-03"
    network_ip = "10.163.1.16"
  }
}
```

### Network

- Private network: `10.163.0.0/16`
- Subnet: `10.163.1.0/24` in `eu-central` zone

### Firewall Rules

Default firewall rules include:
- ICMP (ping) from anywhere
- SSH from allowed IPs
- Wireguard UDP port 51820 from allowed IPs
- TCP traffic from local network (10.163.1.0/24 and 172.22.0.0/24)

## Outputs

After applying, you can access:

- **By type**: 
  - `terraform output manager_server_ipv4_addresses`
  - `terraform output worker_server_ipv4_addresses`
  - `terraform output web_server_ipv4_addresses`
  - `terraform output db_server_ipv4_addresses`

- **Combined**:
  - `terraform output all_server_ipv4_addresses`
  - `terraform output all_server_ids`
  - `terraform output main_server_ip`

## Customization

### Adding New Instances

To add a new instance of an existing type, edit `locals.tf`:

```hcl
worker_instances = {
  worker1 = {
    name       = "cx33-ubuntu-02"
    network_ip = "10.163.1.15"
  }
  worker2 = {
    name       = "cx33-ubuntu-03"
    network_ip = "10.163.1.16"
  }
  worker3 = {  # New instance
    name       = "cx33-ubuntu-04"
    network_ip = "10.163.1.17"
  }
}
```

### Creating a New Instance Type

1. Add default configuration in `locals.tf`:
   ```hcl
   cache_defaults = {
     server_type            = "cx11"
     image                  = "ubuntu-22.04"
     datacenter             = "nbg1-dc3"
     # ... other defaults
   }
   ```

2. Add instance definitions:
   ```hcl
   cache_instances = {
     redis1 = {
       name       = "cx11-redis-01"
       network_ip = "10.163.1.20"
     }
   }
   ```

3. Add module block in `main.tf`:
   ```hcl
   module "cache_instances" {
     for_each = local.cache_instances
     source   = "../../modules/hetzner_instances"
     # ... configuration
   }
   ```

4. Add outputs in `outputs.tf` (optional)

### Overriding Instance-Specific Settings

You can override settings for specific instances in the module's `overrides` block:

```hcl
module "worker_instances" {
  # ...
  overrides = {
    worker2 = {
      server_type = "cx34"  # Override default cx33
      labels = {
        "special" = "true"
      }
    }
  }
}
```

### Modifying Defaults

Edit the default configurations in `locals.tf`:

```hcl
worker_defaults = {
  server_type = "cx34"  # Change default from cx33
  # ... other settings
}
```

## File Structure

```
infra/hetzner/
├── main.tf              # Provider, network, firewall, and module calls
├── locals.tf            # Default configurations for instance types
├── docker_instances.tf  # Docker manager and worker instance definitions
├── web_instances.tf     # Web server instance definitions
├── db_instances.tf      # Database server instance definitions
├── variables.tf         # Input variables
├── outputs.tf           # Output values
├── terraform.tfvars.example  # Example variable values
└── README.md            # This file
```

## Notes

- Each instance type uses its own module with `for_each`, allowing easy scaling
- Default configurations are defined once per type in `locals.tf`
- Individual instances can override defaults via the `overrides` parameter
- Primary IPs for manager/db servers are permanent; worker IPs auto-delete
- All instances are attached to the private network
- Firewall is created separately to avoid circular dependencies
- Firewalls are attached to instances using `hcloud_firewall_attachment` resources, providing better separation of concerns and more flexible firewall management

## Cleanup

To destroy all resources:
```bash
terraform destroy
```
