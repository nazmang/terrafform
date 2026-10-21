resource "cloudflare_zero_trust_access_policy" "people" {
  for_each = local.apps

  account_id       = var.account_id
  name             = "${each.value.name}: people"
  decision         = "allow"
  session_duration = each.value.session_duration
  include          = [for e in each.value.emails : { email = { email = e } }]
}

resource "cloudflare_zero_trust_access_service_token" "machine" {
  for_each = local.token_apps

  account_id = var.account_id
  name       = "${each.value.name}-machine"
  duration   = var.defaults.service_token_duration
}

resource "cloudflare_zero_trust_access_policy" "machine" {
  for_each = local.token_apps

  account_id = var.account_id
  name       = "${each.value.name}: machine"
  decision   = "non_identity"
  include    = [{ service_token = { token_id = cloudflare_zero_trust_access_service_token.machine[each.key].id } }]
}

resource "cloudflare_zero_trust_access_application" "app" {
  for_each = local.apps

  account_id           = var.account_id
  name                 = each.value.name
  type                 = "self_hosted"
  domain               = each.value.domain
  session_duration     = each.value.session_duration
  app_launcher_visible = false
  policies = concat(
    [{ id = cloudflare_zero_trust_access_policy.people[each.key].id, precedence = 1 }],
    each.value.service_token ? [{ id = cloudflare_zero_trust_access_policy.machine[each.key].id, precedence = 2 }] : [],
  )
}
