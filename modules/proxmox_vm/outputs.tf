output "vm_id" {
  value = proxmox_vm_qemu.this.id
}

output "vm_name" {
  value = proxmox_vm_qemu.this.name
}

output "ip_addresses" {
  value       = proxmox_vm_qemu.this.default_ipv4_address
  description = "Main IPv4 address (if available)"
}
