variable "name" {
  description = "A unique name to identify the resource group."
  type        = string
}

variable "defaults" {
  description = "Default configuration for VMs"
  type = object({
    # cores            = number
    memory           = number
    ipconfig0        = optional(string)
    ipconfig1        = optional(string)
    skip_ipv6        = optional(bool)
    target_node      = string
    boot             = optional(string)
    bootdisk         = optional(string)
    onboot           = optional(bool)
    agent            = optional(number)
    vmid             = optional(number)
    template_name    = optional(string)
    pool             = optional(string)
    ciuser           = optional(string)
    cipassword       = optional(string)
    cicustom         = optional(string)
    ciupgrade        = optional(bool)
    sshkeys          = optional(string)
    vm_state         = optional(string)
    automatic_reboot = optional(bool)
    full_clone       = optional(bool)
    scsihw           = optional(string)
    tags             = optional(string)
    os_type          = optional(string)
    searchdomain     = optional(string)
    nameserver       = optional(string)
    cpu = optional(object({
      cores   = number
      sockets = number
    }))
    disks = optional(any)
    networks = optional(list(object({
      id       = number
      bridge   = optional(string)
      model    = optional(string)
      tag      = optional(number)
      macaddr  = optional(string)
      firewall = optional(bool)
    })), [])
  })
}

variable "overrides" {
  description = "Override configuration for specific VM"
  type = object({
    memory           = optional(number)
    ipconfig0        = optional(string)
    ipconfig1        = optional(string)
    skip_ipv6        = optional(bool)
    target_node      = optional(string)
    vmid             = optional(number)
    boot             = optional(string)
    bootdisk         = optional(string)
    onboot           = optional(bool)
    agent            = optional(number)
    template_name    = optional(string)
    pool             = optional(string)
    ciuser           = optional(string)
    cipassword       = optional(string)
    cicustom         = optional(string)
    ciupgrade        = optional(bool)
    sshkeys          = optional(string)
    vm_state         = optional(string)
    automatic_reboot = optional(bool)
    full_clone       = optional(bool)
    scsihw           = optional(string)
    tags             = optional(string)
    os_type          = optional(string)
    searchdomain     = optional(string)
    nameserver       = optional(string)
    cpu = optional(object({
      cores   = number
      sockets = number
    }))
    disks = optional(any)
    networks = optional(list(object({
      id       = number
      bridge   = optional(string)
      model    = optional(string)
      tag      = optional(number)
      macaddr  = optional(string)
      firewall = optional(bool)
    })))
  })
}
