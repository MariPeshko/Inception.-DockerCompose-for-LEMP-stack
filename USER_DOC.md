# *User documentation*

This file must explain, in clear and simple terms, how an end user or administrator can:

◦ Understand what services are provided by the stack.

◦ Start and stop the project.

◦ TODO Access the website and the administration panel.

◦ TODO Locate and manage credentials.

◦ TODO Check that the services are running correctly.

# Services Provided by the Stack

This Inception project provides a complete web hosting stack with three main services:

## 📦 Services Overview

### 🗃️ MariaDB (Database)
- **Purpose**: Database server for storing WordPress data
- **Container**: `mariadb`
- **Port**: Internal communication only (3306)
- **Data Storage**: `~/data/mariadb` (persistent storage)
- **Features**: MySQL-compatible database with user management

### 🌐 WordPress (Content Management)
- **Purpose**: Web application and content management system
- **Container**: `wordpress` 
- **Port**: Internal communication with Nginx (9000/FastCGI)
- **Data Storage**: `~/data/wordpress` (persistent storage)
- **Features**: Full WordPress installation with themes and plugins

### 🔒 Nginx (Web Server)
- **Purpose**: Reverse proxy and web server with SSL termination
- **Container**: `nginx`
- **Port**: 443 (HTTPS only)
- **Features**: 
  - TLS/SSL encryption
  - Reverse proxy to WordPress
  - Static file serving
  - Self-signed certificate

## 🌐 Network Architecture
- **Network**: `inception` (custom bridge network)
- **Communication**: Services communicate internally via container names
- **External Access**: Only Nginx port 443 is exposed to host

## 🚀 Starting the Project

### Full Setup (Recommended)
```bash
make
# or
make setup
```
This will:
1. Create required directories (`~/data/mariadb`, `~/data/wordpress`)
2. Build and start all containers in detached mode
3. Add domain `mpeshko.42.fr` to `/etc/hosts`

### Container Only (No Hosts Entry)
```bash
make up
```
Starts containers without modifying `/etc/hosts`

### Add Domain to Hosts (Separate)
```bash
make hosts
```
Adds `mpeshko.42.fr` to `/etc/hosts` for browser access

## 🛑 Stopping the Project

### Stop Containers (Keep Images)
```bash
make down
```
Stops and removes containers, keeps images and data

### Pause Containers
```bash
make stop
```
Pauses containers without removing them

### Resume Containers  
```bash
make start
```
Resumes paused containers

## 🧹 Cleaning Up

### Complete Cleanup
```bash
make fclean
```
This will:
1. Stop and remove all containers
2. Remove all images and volumes
3. Remove domain from `/etc/hosts`
4. Delete data directories

### Rebuild Everything
```bash
make re
```

## 🌐 Accessing the Website

After running `make setup`, open your browser and visit:
**https://mpeshko.42.fr**

⚠️ **Expected SSL Warning**: The browser will show a security warning due to the self-signed certificate (this is required by the project). Click "Advanced" → "Proceed to mpeshko.42.fr" to continue.
