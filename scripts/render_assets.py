import os
import subprocess
from PIL import Image, ImageDraw

PROJECT_ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), ".."))
EDGE_PATH = r"C:\Program Files (x86)\Microsoft\Edge\Application\msedge.exe"

# 1. HTML for 512x512 App Icon
ICON_HTML = """<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body {
    width: 512px;
    height: 512px;
    background: transparent;
    display: flex;
    align-items: center;
    justify-content: center;
  }
  .icon-box {
    width: 512px;
    height: 512px;
    background: linear-gradient(135deg, #ea580c 0%, #f97316 50%, #fb923c 100%);
    display: flex;
    align-items: center;
    justify-content: center;
  }
  svg {
    width: 420px;
    height: 420px;
  }
</style>
</head>
<body>
  <div class="icon-box">
    <svg viewBox="0 0 24 24">
      <path fill-rule="evenodd" clip-rule="evenodd" d="M10.5 2C6.91 2 4 4.91 4 8.5c0 4.89 6.5 12.5 6.5 12.5s6.5-7.61 6.5-12.5C17 4.91 14.09 2 10.5 2zm0 10a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7z" fill="#ffffff"/>
      <path d="M10.5 5.8l.68 1.38 1.53.22-1.11 1.08.26 1.52-1.36-.72-1.36.72.26-1.52-1.11-1.08 1.53-.22z" fill="#ffffff"/>
      <path d="M17.5 4.5c1.7 1.1 2.8 2.9 2.8 5s-1.1 3.9-2.8 5" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round"/>
      <path d="M20.2 2c2.6 1.6 4 4.2 4 7.5s-1.4 5.9-4 7.5" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round"/>
    </svg>
  </div>
</body>
</html>
"""

