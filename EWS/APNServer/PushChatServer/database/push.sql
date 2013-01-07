USE pushchat;

SET NAMES utf8;

DROP TABLE IF EXISTS push_queue;

CREATE TABLE push_queue
(
	message_id integer NOT NULL AUTO_INCREMENT,
	device_token varchar(64) NOT NULL,
	payload varchar(256) NOT NULL,
	time_queued datetime NOT NULL,
	time_sent datetime,
	PRIMARY KEY (message_id)
)
ENGINE=InnoDB DEFAULT CHARSET=latin1;
