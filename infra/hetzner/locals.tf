locals {
  # Default configurations for different instance types
  manager_defaults = {
    server_type              = "cx23"
    image                    = "ubuntu-22.04"
    datacenter               = "nbg1-dc3"
    shutdown_before_deletion = true
    ipv4_enabled             = false
    ipv6_enabled             = true
    labels = {
      "jumphost" = "true"
      "app"      = "docker"
      "role"     = "manager"
    }
  }

  worker_defaults = {
    server_type              = "cx33"
    image                    = "ubuntu-22.04"
    datacenter               = "nbg1-dc3"
    shutdown_before_deletion = true
    ipv4_enabled             = true
    ipv6_enabled             = true
    labels = {
      "jumphost" = "false"
      "app"      = "docker"
      "role"     = "worker"
    }
  }

  web_defaults = {
    server_type              = "cx23"
    image                    = "ubuntu-22.04"
    datacenter               = "nbg1-dc3"
    shutdown_before_deletion = true
    ipv4_enabled             = true
    ipv6_enabled             = true
    labels = {
      "app"  = "web"
      "role" = "web-server"
    }
  }

  db_defaults = {
    server_type              = "cx33"
    image                    = "ubuntu-22.04"
    datacenter               = "nbg1-dc3"
    shutdown_before_deletion = true
    ipv4_enabled             = true
    ipv6_enabled             = true
    labels = {
      "app"  = "database"
      "role" = "db-server"
    }
  }
}
