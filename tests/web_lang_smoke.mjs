import { spawn } from 'child_process';
import http from 'http';
import fs from 'fs';
import path from 'path';
import { fileURLToPath } from 'url';

const here = path.dirname(fileURLToPath(import.meta.url));
const rootDir = path.resolve(here, '..');
const EDGE = process.env.EDGE_PATH || 'C:\\Program Files (x86)\\Microsoft\\Edge\\Application\\msedge.exe';
const PORT = 8126, CDP = 9256;

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
  let filePath = path.resolve(rootDir, '.' + (reqPath === '/' ? '/index.html' : reqPath));
  if (fs.existsSync(filePath) && fs.statSync(filePath).isFile()) {
    const ext = path.extname(filePath).toLowerCase();
    r.writeHead(200, { 'Content-Type': MIME[ext] || 'application/octet-stream' });
    r.end(fs.readFileSync(filePath));
    return;
  }
  r.writeHead(404);
  r.end('Not Found: ' + reqPath);
});

await new Promise(r => server.listen(PORT, '127.0.0.1', r));
console.log(`Web test server listening on http://127.0.0.1:${PORT}`);

const proc = spawn(EDGE, [
  `--remote-debugging-port=${CDP}`,
  '--headless=new',
  '--disable-gpu',
  '--no-first-run',
  '--user-data-dir=' + (process.env.TEMP || '/tmp') + '\\edge_lang_' + Date.now(),
  'about:blank'
]);

try {
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
  const pageTarget = list.find(t => t.type === 'page');
  if (!pageTarget) throw new Error('No page target found');

  const ws = new WebSocket(pageTarget.webSocketDebuggerUrl);
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

  await send('Runtime.enable');
  await send('Page.enable');
  await send('Console.enable');

  ws.addEventListener('message', e => {
    const d = JSON.parse(e.data);
    if (d.method === 'Console.messageAdded') {
      console.log('BROWSER LOG:', d.params.message.text);
    }
  });

  await send('Page.navigate', { url: `http://127.0.0.1:${PORT}/index.html` });
  await new Promise(r => setTimeout(r, 700));

  console.log('--- Initial Page State ---');
  const initialLang = await ev('window.getCurrentLang()');
  console.log(`Initial language: ${initialLang}`);

  const languages = ['en', 'ar', 'de', 'es', 'fr', 'hi', 'ja', 'pt', 'ru', 'zh'];

  for (const lang of languages) {
    await ev(`window.switchLanguage('${lang}')`);
    await new Promise(r => setTimeout(r, 250)); // Allow 110ms animation phase to complete
    const result = await ev(`
      (function() {
        const docLang = document.documentElement.lang;
        const docDir = document.documentElement.dir;
        const navLabel = document.getElementById('navLangLabel')?.textContent;
        const topLabel = document.getElementById('topLangLabel')?.textContent;
        const activeItems = Array.from(document.querySelectorAll('.lang-dropdown-item.active')).map(el => el.getAttribute('data-lang'));
        const titleHow = document.getElementById('titleHowItWorks')?.textContent;
        const btnApk = document.getElementById('navApkBtn')?.textContent?.trim();
        return {
          lang: docLang,
          dir: docDir,
          navLabel,
          topLabel,
          activeCount: activeItems.length,
          activeLangs: activeItems,
          titleHow,
          btnApk
        };
      })()
    `);

    const expectedDir = lang === 'ar' ? 'rtl' : 'ltr';
    if (result.lang !== lang) {
      throw new Error(`Lang mismatch for ${lang}: got ${result.lang}`);
    }
    if (result.dir !== expectedDir) {
      throw new Error(`Dir mismatch for ${lang}: got ${result.dir}, expected ${expectedDir}`);
    }
    if (!result.activeLangs.includes(lang)) {
      throw new Error(`Active item missing for ${lang}: got ${JSON.stringify(result.activeLangs)}`);
    }

    console.log(`  PASS [${lang.toUpperCase()}] -> Label: "${result.navLabel}", Dir: ${result.dir}, Active: ${result.activeCount}, APK: "${result.btnApk}", HowItWorks: "${result.titleHow}"`);
  }

  // Test Dropdown Toggle Behavior
  console.log('\n--- Testing Dropdown Toggle & Accessibility ---');
  const toggleResult = await ev(`
    (function() {
      const container = document.querySelector('#navLangDropdownContainer');
      const btn = container.querySelector('.lang-select-btn');
      
      // 1. Initially closed
      const initOpen = container.classList.contains('open');
      const initAria = btn.getAttribute('aria-expanded');

      // 2. Click button to open
      btn.click();
      const opened = container.classList.contains('open');
      const openedAria = btn.getAttribute('aria-expanded');

      // 3. Click button to close
      btn.click();
      const closedAgain = !container.classList.contains('open');
      const closedAria = btn.getAttribute('aria-expanded');

      // 4. Open and then click outside
      btn.click();
      document.body.click();
      const closedOutside = !container.classList.contains('open');

      return {
        initClosed: !initOpen && initAria === 'false',
        opened: opened && openedAria === 'true',
        closedAgain: closedAgain && closedAria === 'false',
        closedOutside
      };
    })()
  `);

  if (!toggleResult.initClosed || !toggleResult.opened || !toggleResult.closedAgain || !toggleResult.closedOutside) {
    throw new Error('Dropdown toggle test failed: ' + JSON.stringify(toggleResult));
  }
  console.log('  PASS: Dropdown opens, closes on toggle, and dismisses on outside click seamlessly.');
  for (const lang of ['de', 'ar', 'ja', 'en']) {
    await ev(`
      (function() {
        const item = document.querySelector('.lang-dropdown-item[data-lang="${lang}"]');
        if (item) item.click();
      })()
    `);
    await new Promise(r => setTimeout(r, 250));
    const clickResult = await ev(`
      (function() {
        const item = document.querySelector('.lang-dropdown-item[data-lang="${lang}"]');
        return {
          currentLang: window.getCurrentLang(),
          docLang: document.documentElement.lang,
          navLabel: document.getElementById('navLangLabel')?.textContent,
          activeMatches: item?.classList.contains('active')
        };
      })()
    `);

    if (clickResult.currentLang !== lang || !clickResult.activeMatches) {
      console.error('All browser errors caught so far:', errors);
      throw new Error(`Click test failed for ${lang}: ${JSON.stringify(clickResult)}`);
    }
    console.log(`  CLICK PASS [${lang}]: currentLang=${clickResult.currentLang}, label="${clickResult.navLabel}", active=${clickResult.activeMatches}`);
  }

  if (errors.length > 0) {
    throw new Error('Uncaught browser exceptions: ' + JSON.stringify(errors));
  }

  console.log('\n======================================================');
  console.log('ALL 10 LANGUAGES PASSED 100% IN HEADLESS EDGE BROWSER!');
  console.log('======================================================');
} finally {
  proc.kill();
  server.close();
}
