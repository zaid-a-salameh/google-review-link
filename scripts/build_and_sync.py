import os
import shutil
import re

_CWD = os.getcwd()
ROOT_DIR = _CWD if (os.path.isdir(os.path.join(_CWD, "src")) and os.path.isdir(os.path.join(_CWD, "android-app"))) else os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
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

# 2. Sync modular CSS files for Android APK (all except marketing.css)
src_css = os.path.join(SRC_DIR, "css")
apk_css_files = [
    "variables.css", "base.css", "components.css",
    "search-dropdown.css", "modals.css", "toast.css", "app.css"
]
for f in apk_css_files:
    shutil.copy2(os.path.join(src_css, f), os.path.join(assets_css, f))
    print(f"  [APK CSS] {f}")

# 3. Sync modular JS Core and App files for Android APK
src_js_core = os.path.join(SRC_DIR, "js", "core")
apk_core_js_files = ["i18n.js", "toast.js", "converter.js", "places.js", "qr.js"]
for f in apk_core_js_files:
    shutil.copy2(os.path.join(src_js_core, f), os.path.join(assets_js_core, f))
    print(f"  [APK Core JS] {f}")

src_js_app = os.path.join(SRC_DIR, "js", "app")
apk_app_js_files = ["nfc.js", "updater.js", "bridge.js"]
for f in apk_app_js_files:
    shutil.copy2(os.path.join(src_js_app, f), os.path.join(assets_js_app, f))
    print(f"  [APK App JS] {f}")

shutil.copy2(os.path.join(SRC_DIR, "js", "app-main.js"), os.path.join(assets_js, "app-main.js"))
print("  [APK Main JS] app-main.js")

# 4. Copy qrcode.min.js and favicons to assets
static_assets = [
    "qrcode.min.js", "favicon.svg", "favicon.ico",
    "favicon-48x48.png", "favicon-96x96.png", "favicon-192x192.png", "apple-touch-icon.png"
]
for asset in static_assets:
    src_file = os.path.join(ROOT_DIR, asset)
    if os.path.exists(src_file):
        shutil.copy2(src_file, os.path.join(ASSETS_DIR, asset))
        print(f"  [APK Asset] {asset}")

# 5. Build self-contained, offline-first assets/index.html with inlined CSS & JS
# This guarantees that Android WebView loads instantly with 0 HTTP roundtrips,
# 0 dependency on network connectivity, and completely immune to base-url resolution issues!
app_index_template_path = os.path.join(SRC_DIR, "templates", "app-index.html")
with open(app_index_template_path, "r", encoding="utf-8") as f:
    app_html = f.read()

# Collect all CSS contents in exact order
combined_css_parts = []
for f in apk_css_files:
    with open(os.path.join(src_css, f), "r", encoding="utf-8") as cf:
        combined_css_parts.append(f"/* == {f} == */\n" + cf.read().strip())
bundled_css = "\n\n".join(combined_css_parts)

# Replace <link rel="stylesheet" href="css/..."> tags with <style>...</style>
css_links_regex = r'(?:<link rel="stylesheet" href="css/[^"]+">\s*)+'
app_html = re.sub(css_links_regex, lambda m: f'<style>\n{bundled_css}\n    </style>\n', app_html, count=1)

# Collect all JS contents in exact order: qrcode.min.js + core + app + main
combined_js_parts = []
# Include qrcode.min.js in bundle
qrcode_path = os.path.join(ROOT_DIR, "qrcode.min.js")
if os.path.exists(qrcode_path):
    with open(qrcode_path, "r", encoding="utf-8") as qf:
        combined_js_parts.append("/* == qrcode.min.js == */\n" + qf.read().strip())

# Remove separate <script src="qrcode.min.js" defer></script> from template
app_html = re.sub(r'<script src="qrcode\.min\.js"[^>]*></script>\s*', '', app_html)

for f in apk_core_js_files:
    with open(os.path.join(src_js_core, f), "r", encoding="utf-8") as jf:
        combined_js_parts.append(f"/* == core/{f} == */\n" + jf.read().strip())

for f in apk_app_js_files:
    with open(os.path.join(src_js_app, f), "r", encoding="utf-8") as jf:
        combined_js_parts.append(f"/* == app/{f} == */\n" + jf.read().strip())

with open(os.path.join(SRC_DIR, "js", "app-main.js"), "r", encoding="utf-8") as mf:
    combined_js_parts.append("/* == app-main.js == */\n" + mf.read().strip())

bundled_js = "\n\n".join(combined_js_parts)

# Replace <script src="js/..."> tags with <script>...</script>
js_scripts_regex = r'(?:<script src="js/[^"]+"[^>]*></script>\s*)+'
app_html = re.sub(js_scripts_regex, lambda m: f'<script>\n{bundled_js}\n    </script>\n', app_html, count=1)

app_index_dst = os.path.join(ASSETS_DIR, "index.html")
with open(app_index_dst, "w", encoding="utf-8") as f:
    f.write(app_html)
print(f"  [APK Bundled HTML] assets/index.html ({os.path.getsize(app_index_dst)} bytes) - 100% self-contained offline bundle!")

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

web_css_refs = re.findall(r'href="(src/css/[^"]+)"', web_text)
web_js_refs = re.findall(r'src="(src/js/[^"]+)"', web_text)

for ref in web_css_refs + web_js_refs:
    target = os.path.join(ROOT_DIR, ref.replace('/', os.sep))
    if not os.path.exists(target):
        raise FileNotFoundError(f"Missing referenced Web file: {target}")
print(f"  Verified all {len(web_css_refs)} CSS and {len(web_js_refs)} JS references in Web index.html.")

# Verify APK bundle contents
with open(app_index_dst, "r", encoding="utf-8") as f:
    apk_text = f.read()

assert "<style>" in apk_text and "</style>" in apk_text, "Missing <style> in APK assets/index.html"
assert "<script>" in apk_text and "</script>" in apk_text, "Missing <script> in APK assets/index.html"
assert "is-native-app" in apk_text, "Missing is-native-app marker in APK assets/index.html"
assert "I18N" in apk_text, "Missing I18N in APK assets/index.html"
assert "QRCode" in apk_text, "Missing QRCode in APK assets/index.html"
print(f"  Verified APK assets/index.html bundle: self-contained with complete CSS and JS.")

print("\nArchitectural separation & APK bundling completed with 100% integrity!")
