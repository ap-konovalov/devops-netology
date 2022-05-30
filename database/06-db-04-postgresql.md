# Домашнее задание к занятию "6.4. PostgreSQL"

## Задача 1

Используя docker поднимите инстанс PostgreSQL (версию 13). Данные БД сохраните в volume.

Подключитесь к БД PostgreSQL используя `psql`.

Воспользуйтесь командой `\?` для вывода подсказки по имеющимся в `psql` управляющим командам.

**Найдите и приведите** управляющие команды для:
- вывода списка БД
```roomsql
\l
```
- подключения к БД
```roomsql
\c[onnect] {[DBNAME|- USER|- HOST|- PORT|-] | conninfo}
```
- вывода списка таблиц
```roomsql
\dt
```
- вывода описания содержимого таблиц
```roomsql
\d[S+] NAME
```
- выхода из psql
```roomsql
\q  
```

## Задача 2

Используя `psql` создайте БД `test_database`.
```roomsql
CREATE DATABASE test_database;
```

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-04-postgresql/test_data).

Восстановите бэкап БД в `test_database`.
```roomsql
psql -U admin test_database < /var/backups/test_dump.sql;
```

Перейдите в управляющую консоль `psql` внутри контейнера.

Подключитесь к восстановленной БД и проведите операцию ANALYZE для сбора статистики по таблице.
```roomsql
\c test_database
ANALYZE VERBOSE orders;
INFO:  analyzing "public.orders"
INFO:  "orders": scanned 1 of 1 pages, containing 8 live rows and 0 dead rows; 8 rows in sample, 8 estimated total rows
```

Используя таблицу [pg_stats](https://postgrespro.ru/docs/postgresql/12/view-pg-stats), найдите столбец таблицы `orders`
с наибольшим средним значением размера элементов в байтах.

**Приведите в ответе** команду, которую вы использовали для вычисления и полученный результат.

```roomsql
SELECT attname 
FROM pg_stats 
WHERE avg_width=(SELECT MAX(avg_width) FROM pg_stats WHERE tablename='orders')
AND tablename='orders';
```
## Задача 3

Архитектор и администратор БД выяснили, что ваша таблица orders разрослась до невиданных размеров и
поиск по ней занимает долгое время. Вам, как успешному выпускнику курсов DevOps в нетологии предложили
провести разбиение таблицы на 2 (шардировать на orders_1 - price>499 и orders_2 - price<=499).

Предложите SQL-транзакцию для проведения данной операции.
```roomsql
BEGIN;

-- переименовывем существующую таблицу orders, чтобы заполнить по правилам новую;
ALTER TABLE public.orders RENAME TO orders_old;

-- создаем новую таблицу orders куда будем вставлять значения по правилам;
CREATE TABLE public.orders (
      like public.orders_old
      including defaults
      including constraints
      including indexes
);

-- создаем новые таблицы с проверками для вставки
CREATE TABLE orders_less_than_500 (
	CHECK ( price <= 499 )
) INHERITS (orders);

CREATE TABLE orders_more_than_499 (
	CHECK ( price > 499)
) INHERITS (orders);

-- создаем правила для встакив в таблицу новую orders
CREATE RULE orders_less_than_500_insert AS ON INSERT TO orders
WHERE ( price <= 499 )
DO INSTEAD INSERT INTO orders_less_than_500 VALUES (NEW.*);

CREATE RULE orders_more_than_insert AS ON INSERT TO orders
WHERE ( price > 499 )
DO INSTEAD INSERT INTO orders_more_than_499 VALUES (NEW.*);

-- вставляем данные из старой таблицы в новую с применением правил для вставки
INSERT INTO public.orders (id,title,price) 
SELECT id,title,price 
FROM public.orders_old;

-- перепривязывание SEQUENCE чтобы можно было удалить старую таблицу
ALTER TABLE public.orders_old ALTER id DROP default;
ALTER SEQUENCE public.orders_id_seq OWNED BY public.orders.id;

-- удалим старую таблицу
DROP TABLE public.orders_old;

COMMIT;
```
Можно ли было изначально исключить "ручное" разбиение при проектировании таблицы orders?
***
Да, это можно было сделать изначально.

## Задача 4

Используя утилиту `pg_dump` создайте бекап БД `test_database`.
```roomsql
pg_dump -U admin -d test_database > /var/backups/test_database_dump.sql
```

Как бы вы доработали бэкап-файл, чтобы добавить уникальность значения столбца `title` для таблиц `test_database`?
```roomsql
--- переписал бы в выражении создания таблицы orders строчку где создается стобец title, чтобы выражение выглядело так:
CREATE TABLE public.orders (
    id integer NOT NULL,
    title character varying(80) NOT NULL UNIQUE,
    price integer DEFAULT 0
);
```