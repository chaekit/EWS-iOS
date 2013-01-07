-- In the tutorial we create the database using the phpMyAdmin tool. Here are
-- the SQL statements in case you want to create the database by hand.

-- To create the database:
CREATE DATABASE pushchat DEFAULT CHARACTER SET utf8 COLLATE utf8_general_ci;

-- To create the user for the database:
USE pushchat;
CREATE USER 'pushchat'@'localhost' IDENTIFIED BY 'password';
GRANT USAGE ON *.* TO 'pushchat'@'localhost' IDENTIFIED BY 'password' WITH MAX_QUERIES_PER_HOUR 0 MAX_CONNECTIONS_PER_HOUR 0 MAX_UPDATES_PER_HOUR 0 MAX_USER_CONNECTIONS 0;
GRANT ALL PRIVILEGES ON pushchat.* TO 'pushchat'@'localhost';
