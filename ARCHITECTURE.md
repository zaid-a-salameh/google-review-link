# Architecture and Isolation Rules

The application is structured into strictly isolated, single-responsibility feature modules across CSS and JavaScript so that changes inside one feature cannot leak into or break another.

## Module Layout

| Concern | CSS Module (`src/css/`) | JS Module (`src/js/`) | Target |
|---|---|---|---|
| Design tokens & root animations | `variables.css` | — | Web + APK |
| Base layout & cards | `base.css`, `components.css` | — | Web + APK |
| Link-type switcher & top bar | `link-type-switcher.css` | `core/converter.js` | Web + APK |
| Places autocomplete dropdown | `search-dropdown.css` | `core/places.js` | Web + APK |
| Bilingual strings & direction | — | `core/i18n.js` | Web + APK |
| Toast notifications & morph engine | `toast.css` | `core/toast.js` | Web + APK |
| QR code engine & modal (Review + Wi-Fi) | `qr-modal.css`, `qrcode.min.js` | `core/qr.js` | Web + APK |
| Onboarding tour | `onboarding.css` | `core/onboarding.js` | Web + APK |
| NFC shell, sensor & card reader/writer | `nfc-modal.css` | `app/nfc.js` | APK only |
| Wi-Fi 3-step setup wizard (`#nfcWifiView`) | `wifi-wizard.css` | `app/wifi-wizard.js` | APK only |
| PIN lock / unlock view (`#nfcPwdView`) | `pin-modal.css` | `app/pin-lock.js` | APK only |
| Permanent hardware lock (`#nfcPermConfirmView`) | `perm-lock-modal.css` | `app/perm-lock.js` | APK only |
| Soft keyboard & IME avoidance (`--kb-shift`) | — | `app/keyboard.js` | APK only |
| Self-updater & release modal (`#updateOverlay`) | `update-modal.css` | `app/updater.js` | APK only |
| Native Android bridge callbacks | `app.css` | `app/bridge.js` | APK only |
| Web marketing sections | `marketing.css` | `web/marketing.js` | Web only |
| Entrypoint orchestrators | — | `app-main.js`, `web-main.js` | APK / Web |
| HTML templates (only hand-edited HTML) | `src/templates/app-index.html`, `src/templates/web-index.html` | — | Source |

`index.html` (Web) and `android-app/app/src/main/assets/**` (APK) are **generated** by `python scripts/build_and_sync.py`. Never edit generated files directly.

## Overlay Z-Index Hierarchy

DOM order at the end of `app-index.html` and `handleAndroidBackPress` priority both match this exact stack:

1. `#nfcOverlay` (`z-index: 1000`) — NFC sensor, PIN lock, Permanent lock, Wi-Fi wizard
2. `#updateOverlay` (`z-index: 1050`) — In-app update dialog
3. `#qrOverlay` (`z-index: 1100`) — Review & Wi-Fi QR modal (stacks cleanly over `#nfcOverlay`)
4. `#onboardingOverlay` (`z-index: 3000`) — Welcome / user guide tour
5. `#toast` (`z-index: 99999`) — Non-blocking toast banner

## Isolation Rules

1. **One feature, one CSS file, one JS file.** Every selector in a sub-view stylesheet is scoped to its container (`#nfcWifiView`, `#nfcPwdView`, `#nfcPermConfirmView`, `.qr-overlay`, `.update-overlay`, `.onboarding-overlay`).
2. **Closed modal layers must be completely inert.** Every overlay enforces `:not(.active), :not(.active) * { pointer-events: none !important; }`. Never set unconditional `visibility: visible` or `pointer-events: auto` on a descendant of an overlay unless gated by `.overlay.active`.
3. **Single binding ownership.** Each button's event listener is registered in exactly one module (its owning feature controller).
4. **Explicit cross-module boundaries.** Modules communicate exclusively via narrow `window.*` functions (`openQrModalForWifi`, `openWifiModal`, `showNfcView`, `AppModes`, etc.), never by mutating another module's internal DOM state.

## Build & E2E Verification

```powershell
python scripts/build_and_sync.py
node tests/ui_smoke.mjs             # APK bundle hit-test & modal isolation
node tests/ui_smoke.mjs index.html  # Web build hit-test & modal isolation
node tests/wifi_qr_smoke.mjs        # Wi-Fi (Open/WPA, Arabic/ASCII), QR, PIN, PermLock & Back-press E2E
```
