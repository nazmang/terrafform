variable "yc_region" {
    type = string
    description = "Yandex Cloud region (ru-central1-a/b/c)"
    default = "ru-central1-c"
}

variable "yc_token" {
    type = string
    description = "Token obtained from yc config"
    default = ""
}

variable "yc_cloud_id" {
    type = string
    description = "Yandex Cloud ID"
    default = ""
}

variable "yc_folder_id" {
    type = string
    description = "Yandex Cloud folder ID"
    default = ""
}
