# Домашнее задание к занятию "6.3. MySQL"

## Задача 1

Используя docker поднимите инстанс MySQL (версию 8). Данные БД сохраните в volume.

Изучите [бэкап БД](https://github.com/netology-code/virt-homeworks/tree/master/06-db-03-mysql/test_data) и
восстановитесь из него.

Перейдите в управляющую консоль `mysql` внутри контейнера.

Используя команду `\h` получите список управляющих команд.

Найдите команду для выдачи статуса БД и **приведите в ответе** из ее вывода версию сервера БД.

```
Server version:         8.0.29 MySQL Community Server - GPL
```

Подключитесь к восстановленной БД и получите список таблиц из этой БД.

**Приведите в ответе** количество записей с `price` > 300.
```roomsql
SELECT COUNT(*) FROM orders WHERE price > 300;
+----------+
| COUNT(*) |
+----------+
|        1 |
+----------+
1 row in set (0.00 sec)

```
В следующих заданиях мы будем продолжать работу с данным контейнером.

## Задача 2

Создайте пользователя test в БД c паролем test-pass, используя:
- плагин авторизации mysql_native_password
- срок истечения пароля - 180 дней
- количество попыток авторизации - 3
- максимальное количество запросов в час - 100
- аттрибуты пользователя:
    - Фамилия "Pretty"
    - Имя "James"
```roomsql
CREATE USER 'test'@'localhost' IDENTIFIED BY 'test-pass';
ALTER USER 'test'@'localhost' ATTRIBUTE '{"fname":"James", "lname":"Pretty"}';
ALTER USER 'test'@'localhost' 
    -> IDENTIFIED BY 'test-pass' 
    -> WITH
    -> MAX_QUERIES_PER_HOUR 100
    -> PASSWORD EXPIRE INTERVAL 180 DAY
    -> FAILED_LOGIN_ATTEMPTS 3;
```

Предоставьте привилегии пользователю `test` на операции SELECT базы `test_db`.

```roomsql
GRANT Select ON mydb.orders TO 'test'@'localhost';
```
Используя таблицу INFORMATION_SCHEMA.USER_ATTRIBUTES получите данные по пользователю `test` и
**приведите в ответе к задаче**.
```roomsql
mysql> SELECT * FROM INFORMATION_SCHEMA.USER_ATTRIBUTES WHERE USER='test';
+------+-----------+---------------------------------------+
| USER | HOST      | ATTRIBUTE                             |
+------+-----------+---------------------------------------+
| test | localhost | {"fname": "James", "lname": "Pretty"} |
+------+-----------+---------------------------------------+
1 row in set (0.00 sec)

```

## Задача 3

Установите профилирование `SET profiling = 1`.
Изучите вывод профилирования команд `SHOW PROFILES;`.

Исследуйте, какой `engine` используется в таблице БД `test_db` и **приведите в ответе**.
```roomsql
SELECT engine FROM information_schema.TABLES
WHERE TABLE_SCHEMA = 'test_db';
+--------+
| ENGINE |
+--------+
| InnoDB |
+--------+

```

Измените `engine` и **приведите время выполнения и запрос на изменения из профайлера в ответе**:
- на `MyISAM`
- на `InnoDB`
```roomsql
ALTER TABLE orders ENGINE = MyISAM;
ALTER TABLE orders ENGINE = InnoDB;
SHOW PROFILES;
+----------+------------+----------------------------------------------------------------------------------------------------------+
| Query_ID | Duration   | Query                                                                                                    |
+----------+------------+----------------------------------------------------------------------------------------------------------+
|       24 | 0.09958675 | ALTER TABLE orders ENGINE = MyISAM                                                                       |
|       25 | 0.08524350 | ALTER TABLE orders ENGINE = InnoDB                                                                       |
+----------+------------+----------------------------------------------------------------------------------------------------------+
```

## Задача 4

Изучите файл `my.cnf` в директории /etc/mysql.

Измените его согласно ТЗ (движок InnoDB):
- Скорость IO важнее сохранности данных
- Нужна компрессия таблиц для экономии места на диске
- Размер буффера с незакомиченными транзакциями 1 Мб
- Буффер кеширования 30% от ОЗУ
- Размер файла логов операций 100 Мб

Приведите в ответе измененный файл `my.cnf`.
```roomsql
[mysqld]
pid-file        = /var/run/mysqld/mysqld.pid
socket          = /var/run/mysqld/mysqld.sock
datadir         = /var/lib/mysql
secure-file-priv= NULL

# Скорость IO важнее сохранности данных
innodb_flush_method = O_DSYNC
innodb_flush_log_at_trx_commit = 2

# Поддержка для включение компрессии в таблицах
innodb_file_per_table = ON

# Размер буффера с незакомиченными транзакциями 1 Мб
innodb_log_buffer_size = 1M

# Буффер кеширования 30% от ОЗУ
innodb_buffer_pool_size = 1178M

# Размер файла логов операций 100 Мб
innodb_log_file_size = 100M

# Custom config should go here
!includedir /etc/mysql/conf.d/
```
