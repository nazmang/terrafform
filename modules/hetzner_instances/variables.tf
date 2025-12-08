variable "instances" {
  description = "Map of instances to create. Key is used as instance identifier."
  type = map(object({
    name = string
    networks = optional(list(object({
      network_id = number
      ip         = optional(string)
      alias_ips  = optional(list(string), [])
    })), [])
  }))
}

variable "defaults" {
  description = "Default configuration for all instances."
  type = object({
    server_type = string
    image       = string
    location    = optional(string)
    datacenter  = optional(string)
    ssh_keys    = list(string)
    labels      = optional(map(string), {})
    user_data   = optional(string)
    networks = optional(list(object({
      network_id = number
      ip         = optional(string)
      alias_ips  = optional(list(string), [])
    })), [])
    firewall_ids             = optional(list(number), [])
    shutdown_before_deletion = optional(bool, true)
    ipv4_enabled             = optional(bool, true)
    ipv4                     = optional(number)
    ipv6_enabled             = optional(bool, true)
  })
}

variable "overrides" {
  description = "Overrides for specific instances. Key must match instance key."
  type = map(object({
    server_type = optional(string)
    image       = optional(string)
    location    = optional(string)
    datacenter  = optional(string)
    ssh_keys    = optional(list(string))
    labels      = optional(map(string))
    user_data   = optional(string)
    networks = optional(list(object({
      network_id = number
      ip         = optional(string)
      alias_ips  = optional(list(string), [])
    })))
    firewall_ids             = optional(list(number))
    shutdown_before_deletion = optional(bool)
    ipv4_enabled             = optional(bool)
    ipv4                     = optional(number)
    ipv6_enabled             = optional(bool)
  }))
  default = {}
}

variable "firewalls" {
  description = "Map of firewalls to create. Key is used as firewall identifier."
  type = map(object({
    name = string
  }))
  default = {}
}

variable "firewall_defaults" {
  description = "Default configuration for all firewalls."
  type = object({
    rules = optional(list(object({
      description     = optional(string)
      direction       = string
      protocol        = optional(string)
      port            = optional(string)
      source_ips      = optional(list(string))
      destination_ips = optional(list(string))
    })), [])
    labels = optional(map(string), {})
  })
  default = {
    rules  = []
    labels = {}
  }
}

variable "firewall_overrides" {
  description = "Overrides for specific firewalls. Key must match firewall key."
  type = map(object({
    rules = optional(list(object({
      description     = optional(string)
      direction       = string
      protocol        = optional(string)
      port            = optional(string)
      source_ips      = optional(list(string))
      destination_ips = optional(list(string))
    })))
    labels = optional(map(string))
  }))
  default = {}
}

