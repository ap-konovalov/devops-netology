resource "yandex_dns_zone" "altaromana" {
  name        = "altaromana-ru"
  description = "Zone for site http://altaromana.ru/"

  labels = {
    label1 = "altaromana-public-zone"
  }

  zone    = "altaromana.ru."
  public  = true

  depends_on = [
    yandex_vpc_subnet.default-subnet-a,yandex_vpc_subnet.default-subnet-b
  ]
}

resource "yandex_dns_recordset" "def" {
  zone_id = yandex_dns_zone.altaromana.id
  name    = "@.altaromana.ru."
  type    = "A"
  ttl     = 200
  data    = [yandex_vpc_address.addr.external_ipv4_address[0].address]
}

resource "yandex_dns_recordset" "gitlab" {
  zone_id = yandex_dns_zone.altaromana.id
  name    = "gitlab.altaromana.ru."
  type    = "A"
  ttl     = 200
  data    = [yandex_vpc_address.addr.external_ipv4_address[0].address]
}

resource "yandex_dns_recordset" "alertmanager" {
  zone_id = yandex_dns_zone.altaromana.id
  name    = "alertmanager.altaromana.ru."
  type    = "A"
  ttl     = 200
  data    = [yandex_vpc_address.addr.external_ipv4_address[0].address]
}

resource "yandex_dns_recordset" "grafana" {
  zone_id = yandex_dns_zone.altaromana.id
  name    = "grafana.altaromana.ru."
  type    = "A"
  ttl     = 200
  data    = [yandex_vpc_address.addr.external_ipv4_address[0].address]
}

resource "yandex_dns_recordset" "prometheus" {
  zone_id = yandex_dns_zone.altaromana.id
  name    = "prometheus.altaromana.ru."
  type    = "A"
  ttl     = 200
  data    = [yandex_vpc_address.addr.external_ipv4_address[0].address]
}

resource "yandex_dns_recordset" "www" {
  zone_id = yandex_dns_zone.altaromana.id
  name    = "www.altaromana.ru."
  type    = "A"
  ttl     = 200
  data    = [yandex_vpc_address.addr.external_ipv4_address[0].address]
}