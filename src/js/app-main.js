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
        const tabLinkMode = $('tabLinkMode');
        const tabSearchMode = $('tabSearchMode');
        const businessSearchInput = $('businessSearchInput');
        const searchClearBtn = $('searchClearBtn');
        const searchFieldWrapper = $('searchFieldWrapper');
        const placesDropdown = $('placesDropdown');
        const resultCard = $('resultCard');
        const btnEn = $('btnEn');
        const btnAr = $('btnAr');
        const cardToolsRow = $('cardToolsRow');

        let autocompleteDebounceTimer = null;
        let highlightedSuggestionIndex = -1;

        function syncToolsVisibility() {
            if (cardToolsRow) {
                cardToolsRow.style.display = 'grid';
            }
        }
        window.syncToolsVisibility = syncToolsVisibility;

        // Direct URL Handler with Smart Auto-Detect
        function handleDirectUrlInput(raw) {
            const text = (raw || '').trim();
            if (!text) {
                if (window.AppModes) {
                    window.AppModes.clearModeResult('link');
                } else if (resultCard) {
                    resultCard.classList.remove('active');
                }
                syncToolsVisibility();
                return;
            }

            const updateResultLabel = url => {
                const resultLabelText = $('resultLabelText');
                if (resultLabelText) {
                    const dict = (window.I18N && window.getCurrentLang) ? window.I18N[window.getCurrentLang()] : {};
                    const isReview = /writereview\?placeid=/i.test(url);
                    resultLabelText.textContent = isReview
                        ? (dict.resultLabelReview || 'Direct Review Link:')
                        : (dict.resultLabelCustom || 'Direct Link:');
                }
            };

            const wasResultActive = Boolean(resultCard && resultCard.classList.contains('active'));

            // 1. Existing 5-star Google review link
            if (/writereview\?placeid=/i.test(text)) {
                const pid = window.parsePlaceIdFromText ? window.parsePlaceIdFromText(text) : null;
                const locUrl = pid ? `https://www.google.com/maps/search/?api=1&query=Google&query_place_id=${pid}` : null;
                if (window.AppModes) {
                    window.AppModes.setModeResult('link', text, pid, locUrl);
                } else {
                    const resultLinkText = $('resultLinkText');
                    if (resultLinkText) resultLinkText.textContent = text;
                    if (resultCard) resultCard.classList.add('active');
                }
                updateResultLabel(text);
                syncToolsVisibility();
                if (resultCard && !wasResultActive) {
                    resultCard.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
                }
                return;
            }

            // 2. Raw Google Maps share link -> convert to review/location link
            if (/maps\.app\.goo\.gl|goo\.gl\/maps|google\.[a-z.]+\/maps/i.test(text)) {
                if (window.handleConvert) {
                    window.handleConvert();
                    syncToolsVisibility();
                    return;
                }
            }

            // 3. Any other direct URL (website, menu, social media, etc.)
            if (window.AppModes) {
                window.AppModes.setModeResult('link', text, null, null);
            } else {
                const resultLinkText = $('resultLinkText');
                if (resultLinkText) resultLinkText.textContent = text;
                if (resultCard) resultCard.classList.add('active');
            }
            updateResultLabel(text);
            syncToolsVisibility();
            if (resultCard && !wasResultActive) {
                resultCard.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
            }
        }
        window.handleDirectUrlInput = handleDirectUrlInput;

        // Mode Switcher
        if (tabLinkMode) tabLinkMode.addEventListener('click', () => window.switchMode('link'));
        if (tabSearchMode) tabSearchMode.addEventListener('click', () => window.switchMode('search'));

        // Input & Convert Listeners
        if (convertBtn) {
            convertBtn.addEventListener('click', () => {
                if (urlInput) handleDirectUrlInput(urlInput.value);
            });
        }
        if (urlInput) {
            let directInputTimer = null;
            urlInput.addEventListener('keydown', e => {
                if (e.key === 'Enter') {
                    if (directInputTimer) clearTimeout(directInputTimer);
                    handleDirectUrlInput(urlInput.value);
                }
            });
            urlInput.addEventListener('input', () => {
                const val = urlInput.value.trim();
                if (directInputTimer) clearTimeout(directInputTimer);
                if (!val) {
                    handleDirectUrlInput('');
                } else if (/maps\.app\.goo\.gl|goo\.gl\/maps|google\.[a-z.]+\/maps/i.test(val)) {
                    directInputTimer = setTimeout(() => handleDirectUrlInput(val), 350);
                } else if (/^https?:\/\//i.test(val) || val.includes('.')) {
                    directInputTimer = setTimeout(() => handleDirectUrlInput(val), 250);
                }
            });
            urlInput.addEventListener('blur', () => {
                if (directInputTimer) clearTimeout(directInputTimer);
                if (urlInput.value.trim()) {
                    handleDirectUrlInput(urlInput.value);
                }
            });
        }

        // Clear / Trash
        if (clearBtn) {
            clearBtn.addEventListener('click', () => {
                const dict = window.I18N[window.getCurrentLang()];
                if (urlInput) {
                    urlInput.value = '';
                    if (!window.isTouchDevice || !window.isTouchDevice()) urlInput.focus();
                }
                if (window.AppModes) {
                    window.AppModes.clearModeResult('link');
                } else if (resultCard) {
                    resultCard.classList.remove('active');
                }
                syncToolsVisibility();
                if (window.showToast) window.showToast(dict.toastCleared, 'trash');
            });
        }

        // Paste Action (Native Android Clipboard Bridge)
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
                            handleDirectUrlInput(text.trim());
                        } else if (window.showToast) {
                            window.showToast(window.I18N[window.getCurrentLang()].toastEmptyClip, 'warn');
                        }
                    }).catch(() => {
                        if (window.showToast) window.showToast(window.I18N[window.getCurrentLang()].toastClipDenied, 'paste');
                    });
                }
            });
        }

        // Result Card Action Buttons (Copy, Open, Share, QR)
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

        if (qrBtn) {
            qrBtn.addEventListener('click', () => window.openQrModal(qrBtn));
        }

        // Link Type Segmented Selector (Review vs Location)
        const btnTypeReview = $('btnTypeReview');
        const btnTypeLocation = $('btnTypeLocation');
        if (btnTypeReview) {
            btnTypeReview.addEventListener('click', () => {
                if (window.AppModes && window.AppModes.setLinkType) {
                    window.AppModes.setLinkType('review');
                }
            });
        }
        if (btnTypeLocation) {
            btnTypeLocation.addEventListener('click', () => {
                if (window.AppModes && window.AppModes.setLinkType) {
                    window.AppModes.setLinkType('location');
                }
            });
        }

        // User Guide & Feature Tour
        const btnOpenHelpGuide = $('btnOpenHelpGuide');
        if (btnOpenHelpGuide) {
            btnOpenHelpGuide.addEventListener('click', () => {
                if (window.openOnboardingModal) {
                    window.openOnboardingModal();
                }
            });
        }

        // Hardware Back Button Coordinator (Strict Descending Z-Index Order)
        window.handleAndroidBackPress = function() {
            // 1. Onboarding Tour (z-index: 3000)
            const onboardingOverlay = $('onboardingOverlay');
            if (onboardingOverlay && onboardingOverlay.classList.contains('active')) {
                if (window.closeOnboardingModal) window.closeOnboardingModal(true);
                return true;
            }
            // 2. QR Code Modal (z-index: 1100 — stacks cleanly above NFC/Wi-Fi modal)
            const qrOverlay = $('qrOverlay');
            if (qrOverlay && qrOverlay.classList.contains('active')) {
                if (window.closeQrModal) window.closeQrModal();
                return true;
            }
            // 3. App Update Modal (z-index: 1050)
            const updateOverlay = $('updateOverlay');
            if (updateOverlay && updateOverlay.classList.contains('active')) {
                if (window.closeUpdateModal) window.closeUpdateModal();
                return true;
            }
            // 4. NFC / PIN / PermLock / Wi-Fi Modal (z-index: 1000)
            const nfcOverlay = $('nfcOverlay');
            if (nfcOverlay && nfcOverlay.classList.contains('active')) {
                if (window.handleNfcCancelOrBack) {
                    window.handleNfcCancelOrBack();
                } else if (window.closeNfcModal) {
                    window.closeNfcModal();
                }
                return true;
            }
            // 5. Places Search Dropdown (z-index: 60)
            if (placesDropdown && placesDropdown.classList.contains('show')) {
                if (window.hidePlacesDropdown) window.hidePlacesDropdown();
                return true;
            }
            return false;
        };

        // Search Business Input Events
        if (searchClearBtn) {
            searchClearBtn.addEventListener('click', () => {
                if (businessSearchInput) {
                    businessSearchInput.value = '';
                    searchClearBtn.classList.remove('visible');
                    window.hidePlacesDropdown();
                    if (!window.isTouchDevice || !window.isTouchDevice()) businessSearchInput.focus();
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

        // Floating GitHub Button
        const fabGithub = $('fabGithub');
        if (fabGithub) {
            fabGithub.addEventListener('click', e => {
                e.preventDefault();
                window.open('https://github.com/zaid-a-salameh/quick-nfc', '_blank');
            });
        }

        // Language Toggle Buttons
        if (btnEn) btnEn.addEventListener('click', () => window.switchLanguage('en'));
        if (btnAr) btnAr.addEventListener('click', () => window.switchLanguage('ar'));

        // Native Body Marker
        document.body.classList.add('is-native-app');

        // Initialize Language & Places
        window.applyLanguage(window.getCurrentLang(), false);
        window.initGoogleMapsPlaces();
        syncToolsVisibility();
        if (window.updateModeTabSlider) setTimeout(window.updateModeTabSlider, 60);
        if (document.fonts && document.fonts.ready) {
            document.fonts.ready.then(() => {
                if (window.updateModeTabSlider) window.updateModeTabSlider();
            }).catch(() => {});
        }
        window.addEventListener('resize', () => {
            if (window.updateModeTabSlider) window.updateModeTabSlider();
        });
    });
})();
