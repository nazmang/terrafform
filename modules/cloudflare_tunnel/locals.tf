locals {
  tunnel_secret = coalesce(var.tunnel_secret, base64encode(random_string.tunnel_secret.result))
  zone_content  = coalesce(var.zone_content, var.zone_type == "CNAME" ? "${cloudflare_zero_trust_tunnel_cloudflared.tunnel.id}.cfargotunnel.com" : null)
}
