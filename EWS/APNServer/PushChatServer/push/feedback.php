<?php

// This script should be run every so often from a cron job. It connects to the
// APNS Feedback Service and retrieves a list of device tokens that are no 
// longer valid for our app. We remove the user accounts associated with these
// tokens from our database so we will no longer send them push notifications.
//
// A device token becomes invalid when a user uninstalls the app. Our attempts
// to push to their device will now fail and the APNS Feedback Service lets us
// know that we should no longer send push notifications to that device.
//
// Unlike the push script, the feedback.php script does not run continuously as
// a background process. It makes a connection, does its job, and exits. It is
// best to run this script periodically, e.g. once every hour.

try
{
	require_once('feedback_config.php');

	ini_set('display_errors', 'off');

	if ($argc != 2 || ($argv[1] != 'development' && $argv[1] != 'production'))
		exit("Usage: php feedback.php development|production". PHP_EOL);

	$mode = $argv[1];
	$config = $config[$mode];

	echo "Feedback script started ($mode mode)" . PHP_EOL;

	$obj = new APNS_Feedback($config);
	$obj->start();

	echo 'Feedback script done' . PHP_EOL;
}
catch (Exception $e)
{
	echo $e . PHP_EOL;
}

////////////////////////////////////////////////////////////////////////////////

class APNS_Feedback
{
	private $server;
	private $certificate;
	private $passphrase;

	function __construct($config)
	{
		$this->server = $config['server'];
		$this->certificate = $config['certificate'];
		$this->passphrase = $config['passphrase'];

		// Create a connection to the database.
		$this->pdo = new PDO(
			'mysql:host=' . $config['db']['host'] . ';dbname=' . $config['db']['dbname'], 
			$config['db']['username'], 
			$config['db']['password'],
			array());

		// If there is an error executing database queries, we want PDO to
		// throw an exception.
		$this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
	}

	// This is where the magic happens.
	function start()
	{
		$tuples = $this->retrieveFeedbackTuples();
		if ($tuples !== false)
		{
			$tupleCount = strlen($tuples) / 38;
			echo "Downloaded $tupleCount device tokens" . PHP_EOL;

			for ($i = 0; $i < $tupleCount; $i++)
			{
				$offset = $i * 38;

				// Each tuple is 38 bytes. The first 4 bytes contain a UNIX
				// timestamp that indicates when the APNS determined that the
				// application no longer exists on the device.

				$timestamp = substr($tuples, $offset, 4);
				$timestamp = hexdec(bin2hex($timestamp));

				// The next 2 bytes contain the length of the device token.
				// Currently, this is always 32.

				$length = substr($tuples, $offset + 4, 2);
				$length = hexdec(bin2hex($length));

				// The remaining 32 bytes contain the device token. We convert
				// it to a 64-character hexadecimal string.

				$token = substr($tuples, $offset + 6, 32);
				$token = bin2hex($token);

				echo 'Timestamp: ' . $timestamp . ', Token: ' . $token . PHP_EOL;

				$this->unregisterDeviceToken($token);
			}
		}
	}

	// Opens an SSL/TLS connection to the feedback server and downloads a list
	// of device tokens. Returns the binary list of feedback tuples on success,
	// FALSE on failure.
	function retrieveFeedbackTuples()
	{
		echo 'Connecting to ' . $this->server . PHP_EOL;

		$ctx = stream_context_create();
		stream_context_set_option($ctx, 'ssl', 'local_cert', $this->certificate);
		stream_context_set_option($ctx, 'ssl', 'passphrase', $this->passphrase);

		$fp = stream_socket_client(
			'ssl://' . $this->server, $err, $errstr, 60, STREAM_CLIENT_CONNECT, $ctx);

		if (!$fp)
		{
			echo "Failed to connect: $err $errstr" . PHP_EOL;
			return FALSE;
		}

		$tuples = stream_get_contents($fp);
		fclose($fp);

		if ($tuples === false)
		{
			echo 'Failed to download device tokens' . PHP_EOL;
			return FALSE;
		}

		return $tuples;
	}

	// Removes the record for this device token from the list of active users.
	function unregisterDeviceToken($token)
	{
		$stmt = $this->pdo->prepare('DELETE FROM active_users WHERE device_token = ?');
		$stmt->execute(array($token));
	}
}
