output "service_account_key_path" {
  value = local_file.service_account_key_file.filename
}

output "service_account_name" {
  value = google_service_account.service_account.name
}

