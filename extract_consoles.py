import re, base64

files = [
    r'assets\raw\products\product_switch_console_1.svg',
    r'assets\raw\products\product_switch_console_2.svg',
]

for path in files:
    with open(path, 'r', encoding='utf-8', errors='ignore') as f:
        content = f.read()
    
    # Try PNG first then JPEG
    for mime in ['data:image/png;base64,', 'data:image/jpeg;base64,', 'data:image/jpg;base64,']:
        idx = content.find(mime)
        if idx != -1:
            ext = 'png' if 'png' in mime else 'jpg'
            start = idx + len(mime)
            end = content.find('"', start)
            if end == -1:
                end = content.find(')', start)
            b64 = content[start:end].strip().replace('\n','').replace('\r','').replace(' ','')
            try:
                img_bytes = base64.b64decode(b64)
                out_path = path.replace('.svg', f'.{ext}')
                with open(out_path,'wb') as o:
                    o.write(img_bytes)
                print(f'EXTRACTED ({mime[:20]}...): {out_path} size={len(img_bytes)}')
            except Exception as e:
                print('ERROR:', path, e)
            break
    else:
        print('NO MATCH:', path)
