# Заменить на ID своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_cloud_id" {
  default = "b1ga1jsscj0nff5er8mv"
}

# Заменить на Folder своего облака
# https://console.cloud.yandex.ru/cloud?section=overview
variable "yandex_folder_id" {
  default = "b1gqm8uo6d69j3ajqh4v"
}

# Преднастроеный образ NAT-инстанса
# https://cloud.yandex.ru/marketplace/products/yc/nat-instance-ubuntu-18-04-lts
variable "ubuntu-nat-proxy" {
  default = "fd8v7ru46kt3s4o5f0uo"
}

variable "lan_proxy_ip" {
  default = "192.168.101.100"
}

variable "service_account_id" {
  default = "aje76n8jmiofhh07uif0"
}

# ID yc compute image list Ubuntu 22.04 LTS
variable "ubuntu-base" {
  default = "fd8uoiksr520scs811jl"
}

# ID yc compute image list Ubuntu 20.04 LTS
variable "ubuntu-20" {
  default = "fd8kdq6d0p8sij7h5qe3"
}

# https://cloud.yandex.ru/marketplace/products/yc/nat-instance-ubuntu-18-04-lts
variable "ubuntu-proxy" {
  default = "fd83slullt763d3lo57m"
}