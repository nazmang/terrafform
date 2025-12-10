variable "pm_api_url" {
  description = "Proxmox API URL"
  type        = string
  default     = "https://phv3.bdinfra.net:8006/api2/json"
}

variable "pm_user" {
  description = "Proxmox API user"
  type        = string
  default     = "root@pam"
}

variable "pm_password" {
  description = "Proxmox API password"
  type        = string
  default     = "root"
}

variable "root_user" {
  description = "User to add during cloud-init"
  type        = string
  default     = ""
}

variable "root_user_password" {
  description = "Additional user password"
  type        = string
  default     = ""
}

variable "ldap_default_authtok" {
  type      = string
  sensitive = true
  default   = null
}

