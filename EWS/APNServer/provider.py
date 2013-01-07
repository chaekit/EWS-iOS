from pyapns import configure, provision, notify

configure({'HOST': 'http://localhost:7077'})
provision('com.jaychae.EWSApp', open('apns-dev-cert.pem').read(), 'sandbox')
notify('com.jaychae.EWSApp', 'f51e9c1d23dbcc431c5c621c4eb77cf4991beee6725e329f411173a2829462ae', {'aps':{'alert': 'Hello!'}})
