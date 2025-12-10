resource "google_storage_bucket" "gcs_bucket" {
  name          = var.name
  project       = var.project_id
  location      = local.configuration.location
  storage_class = local.configuration.storage_class

  dynamic "lifecycle_rule" {
    for_each = try(local.configuration.lifecycle_rules, [])
    content {
      condition {
        age                        = try(lifecycle_rule.value.age, null)
        created_before             = try(lifecycle_rule.value.created_before, null)
        with_state                 = try(lifecycle_rule.value.with_state, null)
        matches_storage_class      = try(lifecycle_rule.value.matches_storage_class, null)
        days_since_noncurrent_time = try(lifecycle_rule.value.days_since_noncurrent_time, null)
      }
      action {
        type          = try(lifecycle_rule.value.action.type, "Delete")
        storage_class = try(lifecycle_rule.value.action.storage_class, null)
      }
    }
  }

  versioning {
    enabled = try(local.configuration.versioning, false)
  }

  force_destroy = try(local.configuration.force_destroy, false)
}

resource "google_storage_bucket_iam_binding" "owners" {
  bucket  = google_storage_bucket.gcs_bucket.name
  role    = "roles/storage.objectAdmin"
  members = toset(var.owners)
}
