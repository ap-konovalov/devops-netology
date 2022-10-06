terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }

  cloud {
    organization = "sancheszi"

    workspaces {
      name = "stage"
    }
  }
}

provider "yandex" {
  service_account_key_file = "key.json"
  cloud_id  = "${var.yandex_cloud_id}"
  folder_id = "${var.yandex_folder_id}"
}