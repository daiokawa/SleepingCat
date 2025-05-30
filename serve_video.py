#!/usr/bin/env python3
import http.server
import socketserver
import os

# Change to the directory containing the video
os.chdir('/Users/KoichiOkawa/Downloads')

PORT = 8000

class MyHTTPRequestHandler(http.server.SimpleHTTPRequestHandler):
    def end_headers(self):
        self.send_header('Access-Control-Allow-Origin', '*')
        self.send_header('Access-Control-Allow-Methods', 'GET')
        self.send_header('Cache-Control', 'no-cache')
        super().end_headers()

with socketserver.TCPServer(("", PORT), MyHTTPRequestHandler) as httpd:
    print(f"サーバーを起動しました: http://localhost:{PORT}")
    print("動画ファイル: http://localhost:8000/cat_final_targeted.mov")
    print("Ctrl+C で停止")
    httpd.serve_forever()