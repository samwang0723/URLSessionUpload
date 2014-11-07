#!/usr/bin/env python

import BaseHTTPServer, os, cgi
import cgitb; cgitb.enable()

class Handler(BaseHTTPServer.BaseHTTPRequestHandler):
    def do_GET(self):
        self.send_response(200)
        self.send_header("content-type", "text/html;charset=utf-8")
        self.end_headers()
        self.wfile.write("Upload Complete")

    def do_POST(self):
        print self.headers
        form = cgi.FieldStorage(fp = self.rfile)
        ctype, pdict = cgi.parse_header(self.headers.getheader('content-type'))
        length = cgi.parse_header(self.headers.getheader('Content-Length'))
        print length[0]
        if ctype == 'application/x-www-form-urlencoded':
            qs = self.rfile.read(int(length[0]))
            fout = file(os.path.join('/Users/developer/Desktop', 'swift.png'), 'wb')
            fout.write (qs)
            fout.close()
        self.do_GET()

if __name__ == '__main__':
    server = BaseHTTPServer.HTTPServer(("127.0.0.1", 8000), Handler)
    print('web server on 8000..')
    server.serve_forever()