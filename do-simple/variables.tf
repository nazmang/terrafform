variable "my_ssh_public_key" {
  type = string
  description = "Owner's SSH public key"
  default = ""
}

variable "my_ssh_private_key_file" {
  type = string
  description = "Owner's SSH private key"
  default = "~/.ssh/id_rsa"
}

variable "existing_ssh_key" {
  type = string
  description = "Exsting SSH key in DO team"
  default = ""
}

variable "do_token" {
  type = string
  description = "Digital Ocean access token"
  default =""
}

variable "do_region" {
  type = string
  default = "nyc1"
}

variable "devs" {
  type    = list
  description = "List of droplet names to create"
  default = ["servername"]
}

variable "tags" {
  type = list
  description = "List of tags for droplets"
  default = ["test"]
}

variable "droplet_user" {
  type = string
  description = "Ansble user to connect with"
  default = "root"
}

variable "domain_name" {
  type  = string
  default="nip.io"
}

variable "vpn_user" {
  type = string
  default = ""
}

variable "vpn_password" {
  type = string
  default = ""
}

variable "vpn_ipsec_psk" {
  type = string
  default = ""
}
