output "vm_id" {
  value = local.vm.id
}

output "vm_name" {
  value = local.vm.name
}

output "ip_addresses" {
  value       = local.vm.default_ipv4_address
  description = "Main IPv4 address (if available)"
}
