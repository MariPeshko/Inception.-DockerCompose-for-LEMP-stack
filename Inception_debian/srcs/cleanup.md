Automatically remove the container and its associated anonymous volumes when it exits
```bash
docker rm -f mariadb_container
```

Delete image:
```bash
docker rmi my_mariadb
```

### Cleanup from the evaluation sheet

```bash
# -q, --quiet - Only display container IDs
docker stop $(docker ps -qa);
docker rm $(docker ps -qa);
docker rmi -f $(docker images -qa);
# Attempts to remove all volumes. Fails on in-use volumes.
docker volume rm $(docker volume ls -q);
# 2> file redirects stderr to file. /dev/null is the null device. 
# It takes any input you want and throws it away. It can be used to suppress any output
docker network rm $(docker network ls -q) 2>/dev/null
```

This command only removes Named Volumes. It absolutely "does not see" Bind Mount, because for Docker your /home/mpeshko/data/mariadb folder is just part of your file system, not a Docker object.
```bash
docker volume rm $(docker volume ls -q)
```

Removes only unused volumes.
```bash
docker volume prune -f
```

Removes all unused system resources: containers, networks, volumes, and images. It's a complete cleanup.
```bash
docker system prune -a --volumes -f
```

### How to remove Bind Mount?

To delete data stored via Bind Mount, you need to do it manually in your virtual machine's terminal:
```bash
sudo rm -rf $HOME/data/mariadb/*
# take ownership back to mpeshko
sudo chown -R mpeshko:mpeshko $HOME/data/mariadb

sudo rm -rf $HOME/data/wordpress/*
# take ownership back to mpeshko
sudo chown -R mpeshko:mpeshko $HOME/data/wordpress
```
