### To build an image

```bash
docker build -t my_mariadb .
```

After executing the docker build command, your image does not appear as a separate file in the project folder (such as .exe or .zip). Docker stores it in its internal “storage,” which is managed by Docker Daemon.

To ensure that the image has been created:
```bash
docker images
```

#### run container
-d (detached mode) Docker launchs the container in the background.
--name You have given the container a convenient name. Now you can refer to it by name instead of its long ID.

```bash
docker run -d --name mariadb_container --env-file .env my_mariadb
```

Output is the Full Container ID.

When you add --env-file .env, Docker automatically makes all variables (such as MYSQL_USER) available inside the container. Your docker-entrypoint.sh.sh script sees them just like regular system variables.

Check status:
```bash
docker ps
```

Check exit status:
```bash
docker ps -a
```

Check logs:
```bash
docker logs mariadb_container
```

You can see for yourself that MariaDB has become PID 1. Start the container and execute:
```bash
docker exec mariadb_container ps aux
```

You will see a table where the PID column opposite mariadbd will contain the number 1. This is the ideal result.

Try going inside the working container and checking whether the database has been created.

Warning: When you restart the database, please note - the user "mari_unix" must be exactly the same as MYSQL_USER in your .env.

```bash
docker exec -it mariadb_container mariadb -u mari_unix -p
```

(When prompted for a password, enter the one specified in .env for the user).

In a script we specified the % symbol when create a use - '${MYSQL_USER}'@'%' - means that the user can connect from any IP address (for example, from a WordPress container). 

In MariaDB, localhost is a special case. Sometimes MariaDB considers ‘mari_unix’@'localhost' and ‘mari_unix’@'%' to be different entries. Try connecting by explicitly specifying the host as 127.0.0.1:

```bash
docker exec -it mariadb_container mariadb -h 127.0.0.1 -u mari_unix -p
```

Let's log in as root (whose password we changed in the script) and look at the list of users.
```bash
docker exec -it mariadb_container mariadb -u root -p
```

```SQL
SELECT user, host, plugin FROM mysql.user;
```

Automatically remove the container and its associated anonymous volumes when it exits
```bash
docker rm -f mariadb_container
```

Delete image:
```bash
docker rmi my_mariadb
```

Issue: The script skipped initialization
Since you are on WSL, Docker Desktop sometimes stores data in internal volumes, even if you have not explicitly specified them.

Try this “nuclear” cleaning method before the next build:

```bash
docker stop $(docker ps -qa) 2>/dev/null
docker rm $(docker ps -qa) 2>/dev/null
docker volume prune -f
```

or
```bash
docker rm -f mariadb_container
docker system prune -a --volumes -f
```