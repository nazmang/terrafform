terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      # 1.58+ has Storage Box resources.
      version = "1.70.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "3.7.2"
    }
  }
}

# Provider configuration
provider "hcloud" {
  token = var.hcloud_token
}