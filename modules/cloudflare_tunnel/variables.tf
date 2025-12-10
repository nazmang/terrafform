variable "account_id" {
  description = "Cloudflare account ID"
  type        = string
}

variable "zone_id" {
  description = "Cloudflare zone ID for DNS records"
  type        = string
}

variable "zone_ttl" {
  description = "Cloudflare zone TTL for DNS records"
  type        = number
  default     = 3600
}

variable "zone_type" {
  description = "Cloudflare zone type for DNS records"
  type        = string
  default     = "CNAME"
}

variable "zone_content" {
  description = "Cloudflare zone content for DNS records"
  type        = string
  default     = ""
}

variable "tunnel_name" {
  description = "Name of the Cloudflare Tunnel"
  type        = string
  default     = "default-tunnel"
}

variable "tunnel_secret" {
  description = "Secret for the tunnel"
  type        = string
  default     = ""
}

variable "tunnel_config" {
  description = "Cloudflare Tunnel configuration rules"
  type = object({
    ingress = list(object({
      hostname = optional(string)
      service  = string
    }))
    origin_request = optional(object({
      origin_server_name = optional(string)
    }))
    warp_routing = optional(object({
      enabled = optional(bool)
    }))
  })
  default = {
    ingress = [
      {
        hostname = "example.yourdomain.com"
        service  = "http://localhost:8080"
      },
      {
        hostname = "api.yourdomain.com"
        service  = "https://localhost:8443"
      },
      {
        service = "https://localhost:8080"
      }
    ]
  }
}

variable "create_dns_record" {
  description = "Whether to create a DNS record for the tunnel"
  type        = bool
  default     = true
}

variable "domain" {
  description = "Hostname for the public-facing service"
  type        = string
  default     = "yourdomain.com"
}
