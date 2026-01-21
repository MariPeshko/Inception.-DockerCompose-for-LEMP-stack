## check mariadb

Go inside the working container and check whether the database has been created.

Warning: When you restart the database, please note - the user "mpeshko" must be exactly the same as MYSQL_USER in your .env.

```bash
docker exec -it mariadb_container mariadb -u mpeshko -p
```

(When prompted for a password, enter the one specified in .env for the user).

```SQL
SHOW DATABASES;
```

Switch to your database.
```SQL
USE your_database_name;
SHOW TABLES;
```

Create your first, simplest spreadsheet. For example, for some notes.
```SQL
CREATE TABLE notes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    message VARCHAR(255)
);
INSERT INTO notes (message) VALUES ('Hello, MariaDB!');
SELECT * FROM notes;
```

Let's log in as root (whose password we changed in the script) and look at the list of users.
```bash
docker exec -it mariadb_container mariadb -u root -p
```

```SQL
SELECT user, host, plugin FROM mysql.user;
```

