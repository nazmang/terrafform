# Cloudflare Zone Settings Module

Hardens Cloudflare zones: HTTP→HTTPS redirect at the edge and HSTS.

## Features

- **Multiple zones** from one module call, common settings in `defaults`
- **Always Use HTTPS** on by default: the edge answers plain HTTP with 301
- **HSTS** only when `hsts` is set; start with a short `max_age`, no preload

## Usage

```hcl
module "zone_settings" {
  source = "../../modules/cloudflare_zone_settings"

  defaults = {
    hsts = { max_age = 2592000 }
  }

  zones = {
    main = { zone_id = var.cloudflare_zone_id }
  }
}
```

Behind a cloudflared tunnel this is the only place to force HTTPS: the
tunnel talks to the ingress over plain HTTP, so `ssl-redirect` there loops.
