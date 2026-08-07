"""
Extract base64 PNG data embedded inside SVG files (xlink:href pattern).
Saves extracted PNGs alongside the SVGs as .png files.
Run from project root: python extract_svg_pngs.py
"""
import os, re, base64

SVG_DIRS = [
    r"assets\raw\products",
    r"assets\raw\logos",
    r"assets\raw\banners",
    r"assets\raw\avatars",
    r"assets\raw\images",
    r"assets\raw",  # root loose SVGs
]

# Pattern to find base64 data inside xlink:href="data:image/png;base64,..."
B64_PATTERN = re.compile(r'data:image/png;base64,([A-Za-z0-9+/=\s]+?)(?:"|\))', re.DOTALL)

def extract_from_svg(svg_path):
    with open(svg_path, "r", encoding="utf-8", errors="ignore") as f:
        content = f.read()
    
    if "xlink:href" not in content and "data:image" not in content:
        return False  # no embedded image
    
    matches = B64_PATTERN.findall(content)
    if not matches:
        return False
    
    b64_data = matches[0].strip().replace("\n", "").replace("\r", "").replace(" ", "")
    try:
        png_bytes = base64.b64decode(b64_data)
    except Exception as e:
        print(f"  ERROR decoding {svg_path}: {e}")
        return False
    
    png_path = svg_path.replace(".svg", ".png")
    with open(png_path, "wb") as out:
        out.write(png_bytes)
    print(f"  EXTRACTED: {png_path}")
    return True

def main():
    base = os.path.dirname(os.path.abspath(__file__))
    total = 0
    for rel_dir in SVG_DIRS:
        dir_path = os.path.join(base, rel_dir)
        if not os.path.isdir(dir_path):
            continue
        for fname in os.listdir(dir_path):
            if fname.lower().endswith(".svg"):
                svg_path = os.path.join(dir_path, fname)
                result = extract_from_svg(svg_path)
                if result:
                    total += 1
    print(f"\nDone. Extracted {total} PNGs.")

if __name__ == "__main__":
    main()
