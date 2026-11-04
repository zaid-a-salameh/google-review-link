// ========================================================
// Wi-Fi Card Setup Wizard Controller (#nfcWifiView)
// ========================================================
(function() {
    'use strict';

    const $ = id => document.getElementById(id);

    let wifiCurrentStep = 1;
    let wifiSelectedEnc = 'WPA';
    let wifiSavedSsid = '';
    let wifiSavedPassword = '';

    function getDict() {
        const lang = window.getCurrentLang ? window.getCurrentLang() : 'en';
        return (window.I18N && window.I18N[lang]) ? window.I18N[lang] : {};
    }

    function syncWifiEncryptionSelection(encType, dictOverride) {
        const dict = dictOverride || getDict();
        const norm = String(encType || 'WPA').toUpperCase();
        wifiSelectedEnc = (norm === 'OPEN' || norm === 'WEP') ? norm : 'WPA';

        const wifiDropdownMenu = $('wifiDropdownMenu');
        const wifiSelectedLabel = $('wifiSelectedLabel');
        const wifiSelectedSub = $('wifiSelectedSub');

        const items = wifiDropdownMenu ? wifiDropdownMenu.querySelectorAll('.wifi-dropdown-item') : [];
        items.forEach(it => it.classList.toggle('selected', it.getAttribute('data-enc') === wifiSelectedEnc));

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
    }

    function updateWifiWizardUi() {
        const dict = getDict();
        const wifiStepsIndicator = $('wifiStepsIndicator');
        const wifiStep1Pane = $('wifiStep1Pane');
        const wifiStep2Pane = $('wifiStep2Pane');
        const wifiStep3Pane = $('wifiStep3Pane');
        const wifiDropdownWrapper = $('wifiDropdownWrapper');
        const wifiStepTitle = $('wifiStepTitle');
        const wifiStepDesc = $('wifiStepDesc');
        const wifiNextBtnLabel = $('wifiNextBtnLabel');
        const wifiNextBtnArrow = $('wifiNextBtnArrow');
        const wifiBackBtnLabel = $('wifiBackBtnLabel');
        const btnWifiQr = $('btnWifiQr');
        const wifiQrBtnLabel = $('wifiQrBtnLabel');

        syncWifiEncryptionSelection(wifiSelectedEnc, dict);

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
            if (btnWifiQr) btnWifiQr.style.display = 'none';
        } else if (wifiCurrentStep === 2) {
            newTitle = dict.wifiStep2Title || 'Network Password';
            newDesc = dict.wifiStep2Desc || 'Enter Wi-Fi password (or leave blank for open network)';
            if (wifiNextBtnLabel) wifiNextBtnLabel.textContent = dict.wifiNext || 'Next';
            if (wifiBackBtnLabel) wifiBackBtnLabel.textContent = dict.wifiBack || 'Back';
            if (wifiNextBtnArrow) wifiNextBtnArrow.style.display = 'block';
            if (btnWifiQr) btnWifiQr.style.display = 'none';
        } else if (wifiCurrentStep === 3) {
            newTitle = dict.wifiStep3Title || 'Security Type';
            newDesc = dict.wifiStep3Desc || 'Select network encryption standard';
            if (wifiNextBtnLabel) wifiNextBtnLabel.textContent = dict.wifiWriteTag || 'Write to NFC Tag';
            if (wifiBackBtnLabel) wifiBackBtnLabel.textContent = dict.wifiBack || 'Back';
            if (wifiNextBtnArrow) wifiNextBtnArrow.style.display = 'none';
            if (btnWifiQr) {
                btnWifiQr.style.display = 'inline-flex';
                if (wifiQrBtnLabel) wifiQrBtnLabel.textContent = dict.wifiQrBtn || 'QR Code';
            }
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

    function openWifiModal(triggerBtn) {
        if (document.activeElement && typeof document.activeElement.blur === 'function') {
            try { document.activeElement.blur(); } catch (e) {}
        }

        wifiCurrentStep = 1;
        wifiSelectedEnc = 'WPA';
        wifiSavedSsid = '';
        wifiSavedPassword = '';

        const wifiSsidInput = $('wifiSsidInput');
        const wifiPasswordInput = $('wifiPasswordInput');
        const wifiEyeOpen = $('wifiEyeOpen');
        const wifiEyeClosed = $('wifiEyeClosed');

        if (wifiSsidInput) wifiSsidInput.value = '';
        if (wifiPasswordInput) {
            wifiPasswordInput.value = '';
            wifiPasswordInput.disabled = false;
            wifiPasswordInput.type = 'password';
        }
        if (wifiEyeOpen) wifiEyeOpen.style.display = 'block';
        if (wifiEyeClosed) wifiEyeClosed.style.display = 'none';

        updateWifiWizardUi();

        const nfcOverlay = $('nfcOverlay');
        const nfcModalBox = $('nfcModalBox');
        if (nfcOverlay && nfcModalBox) {
            if (window.showNfcView) {
                window.showNfcView('wifi', false);
            }
            nfcModalBox.classList.remove('theme-lock', 'theme-unlock', 'unlock-mode', 'theme-perm-lock', 'success', 'error', 'perm-lock-standby');
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
        const wifiDropdownWrapper = $('wifiDropdownWrapper');
        if (wifiDropdownWrapper) wifiDropdownWrapper.classList.remove('open');

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

    function returnToWifiWizard() {
        wifiCurrentStep = 3;
        updateWifiWizardUi();
        const nfcModalBox = $('nfcModalBox');
        if (nfcModalBox) {
            nfcModalBox.classList.remove('theme-lock', 'theme-unlock', 'unlock-mode', 'theme-perm-lock', 'success', 'error');
            nfcModalBox.classList.add('theme-wifi');
        }
        if (window.showNfcView) {
            window.showNfcView('wifi', true);
        }
    }

    function resolveEffectiveWifiState() {
        const wifiSsidInput = $('wifiSsidInput');
        const wifiPasswordInput = $('wifiPasswordInput');

        const ssid = (wifiSavedSsid || (wifiSsidInput ? wifiSsidInput.value : '')).trim();
        let pass = (wifiSavedPassword !== undefined && wifiSavedPassword !== null)
            ? String(wifiSavedPassword).trim()
            : '';
        if (!pass && wifiPasswordInput && !wifiPasswordInput.disabled) {
            pass = String(wifiPasswordInput.value || '').trim();
        }

        let enc = String(wifiSelectedEnc || '').toUpperCase();
        if (enc === 'OPEN' || !pass || (wifiPasswordInput && wifiPasswordInput.disabled)) {
            enc = 'OPEN';
            pass = '';
        } else if (enc !== 'WEP') {
            enc = 'WPA';
        }

        return { ssid, pass, enc };
    }

    function retryNfcWifiWrite() {
        const btnWifiTag = $('btnWifiTag');
        if (window.startNfcWifiWrite) {
            const { ssid, pass, enc } = resolveEffectiveWifiState();
            window.startNfcWifiWrite(ssid, pass, enc, btnWifiTag, { skipOpenAnimation: true, preserveCloneMode: true });
        }
    }

    function loadWifiConfigAndPrepareWrite(ssid, password, encType) {
        wifiSavedSsid = String(ssid || '').trim();
        wifiSavedPassword = String(password || '').trim();
        let enc = String(encType || 'WPA').toUpperCase();
        if (enc !== 'WEP' && enc !== 'OPEN') {
            enc = wifiSavedPassword ? 'WPA' : 'OPEN';
        }
        if (enc === 'OPEN' || !wifiSavedPassword) {
            enc = 'OPEN';
            wifiSavedPassword = '';
        }
        wifiSelectedEnc = enc;

        const wifiSsidInput = $('wifiSsidInput');
        const wifiPasswordInput = $('wifiPasswordInput');
        if (wifiSsidInput) wifiSsidInput.value = wifiSavedSsid;
        if (wifiPasswordInput) {
            wifiPasswordInput.disabled = false;
            wifiPasswordInput.value = wifiSavedPassword;
        }

        wifiCurrentStep = 3;
        updateWifiWizardUi();
    }

    document.addEventListener('DOMContentLoaded', () => {
        const btnWifiTag = $('btnWifiTag');
        const wifiSsidInput = $('wifiSsidInput');
        const btnWifiSsidClear = $('btnWifiSsidClear');
        const wifiPasswordInput = $('wifiPasswordInput');
        const btnWifiToggleShow = $('btnWifiToggleShow');
        const wifiEyeOpen = $('wifiEyeOpen');
        const wifiEyeClosed = $('wifiEyeClosed');
        const wifiDropdownWrapper = $('wifiDropdownWrapper');
        const wifiSelectTrigger = $('wifiSelectTrigger');
        const wifiDropdownMenu = $('wifiDropdownMenu');
        const btnWifiNext = $('btnWifiNext');
        const btnWifiQr = $('btnWifiQr');
        const btnWifiBack = $('btnWifiBack');

        if (btnWifiTag) {
            btnWifiTag.addEventListener('click', () => openWifiModal(btnWifiTag));
        }

        if (btnWifiNext) {
            btnWifiNext.addEventListener('click', () => {
                if (document.activeElement && typeof document.activeElement.blur === 'function') {
                    try { document.activeElement.blur(); } catch (e) {}
                }
                if (wifiDropdownWrapper) wifiDropdownWrapper.classList.remove('open');

                const dict = getDict();

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
                    const isDisabled = Boolean(wifiPasswordInput && wifiPasswordInput.disabled);
                    const passVal = isDisabled ? '' : (wifiPasswordInput ? wifiPasswordInput.value : '').trim();

                    if (passVal.length > 0 && passVal.length < 8 && wifiSelectedEnc !== 'WEP') {
                        if (window.showToast) window.showToast(dict.toastWifiPassMinLength || 'Password must be at least 8 characters', 'warn');
                        if (wifiPasswordInput) wifiPasswordInput.focus();
                        return;
                    }

                    wifiSavedPassword = passVal;
                    if (!wifiSavedPassword) {
                        syncWifiEncryptionSelection('OPEN', dict);
                    } else if (wifiSelectedEnc === 'OPEN') {
                        syncWifiEncryptionSelection('WPA', dict);
                    }

                    wifiCurrentStep = 3;
                    updateWifiWizardUi();
                } else if (wifiCurrentStep === 3) {
                    const { ssid, pass, enc } = resolveEffectiveWifiState();
                    if (!ssid) {
                        if (window.showToast) window.showToast(dict.toastEnterSsid || 'Please enter network name (SSID)', 'warn');
                        wifiCurrentStep = 1;
                        updateWifiWizardUi();
                        if (wifiSsidInput) wifiSsidInput.focus();
                        return;
                    }

                    wifiSavedSsid = ssid;
                    wifiSavedPassword = pass;
                    syncWifiEncryptionSelection(enc, dict);
                    if (enc === 'OPEN' && wifiPasswordInput) {
                        wifiPasswordInput.value = '';
                    }

                    if (enc === 'WPA' && pass.length < 8) {
                        if (window.showToast) window.showToast(dict.toastWifiWpaRequired || dict.toastWifiPassMinLength || 'WPA networks require a password of at least 8 characters', 'warn');
                        wifiCurrentStep = 2;
                        updateWifiWizardUi();
                        if (wifiPasswordInput) wifiPasswordInput.focus();
                        return;
                    }

                    if (window.startNfcWifiWrite) {
                        window.startNfcWifiWrite(ssid, pass, enc, btnWifiTag, { skipOpenAnimation: true });
                    }
                }
            });
        }

        if (btnWifiBack) {
            btnWifiBack.addEventListener('click', handleWifiWizardBack);
        }

        if (btnWifiQr) {
            btnWifiQr.addEventListener('click', () => {
                if (document.activeElement && typeof document.activeElement.blur === 'function') {
                    try { document.activeElement.blur(); } catch (e) {}
                }
                if (wifiDropdownWrapper) wifiDropdownWrapper.classList.remove('open');

                const dict = getDict();
                const { ssid, pass, enc } = resolveEffectiveWifiState();

                if (!ssid) {
                    if (window.showToast) window.showToast(dict.toastEnterSsid || 'Please enter network name (SSID)', 'warn');
                    wifiCurrentStep = 1;
                    updateWifiWizardUi();
                    if (wifiSsidInput) wifiSsidInput.focus();
                    return;
                }

                wifiSavedSsid = ssid;
                wifiSavedPassword = pass;
                syncWifiEncryptionSelection(enc, dict);
                if (enc === 'OPEN' && wifiPasswordInput) {
                    wifiPasswordInput.value = '';
                }

                if (enc === 'WPA' && pass.length < 8) {
                    if (window.showToast) window.showToast(dict.toastWifiWpaRequired || dict.toastWifiPassMinLength || 'WPA networks require a password of at least 8 characters', 'warn');
                    wifiCurrentStep = 2;
                    updateWifiWizardUi();
                    if (wifiPasswordInput) wifiPasswordInput.focus();
                    return;
                }

                if (window.openQrModalForWifi) {
                    window.openQrModalForWifi(ssid, pass, enc, btnWifiQr);
                }
            });
        }

        if (wifiSelectTrigger) {
            wifiSelectTrigger.addEventListener('click', e => {
                e.stopPropagation();
                if (wifiDropdownWrapper) {
                    const isOpen = wifiDropdownWrapper.classList.toggle('open');
                    wifiSelectTrigger.setAttribute('aria-expanded', isOpen ? 'true' : 'false');
                }
            });
        }

        const wifiDropItems = wifiDropdownMenu ? wifiDropdownMenu.querySelectorAll('.wifi-dropdown-item') : [];
        wifiDropItems.forEach(item => {
            item.addEventListener('click', () => {
                const enc = item.getAttribute('data-enc') || 'WPA';
                if (enc === 'OPEN') {
                    wifiSavedPassword = '';
                    if (wifiPasswordInput) wifiPasswordInput.value = '';
                }
                syncWifiEncryptionSelection(enc);
                if (wifiDropdownWrapper) wifiDropdownWrapper.classList.remove('open');
                if (wifiSelectTrigger) wifiSelectTrigger.setAttribute('aria-expanded', 'false');
                updateWifiWizardUi();
            });
        });

        document.addEventListener('click', e => {
            if (wifiDropdownWrapper && wifiDropdownWrapper.classList.contains('open')) {
                if (!wifiDropdownWrapper.contains(e.target)) {
                    wifiDropdownWrapper.classList.remove('open');
                    if (wifiSelectTrigger) wifiSelectTrigger.setAttribute('aria-expanded', 'false');
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
                wifiSavedSsid = '';
                wifiSsidInput.focus();
            });
        }

        if (wifiSsidInput) {
            wifiSsidInput.addEventListener('keydown', e => {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    if (btnWifiNext) btnWifiNext.click();
                }
            });
        }

        if (wifiPasswordInput) {
            wifiPasswordInput.addEventListener('keydown', e => {
                if (e.key === 'Enter') {
                    e.preventDefault();
                    if (btnWifiNext) btnWifiNext.click();
                }
            });
        }
    });

    window.openWifiModal = openWifiModal;
    window.updateWifiWizardUi = updateWifiWizardUi;
    window.handleWifiWizardBack = handleWifiWizardBack;
    window.returnToWifiWizard = returnToWifiWizard;
    window.retryNfcWifiWrite = retryNfcWifiWrite;
    window.loadWifiConfigAndPrepareWrite = loadWifiConfigAndPrepareWrite;
})();
