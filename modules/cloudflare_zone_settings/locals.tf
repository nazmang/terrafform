locals {
  zones = {
    for k, z in var.zones : k => {
      zone_id          = z.zone_id
      always_use_https = coalesce(z.always_use_https, var.defaults.always_use_https)
      hsts             = z.hsts != null ? z.hsts : var.defaults.hsts
    }
  }

  hsts_zones = { for k, z in local.zones : k => z if z.hsts != null }
}
