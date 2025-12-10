locals {
  dev_vm_defaults = {
    memory        = 2048
    template_name = "ubuntu-24.04-cloudinit"
    full_clone    = true
    os_type       = "cloud-init"
    bootdisk      = "scsi0"
    agent         = 1
    ciuser        = "${var.root_user}"
    cipassword    = "${var.root_user_password}"
    # See https://registry.terraform.io/providers/Telmate/proxmox/latest/docs/guides/cloud-init%2520getting%2520started
    cicustom         = "vendor=local:snippets/qemu-guest-agent.yml" # /var/lib/vz/snippets/qemu-guest-agent.yml
    ciupgrade        = true
    sshkeys          = <<EOF
ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCw52kAIVSBiJzf9pDc0mvn1YtGOjJg7PmkJuNPd5vZYONoLS7Tygm0bqZSmURHF4Wsadkkp9fJ3QdBTYB1sS6NRoTOLbziHXc57PdV+ENSRl4VjWnrwul5L9VmLZfdnvSvsxyL10LYVYxTN+Ww564V+NNTuLSpWsAmRVKleaQiS5GIjOH3Zbj+mF2npVW5pozQUvKtH3PdS++NC1Ic0BBdOU8Wl165EdJrg02jgJoR8PC2jWbf5PwuqiZ9Vy6itMV9S63E3ZqSTDfsMHJgt+kzYmqXZx22gh1F4/6O+a/0cP7/L6nQmF7eMsJY8R6VfJc2AdjH4r/gMGhbxPXxyQql
EOF
    vm_state         = "running"
    automatic_reboot = true
    pool             = ""
    tags             = "dev"
    target_node      = "pve01"
    scsihw           = "virtio-scsi-pci"
    searchdomain     = "comintern.local"
    nameserver       = "8.8.8.8 1.1.1.1"
    skip_ipv6        = true
    onboot           = true

    cpu = {
      cores   = 2
      sockets = 1
    }

    disks = {
      ide = {
        # Some images require a cloud-init disk on the IDE controller, others on the SCSI or SATA controller
        ide1 = {
          cloudinit = {
            storage = "vmdata_thin"
          }
        }
      }
      scsi = {
        scsi0 = {
          disk = {
            backup  = true
            size    = "20G"
            storage = "vmdata_thin"
          }
        }
      }
      virtio = {}
      sata   = {}
    }

    networks = [
      {
        id       = 0
        model    = "virtio"
        bridge   = "vmbr0"
        firewall = false
      }
    ]
  }
}
