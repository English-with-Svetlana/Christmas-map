function fit(){const s=Math.min(innerWidth/1920,innerHeight/1080);document.querySelector('#stage').style.transform=`scale(${s})`}addEventListener('resize',fit);fit();
