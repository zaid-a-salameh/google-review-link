// ========================================================
// Native Android Hardware NFC Tag Writing & Security Engine
// ========================================================
(function() {
    'use strict';

    let nfcBatchCount = 0;
    let permLockBatchCount = 0;
    let isPermLockStandby = false;
    let shouldReturnToPwdModal = false;
    let nfcResetTimer = null;
    let permThumpTimer = null;
    let lastNfcOperation = 'write';
    let lastNfcPin = '';
    let currentModalState = 'ready';
    let currentModalDetail = null;

    const ICON_NFC_WAVES = `
        <path d="M4.5 10.5C3.67 10.5 3 11.17 3 12s.67 1.5 1.5 1.5S6 12.83 6 12s-.67-1.5-1.5-1.5zm4.8 0c-.83 0-1.5.67-1.5 1.5s.67 1.5 1.5 1.5 1.5-.67 1.5-1.5-.67-1.5-1.5-1.5zm4.8 0c-.83 0-1.5.67-1.5 1.5s.67 1.5 1.5 1.5 1.5-.67 1.5-1.5-.67-1.5-1.5-1.5zm4.8 0c-.83 0-1.5.67-1.5 1.5s.67 1.5 1.5 1.5 1.5-.67 1.5-1.5-.67-1.5-1.5-1.5z"/>
        <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8 0-.55.45-1 1-1s1 .45 1 1c0 3.31 2.69 6 6 6s6-2.69 6-6c0-.55.45-1 1-1s1 .45 1 1c0 4.41-3.59 8-8 8z"/>
    `;

    const ICON_READ_SCANNER = `
        <path d="M3 5v4h2V5h4V3H5c-1.1 0-2 .9-2 2zm2 10H3v4c0 1.1.9 2 2 2h4v-2H5v-4zm14 4h-4v2h4c1.1 0 2-.9 2-2v-4h-2v4zm0-16h-4v2h4v4h2V5c0-1.1-.9-2-2-2z"/>
        <path d="M8.8 10.65a1.35 1.35 0 1 0 0 2.7 1.35 1.35 0 1 0 0-2.7zm1.96-.96a.85.85 0 0 1 1.33-1.05 5.45 5.45 0 0 1 0 6.72.85.85 0 0 1-1.33-1.05 3.75 3.75 0 0 0 0-4.62zm2.44-1.91a.85.85 0 0 1 1.34-1.05 8.55 8.55 0 0 1 0 10.54.85.85 0 0 1-1.34-1.05 6.85 6.85 0 0 0 0-8.44z"/>
    `;

    const ICON_SHIELD_PERM = `
        <path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm0 10.99h7c-.53 4.12-3.28 7.79-7 8.94V12H5V6.3l7-3.11v8.8z"/>
    `;

    const ICON_LOCK = `
        <path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z"/>
    `;

    const ICON_UNLOCK = `
        <path d="M12 17c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zm6-9h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6h1.9c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm0 12H6V10h12v10z"/>
    `;

    const ICON_WIFI = `
        <path d="M12 4C7.31 4 3.07 5.9 0 8.98L12 21 24 8.98A16.88 16.88 0 0 0 12 4zm0 2.9c3.8 0 7.27 1.41 9.94 3.73L12 18.59 2.06 10.63A14.88 14.88 0 0 1 12 6.9zM12 10c-2.48 0-4.73.91-6.47 2.41L12 19.58l6.47-7.17A9.87 9.87 0 0 0 12 10z"/>
    `;

    const ICON_CHECK = `<path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41L9 16.17z"/>`;
    const ICON_ERROR_X = `<path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>`;

    function getDict() {
        const lang = window.getCurrentLang ? window.getCurrentLang() : 'en';
        return (window.I18N && window.I18N[lang]) ? window.I18N[lang] : {};
    }

    function setIconIfChanged(el, svgMarkup) {
        if (!el) return;
        const trimmed = svgMarkup.trim();
        if (el.dataset.currentSvg !== trimmed) {
            el.innerHTML = trimmed;
            el.dataset.currentSvg = trimmed;
        }
    }

    function blurActiveElement() {
        if (document.activeElement && typeof document.activeElement.blur === 'function') {
            try {
                document.activeElement.blur();
            } catch (e) {}
        }
    }

    function setCancelBtnMode(label, isBack = false) {
        const nfcCancelBtn = document.getElementById('nfcCancelBtn');
        const nfcCancelBtnLabel = document.getElementById('nfcCancelBtnLabel');
        shouldReturnToPwdModal = Boolean(isBack);
        if (nfcCancelBtn) {
            nfcCancelBtn.classList.toggle('is-back-btn', Boolean(isBack));
        }
        if (nfcCancelBtnLabel) {
            nfcCancelBtnLabel.textContent = label || '';
        } else if (nfcCancelBtn) {
            nfcCancelBtn.textContent = label || '';
        }
    }

    function syncEmblemInteractivity(interactive) {
        const nfcStatusIcon = document.getElementById('nfcStatusIcon');
        if (!nfcStatusIcon) return;
        if (interactive) {
            nfcStatusIcon.setAttribute('tabindex', '0');
            nfcStatusIcon.setAttribute('aria-disabled', 'false');
        } else {
            nfcStatusIcon.setAttribute('tabindex', '-1');
            nfcStatusIcon.setAttribute('aria-disabled', 'true');
        }
    }

    function updatePermLockBadge(dict) {
        const nfcCounterBadge = document.getElementById('nfcCounterBadge');
        const nfcCounterText = document.getElementById('nfcCounterText');
        if (!nfcCounterBadge) return;
        if (permLockBatchCount > 0) {
            nfcCounterBadge.style.display = 'inline-flex';
            if (nfcCounterText) {
                const tpl = dict.nfcPermLockCount || 'Locked cards: {count}';
                nfcCounterText.textContent = tpl.replace('{count}', permLockBatchCount);
            }
        } else {
            nfcCounterBadge.style.display = 'none';
        }
    }

    function updateWriteBatchBadge(dict) {
        const nfcCounterBadge = document.getElementById('nfcCounterBadge');
        const nfcCounterText = document.getElementById('nfcCounterText');
        if (!nfcCounterBadge) return;
        if (nfcBatchCount > 0) {
            nfcCounterBadge.style.display = 'inline-flex';
            if (nfcCounterText) {
                const tpl = dict.nfcCardsCount || 'Cards written: {count}';
                nfcCounterText.textContent = tpl.replace('{count}', nfcBatchCount);
            }
        } else {
            nfcCounterBadge.style.display = 'none';
        }
    }

    function setNfcModalState(state, detail = null) {
        currentModalState = state;
        currentModalDetail = detail;

        const dict = getDict();
        const nfcModalBox = document.getElementById('nfcModalBox');
        const nfcTitle = document.getElementById('nfcTitle');
        const nfcDesc = document.getElementById('nfcDesc');
        const nfcRetryBtn = document.getElementById('nfcRetryBtn');
        const nfcNextBtn = document.getElementById('nfcNextBtn');
        const nfcNextBtnLabel = document.getElementById('nfcNextBtnLabel');
        const nfcNextBtnIcon = document.getElementById('nfcNextBtnIcon');
        const nfcCounterBadge = document.getElementById('nfcCounterBadge');
        const nfcSvgIcon = document.getElementById('nfcSvgIcon');

        if (nfcModalBox && state !== 'error') {
            nfcModalBox.classList.remove('error');
        }
        if (nfcModalBox && state !== 'perm_lock_standby') {
            nfcModalBox.classList.remove('perm-lock-standby');
        }
        if (nfcRetryBtn && state !== 'error') {
            nfcRetryBtn.style.display = 'none';
        }
        if (nfcNextBtn && state !== 'success') {
            nfcNextBtn.style.display = 'none';
        }
        if (nfcModalBox && state !== 'success') {
            nfcModalBox.classList.remove('has-next-btn');
        }

        syncEmblemInteractivity(state === 'perm_lock_standby');

        if (state === 'ready') {
            isPermLockStandby = false;
            if (nfcModalBox) nfcModalBox.classList.remove('success', 'theme-lock', 'theme-unlock', 'theme-perm-lock');
            if (nfcTitle) nfcTitle.textContent = nfcBatchCount > 0 ? (dict.nfcTitleNext || 'Ready for Next Card') : dict.nfcTitleReady;
            if (nfcDesc) nfcDesc.textContent = nfcBatchCount > 0 ? (dict.nfcDescNext || 'Hold another NFC card near the phone to write the review link.') : dict.nfcDescReady;
            setCancelBtnMode(nfcBatchCount > 0 ? dict.nfcDone : dict.nfcCancel, false);
            if (nfcBatchCount > 0) {
                updateWriteBatchBadge(dict);
            } else if (nfcCounterBadge) {
                nfcCounterBadge.style.display = 'none';
            }
            setIconIfChanged(nfcSvgIcon, ICON_NFC_WAVES);
        } else if (state === 'read_ready') {
            isPermLockStandby = false;
            if (nfcModalBox) nfcModalBox.classList.remove('success', 'theme-lock', 'theme-unlock', 'theme-perm-lock');
            if (nfcTitle) nfcTitle.textContent = dict.nfcTitleReadReady || 'Ready to Read Card';
            if (nfcDesc) nfcDesc.textContent = dict.nfcDescReadReady || 'Hold phone near NFC card to read its content...';
            setCancelBtnMode(dict.nfcCancel, false);
            if (nfcCounterBadge) nfcCounterBadge.style.display = 'none';
            setIconIfChanged(nfcSvgIcon, ICON_READ_SCANNER);
        } else if (state === 'perm_lock_ready') {
            isPermLockStandby = false;
            if (nfcModalBox) {
                nfcModalBox.classList.remove('success', 'theme-unlock', 'perm-lock-standby');
                nfcModalBox.classList.add('theme-lock', 'theme-perm-lock');
            }
            if (nfcTitle) nfcTitle.textContent = dict.nfcTitlePermLockReady || 'Ready to Permanently Lock';
            if (nfcDesc) nfcDesc.textContent = dict.nfcDescPermLockReady || 'Hold phone near NFC card to apply permanent lock...';
            setCancelBtnMode(permLockBatchCount > 0 ? (dict.nfcDone || 'Done') : dict.nfcCancel, false);
            updatePermLockBadge(dict);
            setIconIfChanged(nfcSvgIcon, ICON_SHIELD_PERM);
        } else if (state === 'perm_lock_standby') {
            isPermLockStandby = true;
            if (nfcModalBox) {
                nfcModalBox.classList.remove('success', 'error', 'theme-unlock');
                nfcModalBox.classList.add('theme-lock', 'theme-perm-lock', 'perm-lock-standby');
            }
            if (nfcTitle) nfcTitle.textContent = dict.nfcTitlePermLockStandby || 'Card Permanently Locked!';
            if (nfcDesc) nfcDesc.textContent = dict.nfcDescPermLockStandby || 'Sensor paused for safety. Tap the icon above to reactivate and lock another card.';
            setCancelBtnMode(dict.nfcDone || dict.nfcOk || 'Done', false);
            updatePermLockBadge(dict);
            setIconIfChanged(nfcSvgIcon, ICON_SHIELD_PERM);
        } else if (state === 'pwd_lock_ready') {
            isPermLockStandby = false;
            if (nfcModalBox) {
                nfcModalBox.classList.remove('success', 'theme-unlock', 'theme-perm-lock');
                nfcModalBox.classList.add('theme-lock');
            }
            if (nfcTitle) nfcTitle.textContent = dict.nfcTitlePwdLockReady || 'Ready to Lock';
            if (nfcDesc) nfcDesc.textContent = dict.nfcDescPwdLockReady || 'Hold phone near card to lock with PIN...';
            setCancelBtnMode(dict.nfcCancel, false);
            if (nfcCounterBadge) nfcCounterBadge.style.display = 'none';
            setIconIfChanged(nfcSvgIcon, ICON_LOCK);
        } else if (state === 'pwd_unlock_ready') {
            isPermLockStandby = false;
            if (nfcModalBox) {
                nfcModalBox.classList.remove('success', 'theme-lock', 'theme-perm-lock');
                nfcModalBox.classList.add('theme-unlock');
            }
            if (nfcTitle) nfcTitle.textContent = dict.nfcTitlePwdUnlockReady || 'Ready to Unlock';
            if (nfcDesc) nfcDesc.textContent = dict.nfcDescPwdUnlockReady || 'Hold phone near card to remove protection...';
            setCancelBtnMode(dict.nfcCancel, false);
            if (nfcCounterBadge) nfcCounterBadge.style.display = 'none';
            setIconIfChanged(nfcSvgIcon, ICON_UNLOCK);
        } else if (state === 'wifi_ready') {
            isPermLockStandby = false;
            if (nfcModalBox) {
                nfcModalBox.classList.remove('success', 'theme-lock', 'theme-unlock', 'theme-perm-lock');
                nfcModalBox.classList.add('theme-wifi');
            }
            if (nfcTitle) nfcTitle.textContent = dict.nfcTitleWifiReady || 'Ready to Write Wi-Fi';
            if (nfcDesc) nfcDesc.textContent = dict.nfcDescWifiReady || 'Hold phone near NFC card to write Wi-Fi credentials.';
            setCancelBtnMode(dict.wifiBack || 'Back', true);
            if (nfcCounterBadge) nfcCounterBadge.style.display = 'none';
            setIconIfChanged(nfcSvgIcon, ICON_WIFI);
        } else if (state === 'success') {
            isPermLockStandby = false;
            if (nfcModalBox) {
                nfcModalBox.classList.remove('morph-to-ready', 'error', 'theme-lock', 'theme-unlock', 'theme-perm-lock', 'theme-wifi');
                nfcModalBox.classList.add('success');
            }
            if (detail === 'PWD_LOCK') {
                if (nfcTitle) nfcTitle.textContent = dict.nfcTitlePwdLockSuccess || 'Card Locked';
                if (nfcDesc) nfcDesc.textContent = dict.nfcDescPwdLockSuccess || 'Card is now locked against modifications.';
                setCancelBtnMode(dict.nfcDone || dict.nfcOk || 'Done', false);
                if (nfcNextBtn) {
                    nfcNextBtn.className = 'btn-nfc-next theme-lock';
                    nfcNextBtn.style.display = 'inline-flex';
                    if (nfcNextBtnLabel) nfcNextBtnLabel.textContent = dict.nfcBtnLockAnother || 'Lock Another Card';
                    if (nfcNextBtnIcon) nfcNextBtnIcon.innerHTML = ICON_LOCK.trim();
                }
                if (nfcModalBox) nfcModalBox.classList.add('has-next-btn');
                if (nfcCounterBadge) nfcCounterBadge.style.display = 'none';
            } else if (detail === 'PWD_UNLOCK' || detail === 'ALREADY_UNLOCKED') {
                if (detail === 'ALREADY_UNLOCKED') {
                    if (nfcTitle) nfcTitle.textContent = dict.nfcTitleAlreadyUnlocked || 'Card Not Locked';
                    if (nfcDesc) nfcDesc.textContent = dict.nfcDescAlreadyUnlocked || 'This card is already unlocked and writable.';
                } else {
                    if (nfcTitle) nfcTitle.textContent = dict.nfcTitlePwdUnlockSuccess || 'Card Unlocked';
                    if (nfcDesc) nfcDesc.textContent = dict.nfcDescPwdUnlockSuccess || 'Card is now unlocked and ready for editing.';
                }
                setCancelBtnMode(dict.nfcDone || dict.nfcOk || 'Done', false);
                if (nfcNextBtn) {
                    nfcNextBtn.className = 'btn-nfc-next theme-unlock';
                    nfcNextBtn.style.display = 'inline-flex';
                    if (nfcNextBtnLabel) nfcNextBtnLabel.textContent = dict.nfcBtnUnlockAnother || 'Unlock Another Card';
                    if (nfcNextBtnIcon) nfcNextBtnIcon.innerHTML = ICON_UNLOCK.trim();
                }
                if (nfcModalBox) nfcModalBox.classList.add('has-next-btn');
                if (nfcCounterBadge) nfcCounterBadge.style.display = 'none';
            } else if (detail === 'PERM_LOCK') {
                if (nfcTitle) nfcTitle.textContent = dict.nfcTitlePermLockSuccess || 'Card Permanently Locked';
                if (nfcDesc) nfcDesc.textContent = dict.nfcDescPermLockSuccess || 'Card permanently locked to Read-Only mode.';
                setCancelBtnMode(dict.nfcOk || 'OK', false);
                if (nfcNextBtn) nfcNextBtn.style.display = 'none';
                if (nfcModalBox) nfcModalBox.classList.remove('has-next-btn');
                updatePermLockBadge(dict);
            } else if (detail === 'WRITE_WIFI' || lastNfcOperation === 'write_wifi') {
                if (nfcTitle) nfcTitle.textContent = dict.nfcTitleWifiSuccess || 'Wi-Fi Card Programmed!';
                if (nfcDesc) nfcDesc.textContent = dict.nfcDescWifiSuccess || 'Wi-Fi configuration successfully written to NFC card.';
                setCancelBtnMode(dict.nfcDone || dict.nfcOk || 'Done', false);
                if (nfcNextBtn) {
                    nfcNextBtn.className = 'btn-nfc-next theme-wifi';
                    nfcNextBtn.style.display = 'inline-flex';
                    if (nfcNextBtnLabel) nfcNextBtnLabel.textContent = dict.nfcBtnWifiAnother || 'Write Another Card';
                    if (nfcNextBtnIcon) nfcNextBtnIcon.innerHTML = ICON_WIFI.trim();
                }
                if (nfcModalBox) nfcModalBox.classList.add('has-next-btn');
                if (nfcCounterBadge) nfcCounterBadge.style.display = 'none';
            } else {
                if (nfcTitle) nfcTitle.textContent = dict.nfcTitleSuccess;
                if (nfcDesc) nfcDesc.textContent = dict.nfcDescSuccess || '';
                setCancelBtnMode(dict.nfcDone, false);
                if (nfcNextBtn) {
                    nfcNextBtn.className = 'btn-nfc-next theme-link';
                    nfcNextBtn.style.display = 'inline-flex';
                    if (nfcNextBtnLabel) nfcNextBtnLabel.textContent = dict.nfcBtnWriteAnother || 'Write Another Card';
                    if (nfcNextBtnIcon) nfcNextBtnIcon.innerHTML = ICON_NFC_WAVES.trim();
                }
                if (nfcModalBox) nfcModalBox.classList.add('has-next-btn');
                updateWriteBatchBadge(dict);
            }
            if (nfcRetryBtn) nfcRetryBtn.style.display = 'none';
            setIconIfChanged(nfcSvgIcon, ICON_CHECK);
        } else if (state === 'next') {
            isPermLockStandby = false;
            if (nfcModalBox) {
                nfcModalBox.classList.add('morph-to-ready');
                setTimeout(() => {
                    if (nfcModalBox) {
                        nfcModalBox.classList.remove('success');
                        nfcModalBox.classList.remove('morph-to-ready');
                    }
                }, 320);
            }
            if (nfcTitle) nfcTitle.textContent = dict.nfcTitleNext;
            if (nfcDesc) nfcDesc.textContent = dict.nfcDescNext;
            setCancelBtnMode(dict.nfcDone, false);
            updateWriteBatchBadge(dict);
            setIconIfChanged(nfcSvgIcon, ICON_NFC_WAVES);
        } else if (state === 'error') {
            isPermLockStandby = false;
            if (nfcModalBox) {
                nfcModalBox.classList.remove('morph-to-ready', 'success', 'theme-unlock', 'theme-wifi', 'perm-lock-standby');
                nfcModalBox.classList.add('error');
            }
            if (nfcTitle) {
                if (detail === 'DISABLED') nfcTitle.textContent = dict.nfcTitleDisabled || 'NFC is Disabled';
                else if (detail === 'NO_HARDWARE' || detail === 'NOT_SUPPORTED') nfcTitle.textContent = dict.nfcTitleNoHardware || 'NFC Not Supported';
                else if (detail === 'TAG_LOST') nfcTitle.textContent = dict.nfcTitleTagLost || 'Connection Dropped';
                else if (detail === 'LOCKED') nfcTitle.textContent = dict.nfcTitleLocked || 'Card is Protected';
                else if (detail === 'READ_LOCKED') nfcTitle.textContent = dict.nfcTitleReadLocked || 'Card is Read-Protected';
                else if (detail === 'WRONG_PWD') nfcTitle.textContent = dict.nfcTitleWrongPwd || 'Incorrect PIN';
                else if (detail === 'ALREADY_LOCKED') nfcTitle.textContent = dict.nfcTitleAlreadyLocked || 'Card Already Locked';
                else if (detail === 'CANNOT_LOCK') nfcTitle.textContent = dict.nfcTitleCannotLock || 'Cannot Permanently Lock';
                else if (detail === 'CAPACITY') nfcTitle.textContent = dict.nfcTitleCapacity || 'Capacity Exceeded';
                else if (detail === 'EMPTY_TAG') nfcTitle.textContent = dict.nfcTitleEmptyTag || 'Empty Card';
                else if (lastNfcOperation !== 'write') nfcTitle.textContent = dict.nfcTitleOpFailed || 'Operation Failed';
                else nfcTitle.textContent = dict.nfcTitleError || 'Write Failed';
            }

            let detailMsg = lastNfcOperation === 'write'
                ? (dict.nfcDescGenericError || 'Write operation failed. Ensure the phone is held steady near the card.')
                : (dict.nfcDescOpFailed || 'Operation failed. Hold the phone steadily over the card and try again.');

            if (detail === 'DISABLED') detailMsg = dict.nfcDisabled || 'Please enable NFC in your phone settings.';
            else if (detail === 'NO_HARDWARE' || detail === 'NOT_SUPPORTED') detailMsg = dict.nfcNoHardware || 'NFC is not supported on this device.';
            else if (detail === 'TAG_LOST') detailMsg = dict.nfcDescTagLost || 'Connection lost due to phone movement or weak NFC signal. Please hold the phone steadily over the card without moving it.';
            else if (detail === 'LOCKED') detailMsg = dict.nfcDescLocked || 'This card is locked with a password or read-only and cannot be modified. Please unlock it first.';
            else if (detail === 'READ_LOCKED') detailMsg = dict.nfcDescReadLocked || 'Cannot read card data because it is password-protected.';
            else if (detail === 'CANNOT_LOCK') detailMsg = dict.nfcDescCannotLock || 'This card is already read-only or does not support permanent hardware locking.';
            else if (detail === 'CAPACITY') detailMsg = dict.nfcDescCapacity || 'Link size exceeds this card\'s memory capacity.';
            else if (detail === 'UNSUPPORTED') detailMsg = dict.nfcDescUnsupported || 'This card type is not supported.';
            else if (detail === 'EMPTY_TAG') detailMsg = dict.toastNfcReadEmpty || 'No valid URL found on this card.';
            else if (detail === 'WRONG_PWD') detailMsg = dict.toastNfcWrongPwd || 'Incorrect PIN. The card is protected with a different password.';
            else if (detail === 'PWD_UNSUPPORTED') detailMsg = dict.toastNfcPwdUnsupported || 'PIN protection is not supported on this card.';
            else if (detail === 'ALREADY_LOCKED') detailMsg = dict.toastNfcAlreadyLocked || 'This card is already locked with a different PIN. Unlock it first.';
            else if (detail === 'MISSING_PIN') detailMsg = dict.toastEnterPwd || 'Please enter a password or PIN.';

            if (nfcDesc) nfcDesc.textContent = detailMsg;

            if (lastNfcOperation === 'perm_lock' && permLockBatchCount > 0) {
                updatePermLockBadge(dict);
            } else if (nfcCounterBadge) {
                nfcCounterBadge.style.display = 'none';
            }

            const isPinReturnError =
                (lastNfcOperation === 'pwd_unlock') ||
                (lastNfcOperation === 'pwd_lock' && (
                    detail === 'ALREADY_LOCKED' ||
                    detail === 'LOCKED' ||
                    detail === 'WRONG_PWD' ||
                    detail === 'PWD_FAILED' ||
                    detail === 'MISSING_PIN'
                ));

            const isWifiReturnError = (lastNfcOperation === 'write_wifi');

            if (isPinReturnError) {
                setCancelBtnMode(dict.nfcBackToPin || 'Back', true);
            } else if (isWifiReturnError) {
                setCancelBtnMode(dict.wifiBack || 'Back', true);
            } else {
                const fallbackLabel = (lastNfcOperation === 'perm_lock' && permLockBatchCount > 0)
                    ? (dict.nfcDone || 'Done')
                    : (dict.nfcCancel || 'Cancel');
                setCancelBtnMode(fallbackLabel, false);
            }

            if (nfcRetryBtn) {
                if (detail === 'NO_HARDWARE' || detail === 'NOT_SUPPORTED') {
                    nfcRetryBtn.style.display = 'none';
                } else {
                    nfcRetryBtn.style.display = 'inline-flex';
                    const retryLabel = document.getElementById('nfcRetryBtnLabel');
                    if (retryLabel) retryLabel.textContent = dict.nfcRetryBtn || 'Try Again';
                }
            }

            setIconIfChanged(nfcSvgIcon, ICON_ERROR_X);
        }
    }

    function ensureNfcModalVisible(triggerBtn, fallbackBtnId, options = {}) {
        const nfcOverlay = document.getElementById('nfcOverlay');
        const nfcModalBox = document.getElementById('nfcModalBox');
        if (!nfcOverlay) return;

        if (options.skipOpenAnimation || nfcOverlay.classList.contains('active')) {
            nfcOverlay.classList.add('active');
            return;
        }

        const validBtn = (triggerBtn && triggerBtn.nodeType === 1)
            ? triggerBtn
            : (fallbackBtnId ? document.getElementById(fallbackBtnId) : null);

        if (window.openMorphModal && nfcModalBox) {
            window.openMorphModal(nfcOverlay, nfcModalBox, validBtn);
        } else {
            nfcOverlay.classList.add('active');
        }
    }

    function openNfcModal(triggerBtn, options = {}) {
        blurActiveElement();
        const nfcOverlay = document.getElementById('nfcOverlay');
        const isModalOpen = Boolean(nfcOverlay && nfcOverlay.classList.contains('active'));
        if (window.showNfcView) {
            window.showNfcView('sensor', isModalOpen);
        }
        nfcBatchCount = 0;
        window.nfcBatchCount = 0;
        isPermLockStandby = false;
        shouldReturnToPwdModal = false;
        if (nfcResetTimer) {
            clearTimeout(nfcResetTimer);
            nfcResetTimer = null;
        }
        const nfcNextBtn = document.getElementById('nfcNextBtn');
        if (nfcNextBtn) nfcNextBtn.style.display = 'none';
        const nfcModalBox = document.getElementById('nfcModalBox');
        if (nfcModalBox) {
            nfcModalBox.classList.remove(
                'theme-lock',
                'theme-unlock',
                'theme-perm-lock',
                'perm-lock-standby',
                'perm-lock-thump',
                'success',
                'error',
                'has-next-btn',
                'unlock-mode'
            );
        }
        setNfcModalState('ready');
        ensureNfcModalVisible(triggerBtn, 'nfcBtn', options);
    }

    function closeNfcModal() {
        blurActiveElement();
        if (nfcResetTimer) {
            clearTimeout(nfcResetTimer);
            nfcResetTimer = null;
        }
        if (permThumpTimer) {
            clearTimeout(permThumpTimer);
            permThumpTimer = null;
        }

        const completedWrites = nfcBatchCount;
        nfcBatchCount = 0;
        window.nfcBatchCount = 0;
        permLockBatchCount = 0;
        isPermLockStandby = false;
        shouldReturnToPwdModal = false;

        if (window.AndroidNative && window.AndroidNative.cancelNfcWrite) {
            try { window.AndroidNative.cancelNfcWrite(); } catch (e) {}
        }

        const nfcOverlay = document.getElementById('nfcOverlay');
        const nfcModalBox = document.getElementById('nfcModalBox');
        if (window.closeMorphModal && nfcOverlay && nfcModalBox) {
            window.closeMorphModal(nfcOverlay, nfcModalBox, () => {
                const nfcNextBtn = document.getElementById('nfcNextBtn');
                if (nfcNextBtn) nfcNextBtn.style.display = 'none';
                nfcModalBox.classList.remove(
                    'theme-lock',
                    'theme-unlock',
                    'theme-perm-lock',
                    'theme-wifi',
                    'perm-lock-standby',
                    'perm-lock-thump',
                    'success',
                    'error',
                    'morph-to-ready',
                    'has-next-btn',
                    'unlock-mode'
                );
                if (window.showNfcView) {
                    window.showNfcView('sensor', false);
                }
            });
        } else if (nfcOverlay) {
            nfcOverlay.classList.remove('active');
            if (nfcModalBox) {
                nfcModalBox.classList.remove(
                    'theme-lock',
                    'theme-unlock',
                    'theme-perm-lock',
                    'theme-wifi',
                    'perm-lock-standby',
                    'perm-lock-thump',
                    'success',
                    'error',
                    'morph-to-ready',
                    'has-next-btn',
                    'unlock-mode'
                );
            }
            if (window.showNfcView) {
                window.showNfcView('sensor', false);
            }
        }
    }

    function handleNfcCancelOrBack() {
        const nfcModalBox = document.getElementById('nfcModalBox');
        const activeView = nfcModalBox ? nfcModalBox.querySelector('.nfc-view.active') : null;
        const isPwdView = activeView && activeView.id === 'nfcPwdView';
        const isPermConfirmView = activeView && activeView.id === 'nfcPermConfirmView';
        const isWifiView = activeView && activeView.id === 'nfcWifiView';

        if (isWifiView) {
            if (window.handleWifiWizardBack) {
                window.handleWifiWizardBack();
                return;
            }
            closeNfcModal();
            return;
        }

        if (isPwdView || isPermConfirmView) {
            closeNfcModal();
            return;
        }

        if (lastNfcOperation === 'write_wifi') {
            if (window.returnToWifiWizard) {
                if (window.AndroidNative && window.AndroidNative.cancelNfcWrite) {
                    try { window.AndroidNative.cancelNfcWrite(); } catch (e) {}
                }
                window.returnToWifiWizard();
                return;
            }
        }

        if (shouldReturnToPwdModal && typeof window.returnToPasswordModal === 'function') {
            shouldReturnToPwdModal = false;
            isPermLockStandby = false;
            if (nfcResetTimer) {
                clearTimeout(nfcResetTimer);
                nfcResetTimer = null;
            }
            if (window.AndroidNative && window.AndroidNative.cancelNfcWrite) {
                try { window.AndroidNative.cancelNfcWrite(); } catch (e) {}
            }
            window.returnToPasswordModal();
            return;
        }
        closeNfcModal();
    }

    function startNfcWrite(triggerBtn, options = {}) {
        blurActiveElement();
        if (nfcResetTimer) {
            clearTimeout(nfcResetTimer);
            nfcResetTimer = null;
        }
        const dict = getDict();
        const url = window.getGeneratedReviewUrl ? window.getGeneratedReviewUrl() : '';
        if (!url) {
            if (window.showToast) window.showToast(dict.toastPasteFirst || 'Please generate a link first', 'warn');
            return;
        }

        lastNfcOperation = 'write';
        window.lastNfcOperation = 'write';

        const nfcOverlay = document.getElementById('nfcOverlay');
        const alreadyOpen = Boolean(nfcOverlay && nfcOverlay.classList.contains('active'));

        if (window.AndroidNative && window.AndroidNative.startNfcWrite) {
            if (alreadyOpen && !options.resetBatch) {
                setNfcModalState('ready');
                if (window.showNfcView) window.showNfcView('sensor', true);
            } else {
                openNfcModal(triggerBtn, options);
            }
            window.AndroidNative.startNfcWrite(url);
        } else if ('NDEFReader' in window) {
            if (alreadyOpen && !options.resetBatch) {
                setNfcModalState('ready');
                if (window.showNfcView) window.showNfcView('sensor', true);
            } else {
                openNfcModal(triggerBtn, options);
            }
            const ndef = new NDEFReader();
            ndef.write({
                records: [{ recordType: 'url', data: url }]
            }, { overwrite: true }).then(() => {
                if (window.onNfcSuccess) window.onNfcSuccess(1);
            }).catch(() => {
                if (window.onNfcError) window.onNfcError('WRITE_FAILED');
            });
        } else {
            if (window.showToast) window.showToast(dict.nfcNoHardware || 'NFC not supported', 'warn');
        }
    }

    function startNfcRead(triggerBtn, options = {}) {
        blurActiveElement();
        const dict = getDict();
        lastNfcOperation = 'read';
        window.lastNfcOperation = 'read';
        const nfcOverlay = document.getElementById('nfcOverlay');
        const alreadyOpen = Boolean(nfcOverlay && nfcOverlay.classList.contains('active'));
        if (window.AndroidNative && window.AndroidNative.startNfcRead) {
            setNfcModalState('read_ready');
            if (window.showNfcView) window.showNfcView('sensor', alreadyOpen);
            ensureNfcModalVisible(triggerBtn, 'btnReadTag', options);
            window.AndroidNative.startNfcRead();
        } else {
            if (window.showToast) window.showToast(dict.nfcNoHardware || 'NFC not supported', 'warn');
        }
    }

    function startNfcPermanentLock(triggerBtn, options = {}) {
        blurActiveElement();
        const dict = getDict();
        lastNfcOperation = 'perm_lock';
        window.lastNfcOperation = 'perm_lock';
        if (options.resetCount !== false && !(options.preserveCount)) {
            permLockBatchCount = 0;
        }
        isPermLockStandby = false;
        const nfcOverlay = document.getElementById('nfcOverlay');
        const alreadyOpen = Boolean(nfcOverlay && nfcOverlay.classList.contains('active'));

        if (window.AndroidNative && window.AndroidNative.startNfcPermanentLock) {
            setNfcModalState('perm_lock_ready');
            if (window.showNfcView) window.showNfcView('sensor', alreadyOpen);
            ensureNfcModalVisible(triggerBtn, 'btnPermLockTag', options);
            window.AndroidNative.startNfcPermanentLock();
        } else {
            if (window.showToast) window.showToast(dict.nfcNoHardware || 'NFC not supported', 'warn');
        }
    }

    function rearmSequentialPermLock() {
        if (!isPermLockStandby || lastNfcOperation !== 'perm_lock') return;
        if (window.AndroidNative && typeof window.AndroidNative.triggerLightHaptic === 'function') {
            try { window.AndroidNative.triggerLightHaptic(); } catch (e) {}
        } else if (navigator.vibrate) {
            try { navigator.vibrate(18); } catch (e) {}
        }
        startNfcPermanentLock(null, { skipOpenAnimation: true, preserveCount: true });
    }

    function startNfcPasswordLock(pin, triggerBtn, options = {}) {
        blurActiveElement();
        const dict = getDict();
        if (!pin || !pin.trim()) return;
        lastNfcOperation = 'pwd_lock';
        window.lastNfcOperation = 'pwd_lock';
        lastNfcPin = pin;
        shouldReturnToPwdModal = true;
        const nfcOverlay = document.getElementById('nfcOverlay');
        const alreadyOpen = Boolean(nfcOverlay && nfcOverlay.classList.contains('active'));
        if (window.AndroidNative && window.AndroidNative.startNfcPasswordLock) {
            setNfcModalState('pwd_lock_ready');
            if (window.showNfcView) window.showNfcView('sensor', alreadyOpen);
            ensureNfcModalVisible(triggerBtn, 'btnPwdLockTag', options);
            window.AndroidNative.startNfcPasswordLock(pin);
        } else {
            if (window.showToast) window.showToast(dict.nfcNoHardware || 'NFC not supported', 'warn');
        }
    }

    function startNfcPasswordUnlock(pin, triggerBtn, options = {}) {
        blurActiveElement();
        const dict = getDict();
        if (!pin || !pin.trim()) return;
        lastNfcOperation = 'pwd_unlock';
        window.lastNfcOperation = 'pwd_unlock';
        lastNfcPin = pin;
        shouldReturnToPwdModal = true;
        const nfcOverlay = document.getElementById('nfcOverlay');
        const alreadyOpen = Boolean(nfcOverlay && nfcOverlay.classList.contains('active'));
        if (window.AndroidNative && window.AndroidNative.startNfcPasswordUnlock) {
            setNfcModalState('pwd_unlock_ready');
            if (window.showNfcView) window.showNfcView('sensor', alreadyOpen);
            ensureNfcModalVisible(triggerBtn, 'btnPwdLockTag', options);
            window.AndroidNative.startNfcPasswordUnlock(pin);
        } else {
            if (window.showToast) window.showToast(dict.nfcNoHardware || 'NFC not supported', 'warn');
        }
    }

    function startNfcWifiWrite(ssid, password, encType, triggerBtn, options = {}) {
        blurActiveElement();
        const dict = getDict();
        if (!ssid || !ssid.trim()) {
            if (window.showToast) window.showToast(dict.toastEnterSsid || 'Please enter network name (SSID)', 'warn');
            return;
        }

        lastNfcOperation = 'write_wifi';
        window.lastNfcOperation = 'write_wifi';

        const nfcOverlay = document.getElementById('nfcOverlay');
        const alreadyOpen = Boolean(nfcOverlay && nfcOverlay.classList.contains('active'));

        setNfcModalState('wifi_ready');
        if (window.showNfcView) window.showNfcView('sensor', alreadyOpen);
        ensureNfcModalVisible(triggerBtn, 'btnWifiTag', options);

        if (window.AndroidNative && window.AndroidNative.startNfcWifiWrite) {
            window.AndroidNative.startNfcWifiWrite(ssid.trim(), password || '', encType || 'WPA');
        }
    }

    // Bridge Callbacks from Android Native
    window.onNfcSuccess = function(count) {
        if (lastNfcOperation === 'write_wifi') {
            if (!window.AndroidNative && navigator.vibrate) {
                try { navigator.vibrate([140, 70, 180]); } catch (e) {}
            }
            setNfcModalState('success', 'WRITE_WIFI');
            return;
        }

        nfcBatchCount = typeof count === 'number' && count > 0 ? count : (nfcBatchCount + 1);
        window.nfcBatchCount = nfcBatchCount;

        if (!window.AndroidNative && navigator.vibrate) {
            try { navigator.vibrate([140, 70, 180]); } catch (e) {}
        }

        if (nfcResetTimer) {
            clearTimeout(nfcResetTimer);
            nfcResetTimer = null;
        }

        setNfcModalState('success', nfcBatchCount);
    };

    window.onNfcTagRead = function(url) {
        if (!url) return;
        const dict = getDict();
        if (window.switchMode) {
            window.switchMode('link');
        }
        const urlInput = document.getElementById('urlInput');
        if (urlInput) {
            urlInput.value = url;
        }

        const nfcOverlay = document.getElementById('nfcOverlay');
        const nfcModalBox = document.getElementById('nfcModalBox');
        if (window.closeMorphModal && nfcOverlay && nfcModalBox) {
            window.closeMorphModal(nfcOverlay, nfcModalBox);
        } else if (nfcOverlay) {
            nfcOverlay.classList.remove('active');
        }

        if (window.handleDirectUrlInput) {
            window.handleDirectUrlInput(url);
        }

        if (window.showToast) {
            window.showToast(dict.toastNfcReadSuccess || 'Link copied from card successfully', 'success');
        }
    };

    window.onNfcLockSuccess = function() {
        if (nfcResetTimer) {
            clearTimeout(nfcResetTimer);
            nfcResetTimer = null;
        }
        permLockBatchCount += 1;
        const dict = getDict();

        if (!window.AndroidNative && navigator.vibrate) {
            try { navigator.vibrate([140, 70, 180]); } catch (e) {}
        }

        const nfcOverlay = document.getElementById('nfcOverlay');
        const nfcModalBox = document.getElementById('nfcModalBox');
        const isModalOpen = nfcOverlay && nfcOverlay.classList.contains('active');
        if (isModalOpen) {
            setNfcModalState('perm_lock_standby', permLockBatchCount);
            if (nfcModalBox) {
                nfcModalBox.classList.remove('perm-lock-thump');
                void nfcModalBox.offsetWidth;
                nfcModalBox.classList.add('perm-lock-thump');
                if (permThumpTimer) clearTimeout(permThumpTimer);
                permThumpTimer = setTimeout(() => {
                    if (nfcModalBox) nfcModalBox.classList.remove('perm-lock-thump');
                    permThumpTimer = null;
                }, 460);
            }
        }
    };

    window.onNfcPasswordSuccess = function(action) {
        if (nfcResetTimer) {
            clearTimeout(nfcResetTimer);
            nfcResetTimer = null;
        }
        const dict = getDict();
        const nfcOverlay = document.getElementById('nfcOverlay');
        const isModalOpen = nfcOverlay && nfcOverlay.classList.contains('active');
        if (isModalOpen) {
            let detail = 'PWD_UNLOCK';
            if (action === 'LOCKED') detail = 'PWD_LOCK';
            else if (action === 'ALREADY_UNLOCKED') detail = 'ALREADY_UNLOCKED';
            setNfcModalState('success', detail);
        } else {
            let msg = dict.toastNfcPwdUnlockSuccess || 'Card unlocked successfully';
            if (action === 'LOCKED') msg = dict.toastNfcPwdLockSuccess || 'Card locked with PIN';
            else if (action === 'ALREADY_UNLOCKED') msg = dict.toastNfcAlreadyUnlocked || 'Card is already unlocked';
            if (window.showToast) window.showToast(msg, 'success');
        }
    };

    window.onNfcError = function(errorType) {
        const nfcOverlay = document.getElementById('nfcOverlay');
        const isModalOpen = nfcOverlay && nfcOverlay.classList.contains('active');
        if (isModalOpen) {
            setNfcModalState('error', errorType);
        } else {
            const dict = getDict();
            let msg = dict.nfcWriteFailed || 'Operation failed';
            if (errorType === 'NOT_SUPPORTED' || errorType === 'NO_HARDWARE') msg = dict.nfcNoHardware;
            else if (errorType === 'DISABLED') msg = dict.nfcDisabled;
            else if (errorType === 'TAG_LOST') msg = dict.nfcDescTagLost;
            else if (errorType === 'LOCKED') msg = dict.nfcDescLocked;
            else if (errorType === 'READ_LOCKED') msg = dict.nfcDescReadLocked;
            else if (errorType === 'CANNOT_LOCK') msg = dict.nfcDescCannotLock || dict.nfcDescLocked;
            else if (errorType === 'CAPACITY') msg = dict.nfcCapacity;
            else if (errorType === 'UNSUPPORTED') msg = dict.nfcUnsupported;
            else if (errorType === 'EMPTY_TAG') msg = dict.toastNfcReadEmpty || 'Tag is empty';
            else if (errorType === 'WRONG_PWD') msg = dict.toastNfcWrongPwd || 'Incorrect PIN';
            else if (errorType === 'PWD_UNSUPPORTED') msg = dict.toastNfcPwdUnsupported || 'PIN protection is not supported on this card';
            else if (errorType === 'ALREADY_LOCKED') msg = dict.toastNfcAlreadyLocked || 'Card is already locked with a PIN';
            else if (errorType === 'MISSING_PIN') msg = dict.toastEnterPwd || 'Please enter a password or PIN';
            else if (errorType === 'LOCK_FAILED') msg = dict.nfcDescCannotLock || dict.nfcDescLocked || 'Locking failed on this tag';
            if (window.showToast) window.showToast(msg, 'error');
        }
    };

    window.onNfcSessionPaused = function() {
        const nfcOverlay = document.getElementById('nfcOverlay');
        if (!nfcOverlay || !nfcOverlay.classList.contains('active')) return;
        if (lastNfcOperation === 'perm_lock' && permLockBatchCount > 0) {
            setNfcModalState('perm_lock_standby', permLockBatchCount);
        } else if (currentModalState !== 'error' && currentModalState !== 'success' && currentModalState !== 'perm_lock_standby') {
            closeNfcModal();
        }
    };

    window.refreshActiveNfcModalStrings = function() {
        const nfcOverlay = document.getElementById('nfcOverlay');
        if (nfcOverlay && nfcOverlay.classList.contains('active')) {
            setNfcModalState(currentModalState, currentModalDetail);
        }
    };

    document.addEventListener('DOMContentLoaded', () => {
        const nfcRetryBtn = document.getElementById('nfcRetryBtn');
        if (nfcRetryBtn) {
            nfcRetryBtn.addEventListener('click', () => {
                if (lastNfcOperation === 'write') {
                    startNfcWrite(null, { skipOpenAnimation: true });
                } else if (lastNfcOperation === 'read') {
                    startNfcRead(null, { skipOpenAnimation: true });
                } else if (lastNfcOperation === 'perm_lock') {
                    startNfcPermanentLock(null, { skipOpenAnimation: true, preserveCount: true });
                } else if (lastNfcOperation === 'pwd_lock') {
                    startNfcPasswordLock(lastNfcPin, null, { skipOpenAnimation: true });
                } else if (lastNfcOperation === 'pwd_unlock') {
                    startNfcPasswordUnlock(lastNfcPin, null, { skipOpenAnimation: true });
                } else if (lastNfcOperation === 'write_wifi') {
                    if (window.retryNfcWifiWrite) {
                        window.retryNfcWifiWrite();
                    }
                } else {
                    startNfcWrite(null, { skipOpenAnimation: true });
                }
            });
        }

        const nfcNextBtn = document.getElementById('nfcNextBtn');
        if (nfcNextBtn) {
            nfcNextBtn.addEventListener('click', () => {
                if (lastNfcOperation === 'pwd_lock') {
                    if (lastNfcPin) startNfcPasswordLock(lastNfcPin, null, { skipOpenAnimation: true });
                } else if (lastNfcOperation === 'pwd_unlock') {
                    if (lastNfcPin) startNfcPasswordUnlock(lastNfcPin, null, { skipOpenAnimation: true });
                } else if (lastNfcOperation === 'write_wifi') {
                    if (window.retryNfcWifiWrite) {
                        window.retryNfcWifiWrite();
                    }
                } else if (lastNfcOperation === 'write') {
                    if (nfcResetTimer) {
                        clearTimeout(nfcResetTimer);
                        nfcResetTimer = null;
                    }
                    startNfcWrite(null, { skipOpenAnimation: true, resetBatch: false });
                }
            });
        }

        const nfcWaveContainer = document.getElementById('nfcWaveContainer');
        const nfcStatusIcon = document.getElementById('nfcStatusIcon');
        const rearmTarget = nfcWaveContainer || nfcStatusIcon;
        if (rearmTarget) {
            rearmTarget.addEventListener('click', (e) => {
                if (!isPermLockStandby) return;
                e.preventDefault();
                e.stopPropagation();
                rearmSequentialPermLock();
            });
        }
        if (nfcStatusIcon) {
            nfcStatusIcon.addEventListener('keydown', (e) => {
                if (!isPermLockStandby) return;
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    rearmSequentialPermLock();
                }
            });
        }
    });

    window.openNfcModal = openNfcModal;
    window.closeNfcModal = closeNfcModal;
    window.handleNfcCancelOrBack = handleNfcCancelOrBack;
    window.isNfcBackToPinActive = function() { return shouldReturnToPwdModal; };
    window.startNfcWrite = startNfcWrite;
    window.startNfcWifiWrite = startNfcWifiWrite;
    window.startNfcRead = startNfcRead;
    window.startNfcPermanentLock = startNfcPermanentLock;
    window.startNfcPasswordLock = startNfcPasswordLock;
    window.startNfcPasswordUnlock = startNfcPasswordUnlock;
    window.setNfcModalState = setNfcModalState;
})();
