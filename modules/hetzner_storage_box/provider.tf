terraform {
  required_providers {
    hcloud = {
      source = "hetznercloud/hcloud"
      # 1.58+ has Storage Box resources.
      version = ">= 1.58.0"
    }
    random = {
      source  = "hashicorp/random"
      version = ">= 3.0.0"
    }
  }
}
