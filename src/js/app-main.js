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

        const cardToolsRow = $('cardToolsRow');
        const btnReadTag = $('btnReadTag');
        const btnPwdLockTag = $('btnPwdLockTag');
        const btnPermLockTag = $('btnPermLockTag');
        const pwdModalOverlay = $('pwdModalOverlay');
        const pwdTabLock = $('pwdTabLock');
        const pwdTabUnlock = $('pwdTabUnlock');
        const nfcPinInput = $('nfcPinInput');
        const btnPwdSubmit = $('btnPwdSubmit');
        const btnPwdCancel = $('btnPwdCancel');
        const permLockOverlay = $('permLockOverlay');
        const btnPermLockConfirm = $('btnPermLockConfirm');
        const btnPermLockCancel = $('btnPermLockCancel');

        let autocompleteDebounceTimer = null;
        let highlightedSuggestionIndex = -1;

        function syncToolsVisibility() {
            if (cardToolsRow) {
                cardToolsRow.style.display = 'grid';
            }
        }
        window.syncToolsVisibility = syncToolsVisibility;

        // ── Direct URL Handler with Smart Auto-Detect ──
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

            // Helper to dynamically set result label
            const updateResultLabel = (url) => {
                const resultLabelText = $('resultLabelText');
                if (resultLabelText) {
                    const dict = (window.I18N && window.getCurrentLang) ? window.I18N[window.getCurrentLang()] : {};
                    const isReview = /writereview\?placeid=/i.test(url);
                    resultLabelText.textContent = isReview 
                        ? (dict.resultLabelReview || 'Direct Review Link:') 
                        : (dict.resultLabelCustom || 'Direct Link:');
                }
            };

            // 1. If it's already a 5-star Google review link (writereview?placeid=...)
            // Preserve it exactly as-is without re-converting or breaking it
            if (/writereview\?placeid=/i.test(text)) {
                if (window.AppModes) {
                    window.AppModes.setModeResult('link', text);
                } else {
                    const resultLinkText = $('resultLinkText');
                    if (resultLinkText) resultLinkText.textContent = text;
                    if (resultCard) resultCard.classList.add('active');
                }
                updateResultLabel(text);
                syncToolsVisibility();
                if (resultCard) {
                    resultCard.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
                }
                return;
            }

            // 2. If it's a raw Google Maps share link, auto-convert it to a 5-star review link
            if (/maps\.app\.goo\.gl|goo\.gl\/maps|google\.[a-z.]+\/maps/i.test(text)) {
                if (window.handleConvert) {
                    window.handleConvert();
                    syncToolsVisibility();
                    return;
                }
            }

            // 3. Any other direct URL (website, menu, instagram, whatsapp, etc.)
            if (window.AppModes) {
                window.AppModes.setModeResult('link', text);
            } else {
                const resultLinkText = $('resultLinkText');
                if (resultLinkText) resultLinkText.textContent = text;
                if (resultCard) resultCard.classList.add('active');
            }
            updateResultLabel(text);
            syncToolsVisibility();
            if (resultCard) {
                resultCard.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
            }
        }
        window.handleDirectUrlInput = handleDirectUrlInput;

        // ── Standalone NFC Card Tool Handlers ──
        if (btnReadTag) {
            btnReadTag.addEventListener('click', () => {
                if (window.startNfcRead) window.startNfcRead();
            });
        }

        const btnPwdToggleShow = $('btnPwdToggleShow');
        const eyeIconOpen = $('eyeIconOpen');
        const eyeIconClosed = $('eyeIconClosed');
        if (btnPwdToggleShow && nfcPinInput) {
            btnPwdToggleShow.addEventListener('click', () => {
                const isPassword = nfcPinInput.type === 'password';
                nfcPinInput.type = isPassword ? 'text' : 'password';
                if (eyeIconOpen) eyeIconOpen.style.display = isPassword ? 'none' : 'block';
                if (eyeIconClosed) eyeIconClosed.style.display = isPassword ? 'block' : 'none';
            });
        }

        let pwdCurrentAction = 'lock';
        const pwdModalBox = $('pwdModalBox');
        const pwdIconCircle = $('pwdIconCircle');
        const pwdStatusIcon = $('pwdStatusIcon');
        const pwdModalTitle = $('pwdModalTitle');
        const pwdModalDesc = $('pwdModalDesc');
        const btnPwdInfo = $('btnPwdInfo');

        function updatePwdTabSlider() {
            const slider = $('pwdTabSlider');
            const activeTab = document.querySelector('.pwd-tab.active');
            if (!slider || !activeTab) return;

            slider.style.left = '0px';
            slider.style.right = 'auto';
            slider.style.width = `${activeTab.offsetWidth}px`;
            slider.style.transform = `translate3d(${activeTab.offsetLeft}px, 0, 0)`;
        }
        window.updatePwdTabSlider = updatePwdTabSlider;

        function syncPwdModalText(isSwitch = false) {
            const dict = (window.I18N && window.getCurrentLang) ? window.I18N[window.getCurrentLang()] : {};
            const isLock = pwdCurrentAction === 'lock';
            const pwdSubmitLockLabelEl = $('pwdSubmitLockLabel');
            if (btnPwdSubmit) {
                if (isLock) {
                    btnPwdSubmit.classList.remove('unlock-mode');
                } else {
                    btnPwdSubmit.classList.add('unlock-mode');
                }
                if (!pwdSubmitLockLabelEl) {
                    btnPwdSubmit.textContent = isLock 
                        ? (dict.pwdSubmitLock || 'Lock Card & Touch Phone') 
                        : (dict.pwdSubmitUnlock || 'Unlock & Touch Phone');
                }
            }
            if (pwdModalBox) {
                if (isLock) {
                    pwdModalBox.classList.remove('unlock-mode');
                } else {
                    pwdModalBox.classList.add('unlock-mode');
                }
            }
            if (pwdModalTitle) {
                pwdModalTitle.textContent = isLock 
                    ? (dict.pwdModalTitleLock || dict.pwdModalTitle || 'Lock Card')
                    : (dict.pwdModalTitleUnlock || 'Unlock Card');
            }
            if (pwdModalDesc) {
                pwdModalDesc.textContent = isLock 
                    ? (dict.pwdModalDescLock || dict.pwdModalDesc || 'Set a password or PIN to prevent unauthorized modifications')
                    : (dict.pwdModalDescUnlock || 'Enter the current PIN to remove protection');
            }
            if (nfcPinInput && dict.pwdPlaceholder) {
                nfcPinInput.placeholder = dict.pwdPlaceholder;
            }
            if (pwdIconCircle) {
                if (isLock) {
                    pwdIconCircle.classList.remove('unlock-mode');
                } else {
                    pwdIconCircle.classList.add('unlock-mode');
                }
            }
            if (pwdStatusIcon) {
                const targetSvg = isLock
                    ? '<path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z"/>'
                    : '<path d="M12 17c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zm6-9h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6h1.9c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm0 12H6V10h12v10z"/>';
                if (pwdStatusIcon.innerHTML !== targetSvg) {
                    pwdStatusIcon.innerHTML = targetSvg;
                }
            }

            const slider = $('pwdTabSlider');
            if (slider) {
                if (isLock) {
                    slider.classList.remove('unlock-mode');
                } else {
                    slider.classList.add('unlock-mode');
                }
            }
            updatePwdTabSlider();
            requestAnimationFrame(() => updatePwdTabSlider());
        }
        window.syncPwdModalText = syncPwdModalText;

        if (btnPwdInfo) {
            btnPwdInfo.addEventListener('click', (e) => {
                e.preventDefault();
                e.stopPropagation();
                const dict = (window.I18N && window.getCurrentLang) ? window.I18N[window.getCurrentLang()] : {};
                if (window.showToast) {
                    window.showToast(dict.pwdInfoToast || '4 characters recommended for optimal NFC compatibility', 'info', 4500);
                }
            });
        }

        if (btnPwdLockTag) {
            btnPwdLockTag.addEventListener('click', () => {
                if (document.activeElement && typeof document.activeElement.blur === 'function') {
                    try { document.activeElement.blur(); } catch (e) {}
                }
                if (pwdModalOverlay) {
                    pwdModalOverlay.classList.add('active');
                    syncPwdModalText(false);
                    setTimeout(updatePwdTabSlider, 25);
                    setTimeout(updatePwdTabSlider, 80);
                    if (nfcPinInput) {
                        nfcPinInput.value = '';
                        nfcPinInput.type = 'password';
                        if (eyeIconOpen) eyeIconOpen.style.display = 'block';
                        if (eyeIconClosed) eyeIconClosed.style.display = 'none';
                    }
                }
            });
        }

        if (btnPwdCancel && pwdModalOverlay) {
            btnPwdCancel.addEventListener('click', () => {
                if (nfcPinInput) nfcPinInput.blur();
                pwdModalOverlay.classList.remove('active');
            });
        }

        if (pwdTabLock && pwdTabUnlock) {
            pwdTabLock.addEventListener('click', () => {
                if (pwdCurrentAction === 'lock') return;
                pwdCurrentAction = 'lock';
                pwdTabLock.classList.add('active');
                pwdTabUnlock.classList.remove('active');
                syncPwdModalText(true);
            });
            pwdTabUnlock.addEventListener('click', () => {
                if (pwdCurrentAction === 'unlock') return;
                pwdCurrentAction = 'unlock';
                pwdTabUnlock.classList.add('active');
                pwdTabLock.classList.remove('active');
                syncPwdModalText(true);
            });
        }

        if (nfcPinInput) {
            nfcPinInput.addEventListener('keydown', e => {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    if (btnPwdSubmit) btnPwdSubmit.click();
                }
            });
        }

        if (btnPwdSubmit) {
            btnPwdSubmit.addEventListener('click', () => {
                const pin = nfcPinInput ? nfcPinInput.value.trim() : '';
                const dict = (window.I18N && window.getCurrentLang) ? window.I18N[window.getCurrentLang()] : {};
                if (!pin) {
                    if (window.showToast) window.showToast(dict.toastEnterPwd || 'Please enter a password or PIN', 'warn');
                    return;
                }
                if (nfcPinInput) nfcPinInput.blur();
                if (pwdModalOverlay) pwdModalOverlay.classList.remove('active');
                if (pwdCurrentAction === 'lock') {
                    if (window.startNfcPasswordLock) window.startNfcPasswordLock(pin);
                } else {
                    if (window.startNfcPasswordUnlock) window.startNfcPasswordUnlock(pin);
                }
            });
        }

        if (btnPermLockTag) {
            btnPermLockTag.addEventListener('click', () => {
                if (document.activeElement && typeof document.activeElement.blur === 'function') {
                    try { document.activeElement.blur(); } catch (e) {}
                }
                if (permLockOverlay) permLockOverlay.classList.add('active');
            });
        }

        if (btnPermLockCancel && permLockOverlay) {
            btnPermLockCancel.addEventListener('click', () => {
                permLockOverlay.classList.remove('active');
            });
        }

        if (btnPermLockConfirm) {
            btnPermLockConfirm.addEventListener('click', () => {
                if (permLockOverlay) permLockOverlay.classList.remove('active');
                if (window.startNfcPermanentLock) window.startNfcPermanentLock();
            });
        }

        // ── Mode Switcher ──
        if (tabLinkMode) tabLinkMode.addEventListener('click', () => window.switchMode('link'));
        if (tabSearchMode) tabSearchMode.addEventListener('click', () => window.switchMode('search'));

        // ── Input & Convert Listeners ──
        if (convertBtn) convertBtn.addEventListener('click', () => {
            if (urlInput) handleDirectUrlInput(urlInput.value);
        });
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
                    directInputTimer = setTimeout(() => {
                        handleDirectUrlInput(val);
                    }, 350);
                } else if (/^https?:\/\//i.test(val) || val.includes('.')) {
                    directInputTimer = setTimeout(() => {
                        handleDirectUrlInput(val);
                    }, 250);
                }
            });
            urlInput.addEventListener('blur', () => {
                if (directInputTimer) clearTimeout(directInputTimer);
                if (urlInput.value.trim()) {
                    handleDirectUrlInput(urlInput.value);
                }
            });
        }

        // ── Clear / Trash ──
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

        // ── Floating GitHub Button ──
        const fabGithub = $('fabGithub');
        if (fabGithub) {
            fabGithub.addEventListener('click', e => {
                e.preventDefault();
                window.open('https://github.com/zaid-a-salameh/google-review-link', '_blank');
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
        syncToolsVisibility();
        if (window.updateModeTabSlider) setTimeout(window.updateModeTabSlider, 60);
        window.addEventListener('resize', () => { 
            if (window.updateModeTabSlider) window.updateModeTabSlider(); 
            if (window.updatePwdTabSlider) window.updatePwdTabSlider();
        });

        // ── Auto Update Check when Idle ──
        if ('requestIdleCallback' in window) {
            requestIdleCallback(() => window.checkForAppUpdates(false), { timeout: 4500 });
        } else {
            setTimeout(() => window.checkForAppUpdates(false), 4000);
        }
    });
})();
