<?php

// Configuration file for feedback.php

$config = array(
	// These are the settings for development mode
	'development' => array(

		// The APNS feedback server that we will use
		'server' => 'feedback.sandbox.push.apple.com:2196',

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
		),

	// These are the settings for production mode
	'production' => array(

		// The APNS feedback server that we will use
		'server' => 'feedback.push.apple.com:2196',

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
		),
	);
