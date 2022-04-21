variable "my_ssh_public_key" {
  type = string
  description = "Owner's SSH public key"
  default = ""
}

variable "my_ssh_private_key_file" {
  type = string
  description = "Owner's SSH private key"
  default = "~/.ssh/id_rsa.pub"
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
  type    = string
  default = "servername"
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
