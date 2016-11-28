#!/usr/bin/env python

import BaseHTTPServer
import json
import subprocess
import re

PORT = 8001

class CheckerHandler(BaseHTTPServer.BaseHTTPRequestHandler):
    def do_OPTIONS(self):
        self.send_response(200, "ok")
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET, OPTIONS')
        self.send_header("Access-Control-Allow-Headers", "X-Requested-With")
        self.send_header("Access-Control-Allow-Headers", "Content-Type")
        self.end_headers()

    def do_POST(self):
        def resp(statusCode, result):
            self.send_response(statusCode)
            self.end_headers()
            self.wfile.write(json.dumps(result))
    
        try:
            input = json.loads(self.rfile.read(int(self.headers.getheader('content-length'))))
            challName = input['chall']
            if not re.match('^[a-zA-Z0-9_]+$', challName):
                resp(400, {'status': 'error', 'error': 'badChallName'});
                return
                
            with open('user.ksy', 'wt') as f: f.write(input['yaml'])
            checkRes = json.loads(subprocess.check_output('node checker.js user.ksy ..\challenges\%s\input.bin ..\challenges\%s\check.json' % (challName, challName)));
                
            resp(200, {'status': 'ok', 'check_res': checkRes});
        except Exception as e:
            print e
            resp(400, {'status': 'exception'});

if __name__ == "__main__":
    BaseHTTPServer.HTTPServer(("", PORT), CheckerHandler).serve_forever()