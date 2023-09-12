terraform {
  required_version = ">= 1.1.0"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.0.0"
    }   
    null = {
      version = ">= 3.0"
    }
  }
  # backend "etcdv3" {
  #   endpoints = ["etcd:2379"]
  #   lock      = true
  #   prefix    = "tf-state_do-simple/"
  # }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token      = var.do_token
}

# Get existing key
data "digitalocean_ssh_key" "existing_keys" {
  name       = var.existing_ssh_key
}

# Add my personal key
resource "digitalocean_ssh_key" "others_key" {
  name       = "REBRAIN.SSH.PUB.KEY"
  public_key = var.others_ssh_public_key
}

# Get domain info
data "digitalocean_domain" "default" {
  name = var.domain_name
}

# Create a new Droplet(s) using the SSH key
resource "digitalocean_droplet" "default" {
  count      = length(var.devs)
  image      = "ubuntu-20-04-x64"
  name       = var.devs[count.index]
  region     = var.do_region
  size       = "s-1vcpu-1gb"
  resize_disk  = true
  ssh_keys = [
    digitalocean_ssh_key.others_key.fingerprint,
    data.digitalocean_ssh_key.existing_keys.fingerprint
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
        sudo hostnamectl set-hostname ${self.name}.${var.domain_name}
        apt-get -yqq update && apt-get -yqq install curl wget git net-tools
        curl -sSL https://repos.insights.digitalocean.com/install.sh | sudo bash
        EOF 
    ]
  }
  tags       =  var.tags
}

# Add an A record to the domain for Droplet(s)
resource "digitalocean_record" "default" {
  count  = length(var.devs)
  domain = data.digitalocean_domain.default.id
  type   = "A"
  name   = var.devs[count.index]
  ttl    = 600
  value  = digitalocean_droplet.default[count.index].ipv4_address
}

# Create an inventory file for Ansible
resource "local_file" "ansible_inventory" {
  content = templatefile ("inventory.tpl", 
   {
     droplet_ip_address = digitalocean_droplet.default[*].ipv4_address,
     droplet_names = var.devs,
     droplet_domain = data.digitalocean_domain.default.name
     droplet_user = var.droplet_user
   }
  )
  filename = "inventory/inventory"
}

# Apply playbook to all droplet(s)
resource "null_resource" "ansible_play" {
  depends_on = [digitalocean_droplet.default, digitalocean_record.default]
  
  provisioner "local-exec" {
    command = "ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook  -i inventory/inventory --private-key ${var.my_ssh_private_key_file} install_nginx.yaml"
  }
}

# Command(s) to be applied on slave nodes only 
resource "null_resource" "jenkins_install" {
  depends_on = [digitalocean_droplet.default, digitalocean_record.default]
  for_each = { for droplet in digitalocean_droplet.default: droplet.name => droplet if strcontains(droplet.name, "slave") } 
  connection {
    host = each.value.ipv4_address
    user = "root"
    type = "ssh"
    private_key = file(var.my_ssh_private_key_file)
    timeout = "5m"
  }  
  
  provisioner "remote-exec" {
    inline = [
      "apt-get -yqq update && apt-get -yqq install openjdk-11-jre-headless",
      "curl -s https://deb.nodesource.com/gpgkey/nodesource.gpg.key | gpg --dearmor | tee /usr/share/keyrings/nodesource.gpg >/dev/null",
      "echo 'deb [signed-by=/usr/share/keyrings/nodesource.gpg] https://deb.nodesource.com/node_18.x focal main' > /etc/apt/sources.list.d/nodesource.list",
      "apt-get -yqq update && apt-get -yqq install nodejs",
      ]
  }
}

output "server_ip" {
  value = digitalocean_droplet.default.*.ipv4_address
}

output "server_fqdn" {
  value = digitalocean_record.default.*.fqdn 
}
