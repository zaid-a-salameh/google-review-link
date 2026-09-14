# ⭐ Google Maps Review Link Generator & NFC / QR Writer

> Convert any Google Maps link into a direct 5-star review URL, generate downloadable QR codes, and write directly to NFC cards/tags via Android.

---

## 🌟 Features

- **⭐ Direct 5-Star Review Generation**: Extracts Place IDs from full Google Maps URLs, place share links, and maps.app.goo.gl shortlinks into direct search.google.com/local/writereview?placeid=... review links.
- **⚡ Controlled Conversion**: Generates links strictly upon clicking the convert button to ensure full user control and optimal speed.
- **📱 Downloadable Android APK**: Includes a standalone native Android application ready to install (ReviewLinkGenerator.apk).
- **📶 Instant NFC Tag Writing (Android)**: Cleanly overwrites/formats any writable NFC tag with the 5-star review link in one tap.
- **📷 Instant QR Code Generator**: Generates crisp, downloadable QR codes in a smooth animated popup modal.
- **🌐 Bilingual English / Arabic UI**: Elegant glassmorphism interface with instant language switching and smooth micro-animations.
- **💻 Desktop & Mobile Optimized**: Clean responsive web app with smart platform detection (hardware-specific features like NFC and Paste are exclusive to mobile).
- **📶 Offline-First Support**: Handles offline Place ID resolution gracefully with network status detection.

---

## 🚀 Quick Start

### 1. Web Version
Open index.html in any modern web browser or serve it with any static web host (e.g., GitHub Pages, Vercel).

### 2. Android App (APK)
Download and install [ReviewLinkGenerator.apk](ReviewLinkGenerator.apk) directly on any Android device (Android 7.0+ / API 24+).
- Supports direct NFC writing.
- One-tap clipboard pasting.
- Saves QR images directly to phone gallery.

---

## 🛠️ Project Structure

`	ext
├── index.html                   # Core web application (HTML5, CSS3, ES6+)
├── qrcode.min.js                # Offline QR Code engine
├── ReviewLinkGenerator.apk       # Ready-to-install Android application
├── android-app/                 # Native Android Studio project (Kotlin)
│   ├── app/src/main/
│   │   ├── java/.../MainActivity.kt   # Native NFC, clipboard & media bridge
│   │   └── assets/                    # Offline-bundled web assets
└── .gitignore                   # Git ignore configurations
`

---

## 👤 Author
Developed by **Zaid Salameh** ([@zaid2007salameh](https://github.com/zaid2007salameh))
