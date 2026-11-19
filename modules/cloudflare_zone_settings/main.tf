resource "cloudflare_zone_setting" "always_use_https" {
  for_each = local.zones

  zone_id    = each.value.zone_id
  setting_id = "always_use_https"
  value      = each.value.always_use_https ? "on" : "off"
}

# HSTS is sent by the Cloudflare edge on every proxied response, so each proxied host gets it.
# Hosts that are DNS-only (not proxied) never see the header.
resource "cloudflare_zone_setting" "hsts" {
  for_each = local.hsts_zones

  zone_id    = each.value.zone_id
  setting_id = "security_header"
  value = {
    strict_transport_security = {
      enabled            = true
      max_age            = each.value.hsts.max_age
      include_subdomains = each.value.hsts.include_subdomains
      preload            = each.value.hsts.preload
      nosniff            = true
    }
  }
}
