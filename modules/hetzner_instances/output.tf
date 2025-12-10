output "server_ids" {
  description = "Map of instance keys to server IDs"
  value       = { for k, v in hcloud_server.instance : k => v.id }
}

output "server_ipv4_addresses" {
  description = "Map of instance keys to IPv4 addresses"
  value       = { for k, v in hcloud_server.instance : k => v.ipv4_address }
}

output "server_ipv6_addresses" {
  description = "Map of instance keys to IPv6 addresses"
  value       = { for k, v in hcloud_server.instance : k => v.ipv6_address }
}

output "firewall_ids" {
  description = "Map of firewall keys to firewall IDs"
  value       = { for k, v in hcloud_firewall.firewall : k => v.id }
}

output "servers" {
  description = "Complete server objects"
  value       = hcloud_server.instance
}

output "firewalls" {
  description = "Complete firewall objects"
  value       = hcloud_firewall.firewall
}

