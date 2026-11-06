from pathlib import Path
import hashlib, re
root=Path(__file__).resolve().parent.parent
out=root/'docs';(out/'assets').mkdir(parents=True,exist_ok=True)
# Remove only stale generated publication files.
for p in out.rglob('*'):
 if p.is_file():p.unlink()
files=['assets/room.webp','assets/map.png','style.css','game.js','config.js']
lookup={}
for name in files:
 data=(root/name).read_bytes();tag=hashlib.sha256(data).hexdigest()[:12];p=Path(name);lookup[name]=str(p.parent/(p.stem+'.'+tag+p.suffix))
# CSS references are hashed before its own filename is calculated.
css=(root/'style.css').read_text()
for a,b in lookup.items():css=css.replace(a,b)
lookup['style.css']='style.'+hashlib.sha256(css.encode()).hexdigest()[:12]+'.css'
for name in files:
 data=css.encode() if name=='style.css' else (root/name).read_bytes()
 (out/lookup[name]).write_bytes(data)
html=(root/'index.html').read_text()
for a,b in lookup.items():html=html.replace(a,b)
(out/'index.html').write_text(html)
(out/'.nojekyll').touch()
print('Production bytes:',sum(p.stat().st_size for p in out.rglob('*') if p.is_file()))
