<?php

// This script inserts a test message into the push_queue database table.
// You can use it to quickly test the delivery of push notifications.
//
// Usage: php push_test.php <device token> <your message>

if ($argc != 3)
	exit("Usage: php push_test.php <device token> <your message>" . PHP_EOL);

$deviceToken = $argv[1];
$alert = $argv[2];

$body['aps'] = array(
	'alert' => $alert, 
	'sound' => 'default'
	);

require_once('push_config.php');
$config = $config['development'];

$pdo = new PDO(
	'mysql:host=' . $config['db']['host'] . ';dbname=' . $config['db']['dbname'], 
	$config['db']['username'], 
	$config['db']['password'],
	array());

$payload = json_encode($body);

$stmt = $pdo->prepare('INSERT INTO push_queue (device_token, payload, time_queued) VALUES (?, ?, NOW())');
$stmt->execute(array($deviceToken, $payload));

echo 'New notification inserted' . PHP_EOL;
