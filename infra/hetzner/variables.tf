variable "hcloud_token" {
  description = "The API token for Hetzner Cloud"
  type        = string
  sensitive   = true
}

variable "ssh_public_key_path" {
  description = "Path to your SSH public key file"
  type        = string
  default     = "~/.ssh/id_rsa.pub"
}

variable "firewall_allowed_ips" {
  description = "List of IPs allowed to connect to the server(s)"
  type        = list(string)
  default = [
    "0.0.0.0/0",
    "::/0"
  ]
}

variable "remote_allowed_ips" {
  description = "List of allowed IPs for network routes"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

