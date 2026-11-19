# Always Use HTTPS + HSTS on srvx.cc (pentest 15.10.2026): the cluster tunnel serves every host there and
# plain http:// answered 200, basic-auth included. The ingress cannot redirect behind the tunnel.
# srvxapp.com is left alone for now: siem/pve01 records there are DNS-only.
data "cloudflare_zone" "srvx_cc" {
  filter = { name = local.srvx_cc }
}

module "zone_settings" {
  source = "../../modules/cloudflare_zone_settings"

  defaults = {
    hsts = { max_age = 2592000 }
  }

  zones = {
    srvx_cc = { zone_id = data.cloudflare_zone.srvx_cc.zone_id }
  }
}
