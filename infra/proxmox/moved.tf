# 02.11.2026: модуль proxmox_vm разделён — диски под Terraform у всех VM, кроме k8s
# (там диски PVC подключает Proxmox CSI). Ноды k8s переезжают в ресурс `csi`,
# остальные VM — неявно `this` → `this[0]` (появился count).

moved {
  from = module.dev_proxmox_vms["k8s01"].proxmox_vm_qemu.this
  to   = module.dev_proxmox_vms["k8s01"].proxmox_vm_qemu.csi[0]
}

moved {
  from = module.dev_proxmox_vms["k8s02"].proxmox_vm_qemu.this
  to   = module.dev_proxmox_vms["k8s02"].proxmox_vm_qemu.csi[0]
}

moved {
  from = module.dev_proxmox_vms["k8s03"].proxmox_vm_qemu.this
  to   = module.dev_proxmox_vms["k8s03"].proxmox_vm_qemu.csi[0]
}

moved {
  from = module.dev_proxmox_vms["k8s04"].proxmox_vm_qemu.this
  to   = module.dev_proxmox_vms["k8s04"].proxmox_vm_qemu.csi[0]
}
