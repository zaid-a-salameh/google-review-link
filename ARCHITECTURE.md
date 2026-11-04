# Quick NFC Architecture

Quick NFC is organized as a clean dual-platform codebase:
1. **Flutter Mobile Application** (`flutter_app/`) — Full-featured Android application with native NFC hardware interactions, Wi-Fi cloning, PIN encryption, and permanent locks.
2. **Web Client** (`src/`, `index.html`) — Zero-framework, responsive web landing app deployed to GitHub Pages with instant Google Maps link conversion and high-res QR generation.

---

## Directory Overview

```
quick-nfc/
├── flutter_app/                     # Flutter production Android application
│   ├── lib/
│   │   ├── core/                    # Constants, app theme, and navigation
│   │   ├── data/                    # Services (NFC, QR, Places, GitHub Updater)
│   │   ├── l10n/                    # 10 native ARB localization files
│   │   └── ui/                      # MVVM screens, viewmodels, and widgets
│   ├── android/                     # Android native host config (NFC intent filters)
│   ├── test/                        # Flutter widget and unit test suites
│   └── pubspec.yaml                 # Flutter manifest and dependencies
├── src/                             # Modular Web application source
│   ├── css/                         # Scoped CSS modules (base, components, dropdowns)
│   ├── js/                          # Modular JS (core i18n, converter, places, qr)
│   └── templates/                   # Web HTML template (web-index.html)
├── docs/                            # Documentation and media
│   └── screenshots/                 # Application screenshots showcase
├── scripts/                         # Build and asset synchronization tooling
│   ├── build_and_sync.py            # Web synchronization pipeline
│   ├── build_full_i18n.js           # Multi-language dictionary compiler
│   └── render_assets.py             # Multi-resolution icon & favicon generator
├── tests/                           # Headless automated web test suites
│   └── web_lang_smoke.mjs           # Multilingual switching & accessibility E2E test
├── index.html                       # Production Web entry point (GitHub Pages)
└── README.md                        # Project documentation and showcase
```

---

## Web Architecture & Isolation Rules

- **Zero Framework Bloat**: Pure vanilla HTML5, modular CSS3, and ES6+ JavaScript.
- **Multilingual Localization Engine**: Instant switching across 10 global languages with dynamic RTL/LTR direction switching and automatic UI element updates.
- **Single Binding Ownership**: Each interactive component has exactly one controller module handling its events.
- **Build Verification**:
  ```powershell
  python scripts/build_and_sync.py
  node tests/web_lang_smoke.mjs
  ```

---

## Flutter Application Verification

```powershell
cd flutter_app
flutter test
flutter build apk --release
```
