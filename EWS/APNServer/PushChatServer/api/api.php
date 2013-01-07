<?php

// This is the server API for the PushChat iPhone app. To use the API, the app
// sends an HTTP POST request to our URL. The POST data contains a field "cmd"
// that indicates what API command should be executed.

try
{
	// Are we running in development or production mode? You can easily switch
	// between these two in the Apache VirtualHost configuration.
	if (!defined('APPLICATION_ENV'))
		define('APPLICATION_ENV', getenv('APPLICATION_ENV') ? getenv('APPLICATION_ENV') : 'production');

	// In development mode, we show all errors because we obviously want to 
	// know about them. We don't do this in production mode because that might
	// expose critical details of our app or our database. Critical PHP errors
	// will still be logged in the PHP and Apache error logs, so it's always
	// a good idea to keep an eye on them.
	if (APPLICATION_ENV == 'development')
	{
		error_reporting(E_ALL|E_STRICT);
		ini_set('display_errors', 'on');
	}
	else
	{
		error_reporting(0);
		ini_set('display_errors', 'off');
	}

	// Load the config file. I prefer to keep all configuration settings in a
	// separate file so you don't have to mess around in the main code if you
	// just want to change some settings.
	require_once 'api_config.php';
	$config = $config[APPLICATION_ENV];

	// In development mode, we fake a delay that makes testing more realistic.
	// You're probably running this on a fast local server but in production
	// mode people will be using it on a mobile device over a slow connection.
	if (APPLICATION_ENV == 'development')
		sleep(2);

	// To keep the code clean, I put the API into its own class. Create an
	// instance of that class and let it handle the request.
	$api = new API($config);
	$api->handleCommand();

	echo "OK" . PHP_EOL;
}
catch (Exception $e)
{
	// The code throws an exception when something goes horribly wrong; e.g.
	// no connection to the database could be made. In development mode, we
	// show these exception messages. In production mode, we simply return a
	// "500 Server Error" message.

	if (APPLICATION_ENV == 'development')
		var_dump($e);
	else
		exitWithHttpError(500);
}

////////////////////////////////////////////////////////////////////////////////

function exitWithHttpError($error_code, $message = '')
{
	switch ($error_code)
	{
		case 400: header("HTTP/1.0 400 Bad Request"); break;
		case 403: header("HTTP/1.0 403 Forbidden"); break;
		case 404: header("HTTP/1.0 404 Not Found"); break;
		case 500: header("HTTP/1.0 500 Server Error"); break;
	}

	header('Content-Type: text/plain');

	if ($message != '')
		header('X-Error-Description: ' . $message);

	exit;
}

function isValidUtf8String($string, $maxLength, $allowNewlines = false)
{
	if (empty($string) || strlen($string) > $maxLength)
		return false;

	if (mb_check_encoding($string, 'UTF-8') === false)
		return false;

	// Don't allow control characters, except possibly newlines	
	for ($t = 0; $t < strlen($string); $t++)
	{
		$ord = ord($string{$t});

		if ($allowNewlines && ($ord == 10 || $ord == 13))
			continue;

		if ($ord < 32)
			return false;
	}

	return true;
}

function truncateUtf8($string, $maxLength)
{
	$origString = $string;
	$origLength = $maxLength;

	while (strlen($string) > $origLength)
	{
		$string = mb_substr($origString, 0, $maxLength, 'utf-8');
		$maxLength--;
	}

	return $string;
}

////////////////////////////////////////////////////////////////////////////////

class API
{
	// Because the payload only allows for 256 bytes and there is some overhead
	// we limit the message text to 190 characters.
	const MAX_MESSAGE_LENGTH = 190;

	private $pdo;

	function __construct($config)
	{
		// Create a connection to the database.
		$this->pdo = new PDO(
			'mysql:host=' . $config['db']['host'] . ';dbname=' . $config['db']['dbname'], 
			$config['db']['username'], 
			$config['db']['password'],
			array());

		// If there is an error executing database queries, we want PDO to
		// throw an exception. Our exception handler will then exit the script
		// with a "500 Server Error" message.
		$this->pdo->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);

