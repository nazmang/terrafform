# resource "proxmox_cloud_init_disk" "ci" {
#   name     = "cloud-init-iso"
#   pve_node = "phv6"
#   storage  = "local-lvm"

#   #   user_data = <<-EOT
#   #   #cloud-config
#   #   users:
#   #     - default
#   #   ssh_authorized_keys:
#   #     - ssh-rsa AAAAB3N......
#   #   EOT

#   network_config = yamlencode({
#     version = 1
#     config = [{
#       type = "physical"
#       name = "ens18"
#       subnets = [{
#         type    = "static"
#         address = "10.210.150.125//24"
#         gateway = "10.210.150.1"
#         dns_nameservers = [
#           "10.210.111.254",
#           "8.8.8.8"
#         ]
#       }]
#     }]
#   })
# }
