# Cloudflare Access Application Module

Puts self-hosted apps behind Cloudflare Access. Each app gets a policy for
people by email and, when asked, a service token for machines (monitoring).

## Features

- **Multiple apps** from one module call, common settings in `defaults`
- **People** allowed by email, session 720h by default
- **Service token** per app on `service_token = true`, allowed by a
  `non_identity` policy; the secret lives only in the state

## Usage

```hcl
module "access_apps" {
  source     = "../../modules/cloudflare_access_app"
  account_id = var.cloudflare_account_id

  defaults = {
    emails = var.access_owner_emails
  }

  apps = {
    zbx = {
      domain        = "zbx.example.com"
      service_token = true
    }
  }
}
```

A machine sends both headers on every request:
`CF-Access-Client-Id` and `CF-Access-Client-Secret`.
