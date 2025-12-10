variable "project_id" {
  description = "The Google Cloud project ID where the resources will be created."
  type        = string
}

variable "name" {
  description = "A unique name to identify the resource group."
  type        = string
}

variable "owners" {
  description = "IAM-style members who will be granted roles/storage.objectAdmin to the bucket."
  type        = list(string)
  default     = []
}

variable "defaults" {
  description = "Default configuration for all buckets."
  type = object({
    location      = string
    storage_class = string
    versioning    = optional(bool)
    force_destroy = optional(bool)
    lifecycle_rules = optional(list(object({
      age                   = optional(number)
      created_before        = optional(string)
      with_state            = optional(string)
      matches_storage_class = optional(list(string))
      days_since_noncurrent_time = optional(number)
      action = object({
        type          = string
        storage_class = optional(string)
      })
    })))
  })
  validation {
    condition = alltrue([
      for rule in var.defaults.lifecycle_rules : 
      !(rule.action.type == "SetStorageClass" && rule.action.storage_class == null)
    ])
    error_message = "If action.type is 'SetStorageClass', then action.storage_class must be specified."
  }
}

variable "overrides" {
  description = "Overrides for specific buckets."
  type = object({
    location      = optional(string)
    storage_class = optional(string)
    versioning    = optional(bool)
    force_destroy = optional(bool)
    lifecycle_rules = optional(list(object({
      age                   = optional(number)
      created_before        = optional(string)
      with_state            = optional(string)
      matches_storage_class = optional(list(string))
      days_since_noncurrent_time = optional(number)
      action = optional(object({
        type          = optional(string)
        storage_class = optional(string)
      }))
    })))
  })
  # validation {
  #   condition = alltrue([
  #     for rule in var.overrides.lifecycle_rules : 
  #     !(rule.action.type == "SetStorageClass" && rule.action.storage_class == null)
  #   ])
  #   error_message = "If action.type is 'SetStorageClass', then action.storage_class must be specified."
  # }
}
