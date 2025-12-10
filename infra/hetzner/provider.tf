terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      version = "1.57.0"
    }
  }
}

# Provider configuration
provider "hcloud" {
  token = var.hcloud_token
}