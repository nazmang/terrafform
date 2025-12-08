locals {
  configuration = { for k, v in var.defaults :
    k => var.overrides[k] != null ? var.overrides[k] : var.defaults[k]
  }
}
