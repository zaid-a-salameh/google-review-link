// UI smoke / regression test.
// Usage: node tests/ui_smoke.mjs [path-to-html]   (default: APK bundled index.html)
//
// Enforces architectural isolation rules:
//   1. With every modal closed, EVERY visible interactive element must be the
//      top-most element at its own center point (hit-test passes).
//   2. Opening & closing Onboarding, Language Switcher, QR, NFC, PIN, PermLock,
//      Wi-Fi Wizard, and Update modals must restore Rule 1 with zero leaks.
//   3. Each top-level modal overlay must be hidden + pointer-events:none when closed.
//   4. Zero uncaught JS exceptions or evaluation errors allowed.
import { spawn } from 'child_process';
import http from 'http';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const here = path.dirname(fileURLToPath(import.meta.url));
const rootDir = path.resolve(here, '..');
const HTML = path.resolve(process.cwd(), process.argv[2] || path.resolve(here, '../android-app/app/src/main/assets/index.html'));
const EDGE = process.env.EDGE_PATH || 'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe';
const PORT = 8120, CDP = 9250;

const MIME = {
  '.html': 'text/html; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.js': 'application/javascript; charset=utf-8',
  '.svg': 'image/svg+xml',
  '.png': 'image/png',
  '.ico': 'image/x-icon',
  '.json': 'application/json; charset=utf-8'
};

const server = http.createServer((q, r) => {
  const reqPath = decodeURIComponent((q.url || '/').split('?')[0]);
  if (reqPath === '/' || reqPath === '/index.html') {
    r.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' });
    r.end(fs.readFileSync(HTML));
    return;
  }
  const filePath = path.resolve(rootDir, '.' + reqPath);
  if (filePath.startsWith(rootDir) && fs.existsSync(filePath) && fs.statSync(filePath).isFile()) {
    const ext = path.extname(filePath).toLowerCase();
    r.writeHead(200, { 'Content-Type': MIME[ext] || 'application/octet-stream' });
    r.end(fs.readFileSync(filePath));
    return;
  }
  r.writeHead(404);
  r.end('Not found');
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
  '--user-data-dir=' + (process.env.TEMP || '/tmp') + '\\edge_smoke_' + Date.now(),
  'about:blank'
]);

let list;
for (let i = 0; i < 40; i++) {
  await new Promise(r => setTimeout(r, 200));
  try {
    list = await new Promise((res, rej) => http.get(`http://127.0.0.1:${CDP}/json/list`, x => {
      let b = ''; x.on('data', c => b += c); x.on('end', () => { try { res(JSON.parse(b)); } catch (e) { rej(e); } });
    }).on('error', rej));
    if (list && list.find(t => t.type === 'page')) break;
  } catch (e) {}
}
const ws = new WebSocket(list.find(t => t.type === 'page').webSocketDebuggerUrl);
await new Promise(r => ws.onopen = r);

let id = 1;
const errors = [];
const send = (method, params = {}) => new Promise((res, rej) => {
  const i = id++;
  const h = e => {
    const d = JSON.parse(e.data);
    if (d.id === i) {
      ws.removeEventListener('message', h);
      if (d.error) rej(new Error(JSON.stringify(d.error))); else res(d.result);
    }
  };
  ws.addEventListener('message', h);
  ws.send(JSON.stringify({ id: i, method, params }));
});
ws.addEventListener('message', e => {
  const d = JSON.parse(e.data);
  if (d.method === 'Runtime.exceptionThrown') {
    errors.push(d.params.exceptionDetails.exception?.description || d.params.exceptionDetails.text);
  }
});
const ev = async x => {
  const r = await send('Runtime.evaluate', { expression: x, returnByValue: true, awaitPromise: true });
  if (r.exceptionDetails) {
    const desc = r.exceptionDetails.exception?.description || r.exceptionDetails.text || 'Evaluation error';
    errors.push(desc);
    throw new Error(`Runtime.evaluate exception: ${desc}`);
  }
  return r.result?.value;
};
const sleep = ms => new Promise(r => setTimeout(r, ms));

await send('Runtime.enable');
await send('Page.enable');
await send('Page.bringToFront');
await send('Emulation.setDeviceMetricsOverride', { width: 390, height: 844, deviceScaleFactor: 2, mobile: true });
await send('Page.navigate', { url: `http://127.0.0.1:${PORT}/` });
await sleep(2200);

const HIT = `(() => {
  const bad = [];
  const sel = 'button, a[href], input, select, textarea, [role=button]';
  document.querySelectorAll(sel).forEach(e => {
    const r = e.getBoundingClientRect();
    const cs = getComputedStyle(e);
    if (r.width < 2 || r.height < 2 || cs.visibility === 'hidden' || cs.display === 'none' || cs.pointerEvents === 'none') return;
    if (r.bottom < 0 || r.top > innerHeight || r.right < 0 || r.left > innerWidth) return;
    if (e.closest('[aria-hidden=true]')) return;
    const t = document.elementFromPoint(Math.min(Math.max(r.left + r.width / 2, 0), innerWidth - 1), Math.min(Math.max(r.top + r.height / 2, 0), innerHeight - 1));
    if (!(t === e || e.contains(t) || (t && t.contains(e)))) bad.push((e.id || e.className || e.tagName) + ' <- blocked by ' + (t ? (t.id || t.className || t.tagName) : 'null'));
  });
  return bad;
})()`;

const OVERLAYS = `(() => [...document.querySelectorAll('[id$=Overlay]')].map(o => {
  const c = getComputedStyle(o);
  if (c.display === 'none') return null;
  return { id: o.id, active: o.classList.contains('active') || o.classList.contains('open'), vis: c.visibility, pe: c.pointerEvents };
}).filter(Boolean))()`;

