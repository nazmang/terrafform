locals {
  # Docker manager instances
  manager_instances = {
    main = {
      name       = "cx23-ubuntu-01"
      network_ip = "10.163.1.5"
    }
  }

  # Docker worker instances
  worker_instances = {
    worker1 = {
      name       = "cx33-ubuntu-02"
      network_ip = "10.163.1.15"
    }
    worker2 = {
      name       = "cx33-ubuntu-03"
      network_ip = "10.163.1.16"
    }
  }
}