# 2. HTML for 1200x630 Open Graph Social Banner
OG_HTML = """<!DOCTYPE html>
<html>
<head>
<meta charset="utf-8">
<style>
  * { margin: 0; padding: 0; box-sizing: border-box; }
  body {
    width: 1200px;
    height: 630px;
    background: #0c0a09;
    font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', Roboto, 'Helvetica Neue', Arial, sans-serif;
    color: #ffffff;
    display: flex;
    align-items: center;
    justify-content: center;
    position: relative;
    overflow: hidden;
  }
  .glow-1 {
    position: absolute;
    top: -120px;
    right: -100px;
    width: 600px;
    height: 600px;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(249, 115, 22, 0.4) 0%, transparent 70%);
    filter: blur(80px);
  }
  .glow-2 {
    position: absolute;
    bottom: -140px;
    left: -100px;
    width: 550px;
    height: 550px;
    border-radius: 50%;
    background: radial-gradient(circle, rgba(234, 88, 12, 0.3) 0%, transparent 70%);
    filter: blur(80px);
  }
  .card {
    position: relative;
    z-index: 10;
    width: 1060px;
    background: rgba(28, 25, 23, 0.85);
    border: 1px solid rgba(255, 255, 255, 0.12);
    border-radius: 36px;
    padding: 56px 64px;
    display: flex;
    flex-direction: column;
    align-items: center;
    text-align: center;
    box-shadow: 0 30px 80px rgba(0, 0, 0, 0.7), 0 0 60px rgba(249, 115, 22, 0.15);
  }
  .header-row {
    display: flex;
    align-items: center;
    gap: 20px;
    margin-bottom: 24px;
  }
  .icon-mini {
    width: 80px;
    height: 80px;
    border-radius: 24px;
    background: linear-gradient(135deg, #ea580c 0%, #f97316 50%, #fb923c 100%);
    display: flex;
    align-items: center;
    justify-content: center;
    box-shadow: 0 10px 30px rgba(234, 88, 12, 0.5);
    border: 1px solid rgba(255, 255, 255, 0.2);
  }
  .icon-mini svg {
    width: 48px;
    height: 48px;
  }
  .stars-row {
    display: flex;
    gap: 8px;
    align-items: center;
  }
  .star {
    width: 32px;
    height: 32px;
    fill: #f59e0b;
    filter: drop-shadow(0 2px 8px rgba(245, 158, 11, 0.6));
  }
  h1 {
    font-size: 54px;
    font-weight: 900;
    letter-spacing: -1.5px;
    background: linear-gradient(180deg, #ffffff 30%, #e2e8f0 100%);
    -webkit-background-clip: text;
    -webkit-text-fill-color: transparent;
    margin-bottom: 12px;
    line-height: 1.1;
  }
  p.subtitle {
    font-size: 22px;
    color: #a8a29e;
    font-weight: 500;
    margin-bottom: 36px;
    max-width: 820px;
    line-height: 1.4;
  }
  .badges-grid {
    display: flex;
    gap: 14px;
    flex-wrap: wrap;
    justify-content: center;
    margin-bottom: 30px;
  }
  .badge {
    background: rgba(249, 115, 22, 0.12);
    border: 1px solid rgba(249, 115, 22, 0.35);
    color: #fdba74;
    font-size: 15px;
    font-weight: 700;
    padding: 8px 18px;
    border-radius: 50px;
    display: flex;
    align-items: center;
    gap: 8px;
  }
  .footer-url {
    font-size: 15px;
    font-weight: 700;
    color: #78716c;
    letter-spacing: 0.5px;
  }
</style>
</head>
<body>
  <div class="glow-1"></div>
  <div class="glow-2"></div>
  
  <div class="card">
    <div class="header-row">
      <div class="icon-mini">
        <svg viewBox="0 0 24 24">
          <path fill-rule="evenodd" clip-rule="evenodd" d="M10.5 2C6.91 2 4 4.91 4 8.5c0 4.89 6.5 12.5 6.5 12.5s6.5-7.61 6.5-12.5C17 4.91 14.09 2 10.5 2zm0 10a3.5 3.5 0 1 0 0-7 3.5 3.5 0 0 0 0 7z" fill="#ffffff"/>
          <path d="M10.5 5.8l.68 1.38 1.53.22-1.11 1.08.26 1.52-1.36-.72-1.36.72.26-1.52-1.11-1.08 1.53-.22z" fill="#ffffff"/>
          <path d="M17.5 4.5c1.7 1.1 2.8 2.9 2.8 5s-1.1 3.9-2.8 5" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round"/>
          <path d="M20.2 2c2.6 1.6 4 4.2 4 7.5s-1.4 5.9-4 7.5" fill="none" stroke="#ffffff" stroke-width="2" stroke-linecap="round"/>
        </svg>
      </div>
      <div class="stars-row">
        <svg class="star" viewBox="0 0 24 24"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>
        <svg class="star" viewBox="0 0 24 24"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>
        <svg class="star" viewBox="0 0 24 24"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>
        <svg class="star" viewBox="0 0 24 24"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>
        <svg class="star" viewBox="0 0 24 24"><path d="M12 17.27L18.18 21l-1.64-7.03L22 9.24l-7.19-.61L12 2 9.19 8.63 2 9.24l5.46 4.73L5.82 21z"/></svg>
      </div>
    </div>

    <h1>Review Link Generator</h1>
    <p class="subtitle">Convert any Google Maps link into an instant 5-star rating window. Generate printable QR codes & write directly to NFC cards.</p>

    <div class="badges-grid">
      <div class="badge">Instant 5-Star Links</div>
      <div class="badge">NFC Tag Writer</div>
      <div class="badge">Downloadable QR Codes</div>
      <div class="badge">Android APK Native</div>
      <div class="badge">English & Arabic</div>
    </div>

    <div class="footer-url">zaid-a-salameh.github.io/google-review-link</div>
  </div>
</body>
</html>
"""

def apply_rounded_corners_with_transparency(img, radius_ratio=0.22):
    """Applies a smooth antialiased alpha mask so pixels outside the squircle are 100% transparent."""
    w, h = img.size
    # Super-sampling for smooth antialiasing
    scale = 4
    sw, sh = w * scale, h * scale
    mask = Image.new("L", (sw, sh), 0)
    draw = ImageDraw.Draw(mask)
    radius = int(sw * radius_ratio)
    draw.rounded_rectangle([(0, 0), (sw, sh)], radius=radius, fill=255)
    mask = mask.resize((w, h), Image.Resampling.LANCZOS)
    
    # Ensure image is RGBA
    res = img.convert("RGBA")
    res.putalpha(mask)
    return res

