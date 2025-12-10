module "cloudflare_tunnel_jenkins" {
  for_each      = local.cloudflare_tunnels
  source        = "../../modules/cloudflare_tunnel"
  account_id    = var.cloudflare_account_id
  zone_id       = var.cloudflare_zone_id
  zone_type     = each.value.zone_type
  tunnel_name   = each.key
  tunnel_config = each.value.tunnel_config
  domain        = var.cloudflare_domain_name
}

