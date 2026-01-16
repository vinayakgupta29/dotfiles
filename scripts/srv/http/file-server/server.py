#!/usr/bin/env python3
import http.server, socketserver, os, json, urllib.parse

PORT = 8000
USER_HOME = "/home/zoro"
DOWNLOADS = os.path.join(USER_HOME, "test/Downloads")
DOCUMENTS = os.path.join(USER_HOME, "test/Documents")
SERVER_ROOT = os.path.dirname(os.path.abspath(__file__))

class FileManagerHandler(http.server.SimpleHTTPRequestHandler):
    def do_GET(self):
        parsed_path = urllib.parse.urlparse(self.path)
        if parsed_path.path.startswith("/api/list"):
            query = urllib.parse.parse_qs(parsed_path.query)
            dir_key = query.get("dir", ["Downloads"])[0]
            dir_map = {"Downloads": DOWNLOADS, "Documents": DOCUMENTS}
            dir_path = dir_map.get(dir_key)
            files=[]
            if dir_path and os.path.exists(dir_path):
                for name in os.listdir(dir_path):
                    full_path = os.path.join(dir_path, name)
                    files.append({
                        "name": name,
                        "path": f"/{dir_key}/{name}",
                        "isDirectory": os.path.isdir(full_path),
                        "type": self.guess_type(name, full_path)
                    })
            self.send_response(200)
            self.send_header("Content-Type","application/json")
            self.end_headers()
            self.wfile.write(json.dumps({"files": files}).encode())
        else:
            super().do_GET()

    def guess_type(self, name, full_path):
        if os.path.isdir(full_path): return "folder"
        ext = name.lower().split('.')[-1]
        if ext in ['jpg','jpeg','png','gif','bmp','webp','svg']: return 'image'
        if ext in ['mp4','webm','avi','mov','mkv']: return 'video'
        if ext in ['mp3','wav','ogg','flac']: return 'audio'
        if ext=='pdf': return 'pdf'
        return 'file'

os.chdir(SERVER_ROOT)
with socketserver.TCPServer(("", PORT), FileManagerHandler) as httpd:
    print(f"[*] Serving file manager at http://localhost:{PORT}")
    httpd.serve_forever()
