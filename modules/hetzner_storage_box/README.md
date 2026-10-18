# Hetzner Storage Box Module

Creates Hetzner Storage Boxes and their subaccounts. Follows the defaults
pattern of `hetzner_instances`: common settings go to `defaults`, any box
can set its own value.

## Features

- **Multiple boxes** from one module call, each with its own subaccounts
- **Generated passwords**: `random_password` per account, kept only in the state
- **Safe by default**: delete protection and `prevent_destroy`, every
  protocol off and no external access unless enabled
- **SSH keys** are set only at creation (the API cannot change them)

## Usage

```hcl
module "storage_boxes" {
  source = "../../modules/hetzner_storage_box"

  defaults = {
    storage_box_type = "bx11"
    location         = "hel1"
  }

  storage_boxes = {
    pbs = {
      name     = "pbs"
      ssh_keys = [file("~/.ssh/hetzner_ed25519.pub")]
      access_settings = { ssh_enabled = true }
      subaccounts = {
        pbs01 = {
          home_directory  = "pbs"
          access_settings = { samba_enabled = true }
        }
      }
    }
  }
}
```

## Outputs

- `storage_boxes`, `subaccounts`: id, server (FQDN), username
- `storage_box_passwords`, `subaccount_passwords` (sensitive): pipe with
  `terraform output -json … | jq -r '."pbs/pbs01"'`, never print
