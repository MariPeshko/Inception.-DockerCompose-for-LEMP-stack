Check status:
```bash
docker ps
```

Check exit status:
*-a, Show all containers (default shows just running)*
```bash
docker ps -a
```

Check logs:
```bash
docker logs mariadb
```

You can see for yourself that MariaDB has become PID 1. Start the container and execute:
```bash
docker exec mariadb ps aux
```

You will see a table where the PID column opposite mariadbd will contain the number 1. This is the ideal result.
