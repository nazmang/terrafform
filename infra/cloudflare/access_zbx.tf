# zabbix-web behind Cloudflare Access (PHP2Shell, 21.10.2026). Uptime Kuma checks it with the service token.
# The homepage widget and the duty agent use the internal API and do not go through Access.
module "access_apps" {
  source     = "../../modules/cloudflare_access_app"
  account_id = var.cloudflare_account_id

  defaults = {
    emails = var.pluggio_owner_emails
  }

  apps = {
    zbx = {
      name          = "zabbix"
      domain        = "zbx.${var.cloudflare_domain_name}"
      service_token = true
    }
  }
}

output "access_aud" {
  value = module.access_apps.aud
}

output "access_service_token_client_ids" {
  value = module.access_apps.service_token_client_ids
}

output "access_service_token_client_secrets" {
  value     = module.access_apps.service_token_client_secrets
  sensitive = true
}
