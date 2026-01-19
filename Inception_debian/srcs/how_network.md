You can create the network manually before starting:

```bash
docker network create inception_network

#build maria

docker run -d --name mariadb_container \
--network inception_network \
--env-file .env \
-v /home/mpeshko/data/mariadb:/var/lib/mysql \
my_mariadb

docker build -t my_wordpress ./requirements/wordpress

docker run -d --name wordpress_container \
    --network inception_network \
    --env-file .env \
    -v /home/mpeshko/data/wordpress:/var/www/html \
    my_wordpress
```

Are the containers on the same network?
```bash
docker network inspect inception_network
```

Error with WordPress script.

Your script is stuck because the mysqladmin ping command is trying to "knock" on the database door, but MariaDB is not letting it in without a password or due to incorrect access rights.

Why is mysqladmin not working?
Sometimes mysqladmin ping may require authorization if the database is already initialized. You need to pass in your credentials. Since this is an initialization script, it is best to use the root user.

```bash
until mysqladmin ping -h"mariadb_container" -u root -p"$MYSQL_ROOT_PASSWORD" --silent; do
```