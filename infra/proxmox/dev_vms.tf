locals {
  dev_vms = {
    nas01 = {
      memory    = 4096
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
      memory = 8192
      cpu = {
        cores   = 2
        sockets = 2
      }
      ipconfig0 = "ip=10.163.11.101/24,gw=10.163.11.25"
      ipconfig1 = "ip=10.164.1.101/24"
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
        }
      ]
    },
    k8s02 = {
      memory = 8192
      cpu = {
        cores   = 2
        sockets = 2
      }
      ipconfig0 = "ip=10.163.11.102/24,gw=10.163.11.25"
      ipconfig1 = "ip=10.164.1.102/24"
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
    k8s03 = {
      memory = 8192
      cpu = {
        cores   = 2
        sockets = 2
      }
      ipconfig0 = "ip=10.163.11.103/24,gw=10.163.11.25"
      ipconfig1 = "ip=10.164.1.103/24"
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
      ipconfig0 = "ip=10.163.11.105/24,gw=10.163.11.25"
      ipconfig1 = "ip=10.164.1.105/24"
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
    }
  }
}

