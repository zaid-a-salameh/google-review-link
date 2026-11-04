import os
import shutil
import re

_CWD = os.getcwd()
ROOT_DIR = _CWD if os.path.isdir(os.path.join(_CWD, "src")) else os.path.dirname(os.path.dirname(os.path.abspath(__file__)))
SRC_DIR = os.path.join(ROOT_DIR, "src")

print("Starting architecture build and synchronization...")

# 1. Deploy Web Template to Root index.html
web_index_src = os.path.join(SRC_DIR, "templates", "web-index.html")
web_index_dst = os.path.join(ROOT_DIR, "index.html")

if not os.path.exists(web_index_src):
    raise FileNotFoundError(f"Missing web template: {web_index_src}")

shutil.copy2(web_index_src, web_index_dst)
print(f"  [Web HTML] Root index.html ({os.path.getsize(web_index_dst)} bytes)")

# 2. Verification audit of all CSS, JS, and Icon references
print("\nVerifying integrity of referenced targets...")

with open(web_index_dst, "r", encoding="utf-8") as f:
    web_text = f.read()

web_css_refs = re.findall(r'href="(src/css/[^"]+)"', web_text)
web_js_refs = re.findall(r'src="(src/js/[^"]+)"', web_text)
icon_refs = re.findall(r'href="(assets/icons/[^"?]+)(?:\?[^"]*)?"', web_text)

for ref in web_css_refs + web_js_refs + icon_refs:
    target = os.path.join(ROOT_DIR, ref.replace('/', os.sep))
    if not os.path.exists(target):
        raise FileNotFoundError(f"Missing referenced target: {target}")

print(f"  Verified all {len(web_css_refs)} CSS, {len(web_js_refs)} JS, and {len(icon_refs)} icon references in Web index.html.")
print("\nWeb architecture synchronization completed with 100% integrity!")