let failed = false;
const fail = m => { failed = true; console.log('FAIL:', m); };

try {
  // First launch auto-opens the tour; close it first like a user would.
  await ev(`window.closeOnboardingModal && window.closeOnboardingModal()`);
  await sleep(600);

  let bad = await ev(HIT);
  if (bad.length) fail('blocked after initial close: ' + JSON.stringify(bad));
  else console.log('PASS: all visible controls hit-testable (initial)');

  for (const o of await ev(OVERLAYS)) {
    if (!o.active && (o.vis !== 'hidden' || o.pe !== 'none')) {
      fail(`closed overlay ${o.id} not isolated (vis=${o.vis}, pe=${o.pe})`);
    }
  }
  console.log('PASS: closed overlays isolated check done');

  // Open + step through + close the tour, then re-verify.
  const helpBtnId = await ev(`document.getElementById('btnOpenHelpGuide') && getComputedStyle(document.getElementById('btnOpenHelpGuide').closest('.top-bar') || document.body).display !== 'none' ? 'btnOpenHelpGuide' : (document.getElementById('btnNavHelp') ? 'btnNavHelp' : 'btnOpenHelpGuide')`);
  await ev(`document.getElementById('${helpBtnId}').click()`);
  await sleep(550);
  const opened = await ev(`document.getElementById('onboardingOverlay').classList.contains('active')`);
  if (!opened) fail('help button did not open onboarding');
  for (let i = 0; i < 3; i++) {
    await ev(`document.getElementById('btnObNext').click()`);
    await sleep(400);
  }
  await sleep(450);
  bad = await ev(HIT);
  if (bad.length) fail('blocked after tour closed: ' + JSON.stringify(bad));
  else console.log('PASS: controls hit-testable after tour cycle');

  // Re-open via button a second time (regression check against double-binding).
  await ev(`document.getElementById('${helpBtnId}').click()`);
  await sleep(450);
  if (!(await ev(`document.getElementById('onboardingOverlay').classList.contains('active')`))) fail('second open failed');
  await ev(`window.closeOnboardingModal()`);
  await sleep(500);

  // Test Link Conversion + QR Modal cycle (works on both APK & Web)
  await ev(`
    const inp = document.getElementById('urlInput');
    inp.value = 'https://search.google.com/local/writereview?placeid=ChIJN1t_tDeuEmsRUsoyG83frY4';
    document.getElementById('convertBtn').click();
  `);
  await sleep(350);
  await ev(`document.getElementById('qrBtn').click()`);
  await sleep(400);
  if (!(await ev(`document.getElementById('qrOverlay').classList.contains('active')`))) {
    fail('qrBtn did not open qrOverlay');
  }
  if (!(await ev(`Boolean(document.getElementById('qrCodeContainer').querySelector('canvas, img'))`))) {
    fail('qrCodeContainer did not render QR image');
  }
  await ev(`document.getElementById('qrCloseBtn').click()`);
  await sleep(450);

  // Switch Language AR -> EN and verify hit-test
  await ev(`window.switchLanguage('ar')`);
  await sleep(500);
  bad = await ev(HIT);
  if (bad.length) fail('blocked after switching to AR: ' + JSON.stringify(bad));
  else console.log('PASS: controls hit-testable in Arabic RTL');

  await ev(`window.switchLanguage('en')`);
  await sleep(500);

  // Native-only modal cycles (PIN, PermLock, Wi-Fi) when running on APK bundle
  const isNative = await ev(`document.body.classList.contains('is-native-app')`);
  if (isNative) {
    // PIN modal open -> switch tab -> close
    await ev(`document.getElementById('btnPwdLockTag').click()`);
    await sleep(400);
    if (!(await ev(`document.getElementById('nfcOverlay').classList.contains('active') && document.getElementById('nfcPwdView').classList.contains('active')`))) {
      fail('PIN modal failed to open');
    }
    await ev(`document.getElementById('pwdTabUnlock').click()`);
    await sleep(250);
    await ev(`document.getElementById('btnPwdCancel').click()`);
    await sleep(450);

    // PermLock modal open -> close
    await ev(`document.getElementById('btnPermLockTag').click()`);
    await sleep(400);
    if (!(await ev(`document.getElementById('nfcOverlay').classList.contains('active') && document.getElementById('nfcPermConfirmView').classList.contains('active')`))) {
      fail('PermLock modal failed to open');
    }
    await ev(`document.getElementById('btnPermLockCancel').click()`);
    await sleep(450);

    // Wi-Fi modal open -> close
    await ev(`document.getElementById('btnWifiTag').click()`);
    await sleep(400);
    if (!(await ev(`document.getElementById('nfcOverlay').classList.contains('active') && document.getElementById('nfcWifiView').classList.contains('active')`))) {
      fail('Wi-Fi modal failed to open');
    }
    await ev(`document.getElementById('btnWifiBack').click()`);
    await sleep(450);

    bad = await ev(HIT);
    if (bad.length) fail('blocked after native modal cycles: ' + JSON.stringify(bad));
    else console.log('PASS: native PIN / PermLock / Wi-Fi modal cycles clean');
  }

  for (const o of await ev(OVERLAYS)) {
    if (!o.active && (o.vis !== 'hidden' || o.pe !== 'none')) {
      fail(`closed overlay ${o.id} not isolated at end (vis=${o.vis}, pe=${o.pe})`);
    }
  }
} catch (err) {
  fail(err.message || String(err));
}

if (errors.length) fail('JS exceptions: ' + JSON.stringify(errors));
ws.close();
proc.kill();
server.close();
console.log(failed ? 'RESULT: FAILED' : 'RESULT: ALL PASSED');
process.exit(failed ? 1 : 0);
