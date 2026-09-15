# ⭐ Google Maps Review Link Generator & NFC / QR Writer

> Convert any Google Maps link into a direct 5-star review URL, generate downloadable QR codes, and write directly to NFC cards/tags via Android.

---

## 🌐 Live Web App & Download

- **🚀 Live Web Application**: [https://zaid-a-salameh.github.io/google-review-link/](https://zaid-a-salameh.github.io/google-review-link/)
- **📱 Direct Android APK Download**: [Download ReviewLinkGenerator.apk (v1.0.0)](https://github.com/zaid-a-salameh/google-review-link/releases/download/v1.0.0/ReviewLinkGenerator.apk)

---

## 🌟 Features

- **⭐ Direct 5-Star Review Generation**: Extracts Place IDs from full Google Maps URLs, place share links, and `maps.app.goo.gl` shortlinks into direct `search.google.com/local/writereview?placeid=...` review links.
- **⚡ Controlled Conversion**: Generates links strictly upon clicking the convert button to ensure full user control and optimal speed.
- **📱 Standalone Android App**: Native Android application ready to install (`ReviewLinkGenerator.apk`).
- **📶 Instant NFC Tag Writing (Android)**: Cleanly overwrites and formats any writable NFC tag with the 5-star review link in one tap.
- **📷 Instant QR Code Generator**: Generates crisp, downloadable QR codes in a smooth animated popup modal.
- **🌐 Bilingual English / Arabic UI**: Elegant glassmorphism interface with instant language switching and smooth micro-animations.
- **💻 Desktop & Mobile Optimized**: Clean responsive web app with smart platform detection.
- **📶 Offline-First Support**: Handles offline Place ID resolution gracefully with network status detection.

---

## 🚀 Quick Start

### 1. Web Version
Open the [Live Web App](https://zaid-a-salameh.github.io/google-review-link/) in any modern browser.

### 2. Android App (APK)
Download and install [ReviewLinkGenerator.apk](https://github.com/zaid-a-salameh/google-review-link/releases/download/v1.0.0/ReviewLinkGenerator.apk) directly on any Android device (Android 7.0+ / API 24+).

---

## 🛠️ Project Structure

<pre>
google-review-link/
├── index.html                   # Core web application (HTML5, CSS3, ES6+)
├── qrcode.min.js                # Offline QR Code engine
├── ReviewLinkGenerator.apk      # Ready-to-install Android application
├── README.md                    # Project documentation
├── .gitignore                   # Git ignore configurations
└── android-app/                 # Native Android Studio project (Kotlin)
    ├── app/src/main/
    │   ├── java/.../MainActivity.kt   # Native NFC, clipboard & media bridge
    │   └── assets/                    # Offline-bundled web assets
    └── build.gradle                   # Android build configuration
</pre>

---

## 👤 Author
Developed by **Zaid Salameh** ([@zaid-a-salameh](https://github.com/zaid-a-salameh))
