# Create a new GCP project
resource "google_project" "bucket_access_project" {
  name       = var.project_name
  project_id = var.project_id
  org_id     = var.org_id
  billing_account = var.billing_account
}

module "gcs_backup_buckets" {
  for_each = local.gcs_backup_buckets
  source = "../../gcs-bucket/modules/gcs_buckets"

  name = each.key
  project_id = var.project_id
  

}

# Create a new single-region bucket
resource "google_storage_bucket" "bucket" {
  name     = var.bucket_name
  location = var.region
  storage_class = "STANDARD"

  lifecycle_rule {
    action {
      type = "Delete"
    }
    condition {
      age = 365 # Example: Auto-delete objects older than 1 year
    }
  }
}

# Create a service account
resource "google_service_account" "bucket_service_account" {
  account_id   = "bucket-access-sa"
  display_name = "Service Account for Bucket Access"
}

# Assign IAM role to the service account for bucket access
resource "google_storage_bucket_iam_member" "bucket_rw_access" {
  bucket = google_storage_bucket.bucket.name
  role   = "roles/storage.objectAdmin"
  member = "serviceAccount:${google_service_account.bucket_service_account.email}"
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

output "service_account_key_path" {
  value = local_file.bucket_service_account_key.filename
}

output "bucket_name" {
  value = google_storage_bucket.bucket.name
}