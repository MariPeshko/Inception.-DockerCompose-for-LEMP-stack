You can create the network manually before starting:

```bash
docker network create inception_network

docker run -d --name mariadb --network inception_network --env-file .env my_mariadb
docker run -d --name wordpress --network inception_network --env-file .env my_wordpress
```