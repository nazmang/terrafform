terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.0.0"
    }   
    null = {
      version = ">=3.0"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token      = var.do_token
}

# Add my personal key
resource "digitalocean_ssh_key" "owners_key" {
  name       = "My own SSH key"
  public_key = var.my_ssh_public_key
}

data "digitalocean_domain" "default" {
  name = var.domain_name
}

# Check is Windows/Linux
locals {
  is_windows = substr(pathexpand("~"), 0, 1) == "/" ? false : true
}

# Create a new Droplet(s) using the SSH key
resource "digitalocean_droplet" "default" {
  image      = "ubuntu-20-04-x64"
  name       = var.devs
  region     = var.do_region
  size       = "s-1vcpu-1gb"
  resize_disk  = true
  ssh_keys = [
    digitalocean_ssh_key.owners_key.fingerprint
    ]
  connection {
    host = self.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.my_ssh_private_key_file)
    timeout = "5m"
  }  
  provisioner "remote-exec" {
    inline = [<<EOF
        sudo hostnamectl set-hostname zeus.${var.domain_name}
        apt-get -yqq update && apt-get -yqq install curl wget
        curl -sSL https://repos.insights.digitalocean.com/install.sh | sudo bash
        VPN_IPSEC_PSK='${var.vpn_ipsec_psk}'; \
        VPN_USER='${var.vpn_user}'; \
        VPN_PASSWORD='${var.vpn_password}'; \
        curl -sSL https://git.io/vpnsetup | sh
        export AUTO_INSTALL=y; curl -Ss  https://raw.githubusercontent.com/angristan/openvpn-install/master/openvpn-install.sh | bash
        EOF 
    ]
  }
  tags       = [
    "vpn"
  ]
}

# Add an A record to the domain for VPN
resource "digitalocean_record" "vpn" {
  domain = data.digitalocean_domain.default.id
  type   = "A"
  name   = "zeus"
  ttl    = 600
  value  = digitalocean_droplet.default.ipv4_address
}

locals {
  bash       = "scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${var.my_ssh_private_key_file} root@${digitalocean_record.vpn.fqdn}:*vpn* ."
  powershell = "{ scp -o StrictHostKeyChecking=no -o UserKnownHostsFile=/dev/null -i ${var.my_ssh_private_key_file} root@${digitalocean_record.vpn.fqdn}:*vpn* . }"
}

# Copy configuration files to local machine and set up VPN
resource "null_resource" "default" {
  depends_on = [digitalocean_droplet.default, digitalocean_record.vpn]
  
  provisioner "local-exec" {
    interpreter = local.is_windows ? ["PowerShell", "-Command"] : []
    command = local.is_windows ?  local.powershell : local.bash
  }
}

output "server_ip" {
  value = digitalocean_droplet.default.ipv4_address
}

output "server_fqdn" {
  value = digitalocean_record.vpn.fqdn 
}