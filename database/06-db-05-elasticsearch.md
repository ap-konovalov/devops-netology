# Домашнее задание к занятию "6.5. Elasticsearch"

## Задача 1

В этом задании вы потренируетесь в:

- установке elasticsearch
- первоначальном конфигурировании elastcisearch
- запуске elasticsearch в docker

Используя докер образ [elasticsearch:7](https://hub.docker.com/_/elasticsearch) как базовый:

- составьте Dockerfile-манифест для elasticsearch
- соберите docker-образ и сделайте `push` в ваш docker.io репозиторий
- запустите контейнер из получившегося образа и выполните запрос пути `/` c хост-машины

```
docker build --tag=elasticsearch-apk .
docker run -it -p 9200:9200 -p 9300:9300  elasticsearch-apk  
```

Требования к `elasticsearch.yml`:

- данные `path` должны сохраняться в `/var/lib`
- имя ноды должно быть `netology_test`

В ответе приведите:

- текст Dockerfile манифеста

***
[Ответ: Dockerfile](06-db-05-elasticsearch/Dockerfile)

- ссылку на образ в репозитории dockerhub

***
[Elasticsearch docker image](https://hub.docker.com/repository/docker/3425149/elasticsearch-apk)

- ответ `elasticsearch` на запрос пути `/` в json виде

```json
{
  "name": "netology_test",
  "cluster_name": "cluster_netology_test",
  "cluster_uuid": "qJwDcfjiSlWp9PLwG0aR7A",
  "version": {
    "number": "7.17.2",
    "build_flavor": "default",
    "build_type": "docker",
    "build_hash": "de7261de50d90919ae53b0eff9413fd7e5307301",
    "build_date": "2022-03-28T15:12:21.446567561Z",
    "build_snapshot": false,
    "lucene_version": "8.11.1",
    "minimum_wire_compatibility_version": "6.8.0",
    "minimum_index_compatibility_version": "6.0.0-beta1"
  },
  "tagline": "You Know, for Search"
}
```

Подсказки:

- при сетевых проблемах внимательно изучите кластерные и сетевые настройки в elasticsearch.yml
- при некоторых проблемах вам поможет docker директива ulimit
- elasticsearch в логах обычно описывает проблему и пути ее решения
- обратите внимание на настройки безопасности такие как `xpack.security.enabled`
- если докер образ не запускается и падает с ошибкой 137 в этом случае может помочь настройка `-e ES_HEAP_SIZE`
- при настройке `path` возможно потребуется настройка прав доступа на директорию

Далее мы будем работать с данным экземпляром elasticsearch.

## Задача 2

В этом задании вы научитесь:

- создавать и удалять индексы
- изучать состояние кластера
- обосновывать причину деградации доступности данных

Ознакомьтесь
с [документацией](https://www.elastic.co/guide/en/elasticsearch/reference/current/indices-create-index.html)
и добавьте в `elasticsearch` 3 индекса, в соответствии со таблицей:

| Имя    | Количество реплик | Количество шард |
|--------|-------------------|-----------------|
| ind-1  | 0                 | 1               |
| ind-2  | 1                 | 2               |
| ind-3  | 2                 | 4               |

Получите список индексов и их статусов, используя API и **приведите в ответе** на задание.

```json
green  open .geoip_databases 0gQVmluNTzWZfyoRKuKWgA 1 0 40 0 38.2mb 38.2mb
green  open ind-1            0ip3VIb_R5Wi4YIibqrFpQ 1 0  0 0   226b   226b
yellow open ind-3            ad4mqLB_Rae7CVe1vDxZZQ 4 2  0 0   904b   904b
yellow open ind-2            C8XRUUhxTdKA9flspA2S7g 2 1  0 0   452b   452b
```

Получите состояние кластера `elasticsearch`, используя API.

Как вы думаете, почему часть индексов и кластер находится в состоянии yellow?

Удалите все индексы.

**Важно**

При проектировании кластера elasticsearch нужно корректно рассчитывать количество реплик и шард, иначе возможна потеря
данных индексов, вплоть до полной, при деградации системы.

## Задача 3

В данном задании вы научитесь:

- создавать бэкапы данных
- восстанавливать индексы из бэкапов

Создайте директорию `{путь до корневой директории с elasticsearch в образе}/snapshots`.

Используя
API [зарегистрируйте](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-register-repository.html#snapshots-register-repository)
данную директорию как `snapshot repository` c именем `netology_backup`.

**Приведите в ответе** запрос API и результат вызова API для создания репозитория.
***
```json
PUT http://localhost:9200/_snapshot/netology_backup

{
  "type": "fs",
  "settings": {
    "location": "/usr/share/elasticsearch/snapshots"
  }
}

============ RESPONSE ============
        
{
  "acknowledged": true
}
```

Создайте индекс `test` с 0 реплик и 1 шардом и **приведите в ответе** список индексов.
```
green open .geoip_databases 0gQVmluNTzWZfyoRKuKWgA 1 0 40 0 38.2mb 38.2mb
green open test             NjtO1iA8SFC6MAJ9KOCY6g 1 0  0 0   226b   226b
```

[Создайте `snapshot`](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-take-snapshot.html)
состояния кластера `elasticsearch`.

**Приведите в ответе** список файлов в директории со `snapshot`ами.
```json
index-0  index.latest  indices  meta-4WrpN_yuS8yqv7XqSL7g5A.dat  snap-4WrpN_yuS8yqv7XqSL7g5A.dat
```
Удалите индекс `test` и создайте индекс `test-2`. **Приведите в ответе** список индексов.
```
green open test-2           HqHISyCAQ5uWuNHQLy-d8A 1 0  0 0   226b   226b
green open .geoip_databases _03zwnT5RH2HjV6XWWSJuQ 1 0 40 0 38.2mb 38.2mb
```
[Восстановите](https://www.elastic.co/guide/en/elasticsearch/reference/current/snapshots-restore-snapshot.html)
состояние кластера `elasticsearch` из `snapshot`, созданного ранее.

**Приведите в ответе** запрос к API восстановления и итоговый список индексов.
***
POST http://localhost:9200/_snapshot/netology_backup/snapshot_1/_restore
```json
{
  "indices": "test"
}
```
INDEXES LIST:
```json
green open test-2           7kDSEwIoSGuQVPaoj-_qdw 1 0  0 0   226b   226b
green open .geoip_databases _03zwnT5RH2HjV6XWWSJuQ 1 0 40 0 38.2mb 38.2mb
green open test             -80XwMD-SaqFY-VtTN1EDg 1 0  0 0   226b   226b
```
Подсказки:

- возможно вам понадобится доработать `elasticsearch.yml` в части директивы `path.repo` и перезапустить `elasticsearch`