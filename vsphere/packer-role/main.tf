##################################################################################
# RESOURCES
##################################################################################

resource "vsphere_role" "packer-vsphere" {
  name            = var.packer_vsphere_role
  role_privileges = var.packer_vsphere_privileges
}