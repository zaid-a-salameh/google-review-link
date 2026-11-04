// Comprehensive E2E test for Wi-Fi Wizard, Open/WPA/Arabic QR Code generation,
// Keyboard avoidance (--kb-shift), Clone Mode, and Hardware Back z-index order.
// Uses REAL browser coordinate hit-testing + CDP mouse events (not synthetic .click()).
import { spawn } from 'child_process';
import http from 'http';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const here = path.dirname(fileURLToPath(import.meta.url));
const HTML = process.argv[2] || path.resolve(here, '../android-app/app/src/main/assets/index.html');
const EDGE = process.env.EDGE_PATH || 'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe';
const PORT = 8128, CDP = 9258;

const server = http.createServer((q, r) => {
    r.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
    r.end(fs.readFileSync(HTML));
});
await new Promise(r => server.listen(PORT, '127.0.0.1', r));

const proc = spawn(EDGE, [
    `--remote-debugging-port=${CDP}`,
    '--headless=new',
    '--disable-gpu',
    '--no-first-run',
    '--disable-background-timer-throttling',
    '--disable-renderer-backgrounding',
    '--disable-backgrounding-occluded-windows',
    '--user-data-dir=' + (process.env.TEMP || '/tmp') + '\\edge_wifi_qr_' + Date.now(),
    'about:blank'
]);

let list;
for (let i = 0; i < 40; i++) {
    await new Promise(r => setTimeout(r, 200));
    try {
        const res = await fetch(`http://127.0.0.1:${CDP}/json/list`);
        list = await res.json();
        if (list && list.find(t => t.type === 'page')) break;
    } catch (e) {}
}

const pageTarget = list.find(t => t.type === 'page');
if (!pageTarget) {
    console.error('Failed to find page target in Edge');
    proc.kill();
    server.close();
    process.exit(1);
}

const ws = new WebSocket(pageTarget.webSocketDebuggerUrl);
await new Promise((res, rej) => { ws.onopen = res; ws.onerror = rej; });

let id = 1;
const uncaughtErrors = [];
const send = (method, params = {}) => new Promise((res, rej) => {
    const cur = id++;
    const handler = e => {
        const d = JSON.parse(e.data);
        if (d.id === cur) {
            ws.removeEventListener('message', handler);
            if (d.error) rej(new Error(JSON.stringify(d.error))); else res(d.result);
        }
    };
    ws.addEventListener('message', handler);
    ws.send(JSON.stringify({ id: cur, method, params }));
});

ws.addEventListener('message', e => {
    const d = JSON.parse(e.data);
    if (d.method === 'Runtime.exceptionThrown') {
        const desc = d.params.exceptionDetails.exception?.description || d.params.exceptionDetails.text;
        uncaughtErrors.push(desc);
        console.error('UNCAUGHT PAGE EXCEPTION:', desc);
    }
});

const sleep = ms => new Promise(r => setTimeout(r, ms));
const ev = async x => {
    const r = await send('Runtime.evaluate', { expression: x, returnByValue: true, awaitPromise: true });
    if (r.exceptionDetails) {
        const desc = r.exceptionDetails.exception?.description || r.exceptionDetails.text || 'Runtime.evaluate exception';
        throw new Error(`Evaluate failed: ${desc}`);
    }
    return r.result?.value;
};

// Perform a REAL coordinate tap via CDP Input.dispatchMouseEvent after verifying hit-test
async function realTap(selector) {
    const box = await ev(`(() => {
        const el = document.querySelector(${JSON.stringify(selector)});
        if (!el) return { err: 'Element not found: ' + ${JSON.stringify(selector)} };
        let r = el.getBoundingClientRect();
        if (r.width >= 2 && r.height >= 2 && (r.bottom > window.innerHeight || r.top < 0)) {
            el.scrollIntoView({ block: 'center', behavior: 'instant' });
            r = el.getBoundingClientRect();
        }
        const cs = getComputedStyle(el);
        if (r.width < 2 || r.height < 2 || cs.display === 'none' || cs.visibility === 'hidden' || cs.pointerEvents === 'none') {
            return { err: 'Element not visible/interactive: ' + ${JSON.stringify(selector)} + ' (display=' + cs.display + ', vis=' + cs.visibility + ', pe=' + cs.pointerEvents + ')' };
        }
        const cx = Math.round(r.left + r.width / 2);
        const cy = Math.round(r.top + r.height / 2);
        const topEl = document.elementFromPoint(cx, cy);
        const hitOk = topEl === el || el.contains(topEl) || (topEl && topEl.contains(el));
        return {
            cx,
            cy,
            hitOk,
            blocker: topEl ? (topEl.id || topEl.className || topEl.tagName) : 'null'
        };
    })()`);

    if (box.err) throw new Error(box.err);
    if (!box.hitOk) {
        throw new Error(`Real tap on ${selector} at (${box.cx}, ${box.cy}) was blocked by ${box.blocker}`);
    }

    await send('Input.dispatchMouseEvent', { type: 'mousePressed', x: box.cx, y: box.cy, button: 'left', clickCount: 1 });
    await send('Input.dispatchMouseEvent', { type: 'mouseReleased', x: box.cx, y: box.cy, button: 'left', clickCount: 1 });
}

