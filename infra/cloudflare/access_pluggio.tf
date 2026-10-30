# pluggio behind Cloudflare Access: the owner by email, the toy bridge and the big PC's GPU agent by service tokens.
# The server checks the same JWT itself (aud below), so traffic that skips Access is refused too.

resource "cloudflare_zero_trust_access_service_token" "pluggio_bridge" {
  account_id = var.cloudflare_account_id
  name       = "pluggio-bridge"
  duration   = "8760h"
}

# The GPU agent on the big PC (pluggio contracts.md, «Агент GPU на ПК»): the server opens only /ws/gpu with it.
resource "cloudflare_zero_trust_access_service_token" "pluggio_gpu" {
  account_id = var.cloudflare_account_id
  name       = "pluggio-gpu"
  duration   = "8760h"
}

resource "cloudflare_zero_trust_access_policy" "pluggio_owner" {
  account_id       = var.cloudflare_account_id
  name             = "pluggio: owner"
  decision         = "allow"
  session_duration = "720h"
  include          = [for e in var.pluggio_owner_emails : { email = { email = e } }]
}

resource "cloudflare_zero_trust_access_policy" "pluggio_bridge" {
  account_id = var.cloudflare_account_id
  name       = "pluggio: bridge"
  decision   = "non_identity"
  include    = [{ service_token = { token_id = cloudflare_zero_trust_access_service_token.pluggio_bridge.id } }]
}

resource "cloudflare_zero_trust_access_policy" "pluggio_gpu" {
  account_id = var.cloudflare_account_id
  name       = "pluggio: gpu"
  decision   = "non_identity"
  include    = [{ service_token = { token_id = cloudflare_zero_trust_access_service_token.pluggio_gpu.id } }]
}

resource "cloudflare_zero_trust_access_application" "pluggio" {
  account_id           = var.cloudflare_account_id
  name                 = "pluggio"
  type                 = "self_hosted"
  domain               = var.pluggio_domain
  session_duration     = "720h"
  app_launcher_visible = false
  policies = [
    { id = cloudflare_zero_trust_access_policy.pluggio_owner.id, precedence = 1 },
    { id = cloudflare_zero_trust_access_policy.pluggio_bridge.id, precedence = 2 },
    { id = cloudflare_zero_trust_access_policy.pluggio_gpu.id, precedence = 3 },
  ]
}

output "pluggio_access_aud" {
  value = cloudflare_zero_trust_access_application.pluggio.aud
}

output "pluggio_bridge_client_id" {
  value = cloudflare_zero_trust_access_service_token.pluggio_bridge.client_id
}

output "pluggio_bridge_client_secret" {
  value     = cloudflare_zero_trust_access_service_token.pluggio_bridge.client_secret
  sensitive = true
}

output "pluggio_gpu_client_id" {
  value = cloudflare_zero_trust_access_service_token.pluggio_gpu.client_id
}

output "pluggio_gpu_client_secret" {
  value     = cloudflare_zero_trust_access_service_token.pluggio_gpu.client_secret
  sensitive = true
}

# /ref/<token>.jpg — a reference picture for the image service (nanobananaapi.ai fetches it by URL). Access is
# bypassed only for this path; the server opens each picture by a one-off token that lives ten minutes.
resource "cloudflare_zero_trust_access_policy" "pluggio_ref" {
  account_id = var.cloudflare_account_id
  name       = "pluggio: image references"
  decision   = "bypass"
  include    = [{ everyone = {} }]
}

resource "cloudflare_zero_trust_access_application" "pluggio_ref" {
  account_id           = var.cloudflare_account_id
  name                 = "pluggio refs"
  type                 = "self_hosted"
  domain               = "${var.pluggio_domain}/ref"
  app_launcher_visible = false
  policies = [
    { id = cloudflare_zero_trust_access_policy.pluggio_ref.id, precedence = 1 },
  ]
}
