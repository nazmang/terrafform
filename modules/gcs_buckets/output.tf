output "bucket_url" {
  description = "URLs of created buckets"
  value = google_storage_bucket.gcs_buckets.url
}
