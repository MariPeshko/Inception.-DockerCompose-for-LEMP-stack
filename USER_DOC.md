# *User documentation*

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

# 🚀 Starting the Project

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

# 🌐 Access the Website and Administration Panel

## 📍 Website Access

1. **Start the services** (if not already running):
   ```bash
   make setup
   ```

2. **Access the website**:
   - Open your browser and navigate to: **https://mpeshko.42.fr**
   - ⚠️ **SSL Warning**: Click "Advanced" → "Proceed to mpeshko.42.fr" (self-signed certificate)
   - You should see the WordPress homepage titled "Inception_blog"

### 👤 Testing User Functionality

**Adding Comments as a Regular User:**

1. **Navigate to a blog post** on the website
2. **Scroll down** to the comments section
3. **Log in as the regular user**:
   - Use the regular user credentials from the `.env` file
   - **🔒 Credentials**: Contact Maryna Peshko (login: `mpeshko`) for user login details
4. **Add a comment** to any post
5. **Expected behavior**: "Your comment is awaiting moderation. This is a preview; your comment will be visible after it has been approved."

### 🔧 Administration Dashboard Access

**Accessing the Admin Panel:**

1. **Navigate to**: https://mpeshko.42.fr/wp-admin
2. **Log in with administrator credentials**:
   - Use the administrator credentials from the `.env` file
   - **🔒 Credentials**: Contact Maryna Peshko (login: `mpeshko`) for admin login details

**Testing Admin Functionality:**

1. **From the WordPress Dashboard**:
   - Go to **Pages** → **All Pages**
   - Click **Edit** on any existing page (or create a new one)
   - Make some changes (edit title, content, etc.)

2. **Verify changes**:
   - Open a new browser tab/window
   - Confirm that your changes are visible on the live site

# 🔐 Locate and Manage Credentials

## � Access to Credentials

**To obtain the `.env` file with credentials:**
- **Contact**: Maryna Peshko
- **Login**: `mpeshko`
- **Request**: `.env` file for Inception project access

### 📂 Credential Location

All credentials are stored in the environment file:
**📁 File**: `srcs/.env`

### 🌐 WordPress Credentials

#### Administrator Account
- `WP_ADMIN_USER` - Administrator username
- `WP_ADMIN_PASSWORD` - Administrator password  

**Access**: https://mpeshko.42.fr/wp-admin
**Capabilities**: Full administrative access, can manage users, content, themes, plugins

#### Regular User Account
- `WP_USER` - Regular user username
- `WP_PASSWORD` - Regular user password

**Access**: https://mpeshko.42.fr/wp-login.php
**Capabilities**: Can create and edit own posts, add comments

## 🔍 Check That Services Are Running Correctly

### 📊 Service Status Monitoring

**Check Container Status:**
```bash
# View all containers and their status
docker ps

# Expected output: 3 containers running (nginx, wordpress, mariadb)
# STATUS column should show "Up" for all containers
```

### 🔄 Persistence Testing (Critical Evaluation Point)

**Complete Persistence Test:**

1. **Make changes to your WordPress site**:
   - Add comments

2. **Stop all services**:
   ```bash
   make down
   ```

3. **Reboot the virtual machine**:
   ```bash
   sudo reboot
   ```

4. **After reboot, restart services**:
   ```bash
   make up
   ```

5. **Verify persistence**:
   - Access https://mpeshko.42.fr
   - **✅ Expected**: All your previous changes should still be there
   - Check comments and configurations
