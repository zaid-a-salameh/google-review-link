// ========================================================
// Google Maps URL Resolver & Place ID Extraction Engine
// ========================================================
(function() {
    'use strict';

    function getInitialMode() {
        if (typeof document !== 'undefined') {
            const searchTab = document.getElementById('tabSearchMode');
            if (searchTab && searchTab.classList.contains('active')) {
                return 'search';
            }
        }
        return 'link';
    }

    const AppModes = {
        activeMode: getInitialMode(),
        link: {
            reviewUrl: null,
            locationUrl: null,
            placeId: null,
            activeType: 'review',
            isResultActive: false
        },
        search: {
            reviewUrl: null,
            locationUrl: null,
            placeId: null,
            activeType: 'review',
            isResultActive: false
        },
        getGeneratedReviewUrl: function() {
            const mode = this.activeMode;
            if (!this[mode] || !this[mode].isResultActive) return null;
            if (this[mode].placeId && this[mode].activeType === 'location') {
                return this[mode].locationUrl || this[mode].reviewUrl;
            }
            return this[mode].reviewUrl;
        },
        setModeResult: function(mode, url, placeId = null, locationUrl = null) {
            if (!this[mode]) return;
            this[mode].reviewUrl = url;
            this[mode].locationUrl = locationUrl;
            this[mode].placeId = placeId;
            this[mode].activeType = 'review';
            this[mode].isResultActive = !!url;
            this.syncResultCard();
        },
        setLinkType: function(type) {
            const mode = this.activeMode;
            if (!this[mode] || !this[mode].isResultActive || !this[mode].placeId) return;
            const newType = (type === 'location') ? 'location' : 'review';
            if (this[mode].activeType === newType) return;
            this[mode].activeType = newType;
            this.syncResultCard();

            if (window.AndroidNative && typeof window.AndroidNative.triggerLightHaptic === 'function') {
                try { window.AndroidNative.triggerLightHaptic(); } catch (e) {}
            } else if (navigator.vibrate) {
                try { navigator.vibrate(22); } catch (e) {}
            }
        },
        clearModeResult: function(mode) {
            if (!this[mode]) return;
            this[mode].reviewUrl = null;
            this[mode].locationUrl = null;
            this[mode].placeId = null;
            this[mode].activeType = 'review';
            this[mode].isResultActive = false;
            this.syncResultCard();
        },
        syncResultCard: function() {
            const resultCard = document.getElementById('resultCard');
            const resultLinkText = document.getElementById('resultLinkText');
            const resultLabelText = document.getElementById('resultLabelText');
            const linkTypeSelectorWrapper = document.getElementById('linkTypeSelectorWrapper');
            const btnTypeReview = document.getElementById('btnTypeReview');
            const btnTypeLocation = document.getElementById('btnTypeLocation');

            const current = this[this.activeMode];
            if (current && current.isResultActive && current.reviewUrl) {
                const activeUrl = (current.placeId && current.activeType === 'location')
                    ? (current.locationUrl || current.reviewUrl)
                    : current.reviewUrl;

                if (resultLinkText) resultLinkText.textContent = activeUrl;
                if (resultLabelText) {
                    const dict = (window.I18N && window.getCurrentLang) ? window.I18N[window.getCurrentLang()] : {};
                    if (current.placeId) {
                        resultLabelText.textContent = (current.activeType === 'location')
                            ? (dict.resultLabelLocation || 'Location on Google Maps:')
                            : (dict.resultLabelReview || 'Direct Review Link:');
                    } else {
                        const isReview = /writereview\?placeid=/i.test(current.reviewUrl);
                        resultLabelText.textContent = isReview 
                            ? (dict.resultLabelReview || 'Direct Review Link:') 
                            : (dict.resultLabelCustom || 'Direct Link:');
                    }
                }

                if (linkTypeSelectorWrapper) {
                    if (current.placeId && current.locationUrl) {
                        linkTypeSelectorWrapper.style.display = 'flex';
                        if (btnTypeReview) btnTypeReview.classList.toggle('active', current.activeType === 'review');
                        if (btnTypeLocation) btnTypeLocation.classList.toggle('active', current.activeType === 'location');
                    } else {
                        linkTypeSelectorWrapper.style.display = 'none';
                    }
                }

                if (resultCard) resultCard.classList.add('active');
            } else {
                if (linkTypeSelectorWrapper) linkTypeSelectorWrapper.style.display = 'none';
                if (resultCard) resultCard.classList.remove('active');
            }
            if (window.syncToolsVisibility) {
                window.syncToolsVisibility();
            }
        }
    };
    window.AppModes = AppModes;
    let generatedReviewUrl = '';

    function getDict() {
        const lang = window.getCurrentLang ? window.getCurrentLang() : 'en';
        return (window.I18N && window.I18N[lang]) ? window.I18N[lang] : {};
    }

    function setLoading(isLoading) {
        const dict = getDict();
        const convertBtn = document.getElementById('convertBtn');
        const btnSpinner = document.getElementById('btnSpinner');
        const btnIcon = document.getElementById('btnIcon');
        const btnText = document.getElementById('btnText');

        if (convertBtn) convertBtn.disabled = isLoading;
        if (btnSpinner) btnSpinner.style.display = isLoading ? 'block' : 'none';
        if (btnIcon) btnIcon.style.display = isLoading ? 'none' : 'block';
        if (btnText && dict.resolvingBtn && dict.convertBtn) {
            btnText.textContent = isLoading ? dict.resolvingBtn : dict.convertBtn;
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
            const endpoint = `https://unshorten.me/json/${encodeURIComponent(shortUrl.trim())}`;
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
        const dict = getDict();
        const urlInput = document.getElementById('urlInput');
        const resultCard = document.getElementById('resultCard');
        const resultLinkText = document.getElementById('resultLinkText');

        const raw = urlInput ? urlInput.value.trim() : '';
        if (!raw) {
            if (window.showToast) window.showToast(dict.toastPasteFirst || 'Please paste a link first');
            if (urlInput && (!window.isTouchDevice || !window.isTouchDevice())) urlInput.focus();
            return;
        }

        let placeId = parsePlaceIdFromText(raw);

        if (!placeId && /maps\.app\.goo\.gl|goo\.gl\/maps/i.test(raw)) {
            if (!isDeviceOnline()) {
                if (window.showToast) window.showToast(dict.toastNoInternet || 'No network connection', 'warn');
                return;
            }

            setLoading(true);
            const result = await resolveShortenedUrl(raw);
            setLoading(false);

            if (result && result.error === 'NO_INTERNET') {
                if (window.showToast) window.showToast(dict.toastNoInternet || 'No network connection', 'warn');
                return;
            }

            if (result && result.url) {
                placeId = parsePlaceIdFromText(result.url);
            }
        }

        if (!placeId) {
            if (!isDeviceOnline()) {
                if (window.showToast) window.showToast(dict.toastNoInternet || 'No network connection', 'warn');
            } else {
                if (window.showToast) window.showToast(dict.toastInvalid || 'Could not extract Place ID', 'error');
            }
            return;
        }

        const wasResultActive = Boolean(resultCard && resultCard.classList.contains('active'));
        generatedReviewUrl = `https://search.google.com/local/writereview?placeid=${placeId}`;
        const isMapsUrl = /maps\.app\.goo\.gl|goo\.gl\/maps|google\.[a-z.]+\/maps/i.test(raw);
        const locationUrl = isMapsUrl ? raw : `https://www.google.com/maps/search/?api=1&query=Google&query_place_id=${placeId}`;

        if (window.AppModes) {
            window.AppModes.setModeResult('link', generatedReviewUrl, placeId, locationUrl);
        } else {
            if (resultLinkText) resultLinkText.textContent = generatedReviewUrl;
            if (resultCard) resultCard.classList.add('active');
        }
        
        if (resultCard && !wasResultActive && (!window.AppModes || window.AppModes.link.isResultActive)) {
            resultCard.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
        }
        if (window.showToast) window.showToast(dict.toastSuccess || 'Link converted successfully', 'success');
    }

    window.handleConvert = handleConvert;
    window.parsePlaceIdFromText = parsePlaceIdFromText;
    window.resolveShortenedUrl = resolveShortenedUrl;
    window.isDeviceOnline = isDeviceOnline;
    window.getGeneratedReviewUrl = function() {
        return window.AppModes ? window.AppModes.getGeneratedReviewUrl() : generatedReviewUrl;
    };
    window.setGeneratedReviewUrl = function(u, mode) {
        const targetMode = mode || (window.AppModes ? window.AppModes.activeMode : 'link');
        if (window.AppModes) {
            window.AppModes.setModeResult(targetMode, u);
        } else {
            generatedReviewUrl = u;
        }
    };
})();
