<?php

// This script tests if we can connect to our database.

try
{
	if (!defined('APPLICATION_ENV'))
		define('APPLICATION_ENV', getenv('APPLICATION_ENV') ? getenv('APPLICATION_ENV') : 'production');

	require_once '../api_config.php';
	$config = $config[APPLICATION_ENV];

	$pdo = new PDO(
		'mysql:host=' . $config['db']['host'] . ';dbname=' . $config['db']['dbname'], 
		$config['db']['username'], 
		$config['db']['password'],
		array());
	
	$pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	$pdo->query('SET NAMES utf8');
	
	echo 'Database connection successful!';
}
catch (Exception $e)
{
	echo 'Could not connect to the database. Reason: ' . $e;
}
