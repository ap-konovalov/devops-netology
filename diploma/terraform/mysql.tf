resource "yandex_compute_instance" "db01" {

  name                      = "db01"
  zone                      = "ru-central1-b"
  hostname                  = "db01.altaromana.ru"
  allow_stopping_for_update = true

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.ubuntu-base}"
      type        = "network-nvme"
      size        = "10"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.default-subnet-b.id}"
    nat       = false
  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }

}

resource "yandex_compute_instance" "db02" {

  name                      = "db02"
  zone                      = "ru-central1-b"
  hostname                  = "db02.altaromana.ru"
  allow_stopping_for_update = true

  resources {
    cores  = 4
    memory = 4
  }

  boot_disk {
    initialize_params {
      image_id    = "${var.ubuntu-base}"
      type        = "network-nvme"
      size        = "10"
    }
  }

  network_interface {
    subnet_id = "${yandex_vpc_subnet.default-subnet-b.id}"
    nat       = false
  }

  metadata = {
    user-data = "${file("meta.txt")}"
  }

}