# Create a service account
resource "google_service_account" "service_account" {
  account_id   = var.name
  project = var.project_id
  display_name = "Service Account ${var.name}"
}

# Generate and output the service account key
resource "google_service_account_key" "service_account_key" {
  service_account_id = google_service_account.service_account.id
  private_key_type = "TYPE_GOOGLE_CREDENTIALS_FILE"  
}

# Save private key to a local file
resource "local_file" "service_account_key_file" {
  content  = google_service_account_key.service_account_key.private_key
  filename = "${var.name}_sa_key.json"  
}
