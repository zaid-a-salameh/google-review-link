// ========================================================
// QR Code Generator & Modal Management Engine
// ========================================================
(function() {
    'use strict';

    let qrInstance = null;
    let currentQrMode = 'review';
    let currentWifiSsid = '';
    let currentWifiPayload = '';

    function getDict() {
        const lang = window.getCurrentLang ? window.getCurrentLang() : 'en';
        return (window.I18N && window.I18N[lang]) ? window.I18N[lang] : {};
    }

    function escapeWifiString(str) {
        if (!str) return '';
        return String(str).replace(/([\\;,:"])/g, '\\$1');
    }

    function buildWifiPayload(ssid, password, encType) {
        const cleanSsid = String(ssid || '').trim();
        const cleanPass = String(password || '').trim();
        const rawEnc = String(encType || '').toUpperCase();

        let enc = 'nopass';
        if (rawEnc === 'OPEN' || rawEnc === 'NOPASS' || rawEnc === 'NONE' || !cleanPass) {
            enc = 'nopass';
        } else if (rawEnc === 'WEP') {
            enc = 'WEP';
        } else {
            enc = 'WPA';
        }

        let payload = 'WIFI:S:' + escapeWifiString(cleanSsid) + ';T:' + enc + ';';
        if (enc !== 'nopass' && cleanPass) {
            payload += 'P:' + escapeWifiString(cleanPass) + ';';
        }
        payload += ';';
        return payload;
    }

    function renderFallbackQrImage(container, text) {
        container.innerHTML = '';
        const img = document.createElement('img');
        img.src = `https://api.qrserver.com/v1/create-qr-code/?size=200x200&margin=1&data=${encodeURIComponent(text)}`;
        img.alt = (currentQrMode === 'wifi') ? 'Wi-Fi QR Code' : 'Google Review QR Code';
        img.width = 200;
        img.height = 200;
        container.appendChild(img);
    }

    function generateQrCode(text) {
        const qrCodeContainer = document.getElementById('qrCodeContainer');
        if (!qrCodeContainer) return false;
        const payload = String(text || '');
        if (!payload) return false;

        qrCodeContainer.innerHTML = '';

        if (typeof QRCode !== 'undefined' && QRCode.CorrectLevel) {
            const levels = [
                QRCode.CorrectLevel.H,
                QRCode.CorrectLevel.Q,
                QRCode.CorrectLevel.M,
                QRCode.CorrectLevel.L
            ];

            for (let i = 0; i < levels.length; i++) {
                try {
                    qrCodeContainer.innerHTML = '';
                    qrInstance = new QRCode(qrCodeContainer, {
                        text: payload,
                        width: 200,
                        height: 200,
                        colorDark: '#1c1917',
                        colorLight: '#ffffff',
                        correctLevel: levels[i]
                    });
                    if (qrCodeContainer.querySelector('canvas, img, table')) {
                        return true;
                    }
                } catch (err) {
                    // Cascade down to lower error-correction level if payload is dense
                }
            }
        }

        try {
            renderFallbackQrImage(qrCodeContainer, payload);
            return true;
        } catch (err) {
            return false;
        }
    }

    function refreshQrModalStrings(explicitDict) {
        const dict = explicitDict || getDict();
        const qrModalTitle = document.getElementById('qrModalTitle');
        const qrModalDesc = document.getElementById('qrModalDesc');
        const qrDownloadBtnLabel = document.getElementById('qrDownloadBtnLabel');
        const qrCloseBtn = document.getElementById('qrCloseBtn');

        if (currentQrMode === 'wifi') {
            if (qrModalTitle) qrModalTitle.textContent = dict.wifiQrModalTitle || 'Wi-Fi QR Code';
            if (qrModalDesc) qrModalDesc.textContent = dict.wifiQrModalDesc || 'Scan with any smartphone camera to connect directly';
            if (qrDownloadBtnLabel) qrDownloadBtnLabel.textContent = dict.wifiQrDownloadBtn || dict.qrDownloadBtn || 'Download QR Image';
        } else {
            if (qrModalTitle) qrModalTitle.textContent = dict.qrModalTitle || 'Google Review QR Code';
            if (qrModalDesc) qrModalDesc.textContent = dict.qrModalDesc || 'Scan with any smartphone camera to leave a review directly';
            if (qrDownloadBtnLabel) qrDownloadBtnLabel.textContent = dict.qrDownloadBtn || 'Download QR Image';
        }

        if (qrCloseBtn && dict.qrCloseBtn) {
            qrCloseBtn.textContent = dict.qrCloseBtn;
        }
    }

    function openQrModal(triggerBtn) {
        if (document.activeElement && typeof document.activeElement.blur === 'function') {
            try { document.activeElement.blur(); } catch (e) {}
        }
        const url = window.getGeneratedReviewUrl ? window.getGeneratedReviewUrl() : '';
        if (!url) return;

        currentQrMode = 'review';
        currentWifiSsid = '';
        currentWifiPayload = '';

        const qrOverlay = document.getElementById('qrOverlay');
        const qrModalBox = document.getElementById('qrModalBox');

        refreshQrModalStrings();

        if (qrModalBox) qrModalBox.classList.remove('theme-wifi');
        if (qrOverlay) qrOverlay.classList.remove('theme-wifi');

        generateQrCode(url);

        const validBtn = (triggerBtn && triggerBtn.nodeType === 1) ? triggerBtn : document.getElementById('qrBtn');
        if (window.openMorphModal && qrOverlay && qrModalBox) {
            window.openMorphModal(qrOverlay, qrModalBox, validBtn);
        } else if (qrOverlay) {
            qrOverlay.classList.add('active');
        }
    }

    function openQrModalForWifi(ssid, password, encType, triggerBtn) {
        if (document.activeElement && typeof document.activeElement.blur === 'function') {
            try { document.activeElement.blur(); } catch (e) {}
        }
        const dict = getDict();
        const cleanSsid = String(ssid || '').trim();
        if (!cleanSsid) {
            if (window.showToast) window.showToast(dict.toastEnterSsid || 'Please enter network name (SSID)', 'warn');
            return;
        }

        const cleanPass = String(password || '').trim();
        let normEnc = String(encType || '').toUpperCase();
        if (!cleanPass || normEnc === 'OPEN' || normEnc === 'NOPASS' || normEnc === 'NONE') {
            normEnc = 'OPEN';
        }

        currentQrMode = 'wifi';
        currentWifiSsid = cleanSsid;
        currentWifiPayload = buildWifiPayload(cleanSsid, normEnc === 'OPEN' ? '' : cleanPass, normEnc);

        const qrOverlay = document.getElementById('qrOverlay');
        const qrModalBox = document.getElementById('qrModalBox');

        refreshQrModalStrings(dict);

        if (qrModalBox) qrModalBox.classList.add('theme-wifi');
        if (qrOverlay) qrOverlay.classList.add('theme-wifi');

        generateQrCode(currentWifiPayload);

        const validBtn = (triggerBtn && triggerBtn.nodeType === 1) ? triggerBtn : null;
        if (window.openMorphModal && qrOverlay && qrModalBox) {
            window.openMorphModal(qrOverlay, qrModalBox, validBtn);
        } else if (qrOverlay) {
            qrOverlay.classList.add('active');
        }
    }

    function closeQrModal() {
        const qrOverlay = document.getElementById('qrOverlay');
        const qrModalBox = document.getElementById('qrModalBox');

        const cleanup = () => {
            if (qrModalBox) qrModalBox.classList.remove('theme-wifi');
            if (qrOverlay) qrOverlay.classList.remove('theme-wifi');
            currentQrMode = 'review';
            currentWifiSsid = '';
            currentWifiPayload = '';
            refreshQrModalStrings();
        };

        if (window.closeMorphModal && qrOverlay && qrModalBox) {
            window.closeMorphModal(qrOverlay, qrModalBox, cleanup);
        } else if (qrOverlay) {
            qrOverlay.classList.remove('active');
            cleanup();
        }
    }

    function downloadQrImage() {
        const dict = getDict();
        const qrCodeContainer = document.getElementById('qrCodeContainer');
        if (!qrCodeContainer) return;

        let dataUrl = null;
        const canvas = qrCodeContainer.querySelector('canvas');
        if (canvas) {
            const framed = document.createElement('canvas');
            framed.width = canvas.width + 40;
            framed.height = canvas.height + 40;
            const ctx = framed.getContext('2d');
            ctx.fillStyle = '#ffffff';
            ctx.fillRect(0, 0, framed.width, framed.height);
            ctx.drawImage(canvas, 20, 20);
            dataUrl = framed.toDataURL('image/png');
        } else {
            const img = qrCodeContainer.querySelector('img');
            if (img && img.src) {
                dataUrl = img.src;
            }
        }

        if (!dataUrl) return;

        const isWifi = currentQrMode === 'wifi';
        const safeSlug = (currentWifiSsid || 'network').replace(/[^a-zA-Z0-9_-]/g, '_').replace(/^_+|_+$/g, '') || 'network';
        const filename = isWifi ? `wifi_${safeSlug}_qr.png` : 'google_review_qr.png';
        const toastMsg = isWifi ? (dict.wifiQrDownloaded || 'Wi-Fi QR Code downloaded') : (dict.qrDownloaded || 'QR Code downloaded');

        if (window.AndroidNative && window.AndroidNative.saveQrImage) {
            window.AndroidNative.saveQrImage(dataUrl, filename);
            if (window.showToast) window.showToast(toastMsg, 'success');
            return;
        }

        const link = document.createElement('a');
        link.download = filename;
        link.href = dataUrl;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        if (window.showToast) window.showToast(toastMsg, 'success');
    }

    function initQrModalBindings() {
        const qrOverlay = document.getElementById('qrOverlay');
        if (!qrOverlay || qrOverlay.dataset.qrBound === '1') return;
        qrOverlay.dataset.qrBound = '1';

        const qrCloseBtn = document.getElementById('qrCloseBtn');
        const qrDownloadBtn = document.getElementById('qrDownloadBtn');

        if (qrCloseBtn) qrCloseBtn.addEventListener('click', closeQrModal);
        if (qrDownloadBtn) qrDownloadBtn.addEventListener('click', downloadQrImage);
        qrOverlay.addEventListener('click', e => {
            if (e.target === qrOverlay) closeQrModal();
        });
    }

    document.addEventListener('DOMContentLoaded', initQrModalBindings);

    window.buildWifiPayload = buildWifiPayload;
    window.generateQrCode = generateQrCode;
    window.refreshQrModalStrings = refreshQrModalStrings;
    window.openQrModal = openQrModal;
    window.openQrModalForWifi = openQrModalForWifi;
    window.closeQrModal = closeQrModal;
    window.downloadQrImage = downloadQrImage;
    window.getCurrentQrPayload = function() { return currentWifiPayload; };
})();
