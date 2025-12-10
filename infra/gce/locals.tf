locals {
  gcs_backup_bucket_defaults = {
    storage_class = "COLDLINE"
    location      = "US-CENTRAL1"
    versioning    = false
    force_destroy = false
    lifecycle_rules = [
      {
        age = 180
        action = {
          type          = "SetStorageClass"
          storage_class = "ARCHIVE"
        }
      }
    ]
  }
  gcs_data_bucket_defaults = {
    storage_class = "STANDARD"
    location      = "europe-central2"
    versioning    = true
    force_destroy = false
    lifecycle_rules = [
      {
        days_since_noncurrent_time = 30
        action = {
          type          = "SetStorageClass"
          storage_class = "NEARLINE"
        }
      },
      {
        days_since_noncurrent_time = 60
        action = {
          type          = "SetStorageClass"
          storage_class = "COLDLINE"
        }
      }
    ]
  }
}
