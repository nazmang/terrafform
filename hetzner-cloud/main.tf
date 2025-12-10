provider "hcloud" {
  token = var.hcloud_token
}

resource "hcloud_ssh_key" "my_ssh_key" {
  name       = "my-ssh-key"
  public_key = file(var.ssh_public_key_path)
}

resource "hcloud_server" "main_server" {
  name        = "cx22-ubuntu-01"
  server_type = "cx22"
  image       = "ubuntu-22.04"
  ssh_keys    = [hcloud_ssh_key.my_ssh_key.id]

  location = "nbg1" # You can specify a different location if needed

  public_net {
    ipv4_enabled = true
    ipv4         = hcloud_primary_ip.main.id
    ipv6_enabled = true
  }

  network {
    network_id = hcloud_network.internal.id
    ip         = "10.163.1.5"
  }

  firewall_ids = [hcloud_firewall.basic-access.id]

  shutdown_before_deletion = true

  depends_on = [hcloud_network_subnet.internal-subnet-docker]

  lifecycle {
    ignore_changes = [
      ssh_keys,
      firewall_ids
    ]
  }

  labels = {
    "jumphost" = "true",
    "app"      = "docker",
    "role"     = "manager"
  }
}

resource "hcloud_server" "worker_server1" {
  name        = "cx32-ubuntu-02"
  server_type = "cx32"
  image       = "ubuntu-22.04"
  ssh_keys    = [hcloud_ssh_key.my_ssh_key.id]

  location = "nbg1" # You can specify a different location if needed

  public_net {
    ipv4_enabled = true
    ipv4         = hcloud_primary_ip.worker_server1.id
    ipv6_enabled = true
  }

  network {
    network_id = hcloud_network.internal.id
    ip         = "10.163.1.15"
  }

  firewall_ids = [hcloud_firewall.basic-access.id]

  shutdown_before_deletion = true

  depends_on = [hcloud_network_subnet.internal-subnet-docker]

  lifecycle {
    ignore_changes = [
      ssh_keys,
      firewall_ids
    ]
  }

  labels = {
    "jumphost" = "false",
    "app"      = "docker",
    "role"     = "worker"
  }
}

resource "hcloud_server" "worker_server2" {
  name        = "cx33-ubuntu-03"
  server_type = "cx33"
  image       = "ubuntu-22.04"
  ssh_keys    = [hcloud_ssh_key.my_ssh_key.id]

  location = "nbg1" # You can specify a different location if needed

  public_net {
    ipv4_enabled = true
    ipv4         = hcloud_primary_ip.worker_server2.id
    ipv6_enabled = true
  }

  network {
    network_id = hcloud_network.internal.id
    ip         = "10.163.1.16"
  }

  firewall_ids = [hcloud_firewall.basic-access.id]

  shutdown_before_deletion = true

  depends_on = [hcloud_network_subnet.internal-subnet-docker]

  lifecycle {
    ignore_changes = [
      ssh_keys,
      firewall_ids
    ]
  }

  labels = {
    "jumphost" = "false",
    "app"      = "docker",
    "role"     = "worker"
  }
}

data "hcloud_servers" "docker_servers" {
  with_selector = "app=docker"
  with_status   = ["running"]
}

data "hcloud_servers" "jumphost_servers" {
  with_selector = "jumphost=true"
  with_status   = ["running"]
}

# Apply a universal provisioner to all docker servers
resource "null_resource" "docker_provisioners" {

  for_each = { for server in data.hcloud_servers.docker_servers.servers : server.id => server }

  depends_on = [
    hcloud_server.main_server,
    hcloud_server.worker_server1,
    hcloud_server.worker_server2,
    data.hcloud_servers.docker_servers
  ]

  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.ssh_private_key_path)
    # host        = each.value.ipv4_address != "" ? each.value.ipv4_address : each.value.ipv6_address
    host = each.value.ipv4_address
  }

  provisioner "remote-exec" {
    inline = [
      "apt-get update",
      "apt-get install -y apt-transport-https ca-certificates curl software-properties-common",
      "curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -",
      "add-apt-repository --yes 'deb [arch=amd64] https://download.docker.com/linux/ubuntu focal stable'",
      "apt-get update",
      "apt-get install -y docker-ce",
    ]
  }
}

resource "null_resource" "jumphost_provisioners" {
  for_each = { for server in data.hcloud_servers.jumphost_servers.servers : server.id => server }
  # Optional: Add WireGuard provisioning conditionally based on server role
  connection {
    type        = "ssh"
    user        = var.ssh_user
    private_key = file(var.ssh_private_key_path)
    # host        = each.value.ipv4_address != "" ? each.value.ipv4_address : each.value.ipv6_address
    host = each.value.ipv4_address
  }
  provisioner "remote-exec" {
    inline = [
      "apt-get install -y wireguard",
      "${length(var.wg_private_key) > 0 ? "umask 077; echo ${var.wg_private_key} > /etc/wireguard/privatekey" : "umask 077; wg genkey | tee /etc/wireguard/privatekey"}",
      "wg pubkey < /etc/wireguard/privatekey > /etc/wireguard/publickey",
      "PRIVATE_KEY=$(cat /etc/wireguard/privatekey)",
      "echo \"[Interface]\" > /etc/wireguard/wg0.conf",
      "echo \"PrivateKey = $PRIVATE_KEY\" >> /etc/wireguard/wg0.conf",
      "echo \"Address = 172.22.0.7/24\" >> /etc/wireguard/wg0.conf",
      "echo \"ListenPort = 51820\" >> /etc/wireguard/wg0.conf",
      "echo \"[Peer]\" >> /etc/wireguard/wg0.conf",
      "echo \"PublicKey = ${var.remote_host_public_key}\" >> /etc/wireguard/wg0.conf",
      "echo \"AllowedIPs = ${join(",", var.remote_allowed_ips)}\" >> /etc/wireguard/wg0.conf",
      "echo \"Endpoint = ${var.remote_host_ip}:${var.remote_host_port}\" >> /etc/wireguard/wg0.conf",
      "systemctl enable --now wg-quick@wg0",
      "ping -c 5 172.22.0.1"
    ]
  }
}

resource "null_resource" "always_run" {
  triggers = {
    timestamp = "${timestamp()}"
  }
}

resource "null_resource" "wg_pub_key" {
  for_each = { for server in data.hcloud_servers.jumphost_servers.servers : server.id => server }

  depends_on = [
    null_resource.jumphost_provisioners
  ]
  # Fetch the public key from the remote server
  provisioner "local-exec" {
    command = <<EOT
      ssh -o StrictHostKeyChecking=no -i ${var.ssh_private_key_path} ${var.ssh_user}@${each.value.ipv4_address} 'cat /etc/wireguard/publickey' > ./wireguard_publickey_${each.value.id}.txt
    EOT
  }
}

# Read the public key files after they are created
data "external" "wg_public_keys" {
  for_each   = null_resource.wg_pub_key
  program    = ["bash", "-c", "PUBKEY=$(cat ./wireguard_publickey_${each.key}.txt 2>/dev/null | tr -d '\\n' || echo ''); echo \"{\\\"public_key\\\":\\\"$PUBKEY\\\"}\""]
  depends_on = [null_resource.wg_pub_key]
}

output "server_ipv4" {
  value = hcloud_server.main_server.ipv4_address
}

output "server_ipv6" {
  value = hcloud_server.main_server.ipv6_address
}

# Output the server's WireGuard public key
output "wireguard_public_key" {
  depends_on = [data.external.wg_public_keys]
  value = {
    for id, data in data.external.wg_public_keys : id => data.result.public_key
  }
}
