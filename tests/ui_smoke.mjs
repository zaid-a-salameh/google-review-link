// UI smoke / regression test.
// Usage: node tests/ui_smoke.mjs [path-to-html]   (default: APK bundled index.html)
//
// Guards against the class of bug where an invisible/closed layer (e.g. a modal
// overlay or one of its children) sits on top of the page and swallows taps.
// Rules enforced:
//   1. With every modal closed, EVERY visible interactive element must be the
//      top-most element at its own center point (hit-test passes).
//   2. Opening the onboarding tour then closing it must restore rule 1.
//   3. Each top-level modal overlay must be hidden + pointer-events:none when closed.
import { spawn } from 'child_process';
import http from 'http';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const here = path.dirname(fileURLToPath(import.meta.url));
const HTML = process.argv[2] || path.resolve(here, '../android-app/app/src/main/assets/index.html');
const EDGE = process.env.EDGE_PATH || 'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe';
const PORT = 8120, CDP = 9250;

const server = http.createServer((q, r) => { r.writeHead(200, { 'Content-Type': 'text/html; charset=utf-8' }); r.end(fs.readFileSync(HTML)); });
await new Promise(r => server.listen(PORT, '127.0.0.1', r));
const proc = spawn(EDGE, [`--remote-debugging-port=${CDP}`, '--headless=new', '--disable-gpu', '--no-first-run',
  '--user-data-dir=' + (process.env.TEMP || '/tmp') + '\\edge_smoke_' + Date.now(), 'about:blank']);

let list;
for (let i = 0; i < 40; i++) {
  await new Promise(r => setTimeout(r, 200));
  try {
    list = await new Promise((res, rej) => http.get(`http://127.0.0.1:${CDP}/json/list`, x => {
      let b = ''; x.on('data', c => b += c); x.on('end', () => { try { res(JSON.parse(b)); } catch (e) { rej(e); } });
    }).on('error', rej));
    if (list.length) break;
  } catch (e) {}
}
const ws = new WebSocket(list.find(t => t.type === 'page').webSocketDebuggerUrl);
await new Promise(r => ws.onopen = r);
let id = 1; const errors = [];
const send = (method, params = {}) => new Promise(res => {
  const i = id++;
  const h = e => { const d = JSON.parse(e.data); if (d.id === i) { ws.removeEventListener('message', h); res(d.result); } };
  ws.addEventListener('message', h); ws.send(JSON.stringify({ id: i, method, params }));
});
ws.addEventListener('message', e => {
  const d = JSON.parse(e.data);
  if (d.method === 'Runtime.exceptionThrown') errors.push(d.params.exceptionDetails.exception?.description || d.params.exceptionDetails.text);
});
const ev = async x => (await send('Runtime.evaluate', { expression: x, returnByValue: true, awaitPromise: true })).result?.value;
const sleep = ms => new Promise(r => setTimeout(r, ms));

await send('Runtime.enable'); await send('Page.enable');
await send('Emulation.setDeviceMetricsOverride', { width: 390, height: 844, deviceScaleFactor: 2, mobile: true });
await send('Page.navigate', { url: `http://127.0.0.1:${PORT}/` });
await sleep(2200);

const HIT = `(() => {
  const bad = [];
  const sel = 'button, a[href], input, select, textarea, [role=button]';
  document.querySelectorAll(sel).forEach(e => {
    const r = e.getBoundingClientRect();
    const cs = getComputedStyle(e);
    if (r.width < 2 || r.height < 2 || cs.visibility === 'hidden' || cs.display === 'none' || cs.pointerEvents === 'none') return; // inert elements inside closed layers can neither be tapped nor block taps
    if (r.bottom < 0 || r.top > innerHeight || r.right < 0 || r.left > innerWidth) return;
    if (e.closest('[aria-hidden=true]')) return;
    const t = document.elementFromPoint(Math.min(Math.max(r.left + r.width / 2, 0), innerWidth - 1), Math.min(Math.max(r.top + r.height / 2, 0), innerHeight - 1));
    if (!(t === e || e.contains(t) || (t && t.contains(e)))) bad.push((e.id || e.className || e.tagName) + ' <- blocked by ' + (t ? (t.id || t.className || t.tagName) : 'null'));
  });
  return bad;
})()`;
const OVERLAYS = `(() => [...document.querySelectorAll('[id$=Overlay]')].map(o => { const c = getComputedStyle(o); if (c.display === 'none') return null; return { id: o.id, active: o.classList.contains('active') || o.classList.contains('open'), vis: c.visibility, pe: c.pointerEvents }; }).filter(Boolean))()`;

let failed = false;
const fail = m => { failed = true; console.log('FAIL:', m); };

// First launch auto-opens the tour; close it first like a user would.
await ev(`window.closeOnboardingModal && window.closeOnboardingModal()`);
await sleep(700);

let bad = await ev(HIT);
if (bad.length) fail('blocked after initial close: ' + JSON.stringify(bad)); else console.log('PASS: all visible controls hit-testable (initial)');

for (const o of await ev(OVERLAYS)) {
  if (!o.active && (o.vis !== 'hidden' || o.pe !== 'none')) fail(`closed overlay ${o.id} not isolated (vis=${o.vis}, pe=${o.pe})`);
}
console.log('PASS: closed overlays isolated check done');

// Open + step through + close the tour, then re-verify.
await ev(`document.getElementById('btnOpenHelpGuide').click()`); await sleep(600);
const opened = await ev(`document.getElementById('onboardingOverlay').classList.contains('active')`);
if (!opened) fail('help button did not open onboarding');
for (let i = 0; i < 3; i++) { await ev(`document.getElementById('btnObNext').click()`); await sleep(450); }
await sleep(500);
bad = await ev(HIT);
if (bad.length) fail('blocked after tour closed: ' + JSON.stringify(bad)); else console.log('PASS: controls hit-testable after tour cycle');

// Re-open via button a second time (regression for double-binding).
await ev(`document.getElementById('btnOpenHelpGuide').click()`); await sleep(500);
if (!(await ev(`document.getElementById('onboardingOverlay').classList.contains('active')`))) fail('second open failed');
await ev(`window.closeOnboardingModal()`); await sleep(600);
bad = await ev(HIT);
if (bad.length) fail('blocked after reopen/close: ' + JSON.stringify(bad)); else console.log('PASS: reopen/close cycle clean');

if (errors.length) fail('JS exceptions: ' + JSON.stringify(errors));
ws.close(); proc.kill(); server.close();
console.log(failed ? 'RESULT: FAILED' : 'RESULT: ALL PASSED');
process.exit(failed ? 1 : 0);
