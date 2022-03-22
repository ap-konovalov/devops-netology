# Домашнее задание к занятию "4.3. Языки разметки JSON и YAML"

## Обязательные задания

1. Мы выгрузили JSON, который получили через API запрос к нашему сервису. Нужно найти и исправить все ошибки, которые допускает наш сервис
   <br>
ОТВЕТ:
```json
{
    "info": "Sample JSON output from our service\t",
    "elements": [
        {
            "name": "first",
            "type": "server",
            "ip": 7175
        },
        {
            "name": "second",
            "type": "proxy",
            "ip": "71.78.22.43"
        }
    ]
}
```
2. В прошлый рабочий день мы создавали скрипт, позволяющий опрашивать веб-сервисы и получать их IP. К уже реализованному функционалу нам нужно добавить возможность записи JSON и YAML файлов, описывающих наши сервисы. Формат записи JSON по одному сервису: { "имя сервиса" : "его IP"}. Формат записи YAML по одному сервису: - имя сервиса: его IP. Если в момент исполнения скрипта меняется IP у сервиса - он должен так же поменяться в yml и json файле.
```python
#!/usr/bin/env python3

import socket
import json
import pickle
import yaml

RESULTS_FILE = 'address_check.pkl'
RESULTS_JSON_FILE = 'address_check.json'
RESULTS_YAML_FILE = 'address_check.yaml'

def save_results(path,dict):
	f = open(path,"wb")
	pickle.dump(dict,f)
	f.close()

def save_json_results(path,dict):
	with open(path, 'w') as fp:
		json.dump(dict,fp)

def save_yaml_results(path,dict):
	with open(path, 'w') as outfile:
		yaml.dump(dict, outfile, default_flow_style=False)

def read_results(path):
	with (open(path, "rb")) as openfile:
		while True:
			try:
				return pickle.load(openfile)
			except EOFError:
				break

def get_ips_by_address(hosts):
	services_ips = {}
	for host in hosts:
		ip = socket.getaddrinfo(host, 443)[0][4][0]
		services_ips[host] = ip
	return services_ips

def print_services_ips(services_ips):
	for host in services_ips:
		print(host + ' - ' + services_ips.get(host))

def check_ips(path,services_ips):
	try:
		old_services_ips = read_results(path)
		for host in services_ips:
			old_ip = old_services_ips[host]
			current_ip = services_ips[host] 
			if old_ip != current_ip:
				print("[ERROR] " + host + " IP mismatch: " + old_ip + " " + current_ip)
	except FileNotFoundError:
		pass

hosts = ["drive.google.com","mail.google.com","google.com"]
current_services_ips = get_ips_by_address(hosts)
print_services_ips(current_services_ips)
check_ips(RESULTS_FILE,current_services_ips)
save_results(RESULTS_FILE, current_services_ips)
save_json_results(RESULTS_JSON_FILE, current_services_ips)
save_yaml_results(RESULTS_YAML_FILE, current_services_ips) 
```

## Дополнительное задание (со звездочкой*) - необязательно к выполнению

Так как команды в нашей компании никак не могут прийти к единому мнению о том, какой формат разметки данных использовать: JSON или YAML, нам нужно реализовать парсер из одного формата в другой. Он должен уметь:
* Принимать на вход имя файла
* Проверять формат исходного файла. Если файл не json или yml - скрипт должен остановить свою работу
* Распознавать какой формат данных в файле. Считается, что файлы *.json и *.yml могут быть перепутаны
* Перекодировать данные из исходного формата во второй доступный (из JSON в YAML, из YAML в JSON)
* При обнаружении ошибки в исходном файле - указать в стандартном выводе строку с ошибкой синтаксиса и её номер
* Полученный файл должен иметь имя исходного файла, разница в наименовании обеспечивается разницей расширения файлов

---

### Как сдавать задания

Выполненное домашнее задание пришлите ссылкой на .md-файл в вашем репозитории.

---
