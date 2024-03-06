terraform {
  required_providers {
    vsphere = {
      source  = "hashicorp/vsphere"
      version = ">= 2.6.1"
    }
  }
  required_version = ">= 1.7.1"
}