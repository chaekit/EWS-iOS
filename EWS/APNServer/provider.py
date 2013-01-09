from pyapns import configure, provision, notify

configure({'HOST': 'http://localhost:7078'})
provision('4M39WZ89ZP.com.jaychae.EWSApp', open('apns-dev-no-pwd.pem').read(), 'sandbox')
notify('4M39WZ89ZP.com.jaychae.EWSApp', 'f51e9c1d23dbcc431c5c621c4eb77cf4991beee6725e329f411173a2829462ae', {'aps':{'alert': 'Hello!'}})
