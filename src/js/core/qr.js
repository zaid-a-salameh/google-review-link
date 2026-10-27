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
        return str.replace(/([\\;,:"])/g, '\\$1');
    }

    function buildWifiPayload(ssid, password, encType) {
        const enc = (encType === 'OPEN') ? 'nopass' : (encType === 'WEP' ? 'WEP' : 'WPA');
        let payload = 'WIFI:S:' + escapeWifiString(ssid) + ';T:' + enc + ';';
        if (enc !== 'nopass' && password) {
            payload += 'P:' + escapeWifiString(password) + ';';
        }
        payload += ';';
        return payload;
    }

    function generateQrCode(url) {
        const qrCodeContainer = document.getElementById('qrCodeContainer');
        if (!qrCodeContainer) return;
        qrCodeContainer.innerHTML = '';
        if (typeof QRCode !== 'undefined') {
            qrInstance = new QRCode(qrCodeContainer, {
                text: url,
                width: 200,
                height: 200,
                colorDark: "#1c1917",
                colorLight: "#ffffff",
                correctLevel: QRCode.CorrectLevel.H
            });
        } else {
            const img = document.createElement('img');
            img.src = `https://api.qrserver.com/v1/create-qr-code/?size=200x200&margin=1&data=${encodeURIComponent(url)}`;
            img.alt = (currentQrMode === 'wifi') ? 'Wi-Fi QR Code' : 'Google Review QR Code';
            img.width = 200;
            img.height = 200;
            qrCodeContainer.appendChild(img);
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

        const dict = getDict();
        const qrOverlay = document.getElementById('qrOverlay');
        const qrModalBox = document.getElementById('qrModalBox');
        const qrModalTitle = document.getElementById('qrModalTitle');
        const qrModalDesc = document.getElementById('qrModalDesc');
        const qrDownloadBtnLabel = document.getElementById('qrDownloadBtnLabel');

        if (qrModalTitle) qrModalTitle.textContent = dict.qrModalTitle || 'Google Review QR Code';
        if (qrModalDesc) qrModalDesc.textContent = dict.qrModalDesc || 'Scan with any smartphone camera to leave a review directly';
        if (qrDownloadBtnLabel) qrDownloadBtnLabel.textContent = dict.qrDownloadBtn || 'Download QR Image';

        if (qrModalBox) qrModalBox.classList.remove('theme-wifi');
        if (qrOverlay) qrOverlay.classList.remove('theme-wifi');

        const validBtn = (triggerBtn && triggerBtn.nodeType === 1) ? triggerBtn : document.getElementById('qrBtn');
        generateQrCode(url);
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
        if (!ssid || !ssid.trim()) {
            if (window.showToast) window.showToast(dict.toastEnterSsid || 'Please enter network name (SSID)', 'warn');
            return;
        }

        currentQrMode = 'wifi';
        currentWifiSsid = ssid.trim();
        currentWifiPayload = buildWifiPayload(currentWifiSsid, password, encType);

        const qrOverlay = document.getElementById('qrOverlay');
        const qrModalBox = document.getElementById('qrModalBox');
        const qrModalTitle = document.getElementById('qrModalTitle');
        const qrModalDesc = document.getElementById('qrModalDesc');
        const qrDownloadBtnLabel = document.getElementById('qrDownloadBtnLabel');

        if (qrModalTitle) qrModalTitle.textContent = dict.wifiQrModalTitle || 'Wi-Fi QR Code';
        if (qrModalDesc) qrModalDesc.textContent = dict.wifiQrModalDesc || 'Scan with any smartphone camera to connect directly';
        if (qrDownloadBtnLabel) qrDownloadBtnLabel.textContent = dict.wifiQrDownloadBtn || dict.qrDownloadBtn || 'Download QR Image';

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
            const dict = getDict();
            const qrModalTitle = document.getElementById('qrModalTitle');
            const qrModalDesc = document.getElementById('qrModalDesc');
            const qrDownloadBtnLabel = document.getElementById('qrDownloadBtnLabel');
            if (qrModalTitle) qrModalTitle.textContent = dict.qrModalTitle || 'Google Review QR Code';
            if (qrModalDesc) qrModalDesc.textContent = dict.qrModalDesc || 'Scan with any smartphone camera to leave a review directly';
            if (qrDownloadBtnLabel) qrDownloadBtnLabel.textContent = dict.qrDownloadBtn || 'Download QR Image';
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
        const filename = isWifi
            ? `wifi_${(currentWifiSsid || 'network').replace(/[^a-zA-Z0-9_-]/g, '_')}_qr.png`
            : 'google_review_qr.png';
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

    window.generateQrCode = generateQrCode;
    window.openQrModal = openQrModal;
    window.openQrModalForWifi = openQrModalForWifi;
    window.closeQrModal = closeQrModal;
    window.downloadQrImage = downloadQrImage;
})();
