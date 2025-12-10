# Network configuration (optional, but commonly used)
resource "hcloud_network" "internal" {
  name                     = "internal-network"
  ip_range                 = "10.163.0.0/16"
  expose_routes_to_vswitch = true
  delete_protection        = true
}

resource "hcloud_network_subnet" "internal-subnet" {
  type         = "cloud"
  network_id   = hcloud_network.internal.id
  network_zone = "eu-central"
  ip_range     = "10.163.1.0/24"
}

# resource "hcloud_network_subnet" "internal-vswitch" {
#   type         = "vswitch"
#   network_id   = hcloud_network.internal.id
#   network_zone = "eu-central"
#   ip_range     = "10.163.11.0/24"
#   vswitch_id   = "55879"
# }
