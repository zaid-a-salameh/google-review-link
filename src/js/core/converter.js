// ========================================================
// Google Maps URL Resolver & Place ID Extraction Engine
// ========================================================
(function() {
    'use strict';

    let generatedReviewUrl = '';

        function setLoading(isLoading) {
            const dict = I18N[currentLang];
            if (isLoading) {
                convertBtn.disabled = true;
                btnSpinner.style.display = 'block';
                btnIcon.style.display = 'none';
                btnText.textContent = dict.resolvingBtn;
            } else {
                convertBtn.disabled = false;
                btnSpinner.style.display = 'none';
                btnIcon.style.display = 'block';
                btnText.textContent = dict.convertBtn;
            }
        }

        // ── Protobuf Hex Decoder (0x...:0x... -> ChIJ...) ──
        function hexToPlaceId(featureId) {
            try {
                const parts = featureId.split(':');
                if (parts.length !== 2) return null;

                const hexA = parts[0].replace(/^0x/i, '').padStart(16, '0');
                const hexB = parts[1].replace(/^0x/i, '').padStart(16, '0');

                function toLittleEndian(hex) {
                    const bytes = [];
                    for (let i = hex.length - 2; i >= 0; i -= 2) {
                        bytes.push(parseInt(hex.substring(i, i + 2), 16));
                    }
                    return bytes;
                }

                const msg = [
                    0x0A, 0x12,
                    0x09,
                    ...toLittleEndian(hexA),
                    0x11,
                    ...toLittleEndian(hexB)
                ];

                const b64 = btoa(String.fromCharCode.apply(null, msg));
                return b64.replace(/\+/g, '-').replace(/\//g, '_').replace(/=+$/, '');
            } catch (e) {
                return null;
            }
        }

        // ── Direct Place ID Parser ──
        function parsePlaceIdFromText(text) {
            if (!text) return null;

            let decoded;
            try { decoded = decodeURIComponent(text); } catch(e) { decoded = text; }

            let match = decoded.match(/place_?id[=:]\s*([A-Za-z0-9_-]{15,})/i);
            if (match) return match[1];

            match = decoded.match(/(ChIJ[A-Za-z0-9_-]{20,})/);
            if (match) return match[1];

            match = decoded.match(/(?:!1s|ftid=)(0x[0-9a-fA-F]+:0x[0-9a-fA-F]+)/);
            if (match) {
                const pid = hexToPlaceId(match[1]);
                if (pid) return pid;
            }

            match = decoded.match(/(0x[0-9a-fA-F]{10,}:0x[0-9a-fA-F]{10,})/);
            if (match) {
                const pid = hexToPlaceId(match[1]);
                if (pid) return pid;
            }

            return null;
        }

        // ── Device Connectivity Check ──
        function isDeviceOnline() {
            if (window.AndroidNative && typeof window.AndroidNative.isNetworkConnected === 'function') {
                try {
                    return window.AndroidNative.isNetworkConnected();
                } catch (e) {
                    console.warn('isNetworkConnected error:', e);
                }
            }
            return navigator.onLine !== false;
        }

        // ── Unshorten maps.app.goo.gl / goo.gl shortlinks ──
        async function resolveShortenedUrl(shortUrl) {
            if (!isDeviceOnline()) {
                return { url: null, error: 'NO_INTERNET' };
            }

            let networkError = false;

            try {
                const endpoint = `https://unshorten.me/json/${shortUrl.trim()}`;
                const res = await fetch(endpoint, { method: 'GET' });
                if (res.ok) {
                    const data = await res.json();
                    if (data && data.resolved_url) {
                        return { url: data.resolved_url, error: null };
                    }
                }
            } catch (e) {
                console.warn('unshorten.me error:', e);
                networkError = true;
            }

            try {
                const proxy = `https://api.allorigins.win/raw?url=${encodeURIComponent(shortUrl.trim())}`;
                const res = await fetch(proxy);
                if (res.ok) {
                    const html = await res.text();
                    const match = html.match(/(0x[0-9a-fA-F]{10,}(?::|%3A)0x[0-9a-fA-F]{10,})/i);
                    if (match) {
                        return { url: decodeURIComponent(match[1]), error: null };
                    }
                }
            } catch (e) {
                console.warn('allorigins proxy error:', e);
                networkError = true;
            }

            if (!isDeviceOnline() || networkError) {
                return { url: null, error: 'NO_INTERNET' };
            }

            return { url: null, error: null };
        }

        // ── Execute Convert ──
        async function handleConvert() {
            const dict = I18N[currentLang];
            const raw = urlInput.value.trim();
            if (!raw) {
                showToast(dict.toastPasteFirst);
                urlInput.focus();
                return;
            }

            let placeId = parsePlaceIdFromText(raw);

            if (!placeId && /maps\.app\.goo\.gl|goo\.gl\/maps/i.test(raw)) {
                if (!isDeviceOnline()) {
                    showToast(dict.toastNoInternet);
                    return;
                }

                setLoading(true);
                const result = await resolveShortenedUrl(raw);
                setLoading(false);

                if (result && result.error === 'NO_INTERNET') {
                    showToast(dict.toastNoInternet, 'warn');
                    return;
                }

                if (result && result.url) {
                    placeId = parsePlaceIdFromText(result.url);
                }
            }

            if (!placeId) {
                if (!isDeviceOnline()) {
                    showToast(dict.toastNoInternet, 'warn');
                } else {
                    showToast(dict.toastInvalid, 'error');
                }
                return;
            }

            generatedReviewUrl = `https://search.google.com/local/writereview?placeid=${placeId}`;
            resultLinkText.textContent = generatedReviewUrl;
            
            resultCard.classList.add('active');
            resultCard.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
            showToast(dict.toastSuccess, 'success');
        }

    window.handleConvert = handleConvert;
    window.parsePlaceIdFromText = parsePlaceIdFromText;
    window.resolveShortenedUrl = resolveShortenedUrl;
    window.isDeviceOnline = isDeviceOnline;
    window.getGeneratedReviewUrl = function() { return generatedReviewUrl; };
    window.setGeneratedReviewUrl = function(u) { generatedReviewUrl = u; };
})();
