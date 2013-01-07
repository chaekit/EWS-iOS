from apns import APNs, Payload

apns = APNs(use_sandbox=True, cert_file='apns-dev-cert.pem', key_file='apns-dev-key.pem')

# Send a notification
token_hex = 'f51e9c1d23dbcc431c5c621c4eb77cf4991beee6725e329f411173a2829462ae'
payload = Payload(alert="Hello World!", sound="default", badge=1)
apns.gateway_server.send_notification(token_hex, payload)
