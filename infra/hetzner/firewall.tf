# Firewall (created separately to avoid circular dependency)
resource "hcloud_firewall" "basic_access" {
  name = "basic-access-firewall"

  rule {
    description = "Allow inbound ICMP"
    direction   = "in"
    protocol    = "icmp"
    source_ips = [
      "0.0.0.0/0",
      "::/0"
    ]
  }

  rule {
    description = "Allow inbound SSH"
    direction   = "in"
    protocol    = "tcp"
    port        = "22"
    source_ips  = var.firewall_allowed_ips
  }

  rule {
    description = "Allow inbound Wireguard"
    direction   = "in"
    protocol    = "udp"
    port        = "51820"
    source_ips  = var.firewall_allowed_ips
  }

  rule {
    description = "Allow TCP in Local Network"
    direction   = "in"
    protocol    = "tcp"
    port        = "any"
    source_ips = [
      "10.163.1.0/24",
      "172.22.0.0/24"
    ]
  }

  labels = {
    "environment" = "production"
  }
}