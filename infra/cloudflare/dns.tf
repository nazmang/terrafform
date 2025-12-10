resource "cloudflare_dns_record" "zabbix_dns_record" {
  zone_id = var.cloudflare_zone_id
  name = "zbx"
  ttl = 1
  type = "CNAME"
  comment = "Domain record for Zabbix server"
  content = "5f179a96-7fd7-4998-97ce-64cfcb2e46db.cfargotunnel.com"
  proxied = true
}

resource "cloudflare_dns_record" "proxymgr_dns_record" {
  zone_id = var.cloudflare_zone_id
  name = "proxymgr"
  ttl = 1
  type = "CNAME"
  comment = "Domain record for proxymgr"
  content = "5f179a96-7fd7-4998-97ce-64cfcb2e46db.cfargotunnel.com"
  proxied = true
}