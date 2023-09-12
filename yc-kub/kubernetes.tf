# Create new cluster
resource "yandex_kubernetes_cluster" "kuber-cluster" {
  # Cluster name
  name        = "kuber-cluster"

  # Cluster network connect to
  network_id = yandex_vpc_network.internal.id

  # Masters are in 'ru-central' and subnets to use in each zone
  master {
    regional {
      region = "ru-central1"

      location {
        zone      = yandex_vpc_subnet.internal-a.zone
        subnet_id = yandex_vpc_subnet.internal-a.id
      }

      location {
        zone      = yandex_vpc_subnet.internal-b.zone
        subnet_id = yandex_vpc_subnet.internal-b.id
      }

      location {
        zone      = yandex_vpc_subnet.internal-c.zone
        subnet_id = yandex_vpc_subnet.internal-c.id
      }
    }

    # Kubernetes version
    version   = "1.18"
    # Set an 'External' IP for master nodes
    public_ip = true
  }

  release_channel = "RAPID"

  # Servce accounts for Docker reistry and for node management
  node_service_account_id = yandex_iam_service_account.docker-registry.id
  service_account_id      = yandex_iam_service_account.instances-editor.id
}

# Create node group
resource "yandex_kubernetes_node_group" "node-group-0" {
  # Cluset that this group belongs to
  cluster_id  = yandex_kubernetes_cluster.kuber-cluster.id
  # Group name
  name        = "node-group-0"
  # Grop k8s version
  version     = "1.18"

  # VM template 
  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat = true
      subnet_ids = ["${yandex_vpc_subnet.internal-a.id}","${yandex_vpc_subnet.internal-b.id}","${yandex_vpc_subnet.internal-c.id}"]
    }

    resources {
      core_fraction = 20 # This param allow to reduce CPU performance and infrastructure expences
      memory        = 2
      cores         = 2
    }

    boot_disk {
      type = "network-hdd"
      size = 64
    }

    scheduling_policy {
      preemptible = false
    }
  }

  # Configure a scaling policy. In this case we have a fixed group and there are 2 nodes
  scale_policy {
    fixed_scale {
      size = 2
    }
  }

  # In which zones should create nodes
  allocation_policy {
    location {
      zone = "ru-central1-a"
    }

    location {
      zone = "ru-central1-b"
    }

    location {
      zone = "ru-central1-c"
    }
  }

  # Turn off automatic upgrade 
  maintenance_policy {
    auto_upgrade = false
    auto_repair  = true
  }
}
