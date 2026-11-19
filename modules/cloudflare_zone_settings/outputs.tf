output "always_use_https" {
  value = { for k, s in cloudflare_zone_setting.always_use_https : k => s.value }
}
