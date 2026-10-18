variable "storage_boxes" {
  description = "Map of Storage Boxes to create. Key is used as box identifier. Unset fields fall back to var.defaults."
  type = map(object({
    name             = string
    storage_box_type = optional(string)
    location         = optional(string)
    # Cannot be updated through the API: changes are ignored after creation.
    ssh_keys          = optional(list(string))
    labels            = optional(map(string))
    delete_protection = optional(bool)
    access_settings = optional(object({
      reachable_externally = optional(bool, false)
      samba_enabled        = optional(bool, false)
      ssh_enabled          = optional(bool, false)
      webdav_enabled       = optional(bool, false)
      zfs_enabled          = optional(bool, false)
    }))
    snapshot_plan = optional(object({
      max_snapshots = number
      minute        = number
      hour          = number
      day_of_week   = optional(number)
      day_of_month  = optional(number)
    }))
    # Key is used as subaccount identifier.
    subaccounts = optional(map(object({
      name           = optional(string)
      home_directory = string
      description    = optional(string)
      labels         = optional(map(string), {})
      access_settings = optional(object({
        reachable_externally = optional(bool, false)
        readonly             = optional(bool, false)
        samba_enabled        = optional(bool, false)
        ssh_enabled          = optional(bool, false)
        webdav_enabled       = optional(bool, false)
      }), {})
    })), {})
  }))
}

variable "defaults" {
  description = "Default configuration for all Storage Boxes."
  type = object({
    storage_box_type  = string
    location          = string
    ssh_keys          = optional(list(string), [])
    labels            = optional(map(string), {})
    delete_protection = optional(bool, true)
    access_settings = optional(object({
      reachable_externally = optional(bool, false)
      samba_enabled        = optional(bool, false)
      ssh_enabled          = optional(bool, false)
      webdav_enabled       = optional(bool, false)
      zfs_enabled          = optional(bool, false)
    }), {})
    snapshot_plan = optional(object({
      max_snapshots = number
      minute        = number
      hour          = number
      day_of_week   = optional(number)
      day_of_month  = optional(number)
    }))
  })
}

variable "password_special" {
  description = "Special characters for generated passwords. Hetzner allows ^°!§$%/()=?+#-.,;:~*@{}_&; the default needs no quoting in a CIFS cred file or a shell."
  type        = string
  default     = "-_.+=@#%"
}
