# this specifies the base image that the build will extend
FROM ubuntu:jammy

# ENV <name> <value> - this instruction sets an environment 
# variable that a running container will use.

# RUN <command>
RUN	apt update && \
	apt install -y --no-install-recommends --no-install-suggests \
	mariadb-server && \
	rm -rf /var/lib/apt/lists/*

# Create a folder for the socket and grant rights to the mysql user
RUN mkdir -p /run/mysqld && chown -R mysql:mysql /run/mysqld

# By default, MariaDB only listens to 127.0.0.1 (localhost). In Docker, 
# this means that no one from outside can connect to it. You need to change 
# the bind-address to 0.0.0.0.
# Configure MariaDB to listen on all interfaces
RUN sed -i "s|bind-address            = 127.0.0.1|bind-address = 0.0.0.0|g" /etc/mysql/mariadb.conf.d/50-server.cnf

# COPY <host-path> <image-path> bring our application code into the image
# from source on the host into destination (working directory)
COPY ./tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

# Do I need it?
EXPOSE 3306

# Specify default executable.
ENTRYPOINT ["bash", "/usr/local/bin/docker-entrypoint.sh"]

# CMD ["<command>", "<arg1>"] - this instruction sets the default 
# command a container using this image will run.
# to make the container to run our application we specify command to start our script
# Launching the database daemon directly
CMD ["mariadbd", "--user=mysql"]
