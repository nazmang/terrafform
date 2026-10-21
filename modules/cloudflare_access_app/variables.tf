variable "account_id" {
  description = "Cloudflare account ID"
  type        = string
}

variable "apps" {
  description = "Map of self-hosted Access applications. Key is used as app identifier. Unset fields fall back to var.defaults."
  type = map(object({
    name             = optional(string)
    domain           = string
    emails           = optional(list(string))
    session_duration = optional(string)
    # A service token for machines (monitoring and the like), allowed by a non_identity policy.
    service_token = optional(bool, false)
  }))
}

variable "defaults" {
  description = "Default configuration for all applications."
  type = object({
    emails                 = list(string)
    session_duration       = optional(string, "720h")
    service_token_duration = optional(string, "8760h")
  })
}
