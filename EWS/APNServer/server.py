import tornado.httpserver
import tornado.ioloop
import tornado.web
import tornado.options
from tornado.options import define, options

import simplejson as json

from apns import APNs, Payload

from sqlalchemy.orm import scoped_session, sessionmaker
from models import *

define("port", default=8080, help="run on the given port", type=int)

class Application(tornado.web.Application):
    def __init__(self):
        handlers = [
            (r"/", PollUsageHandler),
            (r"/add-device", DeviceHandler),
            (r"/add-notification", NotificationHandler)
        ]

        tornado.web.Application.__init__(self, handlers, debug=True)
        self.db = scoped_session(sessionmaker(bind=engine))

class PollUsageHandler(tornado.web.RequestHandler):
    def get(self):
        lab_usage_json = {"data": [{"strlabname": "DCL L416","inusecount": 12,"machinecount": 26},
            {"strlabname": "DCL L440","inusecount": 12,"machinecount": 30},
            {"strlabname": "DCL L520","inusecount": 39,"machinecount": 41},
            {"strlabname": "EH 406B1","inusecount": 5,"machinecount": 40},
            {"strlabname": "EH 406B8","inusecount": 5,"machinecount": 40},
            {"strlabname": "EVRT 252","inusecount": 16,"machinecount": 39},
            {"strlabname": "GELIB 057","inusecount": 29,"machinecount": 40},
            {"strlabname": "GELIB 4th","inusecount": 24,"machinecount": 39},
            {"strlabname": "MEL 1001","inusecount": 25,"machinecount": 25},
            {"strlabname": "MEL 1009","inusecount": 12,"machinecount": 40},
            {"strlabname": "SIEBL 0218","inusecount": 12,"machinecount": 21},
            {"strlabname": "SIEBL 0220","inusecount": 6,"machinecount": 21},
            {"strlabname": "SIEBL 0222","inusecount": 21,"machinecount": 21}]}
        self.write(json.dumps(lab_usage_json))
        print self.application.db.query(Lab).all()
        return

class DeviceHandler(tornado.web.RequestHandler):
    def post(self):
        access_token_arg = self.get_argument('access_token')
        udid_arg = self.get_argument('udid')
        print access_token_arg
        print udid_arg
        device = Device(udid=udid_arg, access_token=access_token_arg)
        self.application.db.add(device)
        self.application.db.commit()


class NotificationHandler(tornado.web.RequestHandler):
    def post(self):
        apns = APNs(use_sandbox=True, cert_file='apns-dev-cert.pem', key_file='apns-dev-key.pem')
        # Send a notification
        token_hex = 'f51e9c1d23dbcc431c5c621c4eb77cf4991beee6725e329f411173a2829462ae'
        payload = Payload(alert="Hello World!", sound="default", badge=1)
        apns.gateway_server.send_notification(token_hex, payload)
        print "LOL"

    def get(self):
        apns = APNs(use_sandbox=True, cert_file='apns-dev-cert.pem', key_file='apns-dev-key.pem')
        # Send a notification
        token_hex = 'f51e9c1d23dbcc431c5c621c4eb77cf4991beee6725e329f411173a2829462ae'
        payload = Payload(alert="Hello World!", sound="default", badge=1)
        apns.gateway_server.send_notification(token_hex, payload)
        print "LOL"

if __name__ == '__main__':
    tornado.options.parse_command_line()
    http_server = tornado.httpserver.HTTPServer(Application())
    http_server.listen(options.port)
    tornado.ioloop.IOLoop.instance().start()
