resource "yandex_iam_service_account" "docker-registry" {
  name        = "docker"
  description = "service account to use container registry"
}

resource "yandex_iam_service_account" "instances-editor" {
  name        = "instances"
  description = "service account to manage VMs"
}

resource "yandex_resourcemanager_folder_iam_binding" "editor" {
  folder_id = var.yc_folder_id

  role = "editor"

  members = [
    "serviceAccount:${yandex_iam_service_account.instances-editor.id}",
  ]

  depends_on = [
    yandex_iam_service_account.instances-editor
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "k8s_editor" {
  folder_id = var.yc_folder_id

  role = "k8s.editor"

  members = [
    "serviceAccount:${yandex_iam_service_account.instances-editor.id}",
  ]

  depends_on = [
    yandex_iam_service_account.instances-editor
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "vpc_admin" {
  folder_id = var.yc_folder_id

  role = "vpc.admin"

  members = [
    "serviceAccount:${yandex_iam_service_account.instances-editor.id}",
  ]

  depends_on = [
    yandex_iam_service_account.instances-editor
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "vpc_user" {
  folder_id = var.yc_folder_id

  role = "vpc.user"

  members = [
    "serviceAccount:${yandex_iam_service_account.instances-editor.id}",
  ]

  depends_on = [
    yandex_iam_service_account.instances-editor
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "k8s_cluster-api_cluster-admin" {
  folder_id = var.yc_folder_id

  role = "k8s.cluster-api.cluster-admin"

  members = [
    "serviceAccount:${yandex_iam_service_account.instances-editor.id}",
  ]

  depends_on = [
    yandex_iam_service_account.instances-editor
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "k8s_clusters_agent" {
  folder_id = var.yc_folder_id

  role = "k8s.clusters.agent"

  members = [
    "serviceAccount:${yandex_iam_service_account.instances-editor.id}",
  ]

  depends_on = [
    yandex_iam_service_account.instances-editor
  ]
}

resource "yandex_resourcemanager_folder_iam_binding" "pusher" {
  folder_id = var.yc_folder_id

  role = "container-registry.images.pusher"

  members = [
    "serviceAccount:${yandex_iam_service_account.docker-registry.id}",
  ]

  depends_on = [
    yandex_iam_service_account.docker-registry
  ]
}