def main():
    scripts_dir = os.path.dirname(__file__)
    icon_html_path = os.path.join(scripts_dir, "temp_icon.html")
    og_html_path = os.path.join(scripts_dir, "temp_og.html")
    icon_raw_png = os.path.join(scripts_dir, "icon_raw.png")
    og_raw_png = os.path.join(PROJECT_ROOT, "og-image.png")

    with open(icon_html_path, "w", encoding="utf-8") as f:
        f.write(ICON_HTML)
    with open(og_html_path, "w", encoding="utf-8") as f:
        f.write(OG_HTML)

    print("Rendering Icon via Headless Edge...")
    subprocess.run([
        EDGE_PATH,
        "--headless",
        "--disable-gpu",
        f"--screenshot={icon_raw_png}",
        "--window-size=512,512",
        "--hide-scrollbars",
        f"file:///{icon_html_path.replace(os.sep, '/')}"
    ], check=True)

    print("Rendering Open Graph Image via Headless Edge...")
    subprocess.run([
        EDGE_PATH,
        "--headless",
        "--disable-gpu",
        f"--screenshot={og_raw_png}",
        "--window-size=1200,630",
        "--hide-scrollbars",
        f"file:///{og_html_path.replace(os.sep, '/')}"
    ], check=True)

    # Clean up temp HTML
    if os.path.exists(icon_html_path): os.remove(icon_html_path)
    if os.path.exists(og_html_path): os.remove(og_html_path)

    # Load rendered 512x512 icon
    base_raw = Image.open(icon_raw_png).convert("RGBA")
    
    # Crop to exact 512x512 if needed
    base_raw = base_raw.crop((0, 0, 512, 512))
    
    # Apply true anti-aliased transparency to the squircle corners
    print("Applying true alpha transparency to squircle corners...")
    base_icon = apply_rounded_corners_with_transparency(base_raw, radius_ratio=0.22)

    # Verify corner transparency: pixel (0,0) must have alpha 0
    c_alpha = base_icon.getpixel((0, 0))[3]
    center_alpha = base_icon.getpixel((256, 256))[3]
    print(f"Alpha check -> Corner (0,0) alpha: {c_alpha} (must be 0), Center alpha: {center_alpha} (must be 255)")
    assert c_alpha == 0, "Corner must be transparent!"

    # Save 512x512
    base_icon.save(os.path.join(PROJECT_ROOT, "favicon-512x512.png"), "PNG")

    # Generate multi-resolution icons with transparent corners
    sizes = [
        ("favicon-48x48.png", 48, 48),
        ("favicon-96x96.png", 96, 96),
        ("favicon-192x192.png", 192, 192),
        ("apple-touch-icon.png", 180, 180)
    ]
    for filename, w, h in sizes:
        resized = base_icon.resize((w, h), Image.Resampling.LANCZOS)
        resized.save(os.path.join(PROJECT_ROOT, filename), "PNG")
        print(f"Saved {filename} with alpha={resized.getpixel((0, 0))[3]}")

    # Generate favicon.ico with 16, 32, 48 sizes (all transparent)
    ico_16 = base_icon.resize((16, 16), Image.Resampling.LANCZOS)
    ico_32 = base_icon.resize((32, 32), Image.Resampling.LANCZOS)
    ico_48 = base_icon.resize((48, 48), Image.Resampling.LANCZOS)
    ico_48.save(
        os.path.join(PROJECT_ROOT, "favicon.ico"),
        format="ICO",
        sizes=[(16, 16), (32, 32), (48, 48)]
    )
    print("Saved multi-size favicon.ico with true transparency!")

    # Clean up raw icon
    if os.path.exists(icon_raw_png): os.remove(icon_raw_png)

    print("All icons successfully generated with perfect alpha transparency!")

if __name__ == "__main__":
    main()
