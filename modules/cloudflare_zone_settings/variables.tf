variable "zones" {
  description = "Map of zones to harden. Key is used as identifier. Unset fields fall back to var.defaults."
  type = map(object({
    zone_id          = string
    always_use_https = optional(bool)
    hsts = optional(object({
      max_age            = number
      include_subdomains = optional(bool, false)
      preload            = optional(bool, false)
    }))
  }))
}

variable "defaults" {
  description = "Default configuration for all zones."
  type = object({
    always_use_https = optional(bool, true)
    hsts = optional(object({
      max_age            = number
      include_subdomains = optional(bool, false)
      preload            = optional(bool, false)
    }))
  })
  default = {}
}
