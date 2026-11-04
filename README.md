<div align="center">

<img src="favicon-192x192.png" alt="Quick NFC Logo" width="96" height="96" style="border-radius: 24px; box-shadow: 0 8px 24px rgba(124, 58, 237, 0.35);">

# Quick NFC

**Fast & simple NFC tool for instant Google Maps 5-star reviews, Wi-Fi cards, PIN security, and QR codes.**

[![Release](https://img.shields.io/badge/release-v2.0.0-7c3aed?style=flat-square)](https://github.com/zaid-a-salameh/quick-nfc/releases/latest)
[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg?style=flat-square)](LICENSE)
[![Platform: Android & Web](https://img.shields.io/badge/Platform-Android%20%7C%20Web-success?style=flat-square)](https://zaid-a-salameh.github.io/quick-nfc/)
[![Flutter](https://img.shields.io/badge/Flutter-3.x-02569B?style=flat-square&logo=flutter&logoColor=white)](https://flutter.dev)
[![Languages: 10](https://img.shields.io/badge/Languages-10%20Supported-purple?style=flat-square)](https://github.com/zaid-a-salameh/quick-nfc)

<br/>

[**🌐 Open Web Application**](https://zaid-a-salameh.github.io/quick-nfc/) • [**📱 Download Android APK**](https://github.com/zaid-a-salameh/quick-nfc/raw/main/QuickNFC.apk) • [**✨ Report an Issue**](https://github.com/zaid-a-salameh/quick-nfc/issues)

</div>

---

## Overview

**Quick NFC** is an all-in-one, privacy-focused open-source tool designed to effortlessly bridge digital actions with physical contactless cards and smart NFC tags. Whether you want to boost your business feedback with direct 5-star Google review links, share guest Wi-Fi passwords with a single phone touch, or secure your NFC cards against tampering with PIN protection or permanent hardware locks, Quick NFC delivers instantaneous results with zero friction.

Available both as a responsive **Web Application** and as a high-performance **Android App** built with Flutter.

---

## Core Features

- ⭐ **Direct 5-Star Google Review Links**: Converts any Google Maps link, place share URL, or `maps.app.goo.gl` shortlink into an automated 5-star review submission link (`search.google.com/local/writereview?placeid=...`) without requiring customers to manually navigate through Maps.
- 🔍 **Live Business Search Mode**: Integrated Google Maps Places search engine allowing business owners to find their venue by name and city with live autocomplete suggestions.
- 📶 **Wi-Fi Card Setup & Cloning**: Create contactless Wi-Fi connection cards supporting WPA, WPA2, WPA3 Personal, and Open networks. Easily read and duplicate existing Wi-Fi cards for restaurants, cafes, and offices.
- 📱 **Continuous Batch NFC Writing (Android)**: Multi-tag writing engine that programs dozens of NFC cards, stickers, keyfobs, or coins in a continuous loop with live counter tracking and haptic vibration feedback.
- 🔒 **4-Digit PIN Protection & Unlocking**: Protect NFC cards from unauthorized overwriting in public spaces by setting a 4-digit PIN password, with full reversible unlocking support.
- 🛡️ **Permanent Hardware Lock**: Apply an irreversible Read-Only hardware lock to standard NTAG chips to ensure tamper-proof deployment in public venues.
- 🔲 **High-Resolution Vector QR Codes**: Generate and download crisp, print-ready PNG QR codes for tabletop stands, menus, receipts, and storefront stickers.
- 🌍 **10 Global Languages Supported**: Full native internationalization in English, Arabic, Spanish, French, German, Turkish, Italian, Portuguese, Indonesian, and Russian, with seamless RTL/LTR layout mirroring.
- 🛡️ **100% Free, Private & Offline-First**: No ads, no paid subscriptions, no user registration, and zero third-party tracking. All link resolution and NFC payload generation run directly on your device.

---

## Supported NFC Hardware

Quick NFC is fully compatible with standard NFC Forum Type 2 tags:
- **NTAG213** (144 bytes user memory)
- **NTAG215** (504 bytes user memory)
- **NTAG216** (888 bytes user memory)
- Compatible NFC smart business cards, PVC cards, epoxy tags, keyfobs, and stickers.

---

## Getting Started

### 1. Web Version
Access the live web app in any modern browser without installation:
👉 **[https://zaid-a-salameh.github.io/quick-nfc/](https://zaid-a-salameh.github.io/quick-nfc/)**

### 2. Android App (APK)
1. Download the latest official release: **[QuickNFC.apk](https://github.com/zaid-a-salameh/quick-nfc/raw/main/QuickNFC.apk)**.
2. Enable "Install from unknown sources" on your Android device (Android 7.0+ / API level 24+).
3. Open and install the APK to access hardware NFC writing, cloning, and security locks.

---

## Project Structure

```
quick-nfc/
├── flutter_app/                     # Flutter production Android application
│   ├── lib/
│   │   ├── core/                    # App constants, themes, and localization
│   │   ├── data/                    # Models, repositories, and native service bridges
│   │   │   └── services/            # NFC service, QR service, Places & GitHub updater
│   │   └── ui/                      # MVVM UI layer (screens, viewmodels, widgets)
│   ├── android/                     # Android native host configuration (NFC intent filters)
│   └── pubspec.yaml                 # Flutter dependencies & assets manifest
├── src/                             # Modular web client codebase
│   ├── css/                         # Scoped CSS modules (marketing, layout, components)
│   ├── js/                          # Scoped JavaScript modules (core i18n, converter, places)
│   └── templates/                   # Source HTML templates
├── scripts/                         # Build, sync, and asset rendering scripts
│   ├── build_and_sync.py            # Automated build & asset synchronization pipeline
│   └── render_assets.py             # Multi-resolution icon & favicon generator
├── index.html                       # Production Web entry point (GitHub Pages)
├── QuickNFC.apk                     # Standalone compiled Android application
└── README.md                        # Project documentation
```

---

## Building from Source

### Prerequisites
- [Flutter SDK](https://flutter.dev/docs/get-started/install) (version 3.22+ recommended)
- [Android SDK](https://developer.android.com/studio) (API level 34)
- Python 3.9+ (for web asset builds)

### 1. Build the Flutter Android App
```bash
cd flutter_app
flutter pub get
flutter build apk --release
```
The compiled APK will be generated at `flutter_app/build/app/outputs/flutter-apk/app-release.apk`.

### 2. Build the Web Application
```bash
python scripts/build_and_sync.py
```

---

## Contributing

Contributions, feature requests, and bug reports are warmly welcome!
Feel free to open an issue or submit a Pull Request on the [GitHub Repository](https://github.com/zaid-a-salameh/quick-nfc).

---

## License

This project is licensed under the **MIT License** — see the [LICENSE](LICENSE) file for details.

Developed with care by **Zaid Salameh** ([@zaid-a-salameh](https://github.com/zaid-a-salameh)).
