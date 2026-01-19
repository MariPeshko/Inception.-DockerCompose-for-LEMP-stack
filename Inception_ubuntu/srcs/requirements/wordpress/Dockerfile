FROM ubuntu:jammy

ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && apt install -y --no-install-recommends \
    php8.1-fpm \
    php8.1-mysql \
    curl \
    mariadb-client \
    ca-certificates \
    && rm -rf /var/lib/apt/lists/*

# Installing WP-CLI (a tool for managing WordPress via the console)
RUN curl -s -o /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

# Create a directory for PHP-FPM
RUN mkdir -p /run/php

# Configure PHP-FPM to listen on port 9000 instead of a socket
RUN sed -i 's|listen = /run/php/php8.1-fpm.sock|listen = 9000|g' /etc/php/8.1/fpm/pool.d/www.conf

WORKDIR /var/www/html

COPY ./tools/docker-entrypoint.sh /usr/local/bin/
RUN chmod +x /usr/local/bin/docker-entrypoint.sh

EXPOSE 9000

# Specify default executable.
ENTRYPOINT ["bash", "/usr/local/bin/docker-entrypoint.sh"]

# Running php-fpm in the foreground (F stands for foreground)
CMD ["php-fpm8.1", "-F"]