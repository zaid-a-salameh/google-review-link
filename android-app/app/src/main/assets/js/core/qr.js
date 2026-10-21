// ========================================================
// QR Code Generator & Modal Management Engine
// ========================================================
(function() {
    'use strict';

    let qrInstance = null;

    function getDict() {
        const lang = window.getCurrentLang ? window.getCurrentLang() : 'en';
        return (window.I18N && window.I18N[lang]) ? window.I18N[lang] : {};
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
            img.alt = 'Google Review QR Code';
            img.width = 200;
            img.height = 200;
            qrCodeContainer.appendChild(img);
        }
    }

    function openQrModal() {
        const url = window.getGeneratedReviewUrl ? window.getGeneratedReviewUrl() : '';
        if (!url) return;
        const qrOverlay = document.getElementById('qrOverlay');
        if (qrOverlay) qrOverlay.classList.add('active');
        requestAnimationFrame(() => {
            generateQrCode(url);
        });
    }

    function closeQrModal() {
        const qrOverlay = document.getElementById('qrOverlay');
        if (qrOverlay) qrOverlay.classList.remove('active');
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

        if (window.AndroidNative && window.AndroidNative.saveQrImage) {
            window.AndroidNative.saveQrImage(dataUrl, "google_review_qr.png");
            if (window.showToast) window.showToast(dict.qrDownloaded || 'QR downloaded', 'success');
            return;
        }

        const link = document.createElement('a');
        link.download = 'google_review_qr.png';
        link.href = dataUrl;
        document.body.appendChild(link);
        link.click();
        document.body.removeChild(link);
        if (window.showToast) window.showToast(dict.qrDownloaded || 'QR downloaded', 'success');
    }

    window.generateQrCode = generateQrCode;
    window.openQrModal = openQrModal;
    window.closeQrModal = closeQrModal;
    window.downloadQrImage = downloadQrImage;
})();
