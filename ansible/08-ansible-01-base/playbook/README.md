# Самоконтроль выполнения задания

1. Где расположен файл с `some_fact` из второго пункта задания?
```json
group_vars/all/examp.yml
```
2. Какая команда нужна для запуска вашего `playbook` на окружении `test.yml`?
```bash
ansible-playbook site.yml -i inventory/test.yml 
```
3. Какой командой можно зашифровать файл?
```bash
ansible-vault encrypt <filename>
```
4. Какой командой можно расшифровать файл?
```bash
ansible-vault decrypt <filename>
```
5. Можно ли посмотреть содержимое зашифрованного файла без команды расшифровки файла? Если можно, то как?
```bash
ansible-vault view <filename>
```
6. Как выглядит команда запуска `playbook`, если переменные зашифрованы?
```bash
ansible-playbook site.yml -i inventory/test.yml --ask-vault-password
```
7. Как называется модуль подключения к host на windows?
```bash
winrm
```
8. Приведите полный текст команды для поиска информации в документации ansible для модуля подключений ssh
```bash
ansible-doc -t connection ssh
```
9. Какой параметр из модуля подключения `ssh` необходим для того, чтобы определить пользователя, под которым необходимо совершать подключение?
```bash
remote_user
```