#!/bin/bash

set -e; 
# or set -eu; 
# or # set -ex # print commands & exit on error (debug mode)
# or not neccesarilly

# 1. Запускаємо MariaDB у фоновому режимі, щоб налаштувати її
# Warning: This often does not work in Docker because Docker does not have a systemd system.
service mariadb start

# 2. Чекаємо, поки MariaDB буде готова до роботи
until mysqladmin ping >/dev/null 2>&1; do
    echo "Waiting for MariaDB..."
    sleep 2
done

# Docker will automatically “pick up” variables from .env if you specify 
# it at startup.

# 3. Виконуємо SQL запити для створення бази та користувача
# Ми використовуємо змінні, які Docker передасть із .env файлу
mysql -u root -e "CREATE DATABASE IF NOT EXISTS \`${MYSQL_DATABASE}\`;"
mysql -u root -e "CREATE USER IF NOT EXISTS '${MYSQL_USER}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"
mysql -u root -e "GRANT ALL PRIVILEGES ON \`${MYSQL_DATABASE}\`.* TO '${MYSQL_USER}'@'%';"
mysql -u root -e "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';"
mysql -u root -e "FLUSH PRIVILEGES;"

# 4. Зупиняємо фонову службу, щоб перезапустити її в "чистому" режимі
mysqladmin -u root -p${MYSQL_ROOT_PASSWORD} shutdown

# 5. Запускаємо MariaDB у фоновому режимі (foreground), щоб контейнер не закрився
exec mysqld_safe

# Why do we use exec “$@” at the end?
# This is the “golden rule” of writing Entrypoint scripts.

# $@ is what you wrote in CMD in Dockerfile (i.e., mariadbd --user=mysql).
# exec replaces the script process (bash) with the database process. This 
# makes MariaDB process #1 (PID 1), allowing it to correctly receive stop 
# signals (such as the SIGTERM we mentioned earlier).