#!/bin/bash

set -e

echo "Waiting for MariaDB to be ready..."
# Wait for MariaDB to become available
# The 'mariadb' address is the container name we will give later
until mysqladmin ping -h"mariadb" --silent; do
    echo "Waiting for MariaDB..."
    sleep 2
done

# If WordPress is not yet downloaded — download and configure it
if [ ! -f "wp-config.php" ]; then
    echo "Downloading WordPress..."
    wp core download --allow-root

    echo "Creating wp-config.php..."
    wp config create --allow-root \
        --dbname=$MYSQL_DATABASE \
        --dbuser=$MYSQL_USER \
        --dbpass=$MYSQL_PASSWORD \
        --dbhost=mariadb \
        --path='/var/www/html'

    echo "Installing WordPress..."
    wp core install --allow-root \
        --url=$WP_URL \
        --title=$WP_TITLE \
        --admin_user=$WP_ADMIN_USER \
        --admin_password=$WP_ADMIN_PASSWORD \
        --admin_email=$WP_ADMIN_EMAIL \
        --skip-email
fi

echo "WordPress is ready!"

# Pass control to the main command (from Dockerfile)
exec "$@"