		// We want the database to handle all strings as UTF-8.
		$this->pdo->query('SET NAMES utf8');
	}

	function handleCommand()
	{
		// Figure out which command the client sent and let the corresponding
		// method handle it. If the command is unknown, then exit with an error
		// message.
		if (isset($_POST['cmd']))
		{
			switch (trim($_POST['cmd']))
			{
				case 'join': $this->handleJoin(); return;
				case 'leave': $this->handleLeave(); return;
				case 'update': $this->handleUpdate(); return;
				case 'message': $this->handleMessage(); return;
			}
		}

		exitWithHttpError(400, 'Unknown command');
	}

	// The "join" API command registers a user to receive notifications that
	// are sent in a specific "chat room". Each chat room is identified by a
	// secret code. All the users who register with the same secret code can
	// see each other's messages.
	//
	// This command takes the following POST parameters:
	//
	// - udid:  The device's UDID. Must be a string of 40 hexadecimal characters.
	// - token: The device's device token. Must be a string of 64 hexadecimal
	//          characters, or "0" if no token is available yet.
	// - name:  The nickname of the user. Must be a UTF-8 string of maximum 255
	//          bytes. Only the first 20 bytes are actually shown in the push 
	//          notifications.
	// - code:  The secret code that identifies the chat room. Must be a UTF-8
	//          string of maximum 255 bytes.
	//
	function handleJoin()
	{
		$udid = $this->getUDID();
		$token = $this->getDeviceToken(true);
		$name = $this->getString('name', 255);
		$code = $this->getString('code', 255);

		// When the client sends a "join" command, we add a new record to the
		// active_users table. We identify the client by the UDID that it
		// provides. When the client sends a "leave" command, we delete its
		// record from the active_users table.

		// It is theoretically possible that a client sends a "join" command
		// while its UDID is still present in active_users (because it did not
		// send a "leave" command). In that case, we simply remove the old
		// record first and then insert the new one.

		$this->pdo->beginTransaction();

		$stmt = $this->pdo->prepare('DELETE FROM active_users WHERE udid = ?');
		$stmt->execute(array($udid));

		$stmt = $this->pdo->prepare('INSERT INTO active_users (udid, device_token, nickname, secret_code, ip_address) VALUES (?, ?, ?, ?, ?)');
		$stmt->execute(array($udid, $token, $name, $code, $_SERVER['REMOTE_ADDR']));

		$this->pdo->commit();
	}

	// The "leave" API command removes a user from a chat room. That user will
	// no longer receive push notifications for messages sent to that room.
	//
	// This command takes the following POST parameters:
	//
	// - udid: The device's UDID. Must be a string of 40 hexadecimal characters.
	//
	function handleLeave()
	{
		$udid = $this->getUDID();
		$stmt = $this->pdo->prepare('DELETE FROM active_users WHERE udid = ?');
		$stmt->execute(array($udid));
	}

	// The "update" API command gives a user a new device token.
	//
	// This command takes the following POST parameters:
	//
	// - udid:  The device's UDID. Must be a string of 40 hexadecimal characters.
	// - token: The device's device token. Must be a string of 64 hexadecimal
	//          characters.
	//
	function handleUpdate()
	{
		$udid = $this->getUDID();
		$token = $this->getDeviceToken(false);
		$stmt = $this->pdo->prepare('UPDATE active_users SET device_token = ? WHERE udid = ?');
		$stmt->execute(array($token, $udid));
	}

	// The "message" API command sends a message to all users who are registered
	// with the same secret code as the sender of the message.
	//
	// This command takes the following POST parameters:
	//
	// - udid: The device's UDID. Must be a string of 40 hexadecimal characters.
	// - text: The message text. Must be a UTF-8 string of maximum 190 bytes.
	//
	function handleMessage()
	{
		$udid = $this->getUDID();
		$text = $this->getString('text', self::MAX_MESSAGE_LENGTH, true);

		// First, we get the record for the sender of the message from the
		// active_users table. That gives us the nickname, device token, and
		// secret code for that user.

		$stmt = $this->pdo->prepare('SELECT * FROM active_users WHERE udid = ? LIMIT 1');
		$stmt->execute(array($udid));
		$user = $stmt->fetch(PDO::FETCH_OBJ);

		if ($user !== false)
		{
			// Put the sender's name and the message text into the JSON payload
			// for the push notification.
			$payload = $this->makePayload($user->nickname, $text);

			// Find the device tokens for all other users who are registered
			// for this secret code. We exclude the device token of the sender
			// of the message, so he will not get a push notification. We also
			// exclude users who have not submitted a valid device token yet.
			$stmt = $this->pdo->prepare("SELECT device_token FROM active_users WHERE secret_code = ? AND device_token <> ? AND device_token <> '0'");
			$stmt->execute(array($user->secret_code, $user->device_token));
			$tokens = $stmt->fetchAll(PDO::FETCH_COLUMN);

			// Send out a push notification to each of these devices.
			foreach ($tokens as $token)
			{
				$this->addPushNotification($token, $payload);
			}
		}
	}

	// Retrieves the device identifier from the POST data. If the UDID does not
	// appear to be valid, the script exits with an error message.
	function getUDID()
	{
		if (!isset($_POST['udid']))
			exitWithHttpError(400, 'Missing udid');

		$udid = trim(urldecode($_POST['udid']));
		if (!$this->isValidUDID($udid))
			exitWithHttpError(400, 'Invalid udid');

		return $udid;
	}

	// Checks whether the format of the device identifier is correct (40 hex
	// characters or 32 for the simulator). Note: we have no means to verify
	// whether the identifier corresponds to an actual device.
	function isValidUDID($udid)
	{
		if (strlen($udid) != 40 && strlen($udid) != 32)  // 32 for simulator
			return false;

		if (preg_match("/^[0-9a-fA-F]+$/", $udid) == 0)
			return false;

		return true;
	}

	// Retrieves the device token from the POST data. If the token does not
	// appear to be valid, the script exits with an error message.
	function getDeviceToken($mayBeEmpty = false)
	{
		if (!isset($_POST['token']))
			exitWithHttpError(400, 'Missing device token');

		$token = trim($_POST['token']);

		// The "join" command allows a token value of "0" to be specified,
		// which is necessary in case the client did not yet obtain a device
		// token at that point. We allow such clients to join, but they will
		// not receive any notifications until they provide a valid token
		// using the "update" command.
		if ($mayBeEmpty && $token == "0")
			return $token;

		if (!$this->isValidDeviceToken($token))
			exitWithHttpError(400, 'Invalid device token');

		return $token;	
	}

	// Checks whether the format of the device token is correct (64 hexadecimal
	// characters). Note: we have no means to verify whether the device token
	// was really issued by APNS and corresponds to an actual device.
	function isValidDeviceToken($deviceToken)
	{
		if (strlen($deviceToken) != 64)
			return false;

		if (preg_match("/^[0-9a-fA-F]{64}$/", $deviceToken) == 0)
			return false;

		return true;
	}

	// Looks in the POST data for a field with the given name. If the field
	// is not a valid UTF-8 string, or it is too long, the script exits with
	// an error message.
	function getString($name, $maxLength, $allowNewlines = false)
	{
		if (!isset($_POST[$name]))
			exitWithHttpError(400, "Missing $name");

		$string = trim($_POST[$name]);
		if (!isValidUtf8String($string, $maxLength, $allowNewlines))
			exitWithHttpError(400, "Invalid $name");

		return $string;
	}

	// Creates the JSON payload for the push notification message. The "alert"
	// text has the following format: "sender_name: message_text". Recipients
	// can obtain the name of the sender by parsing the alert text up to the
	// first colon followed by a space.
	function makePayload($senderName, $text)
	{
		// Convert the nickname of the sender to JSON and truncate to a maximum
		// length of 20 bytes (which may be less than 20 characters).
		$nameJson = $this->jsonEncode($senderName);
		$nameJson = truncateUtf8($nameJson, 20);

		// Convert and truncate the message text
		$textJson = $this->jsonEncode($text);
		$textJson = truncateUtf8($textJson, self::MAX_MESSAGE_LENGTH);

		// Combine everything into a JSON string
		$payload = '{"aps":{"alert":"' . $nameJson . ': ' . $textJson . '","sound":"default"}}';
		return $payload;
	}

	// We don't use PHP's built-in json_encode() function because it converts
	// UTF-8 characters to \uxxxx. That eats up 6 characters in the payload for
	// no good reason, as JSON already supports UTF-8 just fine.
	function jsonEncode($text)
	{
		static $from = array("\\", "/", "\n", "\t", "\r", "\b", "\f", '"');
		static $to = array('\\\\', '\\/', '\\n', '\\t', '\\r', '\\b', '\\f', '\"');
		return str_replace($from, $to, $text);
	}

	// Adds a push notification to the push queue. The notification will not
	// be sent immediately. The server runs a separate script, push.php, which 
	// periodically checks for new entries in this database table and sends
	// them to the APNS servers.
	function addPushNotification($deviceToken, $payload)
	{
		// Payloads have a maximum size of 256 bytes. If the payload is too
		// large (which shouldn't happen), we won't send this notification.
		if (strlen($payload) <= 256)
		{
			$stmt = $this->pdo->prepare('INSERT INTO push_queue (device_token, payload, time_queued) VALUES (?, ?, NOW())');
			$stmt->execute(array($deviceToken, $payload));
		}
	}
}
