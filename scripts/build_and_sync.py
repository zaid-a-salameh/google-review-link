import os
import shutil

ROOT_DIR = r"C:\Users\Zaid-PC\Desktop\Projects\Google Link"
SRC_DIR = os.path.join(ROOT_DIR, "src")
ASSETS_DIR = os.path.join(ROOT_DIR, "android-app", "app", "src", "main", "assets")

print("Starting architecture build and synchronization...")

# 1. Ensure assets subdirectories exist
assets_css = os.path.join(ASSETS_DIR, "css")
assets_js_core = os.path.join(ASSETS_DIR, "js", "core")
assets_js_app = os.path.join(ASSETS_DIR, "js", "app")
assets_js = os.path.join(ASSETS_DIR, "js")

for d in [assets_css, assets_js_core, assets_js_app]:
    os.makedirs(d, exist_ok=True)

# 2. Sync CSS files for Android APK (all except marketing.css)
src_css = os.path.join(SRC_DIR, "css")
for f in os.listdir(src_css):
    if f.endswith(".css") and f != "marketing.css":
        shutil.copy2(os.path.join(src_css, f), os.path.join(assets_css, f))
        print(f"  [APK CSS] {f}")

# 3. Sync JS Core and App files for Android APK
src_js_core = os.path.join(SRC_DIR, "js", "core")
for f in os.listdir(src_js_core):
    if f.endswith(".js"):
        shutil.copy2(os.path.join(src_js_core, f), os.path.join(assets_js_core, f))
        print(f"  [APK Core JS] {f}")

src_js_app = os.path.join(SRC_DIR, "js", "app")
for f in os.listdir(src_js_app):
    if f.endswith(".js"):
        shutil.copy2(os.path.join(src_js_app, f), os.path.join(assets_js_app, f))
        print(f"  [APK App JS] {f}")

shutil.copy2(os.path.join(SRC_DIR, "js", "app-main.js"), os.path.join(assets_js, "app-main.js"))
print("  [APK Main JS] app-main.js")

# 4. Copy app-index.html to assets/index.html
app_index_src = os.path.join(SRC_DIR, "templates", "app-index.html")
app_index_dst = os.path.join(ASSETS_DIR, "index.html")
shutil.copy2(app_index_src, app_index_dst)
print(f"  [APK HTML] assets/index.html ({os.path.getsize(app_index_dst)} bytes)")

# 5. Copy qrcode.min.js and favicons to assets
static_assets = [
    "qrcode.min.js", "favicon.svg", "favicon.ico",
    "favicon-48x48.png", "favicon-96x96.png", "favicon-192x192.png", "apple-touch-icon.png"
]
for asset in static_assets:
    src_file = os.path.join(ROOT_DIR, asset)
    if os.path.exists(src_file):
        shutil.copy2(src_file, os.path.join(ASSETS_DIR, asset))
        print(f"  [APK Asset] {asset}")

# 6. Deploy Web Template to Root index.html
web_index_src = os.path.join(SRC_DIR, "templates", "web-index.html")
web_index_dst = os.path.join(ROOT_DIR, "index.html")
shutil.copy2(web_index_src, web_index_dst)
print(f"  [Web HTML] Root index.html ({os.path.getsize(web_index_dst)} bytes)")

# 7. Verification audit
print("\nVerifying integrity of generated targets...")

# Verify Web references
with open(web_index_dst, "r", encoding="utf-8") as f:
    web_text = f.read()

import re
web_css_refs = re.findall(r'href="(src/css/[^"]+)"', web_text)
web_js_refs = re.findall(r'src="(src/js/[^"]+)"', web_text)

for ref in web_css_refs + web_js_refs:
    target = os.path.join(ROOT_DIR, ref.replace('/', os.sep))
    if not os.path.exists(target):
        raise FileNotFoundError(f"Missing referenced Web file: {target}")
print(f"  Verified all {len(web_css_refs)} CSS and {len(web_js_refs)} JS references in Web index.html.")

# Verify APK references
with open(app_index_dst, "r", encoding="utf-8") as f:
    app_text = f.read()

app_css_refs = re.findall(r'href="(css/[^"]+)"', app_text)
app_js_refs = re.findall(r'src="(js/[^"]+)"', app_text)

for ref in app_css_refs + app_js_refs:
    target = os.path.join(ASSETS_DIR, ref.replace('/', os.sep))
    if not os.path.exists(target):
        raise FileNotFoundError(f"Missing referenced APK asset file: {target}")
print(f"  Verified all {len(app_css_refs)} CSS and {len(app_js_refs)} JS references in APK assets/index.html.")

print("\nArchitectural separation & synchronization completed with 100% integrity!")
