variable "project_id" {
  description = "The Google Cloud project ID where the resources will be created."
  type        = string
}

variable "name" {
  description = "A unique name to identify the resource group."
  type        = string
}

variable "defaults" {
  description = "Default configuration for all buckets."
  type        = object({
    location       = string
    storage_class  = string
    versioning     = optional(bool)
    force_destroy  = optional(bool)
    lifecycle      = optional(object({
      age    = optional(number)
      action = optional(string)
    }))
  })
  
}

variable "overrides" {
  description = "Overrides for specific buckets."
  type        = map(any)  
}
