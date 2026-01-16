#!/usr/bin/env bash
set -e

# ----------------- CONFIG -----------------
PORT=8000
USER_HOME=$(eval echo "~$SUDO_USER")  # Original user who invoked sudo
DOWNLOADS="$USER_HOME/test/Downloads"
DOCUMENTS="$USER_HOME/test/Documents"
SERVER_ROOT="srv/http/file-server"
# -----------------------------------------

# --- Create server directories ---
mkdir -p "$SERVER_ROOT"

# --- Check source directories exist ---
for DIR in "$DOWNLOADS" "$DOCUMENTS"; do
  if [[ ! -d "$DIR" ]]; then
    echo "ERROR: Directory not found: $DIR"
    exit 1
  fi
done

# --- Create symlinks inside SERVER_ROOT ---
ln -sfn "$DOWNLOADS" "$SERVER_ROOT/Downloads"
ln -sfn "$DOCUMENTS" "$SERVER_ROOT/Documents"

# --- Generate index.html ---
cat > "$SERVER_ROOT/index.html" <<'EOF'
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1.0">
<title>File Manager</title>
<link rel="stylesheet" href="style.css">
</head>
<body>
<header>
<h1>📁 File Manager</h1>
<nav>
<button onclick="loadDir('Downloads')">Downloads</button>
<button onclick="loadDir('Documents')">Documents</button>
</nav>
</header>
<div id="breadcrumb"></div>
<div id="files-container" class="files-grid"></div>

<div id="preview-modal" class="modal">
<div id="preview-content"></div>
</div>

<script src="script.js"></script>
</body>
</html>
EOF

# --- Generate style.css ---
cat > "$SERVER_ROOT/style.css" <<'EOF'
body { font-family: sans-serif; margin:0; padding:0; background:#f5f5f5; }
header { background:#333; color:#fff; padding:1em; display:flex; justify-content:space-between; align-items:center; }
header nav button { margin-left:0.5em; padding:0.5em 1em; cursor:pointer; }
.files-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(120px,1fr)); gap:1em; padding:1em; }
.file-item { background:#fff; padding:0.5em; text-align:center; border-radius:5px; cursor:pointer; transition:0.2s; word-break:break-word; }
.file-item:hover { background:#e0e0e0; }
.file-icon { font-size:2em; }
.file-name { margin-top:0.5em; font-size:0.9em; }
.modal { display:none; position:fixed; top:0; left:0; width:100%; height:100%; background:rgba(0,0,0,0.6); justify-content:center; align-items:center; }
#preview-content { background:#fff; padding:1em; max-width:90%; max-height:90%; overflow:auto; border-radius:5px; position:relative; }
.close-modal { position:absolute; top:0.5em; right:0.5em; cursor:pointer; font-size:1.5em; background:none; border:none; }
img, video, audio { max-width:100%; max-height:80vh; }
EOF

# --- Generate script.js ---
cat > "$SERVER_ROOT/script.js" <<'EOF'
let currentPath = '';
async function loadDir(dir){
    currentPath = dir;
    document.getElementById('breadcrumb').innerHTML = `<strong>${dir}</strong>`;
    const resp = await fetch(`/api/list?dir=${encodeURIComponent(dir)}`);
    const data = await resp.json();
    renderFiles(data.files);
}

function renderFiles(files){
    const container = document.getElementById('files-container');
    container.innerHTML = '';
    files.forEach(f=>{
        const item = document.createElement('div');
        item.className='file-item';
        item.dataset.path=f.path;
        let icon='📄';
        if(f.isDirectory) icon='📁';
        else if(f.type==='image') icon='🖼️';
        else if(f.type==='video') icon='🎬';
        else if(f.type==='audio') icon='🎵';
        else if(f.type==='pdf') icon='📕';
        item.innerHTML=`<div class="file-icon">${icon}</div><div class="file-name">${f.name}</div>`;
        item.onclick=()=>f.isDirectory ? loadDir(f.path) : previewFile(f);
        container.appendChild(item);
    });
}

function previewFile(f){
    const modal=document.getElementById('preview-modal');
    const content=document.getElementById('preview-content');
    let html=`<button class="close-modal" onclick="closePreview()">×</button><h3>${f.name}</h3>`;
    if(f.type==='image') html+=`<img src="${f.path}">`;
    else if(f.type==='video') html+=`<video controls src="${f.path}"></video>`;
    else if(f.type==='audio') html+=`<audio controls src="${f.path}"></audio>`;
    else html+=`<p><a href="${f.path}" target="_blank">Download ${f.name}</a></p>`;
    content.innerHTML=html;
    modal.style.display='flex';
}

function closePreview(){
    document.getElementById('preview-modal').style.display='none';
}
EOF

# --- Generate Python server ---
cat > "$SERVER_ROOT/server.py" <<EOF
#!/usr/bin/env python3
import http.server, socketserver, os, json, urllib.parse

PORT = $PORT
USER_HOME = "$USER_HOME"
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
EOF

chmod +x "$SERVER_ROOT/server.py"

# --- Start Python server ---
echo "[*] Starting file manager at http://localhost:$PORT"
cd "$SERVER_ROOT"
python3 server.py

