data "vsphere_datacenter" "datacenter" {
  name = var.vsphere_datacenter
}

data "vsphere_network" "network" {
  name          = var.vsphere_network
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_compute_cluster" "cluster" {
  name          = var.vsphere_cluster
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_resource_pool" "pool" {
  name          = format("%s%s", data.vsphere_compute_cluster.cluster.name, "/Resources")
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_datastore" "datastore" {
  name          = var.vsphere_datastore
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

data "vsphere_virtual_machine" "template" {
  name          = "${var.vsphere_template != null ? var.vsphere_template : split(":", element(var.builds, 0).artifact_id)[0]}"
  datacenter_id = data.vsphere_datacenter.datacenter.id
}

resource "vsphere_virtual_machine" "vm" {
  name                    = var.vm_name
  folder                  = var.vsphere_folder
  num_cpus                = var.vm_cpus
  memory                  = var.vm_memory
  firmware                = var.vm_firmware
  efi_secure_boot_enabled = var.vm_efi_secure_boot_enabled
  guest_id                = data.vsphere_virtual_machine.template.guest_id
  datastore_id            = data.vsphere_datastore.datastore.id
  resource_pool_id        = data.vsphere_resource_pool.pool.id
  network_interface {
    network_id = data.vsphere_network.network.id
  }
  disk {
    label            = "disk0"
    size             = data.vsphere_virtual_machine.template.disks[0].size
    eagerly_scrub    = data.vsphere_virtual_machine.template.disks[0].eagerly_scrub
    thin_provisioned = data.vsphere_virtual_machine.template.disks[0].thin_provisioned
  }
  clone {
    template_uuid = data.vsphere_virtual_machine.template.id   
    customize {
      timeout       = 20
      windows_options {
        computer_name         = var.vm_computername
        workgroup             = "WORKGROUP"        
        admin_password        = local.ansible_password
        run_once_command_list = [ 
          "cmd.exe /C Powershell.exe \"Get-NetConnectionProfile | Set-NetConnectionProfile -NetworkCategory Private\"", 
        ]
        auto_logon            = true
        auto_logon_count      = 1  
      }
      network_interface {
        ipv4_address = var.vm_ipv4_address
        ipv4_netmask = var.vm_ipv4_netmask
      }

      ipv4_gateway    = var.vm_ipv4_gateway
      dns_suffix_list = var.vm_dns_suffix_list
      dns_server_list = var.vm_dns_server_list
    }
  }

  lifecycle {
    ignore_changes = [
      clone[0].template_uuid,
    ]
  }

  annotation = "${local.build_description}"   
}

resource "local_file" "ansible_inventory" {
  depends_on = [ vsphere_virtual_machine.vm ]
  content = templatefile ("inventory.tpl", 
   {
     vm_ip_address = vsphere_virtual_machine.vm.default_ip_address,
     vm_name      = var.vm_computername    
   }
  )
  filename = "inventory"
}

resource "time_sleep" "wait_90_seconds" {
  depends_on = [local_file.ansible_inventory]
  create_duration = "90s"
}

resource "null_resource" "ansible" {
  depends_on = [ 
    vsphere_virtual_machine.vm, 
    local_file.ansible_inventory,
    time_sleep.wait_90_seconds
  ]
  provisioner "local-exec" {
    command = <<-EOT
ansible-galaxy collection install -f -r ${path.cwd}/ansible/roles/requirements.yml -p ${path.cwd}/ansible/roles;
ansible-galaxy collection install -f -r ${path.cwd}/ansible/roles/windows-2019-cis/collections/requirements.yml -p ${path.cwd}/ansible/roles;
ANSIBLE_CONFIG=${path.cwd}/ansible/ansible.cfg \
ansible-playbook -i inventory \
-e ansible_user='${local.ansible_user}' \
-e ansible_password='${local.ansible_password}' \
-e ansible_port=5985 \
-e ansible_connection=winrm \
-e vm_domain='${var.vm_domain}' \
-e vm_domain_admin_username='${var.vm_domain_admin_username}' \
-e vm_domain_admin_password='${var.vm_domain_admin_password}' \
${path.cwd}/ansible/ad-controller.yml
EOT  
  }
}