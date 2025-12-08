resource "google_storage_bucket" "buckets" {
  name          = var.name
  project       = var.project_id
  location      = local.configuration.location
  storage_class = local.configuration.storage_class

  lifecycle_rule {
    condition {
      age = try(local.configuration.lifecycle.age, null)
    }
    action {
      type = try(local.configuration.lifecycle.action, "Delete")
    }
  }

  versioning {
    enabled = try(local.configuration.versioning, false)
  }

  force_destroy = try(local.configuration.force_destroy, false)
}