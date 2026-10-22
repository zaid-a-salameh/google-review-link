// ========================================================
// Web Application Main Bootstrapper & Event Orchestrator
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
        const qrOverlay = $('qrOverlay');
        const qrCloseBtn = $('qrCloseBtn');
        const qrDownloadBtn = $('qrDownloadBtn');
        const tabLinkMode = $('tabLinkMode');
        const tabSearchMode = $('tabSearchMode');
        const businessSearchInput = $('businessSearchInput');
        const searchClearBtn = $('searchClearBtn');
        const searchFieldWrapper = $('searchFieldWrapper');
        const placesDropdown = $('placesDropdown');
        const resultCard = $('resultCard');
        const btnEn = $('btnEn');
        const btnAr = $('btnAr');
        const navBtnEn = $('navBtnEn');
        const navBtnAr = $('navBtnAr');

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
                if (window.AppModes) {
                    window.AppModes.clearModeResult('link');
                } else if (resultCard) {
                    resultCard.classList.remove('active');
                }
                if (window.showToast) window.showToast(dict.toastCleared, 'trash');
            });
        }

        // ── Paste Action (Web Clipboard API) ──
        if (pasteBtn) {
            pasteBtn.addEventListener('click', async () => {
                const dict = window.I18N[window.getCurrentLang()];
                if (navigator.clipboard && navigator.clipboard.readText) {
                    try {
                        const text = await navigator.clipboard.readText();
                        if (text && text.trim()) {
                            window.switchMode('link');
                            if (urlInput) {
                                urlInput.value = text.trim();
                                urlInput.focus();
                            }
                            if (window.showToast) window.showToast(dict.toastPasted, 'paste');
                            window.handleConvert();
                            return;
                        } else {
                            if (window.showToast) window.showToast(dict.toastEmptyClip, 'warn');
                            if (urlInput) urlInput.focus();
                            return;
                        }
                    } catch (err) {
                        console.warn('Clipboard readText failed or was blocked by browser:', err);
                    }
                }
                if (urlInput) {
                    urlInput.focus();
                    urlInput.select();
                }
                if (window.showToast) window.showToast(dict.toastClipDenied, 'paste');
            });
        }

        // ── Action Buttons (Copy, Open, Share, QR) ──
        if (copyBtn) {
            copyBtn.addEventListener('click', async () => {
                const reviewUrl = window.getGeneratedReviewUrl();
                if (!reviewUrl) return;
                const dict = window.I18N[window.getCurrentLang()];
                try {
                    await navigator.clipboard.writeText(reviewUrl);
                    copyBtn.classList.add('copied');
                    if (copyBtnLabel) copyBtnLabel.textContent = dict.copySuccess;
                    if (window.showToast) window.showToast(dict.toastCopied, 'copy');
                    setTimeout(() => {
                        copyBtn.classList.remove('copied');
                        if (copyBtnLabel) copyBtnLabel.textContent = dict.copyBtn;
                    }, 2000);
                } catch (e) {
                    if (window.showToast) window.showToast(dict.toastCopied, 'copy');
                }
            });
        }

        if (openBtn) {
            openBtn.addEventListener('click', () => {
                const reviewUrl = window.getGeneratedReviewUrl();
                if (reviewUrl) window.open(reviewUrl, '_blank');
            });
        }

        if (shareBtn) {
            shareBtn.addEventListener('click', async () => {
                const reviewUrl = window.getGeneratedReviewUrl();
                if (!reviewUrl) return;
                const dict = window.I18N[window.getCurrentLang()];
                if (navigator.share) {
                    try {
                        await navigator.share({
                            title: dict.shareTitle,
                            text: dict.shareText,
                            url: reviewUrl
                        });
                    } catch (err) {}
                } else {
                    await navigator.clipboard.writeText(reviewUrl);
                    if (window.showToast) window.showToast(dict.toastShareCopied, 'copy');
                }
            });
        }

        if (qrBtn) qrBtn.addEventListener('click', window.openQrModal);
        if (qrCloseBtn) qrCloseBtn.addEventListener('click', window.closeQrModal);
        if (qrDownloadBtn) qrDownloadBtn.addEventListener('click', window.downloadQrImage);
        if (qrOverlay) {
            qrOverlay.addEventListener('click', e => {
                if (e.target === qrOverlay) window.closeQrModal();
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
                if (window.AppModes) {
                    window.AppModes.clearModeResult('search');
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
        if (navBtnEn) navBtnEn.addEventListener('click', () => window.switchLanguage('en'));
        if (navBtnAr) navBtnAr.addEventListener('click', () => window.switchLanguage('ar'));

        // ── Initialize ──
        window.applyLanguage(window.getCurrentLang(), false);
        window.initGoogleMapsPlaces();
    });
})();
