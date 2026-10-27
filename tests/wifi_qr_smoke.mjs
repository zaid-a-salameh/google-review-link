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
const send = (method, params = {}) => new Promise((res, rej) => {
    const cur = id++;
    const handler = e => {
        const d = JSON.parse(e.data);
        if (d.id === cur) {
            ws.removeEventListener('message', handler);
            if (d.error) rej(d.error); else res(d.result);
        }
    };
    ws.addEventListener('message', handler);
    ws.send(JSON.stringify({ id: cur, method, params }));
});

const sleep = ms => new Promise(r => setTimeout(r, ms));
const ev = async x => {
    const r = await send('Runtime.evaluate', { expression: x, returnByValue: true, awaitPromise: true });
    return r.result?.value;
};

async function captureScreenshot(filepath) {
    const res = await send('Page.captureScreenshot', { format: 'png' });
    fs.writeFileSync(filepath, Buffer.from(res.data, 'base64'));
}

await send('Runtime.enable');
await send('Page.enable');
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
    await sleep(400);

    console.log('Testing Wi-Fi Wizard Step 1 -> 2 -> 3 QR button in Arabic...');
    // 1. Open Wi-Fi Modal
    await ev(`document.getElementById('btnWifiTag').click()`);
    await sleep(500);

    // 2. Step 1: Check btnWifiQr is hidden
    const step1QrDisplay = await ev(`getComputedStyle(document.getElementById('btnWifiQr')).display`);
    if (step1QrDisplay !== 'none') throw new Error(`Expected btnWifiQr display:none in Step 1, got ${step1QrDisplay}`);

    // Fill SSID
    await ev(`
        document.getElementById('wifiSsidInput').value = 'Cafe_Guest_5G';
        document.getElementById('btnWifiNext').click();
    `);
    await sleep(350);

    // 3. Step 2: Check btnWifiQr is hidden
    const step2QrDisplay = await ev(`getComputedStyle(document.getElementById('btnWifiQr')).display`);
    if (step2QrDisplay !== 'none') throw new Error(`Expected btnWifiQr display:none in Step 2, got ${step2QrDisplay}`);

    // Fill Password
    await ev(`
        document.getElementById('wifiPasswordInput').value = 'CoffeeAndWiFi2026';
        document.getElementById('btnWifiNext').click();
    `);
    await sleep(400);

    // 4. Step 3: Check btnWifiQr is visible!
    const step3QrDisplay = await ev(`getComputedStyle(document.getElementById('btnWifiQr')).display`);
    if (step3QrDisplay === 'none') throw new Error(`Expected btnWifiQr to be visible in Step 3! Got ${step3QrDisplay}`);
    console.log('PASS: btnWifiQr is visible in Step 3 (display: ' + step3QrDisplay + ')');

    // Blur active element to remove any focus ring before taking screenshot
    await ev(`if (document.activeElement) document.activeElement.blur()`);
    await sleep(200);

    // Capture screenshot of Step 3 showing [نسخ على البطاقة] and [رمز QR]
    const step3ScreenshotPath = 'C:\\Users\\Zaid-PC\\.gemini\\antigravity\\brain\\0b289e5d-cafa-4436-805f-dde8ad11b616\\screen_wifi_step3_ar.png';
    await captureScreenshot(step3ScreenshotPath);
    console.log(`Step 3 screenshot saved to ${step3ScreenshotPath}`);

    // 5. Click btnWifiQr
    await ev(`document.getElementById('btnWifiQr').click()`);
    await sleep(500);

    // Verify QR modal opened with theme-wifi
    const qrModalActive = await ev(`document.getElementById('qrOverlay').classList.contains('active')`);
    const isThemeWifi = await ev(`document.getElementById('qrModalBox').classList.contains('theme-wifi')`);
    const titleText = await ev(`document.getElementById('qrModalTitle').textContent`);
    const hasCanvas = await ev(`Boolean(document.getElementById('qrCodeContainer').querySelector('canvas, img'))`);

    if (!qrModalActive) throw new Error('Expected qrOverlay to be active');
    if (!isThemeWifi) throw new Error('Expected qrModalBox to have theme-wifi class');
    if (!hasCanvas) throw new Error('Expected qrCodeContainer to have canvas/img');
    console.log(`PASS: QR modal opened with theme-wifi: title="${titleText}"`);

    // Capture screenshot of the Wi-Fi QR modal in Arabic
    const screenshotPath = 'C:\\Users\\Zaid-PC\\.gemini\\antigravity\\brain\\0b289e5d-cafa-4436-805f-dde8ad11b616\\screen_wifi_qr_modal_ar.png';
    await captureScreenshot(screenshotPath);
    console.log(`Arabic QR Modal screenshot saved to ${screenshotPath}`);

    // Close QR modal
    await ev(`document.getElementById('qrCloseBtn').click()`);
    await sleep(400);

    // 5b. Test Open Wi-Fi Network (no password / empty password)
    console.log('Testing Open Wi-Fi Network QR button (empty password)...');
    await ev(`document.getElementById('wifiBackBtnLabel').click()`); // Back to step 2
    await sleep(300);
    await ev(`
        document.getElementById('wifiPasswordInput').value = '';
        document.getElementById('btnWifiNext').click();
    `); // Next to step 3 with empty password
    await sleep(350);

    const openLabel = await ev(`document.getElementById('wifiSelectedLabel').textContent`);
    console.log('Open Network dropdown label:', openLabel);

    await ev(`document.getElementById('btnWifiQr').click()`);
    await sleep(400);

    const openQrActive = await ev(`document.getElementById('qrOverlay').classList.contains('active')`);
    const openIsThemeWifi = await ev(`document.getElementById('qrModalBox').classList.contains('theme-wifi')`);
    if (!openQrActive || !openIsThemeWifi) throw new Error('Expected QR modal to open for open network with empty password!');
    console.log('PASS: Open Wi-Fi network opens QR modal with yellow theme!');

    // Close QR modal and cancel wifi wizard
    await ev(`document.getElementById('qrCloseBtn').click()`);
    await sleep(400);
    await ev(`document.getElementById('btnWifiBack').click()`); // from step 3 to step 2
    await sleep(250);
    await ev(`document.getElementById('btnWifiBack').click()`); // from step 2 to step 1
    await sleep(250);
    await ev(`document.getElementById('btnWifiBack').click()`); // from step 1 close modal
    await sleep(500);

    // 6. Test Clone Mode QR Button
    console.log('Testing Clone Mode Wi-Fi QR button...');
    await ev(`window.onNfcWifiTagRead({ ssid: 'Office_Mesh', password: 'SuperSecretPass', encType: 'WPA' })`);
    await sleep(500);

    const cloneQrDisplay = await ev(`getComputedStyle(document.getElementById('nfcWifiCloneQrBtn')).display`);
    if (cloneQrDisplay === 'none') throw new Error('Expected nfcWifiCloneQrBtn to be visible in Clone mode');
    console.log('PASS: nfcWifiCloneQrBtn is visible in Clone mode (display: ' + cloneQrDisplay + ')');

    // Blur active element before taking screenshot
    await ev(`if (document.activeElement) document.activeElement.blur()`);
    await sleep(200);

    // Capture screenshot of Clone Mode standby screen showing [رمز QR]
    const cloneScreenshotPath = 'C:\\Users\\Zaid-PC\\.gemini\\antigravity\\brain\\0b289e5d-cafa-4436-805f-dde8ad11b616\\screen_wifi_clone_standby_ar.png';
    await captureScreenshot(cloneScreenshotPath);
    console.log(`Clone standby screenshot saved to ${cloneScreenshotPath}`);

    // Click clone QR button
    await ev(`document.getElementById('nfcWifiCloneQrBtn').click()`);
    await sleep(500);

    const cloneQrActive = await ev(`document.getElementById('qrOverlay').classList.contains('active')`);
    const cloneIsThemeWifi = await ev(`document.getElementById('qrModalBox').classList.contains('theme-wifi')`);
    if (!cloneQrActive || !cloneIsThemeWifi) throw new Error('Expected QR modal to open in clone mode with theme-wifi');
    console.log('PASS: Clone QR button opens yellow Wi-Fi QR modal successfully');

    // Close QR modal and cancel NFC
    await ev(`document.getElementById('qrCloseBtn').click()`);
    await sleep(400);
    await ev(`document.getElementById('nfcCancelBtn').click()`);
    await sleep(400);

    // 7. Test standard Review QR button (should NOT have theme-wifi)
    console.log('Testing standard Review QR modal...');
    await ev(`
        document.getElementById('targetUrl').value = 'https://maps.app.goo.gl/test';
        document.getElementById('btnDirectConvert').click();
    `);
    await sleep(300);

    await ev(`document.getElementById('qrBtn').click()`);
    await sleep(400);

    const standardIsThemeWifi = await ev(`document.getElementById('qrModalBox').classList.contains('theme-wifi')`);
    if (standardIsThemeWifi) throw new Error('Expected standard review QR modal NOT to have theme-wifi');
    console.log('PASS: Standard Review QR modal does not have theme-wifi');

    await ev(`document.getElementById('qrCloseBtn').click()`);
    await sleep(400);

    console.log('ALL WI-FI QR TESTS PASSED!');
} catch (err) {
    console.error('TEST FAILED:', err);
    process.exitCode = 1;
} finally {
    ws.close();
    proc.kill();
    server.close();
}
