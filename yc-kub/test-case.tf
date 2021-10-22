resource "yandex_iam_service_account" "docker-registry" {
  name        = "docker-registry"
  description = "service account to use container registry"
}

resource "yandex_iam_service_account" "instances-editor" {
  name        = "instances-editor"
  description = "service account to manage VMs"
}

resource "yandex_vpc_network" "internal" {
  name = "internal"
}

resource "yandex_vpc_subnet" "internal-a" {
  name           = "internal-a"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.internal.id
  v4_cidr_blocks = ["10.200.0.0/16"]
}

resource "yandex_vpc_subnet" "internal-b" {
  name           = "internal-b"
  zone           = "ru-central1-b"
  network_id     = yandex_vpc_network.internal.id
  v4_cidr_blocks = ["10.201.0.0/16"]
}

resource "yandex_vpc_subnet" "internal-c" {
  name           = "internal-c"
  zone           = "ru-central1-c"
  network_id     = yandex_vpc_network.internal.id
  v4_cidr_blocks = ["10.202.0.0/16"]
}

resource "yandex_kubernetes_cluster" "kub-test" {
  name       = "kub-test"
  network_id = yandex_vpc_network.internal.id

  master {
    zonal {
        zone      = yandex_vpc_subnet.internal-a.zone
        subnet_id = yandex_vpc_subnet.internal-a.id
    }
    version   = "1.18"
    public_ip = true
  }
  release_channel         = "RAPID"
  network_policy_provider = "CALICO"
  node_service_account_id = yandex_iam_service_account.docker-registry.id
  service_account_id      = yandex_iam_service_account.instances-editor.id
}

resource "yandex_kubernetes_node_group" "test-group-auto" {
  cluster_id = yandex_kubernetes_cluster.kub-test.id
  name       = "test-group-auto"
  version    = "1.18"

  instance_template {
    platform_id = "standard-v2"

    network_interface {
      nat        = true
      subnet_ids = ["${yandex_vpc_subnet.internal-a.id}", "${yandex_vpc_subnet.internal-b.id}", "${yandex_vpc_subnet.internal-c.id}"]
    }

    resources {
      core_fraction = 20
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

  scale_policy {
    auto_scale {
      initial = 2
      min     = 2
      max     = 3
    }
  }

  allocation_policy {
    location {
      zone = "ru-central1-a"
    }
  }

  maintenance_policy {
    auto_upgrade = false
    auto_repair  = true
  }

}
