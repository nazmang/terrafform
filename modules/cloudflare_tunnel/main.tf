resource "cloudflare_zero_trust_tunnel_cloudflared" "tunnel" {
  account_id    = var.account_id
  name          = var.tunnel_name
  tunnel_secret = local.tunnel_secret
  config_src    = "cloudflare"
  lifecycle {
    ignore_changes = [config_src]
  }
}

resource "cloudflare_zero_trust_tunnel_cloudflared_config" "config" {
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
  account_id = var.account_id
  config     = var.tunnel_config
}

# Optionally, create a public hostname
resource "cloudflare_dns_record" "hostname" {
  count   = var.create_dns_record ? 1 : 0
  zone_id = var.zone_id
  name    = "${var.tunnel_name}.${var.domain}"
  type    = var.zone_type
  content = local.zone_content
  ttl     = var.zone_ttl
  proxied = true
}

resource "random_string" "tunnel_secret" {
  length           = 32
  special          = true
  override_special = "!#$%&*()-_=+[]{}<>:?"
}

resource "local_file" "tunnel_secret_file" {
  content  = local.tunnel_secret
  filename = "${var.tunnel_name}_tunnel_secret.txt"
}

resource "local_file" "tunnel_token_file" {
  content  = data.cloudflare_zero_trust_tunnel_cloudflared_token.token.token
  filename = "${var.tunnel_name}_tunnel_token.txt"
}

data "cloudflare_zero_trust_tunnel_cloudflared_token" "token" {
  tunnel_id  = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
  account_id = var.account_id
}
