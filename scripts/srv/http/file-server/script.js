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
