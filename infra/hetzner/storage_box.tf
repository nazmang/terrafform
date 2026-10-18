# Storage Box for Proxmox Backup Server (pbs01 on pve01).
# pve01 is a dedicated server in hel1, so the box lives there too: free
# traffic and sub-millisecond latency. PBS mounts it over SMB with the
# "pbs01" subaccount; backups are encrypted on pve01 before upload.
module "storage_boxes" {
  source = "../../modules/hetzner_storage_box"

  defaults = {
    storage_box_type = "bx11"
    location         = "hel1"
  }

  storage_boxes = {
    pbs = {
      name = "pbs"
      # The main account is for admin over SSH (port 23) only.
      ssh_keys = [file(var.storage_box_ssh_public_key_path)]
      access_settings = {
        # pbs01 egresses via pve01's Hetzner IP, nothing else needs it.
        reachable_externally = false
        ssh_enabled          = true
      }
      # Daily snapshots out of reach of the subaccount: if pve01/pbs01 is
      # compromised and the datastore wiped, the chunks are still here.
      snapshot_plan = {
        max_snapshots = 7
        minute        = 0
        hour          = 3
      }
      labels = {
        "app"  = "pbs"
        "host" = "pve01"
      }
      subaccounts = {
        pbs01 = {
          home_directory = "pbs"
          description    = "PBS datastore for pbs01 (CIFS mount)"
          access_settings = {
            samba_enabled = true
          }
          labels = {
            "app" = "pbs"
          }
        }
      }
    }
  }
}
