output "aud" {
  description = "Access application audience tag per app, for servers that check the JWT themselves."
  value       = { for k, a in cloudflare_zero_trust_access_application.app : k => a.aud }
}

output "service_token_client_ids" {
  value = { for k, t in cloudflare_zero_trust_access_service_token.machine : k => t.client_id }
}

# Read with `terraform output -json service_token_client_secrets | jq -r .<key>` piped to where it is needed, never printed.
output "service_token_client_secrets" {
  value     = { for k, t in cloudflare_zero_trust_access_service_token.machine : k => t.client_secret }
  sensitive = true
}
