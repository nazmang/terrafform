resource "cloudflare_dns_record" "zabbix_dns_record" {
  zone_id = var.cloudflare_zone_id
  name    = "zbx.${var.cloudflare_domain_name}"
  ttl     = 1
  type    = "CNAME"
  comment = "Domain record for Zabbix server"
  content = "5f179a96-7fd7-4998-97ce-64cfcb2e46db.cfargotunnel.com"
  proxied = true
}

resource "cloudflare_dns_record" "proxymgr_dns_record" {
  zone_id = var.cloudflare_zone_id
  name    = "proxymgr.${var.cloudflare_domain_name}"
  ttl     = 1
  type    = "CNAME"
  comment = "Domain record for proxymgr"
  content = "5f179a96-7fd7-4998-97ce-64cfcb2e46db.cfargotunnel.com"
  proxied = true
}

resource "cloudflare_dns_record" "portainer_dns_record" {
  zone_id = var.cloudflare_zone_id
  name    = "portainer.${var.cloudflare_domain_name}"
  ttl     = 1
  type    = "CNAME"
  comment = "Domain record for portainer"
  content = "5f179a96-7fd7-4998-97ce-64cfcb2e46db.cfargotunnel.com"
  proxied = true
}

resource "cloudflare_dns_record" "grafana_dns_record" {
  zone_id = var.cloudflare_zone_id
  name    = "grafana.${var.cloudflare_domain_name}"
  ttl     = 1
  type    = "CNAME"
  comment = "Domain record for grafana"
  content = "5f179a96-7fd7-4998-97ce-64cfcb2e46db.cfargotunnel.com"
  proxied = true
}

resource "cloudflare_dns_record" "prometheus_dns_record" {
  zone_id = var.cloudflare_zone_id
  name    = "prom.${var.cloudflare_domain_name}"
  ttl     = 1
  type    = "CNAME"
  comment = "Domain record for prometheus"
  content = "5f179a96-7fd7-4998-97ce-64cfcb2e46db.cfargotunnel.com"
  proxied = true
}

resource "cloudflare_dns_record" "opensearch_dns_record" {
  zone_id = var.cloudflare_zone_id
  name    = "os.${var.cloudflare_domain_name}"
  ttl     = 1
  type    = "CNAME"
  comment = "Domain record for OpenSearch"
  content = "5f179a96-7fd7-4998-97ce-64cfcb2e46db.cfargotunnel.com"
  proxied = true
}

resource "cloudflare_dns_record" "siem_dns_record" {
  zone_id = var.cloudflare_zone_id
  name    = "siem.${var.cloudflare_domain_name}"
  ttl     = 3600
  type    = "A"
  comment = "Domain record for SIEM"
  content = "95.217.42.189"
  proxied = false
}
