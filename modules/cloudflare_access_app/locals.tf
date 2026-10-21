locals {
  apps = {
    for k, a in var.apps : k => {
      name             = coalesce(a.name, k)
      domain           = a.domain
      emails           = coalesce(a.emails, var.defaults.emails)
      session_duration = coalesce(a.session_duration, var.defaults.session_duration)
      service_token    = a.service_token
    }
  }

  token_apps = { for k, a in local.apps : k => a if a.service_token }
}
