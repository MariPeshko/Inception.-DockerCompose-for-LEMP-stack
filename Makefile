# Notes:
# -f flag for docker compose - Docker uses the specific file you specify
# echo -e - enable interpretation of backslash escapes because echo 
# won't interpret \033 codes without it. You see literal \033[0;32m text instead of green color.
# The all: rule is the default rule that runs when you type just make
# hostsed is a specialized tool for managing hosts entries more safely than directly editing the file
# The @ character at the beginning of Make commands suppresses echoing of the command itself.

SRCS			= srcs/
YAML	= $(SRCS)/docker-compose.yml
DOMAIN			= mpeshko.42.fr

# Rules
all: setup

# setup everything (containers + hosts)
setup: up hosts

# start the containers trough docker compose
up:
	@mkdir -p $(HOME)/data/mariadb $(HOME)/data/wordpress && echo -e " $(DIR_CREATED)"
# maybe, I don't need it
#@chown -R $(USER):$(USER) $(HOME)/data/mariadb
#@chown -R $(USER):$(USER) $(HOME)/data/wordpress
	@docker compose -f $(YAML) up -d --build || (echo -e " $(FAIL)" && exit 1)
	@echo " $(UP)"

# add domain to hosts file for browser access
hosts:
	@echo "Adding $(DOMAIN) to /etc/hosts..."
# in case no hostsed on system
#@echo "127.0.0.1 $(DOMAIN)" | sudo tee -a /etc/hosts
	@sudo hostsed add 127.0.0.1 $(DOMAIN) > $(SILENCE)
	@echo " $(HOST_ADD)"

stop:
	@docker compose -f $(YAML) stop
	@echo " $(STOPPED)"

start:
	@docker compose -f $(YAML) start
	@echo " $(STARTED)"

# stop the containers through docker compose
down:
	@docker compose -f $(YAML) down
	@echo " $(DOWN)"

# removes the containers, images and the host url from the host file
# If domain isn't in hosts file with || true: Make continues, treating it as success
fclean: down
	@docker compose -f $(YAML) down -v --rmi all
	@sudo hostsed rm 127.0.0.1 $(DOMAIN) > $(SILENCE) || true
	@echo " $(HOST_RM)"
	@sudo rm -rf $(HOME)/data/mariadb $(HOME)/data/wordpress
	@echo " $(DIR_RMVD)"

# Rebuild from scratch
re: fclean setup

# Customs

GREEN		= \033[0;32m
RED			= \033[0;31m
RESET		= \033[0m

MARK		= $(GREEN)✔$(RESET)
EXECUTED	= $(GREEN)Executed$(RESET)
ADDED		= $(GREEN)Added$(RESET)
REMOVED		= $(GREEN)Removed$(RESET)

SILENCE		= /dev/null 2>&1

# Messages

UP			= $(MARK) Inception		$(EXECUTED)
STARTED		= $(MARK) Started$(RESET)
STOPPED		= $(GREEN)Stopped$(RESET)
DOWN		= $(MARK) Inception	stopped. Containers, networks are removed$(RESET)
FAIL		= $(RED)✔$(RESET) Inception		$(RED)Failed$(RESET)
DIR_CREATED = $(MARK) Directories for volumes are created
DIR_RMVD	= $(MARK) Directories for volumes are deleted
HOST_RM		= $(MARK) Host $(DOMAIN)  $(REMOVED)
HOST_ADD	= $(MARK) Host $(DOMAIN)  $(ADDED)

.PHONY: all up setup hosts stop start down fclean re
