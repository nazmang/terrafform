# Create a new GCP project
resource "google_project" "bucket_access_project" {
  name       = var.project_name
  project_id = var.project_id
  org_id     = var.org_id
  billing_account = var.billing_account
}

module "backup_bucket_sa" {
  for_each = local.iam_backup_sa
  source = "../../modules/iam_service_accounts"

  project_id = var.project_id
  name = each.key
}

module "data_bucket_sa" {
  for_each = local.iam_data_sa
  source = "../../modules/iam_service_accounts"

  project_id = var.project_id
  name = each.key
}


module "gcs_backup_buckets" {
  for_each = local.gcs_backup_buckets
  source = "../../modules/gcs_buckets"

  name = each.key
  project_id = var.project_id
  defaults = local.gcs_backup_bucket_defaults
  overrides = each.value
  owners =  { for sa in module.backup_bucket_sa.service_account_name : sa.account_id => sa.name }

}

module "gcs_data_buckets" {
  for_each = local.gcs_data_buckets
  source = "../../modules/gcs_buckets"

  name = each.key
  project_id = var.project_id
  defaults = local.gcs_data_bucket_defaults
  overrides = each.value
  owners = [
    "serviceAccount:${google_service_account.bucket_service_account.email}"
  ]

}

# Create a service account
resource "google_service_account" "bucket_service_account" {
  account_id   = "bucket-access-sa"
  display_name = "Service Account for Bucket Access"
}

# Generate and output the service account key
resource "google_service_account_key" "bucket_key" {
  service_account_id = google_service_account.bucket_service_account.id
  private_key_type = "TYPE_GOOGLE_CREDENTIALS_FILE"  
}

# Save private key to a local file
resource "local_file" "bucket_service_account_key" {
  content  = google_service_account_key.bucket_key.private_key
  filename = "bucket_service_account_key.json"  # Specify the file name and path
}