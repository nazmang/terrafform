variable "project_name" {
  description = "Name of the GCP project to create"
}

variable "project_id" {
  description = "Unique ID for the GCP project"
}

variable "org_id" {
  description = "Organization ID in GCP"
}

variable "billing_account" {
  description = "Billing account ID in GCP"
}

variable "bucket_name" {
  description = "Name of the GCS bucket to create"
}

variable "region" {
  description = "Region for the GCS bucket"
  default     = "us-central1" 
}
