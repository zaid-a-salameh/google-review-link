// ========================================================
// QR Code Generator & Modal Management Engine
// ========================================================
(function() {
    'use strict';

    let qrInstance = null;

        function generateQrCode(url) {
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
                // Fallback using high-res QR image service
                const img = document.createElement('img');
                img.src = `https://api.qrserver.com/v1/create-qr-code/?size=200x200&margin=1&data=${encodeURIComponent(url)}`;
                img.alt = 'Google Review QR Code';
                img.width = 200;
                img.height = 200;
                qrCodeContainer.appendChild(img);
            }
        }

        function openQrModal() {
            if (!generatedReviewUrl) return;
            // Open modal with smooth spring animation immediately
            qrOverlay.classList.add('active');
            // Generate QR code cleanly on next animation frame
            requestAnimationFrame(() => {
                generateQrCode(generatedReviewUrl);
            });
        }

        function closeQrModal() {
            qrOverlay.classList.remove('active');
        }

        qrBtn.addEventListener('click', openQrModal);
        qrCloseBtn.addEventListener('click', closeQrModal);
        qrOverlay.addEventListener('click', e => {
            if (e.target === qrOverlay) closeQrModal();
        });

        // Download QR Image
        qrDownloadBtn.addEventListener('click', () => {
            const dict = I18N[currentLang];
            let dataUrl = null;

            const canvas = qrCodeContainer.querySelector('canvas');
            if (canvas) {
                // Create a beautiful framed image with padding
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

            // Check if running inside Android APK
            if (window.AndroidNative && window.AndroidNative.saveQrImage) {
                window.AndroidNative.saveQrImage(dataUrl, "google_review_qr.png");
                showToast(dict.qrDownloaded, 'success');
                return;
            }

            // Web download via anchor
            const link = document.createElement('a');
            link.download = 'google_review_qr.png';
            link.href = dataUrl;
            document.body.appendChild(link);
            link.click();
            document.body.removeChild(link);
            showToast(dict.qrDownloaded, 'success');
        });

    window.generateQrCode = generateQrCode;
    window.openQrModal = openQrModal;
    window.closeQrModal = closeQrModal;
})();
