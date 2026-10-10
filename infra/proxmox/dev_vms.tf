locals {
  dev_vms = {
    nas01 = {
      # NFS server for the cluster's nfs-client storage class. 4G left it with a
      # page cache too small for the write load; stalls there surfaced as
      # SQLite/Knex pool timeouts inside uptime-kuma.
      memory    = 8192
      ipconfig0 = "ip=10.163.11.100/24,gw=10.163.11.25"
      ipconfig1 = "ip=10.164.1.100/24"
      boot      = "order=scsi0"
      tags      = "dev,nas"
      disks = {
        scsi = {
          scsi0 = {
            disk = {
              backup  = true
              size    = "20G"
              storage = "vmdata_thin"
            }
          }
          scsi1 = {
            disk = {
              backup  = true
              size    = "50G"
              storage = "vmdata_thin"
            }
          }
        }
      }
      networks = [
        {
          id       = 0
          model    = "virtio"
          bridge   = "vmbr1"
          firewall = false
        },
        {
          id     = 1
          model  = "virtio"
          bridge = "vmbr0"
        }
      ]
    },
    k8s01 = {
      # control-plane + etcd (host-deployed). apiserver alone resides ~2G, and etcd
      # lives in system.slice where the scheduler cannot see it.
      memory = 16384
      cpu = {
        cores   = 2
        sockets = 2
      }
      ipconfig0 = "ip=10.163.11.101/24,gw=10.163.11.25"
      ipconfig1 = "ip=10.164.1.101/24"
      boot      = "order=scsi0"
      tags      = "dev,k8s"
      # control-plane + etcd: never rebooted by the provider on its own.
      automatic_reboot = false
      disks = {
        scsi = {
          scsi0 = {
            disk = {
              backup = true
              # 30G -> 50G on 2026-09-20 (grown online, see k8s03).
              size    = "50G"
              storage = "vmdata_thin"
            }
          }
        }
      }
      networks = [
        {
          id       = 0
          model    = "virtio"
          bridge   = "vmbr1"
          firewall = false
        },
        {
          id     = 1
          model  = "virtio"
          bridge = "vmbr0"
        }
      ]
    },
    k8s02 = {
      # control-plane + etcd. Was the node that hit SystemOOM (victim:
      # argocd-application-controller) on 2026-09-09.
      memory = 16384
      cpu = {
        cores   = 2
        sockets = 2
      }
      ipconfig0 = "ip=10.163.11.102/24,gw=10.163.11.25"
      ipconfig1 = "ip=10.164.1.102/24"
      boot      = "order=scsi0"
      tags      = "dev,k8s"
      # control-plane + etcd: never rebooted by the provider on its own.
      automatic_reboot = false
      disks = {
        scsi = {
          scsi0 = {
            disk = {
              backup = true
              # 30G -> 50G on 2026-09-20 (grown online, see k8s03).
              size    = "50G"
              storage = "vmdata_thin"
            }
          }
        }
      }
      networks = [
        {
          id       = 0
          model    = "virtio"
          bridge   = "vmbr1"
          firewall = false
        },
        {
          id     = 1
          model  = "virtio"
          bridge = "vmbr0"
      }]
    },
    k8s03 = {
      # etcd member and worker both -- carries vault, trivy and a minio pool on top
      # of etcd, and was the tightest node in the cluster.
      memory = 16384
      cpu = {
        cores   = 2
        sockets = 2
      }
      ipconfig0 = "ip=10.163.11.103/24,gw=10.163.11.25"
      ipconfig1 = "ip=10.164.1.103/24"
      boot      = "order=scsi0"
      tags      = "dev,k8s"
      # Never let the provider reboot this VM on its own: it carries an etcd
      # member, Vault, Prometheus and a MinIO pool. A disk grow is online; if
      # the provider ever thinks a change needs a reboot it may only flag
      # reboot_required, and the reboot is scheduled by hand.
      automatic_reboot = false
      disks = {
        scsi = {
          scsi0 = {
            disk = {
              backup = true
              # 30G -> 50G on 2026-09-20. 29G root was 83% full with 12G of containerd
              # layers; an image pull of ~1G could cross kubelet's 10% eviction
              # threshold (k8s01 did on 2026-09-20 06:10 UTC). Grown online:
              # provider resizes the Proxmox disk, then growpart + resize2fs on the
              # node. k8s01/k8s02 to follow one at a time.
              # 50G -> 80G on 2026-10-08: root 81% full, 56 pluggio images in
              # containerd (image GC only starts at 85%). Grown online, same way.
              size    = "80G"
              storage = "vmdata_thin"
            }
          }
        }
      }
      networks = [
        {
          id       = 0
          model    = "virtio"
          bridge   = "vmbr1"
          firewall = false
        },
        {
          id     = 1
          model  = "virtio"
          bridge = "vmbr0"
      }]
    },
    k8s04 = {
      memory = 8192
      cpu = {
        cores   = 2
        sockets = 2
      }
      ipconfig0 = "ip=10.163.11.104/24,gw=10.163.11.25"
      ipconfig1 = "ip=10.164.1.104/24"
      boot      = "order=scsi0"
      tags      = "dev,k8s"
      disks = {
        scsi = {
          scsi0 = {
            disk = {
              backup  = true
              size    = "30G"
              storage = "vmdata_thin"
            }
          }
        }
      }
      networks = [
        {
          id       = 0
          model    = "virtio"
          bridge   = "vmbr1"
          firewall = false
        },
        {
          id     = 1
          model  = "virtio"
          bridge = "vmbr0"
      }]
    },
    dkr01 = {
      memory = 4096
      cpu = {
        cores   = 2
        sockets = 1
      }
      ipconfig0        = "ip=10.163.11.105/24,gw=10.163.11.25"
      ipconfig1        = "ip=10.164.1.105/24"
      boot             = "order=scsi0"
      tags             = "dev,docker"
      automatic_reboot = false
      disks = {
        scsi = {
          scsi0 = {
            disk = {
              backup  = true
              size    = "60G"
              storage = "vmdata_thin"
            }
          }
        }
      }
      networks = [
        {
          id       = 0
          model    = "virtio"
          bridge   = "vmbr1"
          firewall = false
        },
        {
          id     = 1
          model  = "virtio"
          bridge = "vmbr0"
      }]
    },
    dkr02 = {
      memory = 8192
      cpu = {
        cores   = 2
        sockets = 2
      }
      ipconfig0 = "ip=10.163.11.106/24,gw=10.163.11.25"
      ipconfig1 = "ip=10.164.1.106/24"
      boot      = "order=scsi0"
      tags      = "dev,docker"
      disks = {
        scsi = {
          scsi0 = {
            disk = {
              backup  = true
              size    = "40G"
              storage = "vmdata_thin"
            }
          }
        }
      }
      networks = [
        {
          id       = 0
          model    = "virtio"
          bridge   = "vmbr1"
          firewall = false
        },
        {
          id     = 1
          model  = "virtio"
          bridge = "vmbr0"
      }]
    },
    dkr03 = {
      memory = 8192
      cpu = {
        cores   = 2
        sockets = 2
      }
      ipconfig0 = "ip=10.163.11.107/24,gw=10.163.11.25"
      ipconfig1 = "ip=10.164.1.107/24"
      boot      = "order=scsi0"
      tags      = "dev,docker"
      disks = {
        scsi = {
          scsi0 = {
            disk = {
              backup  = true
              size    = "40G"
              storage = "vmdata_thin"
            }
          }
        }
      }
      networks = [
        {
          id       = 0
          model    = "virtio"
          bridge   = "vmbr1"
          firewall = false
        },
        {
          id     = 1
          model  = "virtio"
          bridge = "vmbr0"
      }]
    },
    wazuh01 = {
      memory = 8192
      cpu = {
        cores   = 2
        sockets = 2
      }
      ipconfig0 = "ip=10.163.11.108/24,gw=10.163.11.25"
      ipconfig1 = "ip=10.164.1.108/24"
      boot      = "order=scsi0"
      tags      = "dev,security"
      disks = {
        scsi = {
          scsi0 = {
            disk = {
              backup  = true
              size    = "40G"
              storage = "vmdata_thin"
            }
          }
        }
      }
      networks = [
        {
          id       = 0
          model    = "virtio"
          bridge   = "vmbr1"
          firewall = false
        },
        {
          id     = 1
          model  = "virtio"
          bridge = "vmbr0"
      }]
    }
  }
}

