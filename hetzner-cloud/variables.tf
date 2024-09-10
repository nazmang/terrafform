# Hezner Cloud configuration
variable "hcloud_token" {
  description = "The API token for Hetzner Cloud"
  type        = string
}

variable "firewall_allowed_ips" {
  description = "List of IPs allowed to connet to the server(s)"
  type = list
  default = [
    "0.0.0.0/0",
    "::/0"
  ]
}

# SSH configuration
variable "ssh_public_key_path" {
  description = "Path to your SSH public key file"
  type        = string
  default = "!/.ssh/id_rsa.pub"
}

variable "ssh_private_key_path" {
  description = "Privat key path for remote SSH connations"
  type = string
  default = "~/.ssh/id_rsa"
}

variable "ssh_user" {
  description = "A user for remote SSH connections"
  type = string
  default = "root"
}

# Wireguard configuration
variable "remote_host_public_key" {
  description = "Wireguard remote host public key"
  type = string  
}

variable "remote_host_ip" {
  description = "Wiregard remote host"
  type = string
}

variable "remote_allowed_ips" {
  description = "List of allow IPs for Wireguard tunnel"
  type = list
  default = ["0.0.0.0/0"]
}

variable "remote_host_port" {
  description = "Wireguard remote host's port"
  type = string
  default = "51820"
}

variable "wg_private_key" {
  description = "Wiregurad private key for local client"
  type = string
  default = ""
}
