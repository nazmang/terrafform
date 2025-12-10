# Manager instances outputs
output "manager_server_ipv4_addresses" {
  description = "IPv4 addresses of manager servers"
  value = merge([
    for k, v in module.manager_instances : v.server_ipv4_addresses
  ]...)
}

output "manager_server_ids" {
  description = "IDs of manager servers"
  value = merge([
    for k, v in module.manager_instances : { for sk, sv in v.server_ids : "${k}-${sk}" => sv }
  ]...)
}

# Worker instances outputs
output "worker_server_ipv4_addresses" {
  description = "IPv4 addresses of worker servers"
  value = merge([
    for k, v in module.worker_instances : v.server_ipv4_addresses
  ]...)
}

output "worker_server_ids" {
  description = "IDs of worker servers"
  value = merge([
    for k, v in module.worker_instances : { for sk, sv in v.server_ids : "${k}-${sk}" => sv }
  ]...)
}

# Web instances outputs
output "web_server_ipv4_addresses" {
  description = "IPv4 addresses of web servers"
  value = merge([
    for k, v in module.web_instances : v.server_ipv4_addresses
  ]...)
}

output "web_server_ids" {
  description = "IDs of web servers"
  value = merge([
    for k, v in module.web_instances : { for sk, sv in v.server_ids : "${k}-${sk}" => sv }
  ]...)
}

# Database instances outputs
output "db_server_ipv4_addresses" {
  description = "IPv4 addresses of database servers"
  value = merge([
    for k, v in module.db_instances : v.server_ipv4_addresses
  ]...)
}

output "db_server_ids" {
  description = "IDs of database servers"
  value = merge([
    for k, v in module.db_instances : { for sk, sv in v.server_ids : "${k}-${sk}" => sv }
  ]...)
}

# Combined outputs
output "all_server_ipv4_addresses" {
  description = "IPv4 addresses of all servers"
  value = merge(
    merge([for k, v in module.manager_instances : v.server_ipv4_addresses]...),
    merge([for k, v in module.worker_instances : v.server_ipv4_addresses]...),
    merge([for k, v in module.web_instances : v.server_ipv4_addresses]...),
    merge([for k, v in module.db_instances : v.server_ipv4_addresses]...)
  )
}

output "all_server_ids" {
  description = "IDs of all servers"
  value = merge(
    merge([for k, v in module.manager_instances : { for sk, sv in v.server_ids : "${k}-${sk}" => sv }]...),
    merge([for k, v in module.worker_instances : { for sk, sv in v.server_ids : "${k}-${sk}" => sv }]...),
    merge([for k, v in module.web_instances : { for sk, sv in v.server_ids : "${k}-${sk}" => sv }]...),
    merge([for k, v in module.db_instances : { for sk, sv in v.server_ids : "${k}-${sk}" => sv }]...)
  )
}

# Main server IP (first manager instance)
output "main_server_ip" {
  description = "IPv4 address of the main server"
  value = try(
    module.manager_instances["main"].server_ipv4_addresses["main"],
    null
  )
}
