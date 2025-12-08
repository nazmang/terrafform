locals {
  gcs_backup_bucket_defaults = {
    storage_class = "COLDLINE"
    location      = "US-CENTRAL1"
    versioning    = false
    force_destroy = false
    lifecycle = {
      age    = 90
      action = "Delete"
    }
  }
  gcs_backup_data_defaults = {
    storage_class = "STANDARD"
    location      = "europe-central2"
    versioning    = false
    force_destroy = false
  }
}
