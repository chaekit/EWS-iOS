USE pushchat;

SET NAMES utf8;

DROP TABLE IF EXISTS active_users;

CREATE TABLE active_users
(
	udid varchar(40) NOT NULL PRIMARY KEY,
	device_token varchar(64) NOT NULL,
	nickname varchar(255) NOT NULL,
	secret_code varchar(255) NOT NULL,
	ip_address varchar(32) NOT NULL
)
ENGINE=InnoDB DEFAULT CHARSET=utf8;
