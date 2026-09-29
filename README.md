# Google Maps Review Link Generator & NFC / QR Writer

> Convert any Google Maps link into a direct 5-star review URL, generate downloadable high-resolution QR codes, and write directly to physical NFC cards/tags via Android.

---

## Live Web Application & Downloads

- **Live Web Application**: [https://zaid-a-salameh.github.io/google-review-link/](https://zaid-a-salameh.github.io/google-review-link/)
- **Direct Android APK Download**: [Download ReviewLinkGenerator.apk](https://github.com/zaid-a-salameh/google-review-link/raw/main/ReviewLinkGenerator.apk)

---

## Core Capabilities & Features

- **Direct 5-Star Review Generation**: Extracts Place IDs from full Google Maps URLs, place share links, and `maps.app.goo.gl` shortlinks into direct `search.google.com/local/writereview?placeid=...` review links.
- **Find Business Search Mode**: Integrated workflow allowing users to query businesses directly on Google Maps and auto-convert via 1-tap clipboard integration.
- **Desktop Showcase & Sticky Navigation**: Tailored desktop experience featuring a glassmorphic top navigation bar, 3-step visual workflow guides, and interactive feature highlights.
- **Micro-Spring & Entrance Animations**: Hardware-accelerated entrance choreography and physics-based spring toggles for instantaneous feedback with zero layout shifts.
- **Instant NFC Tag Writing (Android)**: Cleanly overwrites, formats, and locks writable NFC tags (NTAG213/215/216) with the direct review URL in one tap.
- **High-Resolution QR Code Engine**: Generates crisp, downloadable vector-grade QR codes inside an animated modal dialog.
- **Bilingual English & Arabic Interface**: Full bi-directional support (LTR / RTL) with seamless cross-dissolve transitions between Inter and Cairo typography.
- **Zero API Key Requirement**: Completely free and open-source architecture that requires no third-party API credentials or billing accounts.
- **100% Offline-First Architecture**: Android APK bundles all dependencies locally for offline Place ID parsing and QR generation.

---

## Quick Start

### 1. Web Version
Open the [Live Web Application](https://zaid-a-salameh.github.io/google-review-link/) in any modern desktop or mobile browser.

### 2. Android Application (APK)
Download and install [ReviewLinkGenerator.apk](https://github.com/zaid-a-salameh/google-review-link/raw/main/ReviewLinkGenerator.apk) on any Android device running Android 7.0+ (API level 24+).

---

## Project Structure

<pre>
google-review-link/
├── index.html                   # Core web application & desktop showcase
├── qrcode.min.js                # Offline client-side QR generation engine
├── ReviewLinkGenerator.apk      # Compiled standalone Android application
├── README.md                    # Project documentation
├── .gitignore                   # Git version control rules
└── android-app/                 # Native Android Studio project (Kotlin)
    ├── app/src/main/
    │   ├── java/.../MainActivity.kt   # Native NFC, clipboard, and bridge layer
    │   └── assets/index.html          # Bundled offline assets
    └── build.gradle                   # Gradle configuration
</pre>

---

## License & Author
Developed by **Zaid Salameh** ([@zaid-a-salameh](https://github.com/zaid-a-salameh)). MIT License.
