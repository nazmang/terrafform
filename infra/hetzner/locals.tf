locals {
  # Default configurations for different instance types
  manager_defaults = {
    server_type              = "cx23"
    image                    = "ubuntu-22.04"
    datacenter               = "nbg1-dc3"
    shutdown_before_deletion = true
    ipv4_enabled             = true
    ipv6_enabled             = true
    external_ip              = true
    primary_ip_auto_delete   = false
    primary_ip_labels = {
      "dc"        = "nuremberg"
      "permanent" = "yes"
    }
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
    external_ip              = false
    primary_ip_auto_delete   = true
    primary_ip_labels = {
      "dc"        = "nuremberg"
      "permanent" = "no"
    }
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
    external_ip              = true
    primary_ip_auto_delete   = false
    primary_ip_labels = {
      "dc"        = "nuremberg"
      "permanent" = "yes"
    }
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
    external_ip              = false
    primary_ip_auto_delete   = false
    primary_ip_labels = {
      "dc"        = "nuremberg"
      "permanent" = "yes"
    }
    labels = {
      "app"  = "database"
      "role" = "db-server"
    }
  }
}
