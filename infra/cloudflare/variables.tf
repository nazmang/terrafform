variable "cloudflare_api_token" {
  type        = string
  default     = ""
  description = "Cloudflare API token - https://dash.cloudflare.com/profile/api-tokens"
}

variable "cloudflare_domain_name" {
  type        = string
  default     = "example.com"
  description = "Domain name to create DNS records"
}

variable "cloudflare_account_id" {
  type        = string
  default     = ""
  description = "Cloudflare Account ID"
}

variable "cloudflare_zone_id" {
  type        = string
  default     = ""
  description = "Cloudflare Zone ID"
}