await send('Runtime.enable');
await send('Page.enable');
await send('Page.bringToFront');
await send('Emulation.setDeviceMetricsOverride', { width: 390, height: 844, deviceScaleFactor: 2, mobile: true });
await send('Page.navigate', { url: `http://127.0.0.1:${PORT}/` });
await sleep(2200);

try {
    // Dismiss onboarding and switch to Arabic
    await ev(`
        if (window.closeOnboardingModal) window.closeOnboardingModal();
        try { localStorage.setItem('ob_seen_v1', '1'); } catch(e){}
        if (window.switchLanguage) window.switchLanguage('ar');
    `);
    await sleep(500);

    // =========================================================================
    // 1. Exact User Bug Regression: Arabic Open Wi-Fi Network (Empty & Disabled Password)
    // =========================================================================
    const arabicSsids = ['شبكة', 'الضيوف', 'شبكة الضيوف المجانية', 'كافيه السعادة ☕'];
    for (const ssid of arabicSsids) {
        console.log(`Testing Open Wi-Fi QR in Arabic for SSID="${ssid}"...`);
        await realTap('#btnWifiTag');
        await sleep(380);

        await ev(`document.getElementById('wifiSsidInput').value = ${JSON.stringify(ssid)};`);
        await realTap('#btnWifiNext');
        await sleep(300);

        // Simulate Keyboard IME open on Step 2, then closing as user taps Next to Step 3
        await ev(`
            document.getElementById('wifiPasswordInput').focus();
            window.__onNativeKeyboardInset(280, true);
        `);
        const step2Shift = await ev(`getComputedStyle(document.documentElement).getPropertyValue('--kb-shift').trim()`);
        if (step2Shift === '0px' || !step2Shift.startsWith('-')) {
            throw new Error(`Expected negative --kb-shift while password input focused, got "${step2Shift}"`);
        }

        // Leave password empty (and test disabled state on the second iteration)
        const testDisabled = ssid === 'الضيوف';
        await ev(`(() => {
            const p = document.getElementById('wifiPasswordInput');
            p.value = '';
            p.disabled = ${testDisabled};
        })()`);
        await realTap('#btnWifiNext');
        await sleep(320);

        // Simulate Android IME still mid-close animation (imeBottomDp=180, imeVisible=true)
        await ev(`window.__onNativeKeyboardInset(180, true);`);
        const step3Shift = await ev(`getComputedStyle(document.documentElement).getPropertyValue('--kb-shift').trim()`);
        if (step3Shift !== '0px') {
            throw new Error(`Expected --kb-shift to be 0px on Step 3 when input is blurred, got "${step3Shift}"`);
        }
        await ev(`window.__onNativeKeyboardInset(0, false);`);

        // Verify Step 3 auto-selected Open Network in Arabic
        const selectedEncLabel = await ev(`document.getElementById('wifiSelectedLabel').textContent.trim()`);
        if (!selectedEncLabel.includes('مفتوحة')) {
            throw new Error(`Expected Arabic Open Network label, got "${selectedEncLabel}"`);
        }

        // Real coordinate tap on #btnWifiQr!
        await realTap('#btnWifiQr');
        await sleep(380);

        const qrState = await ev(`(() => {
            const ov = document.getElementById('qrOverlay');
            const box = document.getElementById('qrModalBox');
            const canvas = document.getElementById('qrCodeContainer').querySelector('canvas');
            return {
                active: ov.classList.contains('active'),
                themeWifi: box.classList.contains('theme-wifi'),
                hasCanvas: Boolean(canvas && canvas.width === 200 && canvas.height === 200),
                payload: window.getCurrentQrPayload ? window.getCurrentQrPayload() : ''
            };
        })()`);

        if (!qrState.active) throw new Error(`QR modal failed to open for Open Arabic SSID="${ssid}"`);
        if (!qrState.themeWifi) throw new Error(`QR modal missing theme-wifi for SSID="${ssid}"`);
        if (!qrState.hasCanvas) throw new Error(`QR canvas not rendered cleanly for SSID="${ssid}"`);
        if (!qrState.payload.includes(';T:nopass;;') || qrState.payload.includes(';P:')) {
            throw new Error(`Unexpected Open Wi-Fi QR payload: "${qrState.payload}"`);
        }
        console.log(`  PASS: SSID="${ssid}" (disabled=${testDisabled}) -> ${qrState.payload}`);

        // Test Hardware Back button while QR modal is stacked over Wi-Fi Wizard!
        const handledQr = await ev(`window.handleAndroidBackPress()`);
        await sleep(350);
        const afterBack = await ev(`({
            qrActive: document.getElementById('qrOverlay').classList.contains('active'),
            nfcActive: document.getElementById('nfcOverlay').classList.contains('active'),
            step3Active: document.getElementById('wifiStep3Pane').classList.contains('active')
        })`);
        if (!handledQr || afterBack.qrActive || !afterBack.nfcActive || !afterBack.step3Active) {
            throw new Error(`Hardware Back did not close ONLY qrOverlay cleanly: ${JSON.stringify(afterBack)}`);
        }

        // Step back out of Wi-Fi wizard cleanly via Hardware Back (Step 3 -> 2 -> 1 -> close)
        await ev(`window.handleAndroidBackPress()`);
        await sleep(150);
        await ev(`window.handleAndroidBackPress()`);
        await sleep(150);
        await ev(`window.handleAndroidBackPress()`);
        await sleep(400);
    }

    // =========================================================================
    // 2. WPA Network -> Step 3 -> Switch Dropdown to OPEN -> Tap QR Button
    // =========================================================================
    console.log('Testing WPA password entered then switched to OPEN on Step 3...');
    await realTap('#btnWifiTag');
    await sleep(350);
    await ev(`document.getElementById('wifiSsidInput').value = 'Cafe_Guest_5G';`);
    await realTap('#btnWifiNext');
    await sleep(300);
    await ev(`document.getElementById('wifiPasswordInput').value = 'CoffeeAndWiFi2026';`);
    await realTap('#btnWifiNext');
    await sleep(350);

    // First verify WPA QR opens cleanly
    await realTap('#btnWifiQr');
    await sleep(380);
    const wpaPayload = await ev(`window.getCurrentQrPayload()`);
    if (wpaPayload !== 'WIFI:S:Cafe_Guest_5G;T:WPA;P:CoffeeAndWiFi2026;;') {
        throw new Error(`Unexpected WPA payload: ${wpaPayload}`);
    }
    console.log('  PASS: WPA QR modal opened with payload:', wpaPayload);
    await realTap('#qrCloseBtn');
    await sleep(380);

    // Open security dropdown on Step 3 and pick OPEN
    await realTap('#wifiSelectTrigger');
    await sleep(250);
    await realTap('#wifiDropdownMenu .wifi-dropdown-item[data-enc="OPEN"]');
    await sleep(250);
    await realTap('#btnWifiQr');
    await sleep(380);
    const switchedOpenPayload = await ev(`window.getCurrentQrPayload()`);
    if (switchedOpenPayload !== 'WIFI:S:Cafe_Guest_5G;T:nopass;;') {
        throw new Error(`Expected nopass payload after selecting OPEN, got: ${switchedOpenPayload}`);
    }
    console.log('  PASS: Switching dropdown to OPEN updated QR payload cleanly:', switchedOpenPayload);
    await realTap('#qrCloseBtn');
    await sleep(380);

    // Close Wi-Fi modal via backdrop click
    await ev(`document.getElementById('nfcOverlay').dispatchEvent(new MouseEvent('click', { bubbles: true }))`);
    await sleep(420);

    // =========================================================================
    // 3. Clone Mode (Open & WPA Arabic Wi-Fi Card Read -> Clone QR Button)
    // =========================================================================
    console.log('Testing Clone Mode Wi-Fi QR button (Open Arabic Card)...');
    await ev(`
        document.getElementById('btnReadTag').click();
    `);
    await sleep(350);
    await ev(`window.onNfcWifiTagRead({ ssid: 'شبكة الاستقبال', password: '', encType: 'OPEN' })`);
    await sleep(450);

    await realTap('#nfcWifiCloneQrBtn');
    await sleep(380);
    const cloneOpenState = await ev(`({
        active: document.getElementById('qrOverlay').classList.contains('active'),
        themeWifi: document.getElementById('qrModalBox').classList.contains('theme-wifi'),
        payload: window.getCurrentQrPayload()
    })`);
    if (!cloneOpenState.active || !cloneOpenState.themeWifi || cloneOpenState.payload !== 'WIFI:S:شبكة الاستقبال;T:nopass;;') {
        throw new Error(`Clone Open Wi-Fi QR failed: ${JSON.stringify(cloneOpenState)}`);
    }
    console.log('  PASS: Clone Mode Open Arabic Wi-Fi QR opened cleanly:', cloneOpenState.payload);

    await realTap('#qrCloseBtn');
    await sleep(380);
    await realTap('#nfcCancelBtn');
    await sleep(420);

    const cloneBackToWizard = await ev(`({
        overlayActive: document.getElementById('nfcOverlay').classList.contains('active'),
        wifiViewVisible: document.getElementById('nfcWifiView').style.display !== 'none',
        step3Active: document.getElementById('wifiStep3Pane').classList.contains('active'),
        ssid: document.getElementById('wifiSsidInput').value
    })`);
    if (!cloneBackToWizard.overlayActive || !cloneBackToWizard.wifiViewVisible || !cloneBackToWizard.step3Active || cloneBackToWizard.ssid !== 'شبكة الاستقبال') {
        throw new Error(`Clone Mode Back button did not return cleanly to Wi-Fi Step 3: ${JSON.stringify(cloneBackToWizard)}`);
    }
    console.log('  PASS: Clone Mode Back button returned cleanly to Wi-Fi Wizard Step 3');

    await ev(`window.closeNfcModal()`);
    await sleep(420);

    // =========================================================================
    // 4. Standard Review QR Modal (Must NOT have theme-wifi, preserves strings)
    // =========================================================================
    console.log('Testing standard Review QR modal isolation...');
    await ev(`(() => {
        const u = document.getElementById('urlInput');
        u.value = 'https://search.google.com/local/writereview?placeid=ChIJN1t_tDeuEmsRUsoyG83frY4';
        u.dispatchEvent(new Event('input', { bubbles: true }));
        u.dispatchEvent(new Event('blur'));
    })()`);
    await sleep(380);
    await realTap('#qrBtn');
    await sleep(380);

    const stdQrState = await ev(`({
        active: document.getElementById('qrOverlay').classList.contains('active'),
        themeWifi: document.getElementById('qrModalBox').classList.contains('theme-wifi'),
        title: document.getElementById('qrModalTitle').textContent.trim(),
        hasCanvas: Boolean(document.getElementById('qrCodeContainer').querySelector('canvas'))
    })`);
    if (!stdQrState.active || stdQrState.themeWifi || !stdQrState.hasCanvas || stdQrState.title.includes('واي فاي')) {
        throw new Error(`Standard Review QR state tainted: ${JSON.stringify(stdQrState)}`);
    }
    console.log(`  PASS: Standard Review QR isolated cleanly (title="${stdQrState.title}")`);

    await realTap('#qrCloseBtn');
    await sleep(400);

    if (uncaughtErrors.length > 0) {
        throw new Error('Uncaught page exceptions detected: ' + JSON.stringify(uncaughtErrors));
    }

    console.log('ALL WI-FI, QR, KEYBOARD & STACKING E2E TESTS PASSED!');
} catch (err) {
    console.error('TEST FAILED:', err);
    process.exitCode = 1;
} finally {
    ws.close();
    proc.kill();
    server.close();
}
