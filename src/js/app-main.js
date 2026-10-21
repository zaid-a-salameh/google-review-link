// ========================================================
// Native Android App Main Bootstrapper & Event Orchestrator
// ========================================================
(function() {
    'use strict';

    const $ = id => document.getElementById(id);

    document.addEventListener('DOMContentLoaded', () => {
        const urlInput = $('urlInput');
        const clearBtn = $('clearBtn');
        const pasteBtn = $('pasteBtn');
        const convertBtn = $('convertBtn');
        const copyBtn = $('copyBtn');
        const copyBtnLabel = $('copyBtnLabel');
        const openBtn = $('openBtn');
        const shareBtn = $('shareBtn');
        const qrBtn = $('qrBtn');
        const nfcBtn = $('nfcBtn');
        const tabLinkMode = $('tabLinkMode');
        const tabSearchMode = $('tabSearchMode');
        const businessSearchInput = $('businessSearchInput');
        const searchClearBtn = $('searchClearBtn');
        const searchFieldWrapper = $('searchFieldWrapper');
        const placesDropdown = $('placesDropdown');
        const resultCard = $('resultCard');
        const qrOverlay = $('qrOverlay');
        const qrCloseBtn = $('qrCloseBtn');
        const qrDownloadBtn = $('qrDownloadBtn');
        const nfcCancelBtn = $('nfcCancelBtn');
        const btnEn = $('btnEn');
        const btnAr = $('btnAr');
        const btnCheckUpdate = $('btnCheckUpdate');
        const btnUpdateNow = $('btnUpdateNow');
        const updateCloseBtn = $('updateCloseBtn');
        const btnUpdateLater = $('btnUpdateLater');
        const updateOverlay = $('updateOverlay');

        let autocompleteDebounceTimer = null;
        let highlightedSuggestionIndex = -1;

        // ── Mode Switcher ──
        if (tabLinkMode) tabLinkMode.addEventListener('click', () => window.switchMode('link'));
        if (tabSearchMode) tabSearchMode.addEventListener('click', () => window.switchMode('search'));

        // ── Input & Convert Listeners ──
        if (convertBtn) convertBtn.addEventListener('click', window.handleConvert);
        if (urlInput) {
            urlInput.addEventListener('keydown', e => {
                if (e.key === 'Enter') window.handleConvert();
            });
            urlInput.addEventListener('input', () => {
                const val = urlInput.value.trim();
                if (val.length >= 3 && !/^https?:\/\//i.test(val) && !/maps\.app\.goo\.gl/i.test(val) && !/goo\.gl/i.test(val) && !/placeid/i.test(val) && !/ChIJ/i.test(val)) {
                    window.switchMode('search');
                    if (businessSearchInput) {
                        businessSearchInput.value = val;
                        businessSearchInput.dispatchEvent(new Event('input'));
                    }
                }
            });
        }

        // ── Clear / Trash ──
        if (clearBtn) {
            clearBtn.addEventListener('click', () => {
                const dict = window.I18N[window.getCurrentLang()];
                if (urlInput) {
                    urlInput.value = '';
                    urlInput.focus();
                }
                if (resultCard) resultCard.classList.remove('active');
                if (window.showToast) window.showToast(dict.toastCleared, 'trash');
            });
        }

        // ── Paste Action (Native Android Clipboard Bridge) ──
        if (pasteBtn) {
            pasteBtn.addEventListener('click', () => {
                if (window.AndroidNative && window.AndroidNative.pasteFromClipboard) {
                    window.AndroidNative.pasteFromClipboard();
                } else if (navigator.clipboard && navigator.clipboard.readText) {
                    navigator.clipboard.readText().then(text => {
                        if (text && text.trim()) {
                            window.switchMode('link');
                            if (urlInput) urlInput.value = text.trim();
                            if (window.showToast) window.showToast(window.I18N[window.getCurrentLang()].toastPasted, 'paste');
                            window.handleConvert();
                        } else {
                            if (window.showToast) window.showToast(window.I18N[window.getCurrentLang()].toastEmptyClip, 'warn');
                        }
                    }).catch(() => {
                        if (window.showToast) window.showToast(window.I18N[window.getCurrentLang()].toastClipDenied, 'paste');
                    });
                }
            });
        }

        // ── Action Buttons (Copy, Open, Share, QR, NFC) ──
        if (copyBtn) {
            copyBtn.addEventListener('click', () => {
                const reviewUrl = window.getGeneratedReviewUrl();
                if (!reviewUrl) return;
                const dict = window.I18N[window.getCurrentLang()];
                if (window.AndroidNative && window.AndroidNative.copyToClipboard) {
                    window.AndroidNative.copyToClipboard(reviewUrl);
                } else if (navigator.clipboard) {
                    navigator.clipboard.writeText(reviewUrl);
                }
                copyBtn.classList.add('copied');
                if (copyBtnLabel) copyBtnLabel.textContent = dict.copySuccess;
                if (window.showToast) window.showToast(dict.toastCopied, 'copy');
                setTimeout(() => {
                    copyBtn.classList.remove('copied');
                    if (copyBtnLabel) copyBtnLabel.textContent = dict.copyBtn;
                }, 2000);
            });
        }

        if (openBtn) {
            openBtn.addEventListener('click', () => {
                const reviewUrl = window.getGeneratedReviewUrl();
                if (reviewUrl) window.open(reviewUrl, '_blank');
            });
        }

        if (shareBtn) {
            shareBtn.addEventListener('click', () => {
                const reviewUrl = window.getGeneratedReviewUrl();
                if (!reviewUrl) return;
                const dict = window.I18N[window.getCurrentLang()];
                if (window.AndroidNative && window.AndroidNative.shareText) {
                    window.AndroidNative.shareText(reviewUrl, dict.shareText);
                } else if (navigator.share) {
                    navigator.share({ title: dict.shareTitle, text: dict.shareText, url: reviewUrl }).catch(() => {});
                } else if (navigator.clipboard) {
                    navigator.clipboard.writeText(reviewUrl);
                    if (window.showToast) window.showToast(dict.toastShareCopied, 'copy');
                }
            });
        }

        // ── QR Code Modal Handlers ──
        if (qrBtn) qrBtn.addEventListener('click', window.openQrModal);
        if (qrCloseBtn) qrCloseBtn.addEventListener('click', window.closeQrModal);
        if (qrDownloadBtn) qrDownloadBtn.addEventListener('click', window.downloadQrImage);
        if (qrOverlay) {
            qrOverlay.addEventListener('click', e => {
                if (e.target === qrOverlay) window.closeQrModal();
            });
        }

        // ── NFC Button & Modal Handlers ──
        if (nfcBtn) nfcBtn.addEventListener('click', window.startNfcWrite);
        if (nfcCancelBtn) nfcCancelBtn.addEventListener('click', window.closeNfcModal);

        // ── In-App Update Handlers ──
        if (btnCheckUpdate) {
            btnCheckUpdate.addEventListener('click', () => window.checkForAppUpdates(true));
        }
        if (btnUpdateNow) {
            btnUpdateNow.addEventListener('click', () => {
                const dict = window.I18N[window.getCurrentLang()];
                const targetUrl = window.latestApkDownloadUrl || 'https://github.com/zaid-a-salameh/google-review-link/releases/latest/download/ReviewLinkGenerator.apk';
                if (window.AndroidNative && typeof window.AndroidNative.downloadAndInstallApk === 'function') {
                    window.AndroidNative.downloadAndInstallApk(targetUrl);
                    if (window.showToast) window.showToast(dict.toastDownloadStarted, 'download');
                    window.closeUpdateModal();
                } else {
                    window.open(targetUrl, '_blank');
                    window.closeUpdateModal();
                }
            });
        }
        if (updateCloseBtn) updateCloseBtn.addEventListener('click', window.closeUpdateModal);
        if (btnUpdateLater) btnUpdateLater.addEventListener('click', window.closeUpdateModal);
        if (updateOverlay) {
            updateOverlay.addEventListener('click', e => {
                if (e.target === updateOverlay) window.closeUpdateModal();
            });
        }

        // ── Search Business Input Events ──
        if (searchClearBtn) {
            searchClearBtn.addEventListener('click', () => {
                if (businessSearchInput) {
                    businessSearchInput.value = '';
                    searchClearBtn.classList.remove('visible');
                    window.hidePlacesDropdown();
                    businessSearchInput.focus();
                }
            });
        }

        document.addEventListener('click', e => {
            if (searchFieldWrapper && !searchFieldWrapper.contains(e.target)) {
                window.hidePlacesDropdown();
            }
        });

        if (businessSearchInput) {
            businessSearchInput.addEventListener('keydown', e => {
                if (placesDropdown && placesDropdown.classList.contains('show')) {
                    const items = placesDropdown.querySelectorAll('.place-suggestion-item');
                    if (e.key === 'ArrowDown') {
                        e.preventDefault();
                        highlightedSuggestionIndex = Math.min(highlightedSuggestionIndex + 1, items.length - 1);
                        items.forEach((item, i) => item.classList.toggle('selected', i === highlightedSuggestionIndex));
                        if (items[highlightedSuggestionIndex]) items[highlightedSuggestionIndex].scrollIntoView({ block: 'nearest' });
                        return;
                    }
                    if (e.key === 'ArrowUp') {
                        e.preventDefault();
                        highlightedSuggestionIndex = Math.max(highlightedSuggestionIndex - 1, 0);
                        items.forEach((item, i) => item.classList.toggle('selected', i === highlightedSuggestionIndex));
                        if (items[highlightedSuggestionIndex]) items[highlightedSuggestionIndex].scrollIntoView({ block: 'nearest' });
                        return;
                    }
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        if (highlightedSuggestionIndex >= 0 && items[highlightedSuggestionIndex]) {
                            items[highlightedSuggestionIndex].click();
                        } else if (items.length > 0) {
                            items[0].click();
                        }
                        return;
                    }
                    if (e.key === 'Escape') {
                        window.hidePlacesDropdown();
                        return;
                    }
                }
            });

            businessSearchInput.addEventListener('input', () => {
                const val = businessSearchInput.value;
                const trimmed = val.trim();

                if (searchClearBtn) {
                    searchClearBtn.classList.toggle('visible', trimmed.length > 0);
                }

                if (/https?:\/\//i.test(trimmed) || /maps\.app\.goo\.gl/i.test(trimmed) || /goo\.gl\/maps/i.test(trimmed) || /placeid/i.test(trimmed) || /ChIJ/i.test(trimmed)) {
                    window.switchMode('link');
                    if (urlInput) urlInput.value = trimmed;
                    businessSearchInput.value = '';
                    window.hidePlacesDropdown();
                    if (window.showToast) window.showToast(window.I18N[window.getCurrentLang()].toastPasted, 'paste');
                    window.handleConvert();
                    return;
                }

                clearTimeout(autocompleteDebounceTimer);
                if (trimmed.length >= 2) {
                    autocompleteDebounceTimer = setTimeout(() => {
                        window.fetchPlaceSuggestions(trimmed);
                    }, 250);
                } else {
                    window.hidePlacesDropdown();
                }
            });
        }

        // ── Language Toggle Buttons ──
        if (btnEn) btnEn.addEventListener('click', () => window.switchLanguage('en'));
        if (btnAr) btnAr.addEventListener('click', () => window.switchLanguage('ar'));

        // ── Native Body Marker ──
        document.body.classList.add('is-native-app');

        // ── Initialize Version Text ──
        if (window.initAppVersionDisplay) window.initAppVersionDisplay();

        // ── Initialize Language & Places ──
        window.applyLanguage(window.getCurrentLang(), false);
        window.initGoogleMapsPlaces();

        // ── Auto Update Check when Idle ──
        if ('requestIdleCallback' in window) {
            requestIdleCallback(() => window.checkForAppUpdates(false), { timeout: 4500 });
        } else {
            setTimeout(() => window.checkForAppUpdates(false), 4000);
        }
    });
})();
