output "tunnel_id" {
  description = "The ID of the Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.tunnel.id
}

output "tunnel_name" {
  description = "The name of the Cloudflare Tunnel"
  value       = cloudflare_zero_trust_tunnel_cloudflared.tunnel.name
}

output "dns_record" {
  description = "Hostname for accessing the tunnel"
  value       = var.create_dns_record ? cloudflare_dns_record.hostname[0].name : "DNS record not created"
}

output "tunnel_secret" {
  description = "Randomly generated tunnel secret"
  value       = local.tunnel_secret
}

output "tunnel_token" {
  description = "Cloudflare tunnel token"
  value       = data.cloudflare_zero_trust_tunnel_cloudflared_token.token.token
}
