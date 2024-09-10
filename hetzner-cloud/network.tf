resource "hcloud_primary_ip" "main" {
name          = "primary_ip_main"
datacenter    = "nbg1-dc3"
type          = "ipv4"
assignee_type = "server"
auto_delete   = false
  labels = {
    "dc" : "nuremberg"
    "permanent" : "yes"
  }
}

resource "hcloud_primary_ip" "worker_server1" {
  name = "worker_server1"
  datacenter    = "nbg1-dc3"
  type          = "ipv4"
  assignee_type = "server"
  auto_delete   = true
  labels = {
    "dc" : "nuremberg"
    "permanent" : "no"
  }
}

resource "hcloud_network" "internal" {
  name     = "network"
  ip_range = "10.163.0.0/16"
  expose_routes_to_vswitch = true
  delete_protection = true
}

resource "hcloud_network_subnet" "internal-subnet-docker" {
  type         = "cloud"
  network_id   = hcloud_network.internal.id
  network_zone = "eu-central"
  ip_range     = "10.163.1.0/24"
}

resource "hcloud_network_route" "privNet" {
  for_each   = toset(var.remote_allowed_ips) # Converts the list into a set to avoid duplicates
  network_id = hcloud_network.internal.id
  destination = each.value # Use each.value to get the IPs from the list
  gateway     = "10.163.1.5" # Use the appropriate gateway IP
}

resource "hcloud_firewall" "basic-access" {
  name = "my-firewall"
  rule {
    description = "Allow inbound ICMP"
    direction = "in"
    protocol  = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    description = "Allow inbound SSH"
    direction = "in"
    protocol  = "tcp"
    port      = "22"
    source_ips = var.firewall_allowed_ips
  }

  rule {
    description = "Allow inbound Wireguard"
    direction = "in"
    protocol  = "udp"
    port      = "51820"
    source_ips = var.firewall_allowed_ips
  }

  rule {
    description = "Allow TCP in Local Network"
    direction = "in"
    protocol = "tcp"
    port = "any"
    source_ips = [ 
        "10.163.1.0/24",
        "172.22.0.0/24"
    ]
  }

}