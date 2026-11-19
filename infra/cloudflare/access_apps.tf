# Admin UIs behind Cloudflare Access.
# zbx (PHP2Shell, 21.10.2026): Uptime Kuma checks it with the service token; the homepage widget and the duty
# agent use the internal API and do not go through Access.
# argocd, prom-k8s, alertmanager (pentest 15.10.2026): published by the cluster tunnel, before this only
# ArgoCD's own login and nginx basic-auth. The argocd CLI goes through `cloudflared access`.
# prom-k8s keeps a service token for the Grafana datasource on the Swarm stack.
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
    argocd = {
      domain = "argocd.${local.srvx_cc}"
    }
    prom_k8s = {
      name          = "prom-k8s"
      domain        = "prom-k8s.${local.srvx_cc}"
      service_token = true
    }
    alertmanager = {
      domain = "alertmanager.${local.srvx_cc}"
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
