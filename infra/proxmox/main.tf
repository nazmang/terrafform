module "dev_proxmox_vms" {
  for_each = local.dev_vms
  source   = "../../modules/proxmox_vm"

  name      = each.key
  defaults  = local.dev_vm_defaults
  overrides = each.value
}