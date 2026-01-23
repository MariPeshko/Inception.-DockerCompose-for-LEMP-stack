### To build an image

```bash
docker build -t mariadb ./requirements/mariadb
```

After executing the docker build command, your image does not appear as a separate file in the project folder (such as .exe or .zip). Docker stores it in its internal “storage,” which is managed by Docker Daemon.

To ensure that the image has been created:
```bash
docker images
```

### run container without volume

```bash
docker run -d --name mariadb --env-file .env mariadb
```

-d (detached mode) Docker launchs the container in the background.

--name You have given the container a convenient name. Now you can refer to it by name instead of its long ID.

Output is the Full Container ID.

When you add --env-file .env, Docker automatically makes all variables (such as MYSQL_USER) available inside the container. Your docker-entrypoint.sh script sees them just like regular system variables.

### run with volumes (bind mounts)

```bash
docker run -d --name mariadb \
  --env-file .env \
  -v $HOME/data/mariadb:/var/lib/mysql \
  mariadb
```

Delete the container (docker rm -f) and check that the files in db_data remain!

### To stop container
```bash
docker stop mariadb
```

### With .yml file:

The data should not disappear after:
```bash
docker compose down
```

But it should be deleted if you explicitly run:

```bash
#the -v flag deletes the volumes
docker compose down -v
```
