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
        const btnWifiTag = $('btnWifiTag');
        const btnPwdLockTag = $('btnPwdLockTag');
        const btnPermLockTag = $('btnPermLockTag');
        const nfcWifiView = $('nfcWifiView');
        const wifiStepsIndicator = $('wifiStepsIndicator');
        const wifiStepTitle = $('wifiStepTitle');
        const wifiStepDesc = $('wifiStepDesc');
        const wifiStep1Pane = $('wifiStep1Pane');
        const wifiStep2Pane = $('wifiStep2Pane');
        const wifiStep3Pane = $('wifiStep3Pane');
        const wifiSsidInput = $('wifiSsidInput');
        const btnWifiSsidClear = $('btnWifiSsidClear');
        const wifiDropdownWrapper = $('wifiDropdownWrapper');
        const wifiSelectTrigger = $('wifiSelectTrigger');
        const wifiSelectedLabel = $('wifiSelectedLabel');
        const wifiSelectedSub = $('wifiSelectedSub');
        const wifiDropdownMenu = $('wifiDropdownMenu');
        const wifiPasswordInput = $('wifiPasswordInput');
        const btnWifiToggleShow = $('btnWifiToggleShow');
        const wifiEyeOpen = $('wifiEyeOpen');
        const wifiEyeClosed = $('wifiEyeClosed');
        const btnWifiNext = $('btnWifiNext');
        const wifiNextBtnLabel = $('wifiNextBtnLabel');
        const wifiNextBtnArrow = $('wifiNextBtnArrow');
        const btnWifiBack = $('btnWifiBack');
        const wifiBackBtnLabel = $('wifiBackBtnLabel');
        const pwdModalOverlay = $('pwdModalOverlay');
        const pwdTabLock = $('pwdTabLock');
        const pwdTabUnlock = $('pwdTabUnlock');
        const nfcPinInput = $('nfcPinInput');
        const btnPwdSubmit = $('btnPwdSubmit');
        const btnPwdCancel = $('btnPwdCancel');
        const permLockOverlay = $('permLockOverlay');
        const permLockBox = $('permLockBox');
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

            const wasResultActive = Boolean(resultCard && resultCard.classList.contains('active'));

            // 1. If it's already a 5-star Google review link (writereview?placeid=...)
            // Preserve it exactly as-is without re-converting or breaking it
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

        // ── Standalone NFC Card Tool Handlers ──
        if (btnReadTag) {
            btnReadTag.addEventListener('click', () => {
                if (window.startNfcRead) window.startNfcRead(btnReadTag);
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
            const nfcModalBox = $('nfcModalBox');

            if (btnPwdSubmit) {
                if (isLock) {
                    btnPwdSubmit.classList.remove('unlock-mode');
                } else {
                    btnPwdSubmit.classList.add('unlock-mode');
                }
                if (!pwdSubmitLockLabelEl) {
                    btnPwdSubmit.textContent = isLock 
                        ? (dict.pwdSubmitLock || 'Lock Card') 
                        : (dict.pwdSubmitUnlock || 'Unlock Card');
                }
            }
            if (nfcModalBox) {
                if (isLock) {
                    nfcModalBox.classList.remove('unlock-mode', 'theme-unlock');
                    nfcModalBox.classList.add('theme-lock');
                } else {
                    nfcModalBox.classList.remove('theme-lock');
                    nfcModalBox.classList.add('unlock-mode', 'theme-unlock');
                }
            }
            if (pwdModalBox && pwdModalBox !== nfcModalBox) {
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
                    ? (dict.pwdModalDescLock || dict.pwdModalDesc || 'Set a PIN to protect card from modifications')
                    : (dict.pwdModalDescUnlock || 'Enter PIN to remove card protection');
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
                const nfcOverlay = $('nfcOverlay');
                const nfcModalBox = $('nfcModalBox');
                if (nfcOverlay && nfcModalBox) {
                    if (nfcPinInput) {
                        nfcPinInput.value = '';
                        nfcPinInput.type = 'password';
                        if (eyeIconOpen) eyeIconOpen.style.display = 'block';
                        if (eyeIconClosed) eyeIconClosed.style.display = 'none';
                    }
                    if (window.showNfcView) {
                        window.showNfcView('pwd', false);
                    }
                    syncPwdModalText(false);
                    if (window.openMorphModal) {
                        window.openMorphModal(nfcOverlay, nfcModalBox, btnPwdLockTag);
                    } else {
                        nfcOverlay.classList.add('active');
                    }
                    setTimeout(updatePwdTabSlider, 25);
                    setTimeout(updatePwdTabSlider, 80);
                }
            });
        }

        if (btnPwdCancel) {
            btnPwdCancel.addEventListener('click', () => {
                if (nfcPinInput) nfcPinInput.blur();
                if (window.closeNfcModal) {
                    window.closeNfcModal();
                } else {
                    const nfcOverlay = $('nfcOverlay');
                    const nfcModalBox = $('nfcModalBox');
                    if (window.closeMorphModal && nfcOverlay && nfcModalBox) {
                        window.closeMorphModal(nfcOverlay, nfcModalBox);
                    } else if (nfcOverlay) {
                        nfcOverlay.classList.remove('active');
                    }
                }
            });
        }

        if (pwdModalOverlay && pwdModalOverlay !== $('nfcOverlay')) {
            pwdModalOverlay.addEventListener('click', e => {
                if (e.target === pwdModalOverlay) {
                    if (nfcPinInput) nfcPinInput.blur();
                    if (window.closeNfcModal) {
                        window.closeNfcModal();
                    } else {
                        pwdModalOverlay.classList.remove('active');
                    }
                }
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

        function returnToPasswordModal() {
            syncPwdModalText(false);
            if (nfcPinInput) {
                nfcPinInput.blur();
            }
            if (window.showNfcView) {
                window.showNfcView('pwd', true);
                updatePwdTabSlider();
                setTimeout(() => {
                    updatePwdTabSlider();
                    if (nfcPinInput) nfcPinInput.blur();
                }, 60);
            }
        }
        window.returnToPasswordModal = returnToPasswordModal;

        if (btnPwdSubmit) {
            btnPwdSubmit.addEventListener('click', () => {
                const pin = nfcPinInput ? nfcPinInput.value.trim() : '';
                const dict = (window.I18N && window.getCurrentLang) ? window.I18N[window.getCurrentLang()] : {};
                if (!pin) {
                    if (window.showToast) window.showToast(dict.toastEnterPwd || 'Please enter a password or PIN', 'warn');
                    return;
                }
                if (nfcPinInput) nfcPinInput.blur();
                const action = pwdCurrentAction;

                if (action === 'lock') {
                    if (window.startNfcPasswordLock) window.startNfcPasswordLock(pin, btnPwdLockTag, { skipOpenAnimation: true });
                } else {
                    if (window.startNfcPasswordUnlock) window.startNfcPasswordUnlock(pin, btnPwdLockTag, { skipOpenAnimation: true });
                }
            });
        }

        if (btnPermLockTag) {
            btnPermLockTag.addEventListener('click', () => {
                if (document.activeElement && typeof document.activeElement.blur === 'function') {
                    try { document.activeElement.blur(); } catch (e) {}
                }
                const nfcOverlay = $('nfcOverlay');
                const nfcModalBox = $('nfcModalBox');
                if (nfcOverlay && nfcModalBox) {
                    if (window.showNfcView) {
                        window.showNfcView('perm_confirm', false);
                    }
                    nfcModalBox.classList.remove('theme-unlock', 'unlock-mode', 'success', 'error', 'perm-lock-standby');
                    nfcModalBox.classList.add('theme-lock', 'theme-perm-lock');
                    if (window.openMorphModal) {
                        window.openMorphModal(nfcOverlay, nfcModalBox, btnPermLockTag);
                    } else {
                        nfcOverlay.classList.add('active');
                    }
                }
            });
        }

        if (btnPermLockCancel) {
            btnPermLockCancel.addEventListener('click', () => {
                if (window.closeNfcModal) {
                    window.closeNfcModal();
                } else {
                    const nfcOverlay = $('nfcOverlay');
                    const nfcModalBox = $('nfcModalBox');
                    if (window.closeMorphModal && nfcOverlay && nfcModalBox) {
                        window.closeMorphModal(nfcOverlay, nfcModalBox);
                    } else if (nfcOverlay) {
                        nfcOverlay.classList.remove('active');
                    }
                }
            });
        }

        if (permLockOverlay && permLockOverlay !== $('nfcOverlay')) {
            permLockOverlay.addEventListener('click', e => {
                if (e.target === permLockOverlay) {
                    if (window.closeNfcModal) {
                        window.closeNfcModal();
                    } else {
                        permLockOverlay.classList.remove('active');
                    }
                }
            });
        }

        if (btnPermLockConfirm) {
            btnPermLockConfirm.addEventListener('click', () => {
                if (window.startNfcPermanentLock) {
                    window.startNfcPermanentLock(btnPermLockTag, { skipOpenAnimation: true, resetCount: true });
                }
            });
        }

        // ── Wi-Fi Card Wizard Engine ──
        let wifiCurrentStep = 1;
        let wifiSelectedEnc = 'WPA';
        let wifiSavedSsid = '';
        let wifiSavedPassword = '';

        function updateWifiWizardUi() {
            const dict = (window.I18N && window.getCurrentLang) ? window.I18N[window.getCurrentLang()] : {};
            
            const stepItems = wifiStepsIndicator ? wifiStepsIndicator.querySelectorAll('.wifi-step-item') : [];
            const stepLines = wifiStepsIndicator ? wifiStepsIndicator.querySelectorAll('.wifi-step-line') : [];
            stepItems.forEach((item, idx) => {
                const stepNum = idx + 1;
                item.classList.remove('active', 'completed');
                if (stepNum === wifiCurrentStep) {
                    item.classList.add('active');
                } else if (stepNum < wifiCurrentStep) {
                    item.classList.add('completed');
                }
            });
            stepLines.forEach((line, idx) => {
                line.classList.toggle('active', (idx + 1) < wifiCurrentStep);
            });

            const panes = [wifiStep1Pane, wifiStep2Pane, wifiStep3Pane];
            panes.forEach((pane, idx) => {
                if (!pane) return;
                const stepNum = idx + 1;
                pane.classList.remove('active', 'pane-prev', 'pane-next');
                if (stepNum === wifiCurrentStep) {
                    pane.classList.add('active');
                } else if (stepNum < wifiCurrentStep) {
                    pane.classList.add('pane-prev');
                } else {
                    pane.classList.add('pane-next');
                }
            });

            if (wifiCurrentStep !== 3 && wifiDropdownWrapper) {
                wifiDropdownWrapper.classList.remove('open');
            }

            let newTitle = '';
            let newDesc = '';
            if (wifiCurrentStep === 1) {
                newTitle = dict.wifiStep1Title || 'Wi-Fi Card Setup';
                newDesc = dict.wifiStep1Desc || 'Enter the Wi-Fi network name (SSID)';
                if (wifiNextBtnLabel) wifiNextBtnLabel.textContent = dict.wifiNext || 'Next';
                if (wifiBackBtnLabel) wifiBackBtnLabel.textContent = dict.pwdCancel || 'Cancel';
                if (wifiNextBtnArrow) wifiNextBtnArrow.style.display = 'block';
            } else if (wifiCurrentStep === 2) {
                newTitle = dict.wifiStep2Title || 'Network Password';
                newDesc = dict.wifiStep2Desc || 'Enter Wi-Fi password (or leave blank for open network)';
                if (wifiNextBtnLabel) wifiNextBtnLabel.textContent = dict.wifiNext || 'Next';
                if (wifiBackBtnLabel) wifiBackBtnLabel.textContent = dict.wifiBack || 'Back';
                if (wifiNextBtnArrow) wifiNextBtnArrow.style.display = 'block';
            } else if (wifiCurrentStep === 3) {
                newTitle = dict.wifiStep3Title || 'Security Type';
                newDesc = dict.wifiStep3Desc || 'Select network encryption standard';
                if (wifiNextBtnLabel) wifiNextBtnLabel.textContent = dict.wifiWriteTag || 'Write to NFC Tag';
                if (wifiBackBtnLabel) wifiBackBtnLabel.textContent = dict.wifiBack || 'Back';
                if (wifiNextBtnArrow) wifiNextBtnArrow.style.display = 'none';
            }

            if (wifiStepTitle) {
                const titleChanged = wifiStepTitle.textContent !== newTitle;
                wifiStepTitle.textContent = newTitle;
                if (titleChanged) {
                    wifiStepTitle.classList.remove('step-title-animate');
                    void wifiStepTitle.offsetWidth;
                    wifiStepTitle.classList.add('step-title-animate');
                }
            }
            if (wifiStepDesc) {
                const descChanged = wifiStepDesc.textContent !== newDesc;
                wifiStepDesc.textContent = newDesc;
                if (descChanged) {
                    wifiStepDesc.classList.remove('step-desc-animate');
                    void wifiStepDesc.offsetWidth;
                    wifiStepDesc.classList.add('step-desc-animate');
                }
            }
        }
        window.updateWifiWizardUi = updateWifiWizardUi;

        function openWifiModal(triggerBtn) {
            if (document.activeElement && typeof document.activeElement.blur === 'function') {
                try { document.activeElement.blur(); } catch (e) {}
            }
            wifiCurrentStep = 1;
            wifiSelectedEnc = 'WPA';
            wifiSavedSsid = '';
            wifiSavedPassword = '';
            if (wifiSsidInput) wifiSsidInput.value = '';
            if (wifiPasswordInput) wifiPasswordInput.value = '';

            const items = wifiDropdownMenu ? wifiDropdownMenu.querySelectorAll('.wifi-dropdown-item') : [];
            items.forEach(it => it.classList.toggle('selected', it.getAttribute('data-enc') === 'WPA'));
            const dict = (window.I18N && window.getCurrentLang) ? window.I18N[window.getCurrentLang()] : {};
            if (wifiSelectedLabel) wifiSelectedLabel.textContent = dict.wifiEncWpa || 'WPA / WPA2 / WPA3 Personal';
            if (wifiSelectedSub) wifiSelectedSub.textContent = dict.wifiEncWpaSub || 'Most common (Home & Office)';

            updateWifiWizardUi();

            const nfcOverlay = $('nfcOverlay');
            const nfcModalBox = $('nfcModalBox');
            if (nfcOverlay && nfcModalBox) {
                if (window.showNfcView) {
                    window.showNfcView('wifi', false);
                }
                nfcModalBox.classList.remove('theme-lock', 'theme-unlock', 'theme-perm-lock', 'success', 'error', 'perm-lock-standby');
                nfcModalBox.classList.add('theme-wifi');
                if (window.openMorphModal) {
                    window.openMorphModal(nfcOverlay, nfcModalBox, triggerBtn);
                } else {
                    nfcOverlay.classList.add('active');
                }
            }
        }

        function handleWifiWizardBack() {
            if (document.activeElement && typeof document.activeElement.blur === 'function') {
                try { document.activeElement.blur(); } catch (e) {}
            }
            if (wifiCurrentStep === 1) {
                if (window.closeNfcModal) window.closeNfcModal();
            } else if (wifiCurrentStep === 2) {
                wifiCurrentStep = 1;
                updateWifiWizardUi();
            } else if (wifiCurrentStep === 3) {
                wifiCurrentStep = 2;
                updateWifiWizardUi();
            }
        }
        window.handleWifiWizardBack = handleWifiWizardBack;

        window.returnToWifiWizard = function() {
            wifiCurrentStep = 3;
            updateWifiWizardUi();
            const nfcModalBox = $('nfcModalBox');
            if (nfcModalBox) {
                nfcModalBox.classList.remove('theme-lock', 'theme-unlock', 'theme-perm-lock', 'success', 'error');
                nfcModalBox.classList.add('theme-wifi');
            }
            if (window.showNfcView) {
                window.showNfcView('wifi', true);
            }
        };

        window.retryNfcWifiWrite = function() {
            if (window.startNfcWifiWrite) {
                window.startNfcWifiWrite(wifiSavedSsid, wifiSavedPassword, wifiSelectedEnc, btnWifiTag, { skipOpenAnimation: true, preserveCloneMode: true });
            }
        };

        window.loadWifiConfigAndPrepareWrite = function(ssid, password, encType) {
            wifiSavedSsid = (ssid || '').trim();
            wifiSavedPassword = (password || '').trim();
            let enc = (encType || 'WPA').toUpperCase();
            if (enc !== 'WEP' && enc !== 'OPEN') {
                enc = wifiSavedPassword ? 'WPA' : 'OPEN';
            }
            wifiSelectedEnc = enc;

            if (wifiSsidInput) wifiSsidInput.value = wifiSavedSsid;
            if (wifiPasswordInput) wifiPasswordInput.value = wifiSavedPassword;

            const items = wifiDropdownMenu ? wifiDropdownMenu.querySelectorAll('.wifi-dropdown-item') : [];
            items.forEach(it => it.classList.toggle('selected', it.getAttribute('data-enc') === wifiSelectedEnc));
            const dict = (window.I18N && window.getCurrentLang) ? window.I18N[window.getCurrentLang()] : {};
            if (wifiSelectedEnc === 'OPEN') {
                if (wifiSelectedLabel) wifiSelectedLabel.textContent = dict.wifiEncOpen || 'Open Network';
                if (wifiSelectedSub) wifiSelectedSub.textContent = dict.wifiEncOpenSub || 'No password (Public / Guest)';
            } else if (wifiSelectedEnc === 'WEP') {
                if (wifiSelectedLabel) wifiSelectedLabel.textContent = dict.wifiEncWep || 'WEP';
                if (wifiSelectedSub) wifiSelectedSub.textContent = dict.wifiEncWepSub || 'Legacy networks';
            } else {
                if (wifiSelectedLabel) wifiSelectedLabel.textContent = dict.wifiEncWpa || 'WPA / WPA2 / WPA3 Personal';
                if (wifiSelectedSub) wifiSelectedSub.textContent = dict.wifiEncWpaSub || 'Most common (Home & Office)';
            }

            wifiCurrentStep = 3;
            updateWifiWizardUi();
        };

        if (btnWifiTag) {
            btnWifiTag.addEventListener('click', () => openWifiModal(btnWifiTag));
        }

        if (btnWifiNext) {
            btnWifiNext.addEventListener('click', () => {
                if (document.activeElement && typeof document.activeElement.blur === 'function') {
                    try { document.activeElement.blur(); } catch (e) {}
                }
                const dict = (window.I18N && window.getCurrentLang) ? window.I18N[window.getCurrentLang()] : {};

                if (wifiCurrentStep === 1) {
                    const ssidVal = (wifiSsidInput ? wifiSsidInput.value : '').trim();
                    if (!ssidVal) {
                        if (window.showToast) window.showToast(dict.toastEnterSsid || 'Please enter network name (SSID)', 'warn');
                        if (wifiSsidInput) wifiSsidInput.focus();
                        return;
                    }
                    wifiSavedSsid = ssidVal;
                    wifiCurrentStep = 2;
                    updateWifiWizardUi();
                } else if (wifiCurrentStep === 2) {
                    const passVal = (wifiPasswordInput ? wifiPasswordInput.value : '').trim();
                    if (passVal.length > 0 && passVal.length < 8) {
                        if (window.showToast) window.showToast(dict.toastWifiPassMinLength || 'Password must be at least 8 characters', 'warn');
                        if (wifiPasswordInput) wifiPasswordInput.focus();
                        return;
                    }
                    wifiSavedPassword = passVal;

                    // If user left password empty and security is currently WPA, auto-switch to OPEN
                    if (!wifiSavedPassword && wifiSelectedEnc === 'WPA') {
                        wifiSelectedEnc = 'OPEN';
                        const items = wifiDropdownMenu ? wifiDropdownMenu.querySelectorAll('.wifi-dropdown-item') : [];
                        items.forEach(it => it.classList.toggle('selected', it.getAttribute('data-enc') === 'OPEN'));
                        if (wifiSelectedLabel) wifiSelectedLabel.textContent = dict.wifiEncOpen || 'Open Network';
                        if (wifiSelectedSub) wifiSelectedSub.textContent = dict.wifiEncOpenSub || 'No password (Public / Guest)';
                    } else if (wifiSavedPassword && wifiSelectedEnc === 'OPEN') {
                        wifiSelectedEnc = 'WPA';
                        const items = wifiDropdownMenu ? wifiDropdownMenu.querySelectorAll('.wifi-dropdown-item') : [];
                        items.forEach(it => it.classList.toggle('selected', it.getAttribute('data-enc') === 'WPA'));
                        if (wifiSelectedLabel) wifiSelectedLabel.textContent = dict.wifiEncWpa || 'WPA / WPA2 / WPA3 Personal';
                        if (wifiSelectedSub) wifiSelectedSub.textContent = dict.wifiEncWpaSub || 'Most common (Home & Office)';
                    }

                    wifiCurrentStep = 3;
                    updateWifiWizardUi();
                } else if (wifiCurrentStep === 3) {
                    if (wifiSelectedEnc === 'WPA') {
                        if (!wifiSavedPassword || wifiSavedPassword.length < 8) {
                            if (window.showToast) window.showToast(dict.toastWifiWpaRequired || dict.toastWifiPassMinLength || 'WPA networks require a password of at least 8 characters', 'warn');
                            wifiCurrentStep = 2;
                            updateWifiWizardUi();
                            if (wifiPasswordInput) wifiPasswordInput.focus();
                            return;
                        }
                    } else if (wifiSelectedEnc === 'OPEN') {
                        wifiSavedPassword = '';
                    }

                    if (window.startNfcWifiWrite) {
                        window.startNfcWifiWrite(wifiSavedSsid, wifiSavedPassword, wifiSelectedEnc, btnWifiTag, { skipOpenAnimation: true });
                    }
                }
            });
        }

        if (btnWifiBack) {
            btnWifiBack.addEventListener('click', handleWifiWizardBack);
        }

        if (wifiSelectTrigger) {
            wifiSelectTrigger.addEventListener('click', (e) => {
                e.stopPropagation();
                if (wifiDropdownWrapper) {
                    wifiDropdownWrapper.classList.toggle('open');
                }
            });
        }

        const wifiDropItems = wifiDropdownMenu ? wifiDropdownMenu.querySelectorAll('.wifi-dropdown-item') : [];
        wifiDropItems.forEach(item => {
            item.addEventListener('click', () => {
                const enc = item.getAttribute('data-enc');
                wifiSelectedEnc = enc;
                wifiDropItems.forEach(it => it.classList.toggle('selected', it === item));

                const mainText = item.querySelector('.wifi-dropdown-main')?.textContent || '';
                const subText = item.querySelector('.wifi-dropdown-sub')?.textContent || '';
                if (wifiSelectedLabel) wifiSelectedLabel.textContent = mainText;
                if (wifiSelectedSub) wifiSelectedSub.textContent = subText;

                if (wifiDropdownWrapper) wifiDropdownWrapper.classList.remove('open');
                updateWifiWizardUi();
            });
        });

        document.addEventListener('click', (e) => {
            if (wifiDropdownWrapper && wifiDropdownWrapper.classList.contains('open')) {
                if (!wifiDropdownWrapper.contains(e.target)) {
                    wifiDropdownWrapper.classList.remove('open');
                }
            }
        });

        if (btnWifiToggleShow && wifiPasswordInput) {
            btnWifiToggleShow.addEventListener('click', () => {
                const isPassword = wifiPasswordInput.type === 'password';
                wifiPasswordInput.type = isPassword ? 'text' : 'password';
                if (wifiEyeOpen) wifiEyeOpen.style.display = isPassword ? 'none' : 'block';
                if (wifiEyeClosed) wifiEyeClosed.style.display = isPassword ? 'block' : 'none';
            });
        }

        if (btnWifiSsidClear && wifiSsidInput) {
            btnWifiSsidClear.addEventListener('click', () => {
                wifiSsidInput.value = '';
                wifiSsidInput.focus();
            });
        }

        if (wifiSsidInput) {
            wifiSsidInput.addEventListener('keydown', (e) => {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    if (btnWifiNext) btnWifiNext.click();
                }
            });
        }

        if (wifiPasswordInput) {
            wifiPasswordInput.addEventListener('keydown', (e) => {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    if (btnWifiNext) btnWifiNext.click();
                }
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
                            if (window.handleDirectUrlInput) {
                                window.handleDirectUrlInput(text.trim());
                            } else if (window.handleConvert) {
                                window.handleConvert();
                            }
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
        if (qrBtn) qrBtn.addEventListener('click', () => window.openQrModal(qrBtn));
        if (qrCloseBtn) qrCloseBtn.addEventListener('click', window.closeQrModal);
        if (qrDownloadBtn) qrDownloadBtn.addEventListener('click', window.downloadQrImage);
        if (qrOverlay) {
            qrOverlay.addEventListener('click', e => {
                if (e.target === qrOverlay) window.closeQrModal();
            });
        }

        // ── NFC Button & Modal Handlers ──
        if (nfcBtn) {
            nfcBtn.addEventListener('click', () => {
                if (window.startNfcWrite) window.startNfcWrite(nfcBtn);
            });
        }
        if (nfcCancelBtn) {
            nfcCancelBtn.addEventListener('click', () => {
                if (window.handleNfcCancelOrBack) {
                    window.handleNfcCancelOrBack();
                } else if (window.closeNfcModal) {
                    window.closeNfcModal();
                }
            });
        }
        const nfcOverlay = $('nfcOverlay');
        if (nfcOverlay) {
            nfcOverlay.addEventListener('click', e => {
                if (e.target === nfcOverlay && window.closeNfcModal) window.closeNfcModal();
            });
        }

        // ── Link Type Segmented Selector (Review vs Location) ──
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

        // ── User Guide & Feature Tour ──
        const btnOpenHelpGuide = $('btnOpenHelpGuide');
        if (btnOpenHelpGuide) {
            btnOpenHelpGuide.addEventListener('click', () => {
                if (window.openOnboardingModal) {
                    window.openOnboardingModal();
                }
            });
        }

        // ── Hardware Back Button Coordinator ──
        window.handleAndroidBackPress = function() {
            const onboardingOverlay = $('onboardingOverlay');
            if (onboardingOverlay && onboardingOverlay.classList.contains('active')) {
                if (window.closeOnboardingModal) window.closeOnboardingModal(true);
                return true;
            }
            if (updateOverlay && updateOverlay.classList.contains('active')) {
                if (window.closeUpdateModal) window.closeUpdateModal();
                return true;
            }
            if (nfcOverlay && nfcOverlay.classList.contains('active')) {
                if (window.handleNfcCancelOrBack) {
                    window.handleNfcCancelOrBack();
                } else if (window.closeNfcModal) {
                    window.closeNfcModal();
                }
                return true;
            }
            if (pwdModalOverlay && pwdModalOverlay.classList.contains('active')) {
                if (nfcPinInput) nfcPinInput.blur();
                if (window.closeMorphModal && pwdModalBox) {
                    window.closeMorphModal(pwdModalOverlay, pwdModalBox);
                } else {
                    pwdModalOverlay.classList.remove('active');
                }
                return true;
            }
            if (permLockOverlay && permLockOverlay.classList.contains('active')) {
                if (window.closeMorphModal && permLockBox) {
                    window.closeMorphModal(permLockOverlay, permLockBox);
                } else {
                    permLockOverlay.classList.remove('active');
                }
                return true;
            }
            if (qrOverlay && qrOverlay.classList.contains('active')) {
                if (window.closeQrModal) window.closeQrModal();
                return true;
            }
            if (placesDropdown && placesDropdown.classList.contains('show')) {
                if (window.hidePlacesDropdown) window.hidePlacesDropdown();
                return true;
            }
            return false;
        };

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

        // ── Soft Keyboard Dock & Modal Avoidance on Mobile/Native ──
        let keyboardBlurTimer = null;
        let lastKnownImeHeight = Math.round(Math.min(310, Math.max(250, window.innerHeight * 0.39)));

        function computeModalKbShift(imeHeightPx) {
            const vh = window.innerHeight || 780;
            const kbH = Math.max(220, imeHeightPx || lastKnownImeHeight);
            const nfcModalBoxEl = $('nfcModalBox');
            const modalH = (nfcModalBoxEl && nfcModalBoxEl.offsetHeight > 100) ? nfcModalBoxEl.offsetHeight : 344;
            const centeredTop = (vh - modalH) * 0.5;
            const minShift = Math.min(0, 12 - centeredTop);
            const bottomClearanceShift = centeredTop - kbH - 14;
            const rawShift = Math.min(-kbH * 0.5, bottomClearanceShift);
            return Math.round(Math.max(-240, minShift, Math.min(0, rawShift)));
        }

        function setModalKeyboardShift(active, imeHeightPx) {
            if (!active) {
                document.documentElement.style.setProperty('--kb-shift', '0px');
                return;
            }
            const nfcOverlayEl = $('nfcOverlay');
            const isModalOpen = Boolean(nfcOverlayEl && nfcOverlayEl.classList.contains('active'));
            if (!isModalOpen) {
                document.documentElement.style.setProperty('--kb-shift', '0px');
                return;
            }
            const shift = computeModalKbShift(imeHeightPx);
            document.documentElement.style.setProperty('--kb-shift', `${shift}px`);
        }

        window.__onNativeKeyboardInset = function(imeBottomDp, imeVisible) {
            if (imeBottomDp >= 120) {
                lastKnownImeHeight = imeBottomDp;
            }
            if (!imeVisible || imeBottomDp <= 20) {
                document.body.classList.remove('keyboard-open');
                setModalKeyboardShift(false, 0);
            } else {
                document.body.classList.add('keyboard-open');
                const activeEl = document.activeElement;
                const nfcOverlayEl = $('nfcOverlay');
                const isModalInput = Boolean(activeEl && nfcOverlayEl && nfcOverlayEl.contains(activeEl));
                if (isModalInput || (nfcOverlayEl && nfcOverlayEl.classList.contains('active'))) {
                    setModalKeyboardShift(true, imeBottomDp >= 120 ? imeBottomDp : lastKnownImeHeight);
                }
            }
        };

        if (nfcPinInput) {
            nfcPinInput.addEventListener('click', () => {
                const nfcOverlayEl = $('nfcOverlay');
                if (nfcOverlayEl && nfcOverlayEl.classList.contains('active')) {
                    setModalKeyboardShift(true, lastKnownImeHeight);
                }
            });
            nfcPinInput.addEventListener('focus', () => {
                const nfcOverlayEl = $('nfcOverlay');
                if (nfcOverlayEl && nfcOverlayEl.classList.contains('active')) {
                    setModalKeyboardShift(true, lastKnownImeHeight);
                }
            });
        }

        document.addEventListener('focusin', e => {
            const tag = e.target && e.target.tagName ? e.target.tagName.toUpperCase() : '';
            if (tag === 'INPUT' || tag === 'TEXTAREA') {
                if (keyboardBlurTimer) {
                    clearTimeout(keyboardBlurTimer);
                    keyboardBlurTimer = null;
                }
                document.body.classList.add('keyboard-open');
                const nfcOverlayEl = $('nfcOverlay');
                if (nfcOverlayEl && nfcOverlayEl.contains(e.target)) {
                    setModalKeyboardShift(true, lastKnownImeHeight);
                }
            }
        });
        document.addEventListener('focusout', e => {
            const tag = e.target && e.target.tagName ? e.target.tagName.toUpperCase() : '';
            if (tag === 'INPUT' || tag === 'TEXTAREA') {
                const nfcOverlayEl = $('nfcOverlay');
                if (nfcOverlayEl && nfcOverlayEl.contains(e.target)) {
                    setModalKeyboardShift(false, 0);
                }
                if (keyboardBlurTimer) clearTimeout(keyboardBlurTimer);
                keyboardBlurTimer = setTimeout(() => {
                    const activeTag = document.activeElement && document.activeElement.tagName
                        ? document.activeElement.tagName.toUpperCase()
                        : '';
                    if (activeTag !== 'INPUT' && activeTag !== 'TEXTAREA') {
                        document.body.classList.remove('keyboard-open');
                        setModalKeyboardShift(false, 0);
                    }
                }, 120);
            }
        });

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
        if (document.fonts && document.fonts.ready) {
            document.fonts.ready.then(() => {
                if (window.updateModeTabSlider) window.updateModeTabSlider();
                if (window.updatePwdTabSlider) window.updatePwdTabSlider();
            }).catch(() => {});
        }
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
