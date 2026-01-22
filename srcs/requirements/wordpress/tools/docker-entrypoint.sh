#!/bin/bash

# When I run a container, the "working directory" is defined 
# in my Dockerfile using the WORKDIR directive.

set -e

echo "Waiting for MariaDB to be ready..."
# Wait for MariaDB to become available
# The 'mariadb' address is the container name
until mysqladmin ping -h"mariadb" -u $MYSQL_USER -p"$MYSQL_PASSWORD" --silent; do
    echo "Waiting for MariaDB..."
    sleep 2
done

# First line checks whether WordPress has already been configured 
# before, or whether this is a "first run" on a clean system.
# A flag that checks if such a file exists in the current directory.
# If WordPress is not yet downloaded — download and configure it
# --dbhost assign a name of the container
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
    
    echo "Creating WordPress user..."
    wp user create --allow-root \
        $WP_USER \
        $WP_EMAIL \
        --user_pass=$WP_PASSWORD \
        --role=author
fi

echo "WordPress is ready!"

# Pass control to the main command (from Dockerfile)
exec "$@"