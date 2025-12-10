# Dev-IL Proxmox Infrastructure

This environment provisions a set of development VMs on a Proxmox cluster using the `proxmox_vm` module.

## Structure

- VM definitions and defaults are managed in `dev_vms.tf` and `locals.tf`.
- The `main.tf` file instantiates the module for each VM defined in `local.dev_vms`.
- Provider configuration is in `provider.tf`.

## Usage

1. Copy `terraform.tfvars.sample` to `terraform.tfvars` and fill in your Proxmox API credentials.
2. Initialize and apply with Terraform:

   ```sh
   terraform init
   terraform apply
   ```

## Configuration

- `variables.tf` defines required variables for Proxmox API access (`pm_api_url`, `pm_user`, `pm_password`).
- `locals.tf` contains default VM settings (template, resources, network, etc.).
- `dev_vms.tf` lists the VMs to be created and their specific settings.

## Example `terraform.tfvars`

```hcl
pm_api_url = "https://proxmox.example.com:8006/api2/json"
pm_user    = "root@pam"
pm_password = "password"
```

## Provider

Uses the `Telmate/proxmox` provider, version `3.0.2-rc03`. 