<?php

// Configuration file for push.php

$config = array(
	// These are the settings for development mode
	'development' => array(

		// The APNS server that we will use
		'server' => 'gateway.sandbox.push.apple.com:2195',

		// The SSL certificate that allows us to connect to the APNS servers
		'certificate' => 'ck_development.pem',
		'passphrase' => 'pushchat',

		// Configuration of the MySQL database
		'db' => array(
			'host'     => 'localhost',
			'dbname'   => 'pushchat',
			'username' => 'pushchat',
			'password' => 'd]682\#%yI1nb3',
			),

		// Name and path of our log file
		'logfile' => '../log/push_development.log',
		),

	// These are the settings for production mode
	'production' => array(

		// The APNS server that we will use
		'server' => 'gateway.push.apple.com:2195',

		// The SSL certificate that allows us to connect to the APNS servers
		'certificate' => 'ck_production.pem',
		'passphrase' => 'pushchat',

		// Configuration of the MySQL database
		'db' => array(
			'host'     => 'localhost',
			'dbname'   => 'pushchat',
			'username' => 'pushchat',
			'password' => 'password',
			),

		// Name and path of our log file
		'logfile' => '../log/push_production.log',
		),
	);
