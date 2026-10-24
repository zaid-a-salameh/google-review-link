// ========================================================
// Native Android Hardware NFC Tag Writing Engine
// ========================================================
(function() {
    'use strict';

    let nfcBatchCount = 0;
    let nfcResetTimer = null;

    function getDict() {
        const lang = window.getCurrentLang ? window.getCurrentLang() : 'en';
        return (window.I18N && window.I18N[lang]) ? window.I18N[lang] : {};
    }

    function setNfcModalState(state, count = 0) {
        const dict = getDict();
        const nfcModalBox = document.getElementById('nfcModalBox');
        const nfcTitle = document.getElementById('nfcTitle');
        const nfcDesc = document.getElementById('nfcDesc');
        const nfcCancelBtn = document.getElementById('nfcCancelBtn');
        const nfcCounterBadge = document.getElementById('nfcCounterBadge');
        const nfcCounterText = document.getElementById('nfcCounterText');
        const nfcSvgIcon = document.getElementById('nfcSvgIcon');

        if (state === 'ready') {
            if (nfcModalBox) nfcModalBox.classList.remove('success');
            if (nfcTitle) nfcTitle.textContent = dict.nfcTitleReady;
            if (nfcDesc) nfcDesc.textContent = dict.nfcDescReady;
            if (nfcCancelBtn) nfcCancelBtn.textContent = dict.nfcCancel;
            if (nfcCounterBadge) nfcCounterBadge.style.display = 'none';
            if (nfcSvgIcon) nfcSvgIcon.innerHTML = `
                <path d="M4.5 10.5C3.67 10.5 3 11.17 3 12s.67 1.5 1.5 1.5S6 12.83 6 12s-.67-1.5-1.5-1.5zm4.8 0c-.83 0-1.5.67-1.5 1.5s.67 1.5 1.5 1.5 1.5-.67 1.5-1.5-.67-1.5-1.5-1.5zm4.8 0c-.83 0-1.5.67-1.5 1.5s.67 1.5 1.5 1.5 1.5-.67 1.5-1.5-.67-1.5-1.5-1.5zm4.8 0c-.83 0-1.5.67-1.5 1.5s.67 1.5 1.5 1.5 1.5-.67 1.5-1.5-.67-1.5-1.5-1.5z"/>
                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8 0-.55.45-1 1-1s1 .45 1 1c0 3.31 2.69 6 6 6s6-2.69 6-6c0-.55.45-1 1-1s1 .45 1 1c0 4.41-3.59 8-8 8z"/>
            `;
        } else if (state === 'read_ready') {
            if (nfcModalBox) nfcModalBox.classList.remove('success');
            if (nfcTitle) nfcTitle.textContent = dict.nfcTitleReadReady || 'Ready to Read Card';
            if (nfcDesc) nfcDesc.textContent = dict.nfcDescReadReady || 'Hold phone near NFC card to read its content...';
            if (nfcCancelBtn) nfcCancelBtn.textContent = dict.nfcCancel;
            if (nfcCounterBadge) nfcCounterBadge.style.display = 'none';
            if (nfcSvgIcon) nfcSvgIcon.innerHTML = `
                <path d="M19 3H5c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V5c0-1.1-.9-2-2-2zm-5 14H7v-2h7v2zm3-4H7v-2h10v2zm0-4H7V7h10v2z"/>
            `;
        } else if (state === 'perm_lock_ready') {
            if (nfcModalBox) nfcModalBox.classList.remove('success');
            if (nfcTitle) nfcTitle.textContent = dict.nfcTitlePermLockReady || 'Ready to Lock';
            if (nfcDesc) nfcDesc.textContent = dict.nfcDescPermLockReady || 'Hold phone near NFC card to apply permanent lock...';
            if (nfcCancelBtn) nfcCancelBtn.textContent = dict.nfcCancel;
            if (nfcCounterBadge) nfcCounterBadge.style.display = 'none';
            if (nfcSvgIcon) nfcSvgIcon.innerHTML = `
                <path d="M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm0 10.99h7c-.53 4.12-3.28 7.79-7 8.94V12H5V6.3l7-3.11v8.8z"/>
            `;
        } else if (state === 'pwd_lock_ready' || state === 'pwd_unlock_ready') {
            if (nfcModalBox) nfcModalBox.classList.remove('success');
            if (nfcTitle) nfcTitle.textContent = state === 'pwd_lock_ready' ? (dict.nfcTitlePwdLockReady || 'Ready to Set PIN') : (dict.nfcTitlePwdUnlockReady || 'Ready to Unlock');
            if (nfcDesc) nfcDesc.textContent = state === 'pwd_lock_ready' ? (dict.nfcDescPwdLockReady || 'Hold phone near card to lock...') : (dict.nfcDescPwdUnlockReady || 'Hold phone near card to unlock...');
            if (nfcCancelBtn) nfcCancelBtn.textContent = dict.nfcCancel;
            if (nfcCounterBadge) nfcCounterBadge.style.display = 'none';
            if (nfcSvgIcon) nfcSvgIcon.innerHTML = `
                <path d="M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z"/>
            `;
        } else if (state === 'success') {
            if (nfcModalBox) {
                nfcModalBox.classList.remove('morph-to-ready');
                nfcModalBox.classList.add('success');
            }
            if (nfcTitle) nfcTitle.textContent = dict.nfcTitleSuccess;
            if (nfcDesc) nfcDesc.textContent = dict.nfcDescSuccess || '';
            if (nfcCancelBtn) nfcCancelBtn.textContent = dict.nfcDone;
            if (nfcCounterBadge) nfcCounterBadge.style.display = 'none';
            if (nfcSvgIcon) nfcSvgIcon.innerHTML = `<path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41L9 16.17z"/>`;
        } else if (state === 'next') {
            if (nfcModalBox) {
                nfcModalBox.classList.add('morph-to-ready');
                setTimeout(() => {
                    if (nfcModalBox) {
                        nfcModalBox.classList.remove('success');
                        nfcModalBox.classList.remove('morph-to-ready');
                    }
                }, 300);
            }
            if (nfcTitle) nfcTitle.textContent = dict.nfcTitleNext;
            if (nfcDesc) nfcDesc.textContent = dict.nfcDescNext;
            if (nfcCancelBtn) nfcCancelBtn.textContent = dict.nfcDone;
            if (nfcCounterBadge) nfcCounterBadge.style.display = 'none';
            if (nfcSvgIcon) nfcSvgIcon.innerHTML = `
                <path d="M4.5 10.5C3.67 10.5 3 11.17 3 12s.67 1.5 1.5 1.5S6 12.83 6 12s-.67-1.5-1.5-1.5zm4.8 0c-.83 0-1.5.67-1.5 1.5s.67 1.5 1.5 1.5 1.5-.67 1.5-1.5-.67-1.5-1.5-1.5zm4.8 0c-.83 0-1.5.67-1.5 1.5s.67 1.5 1.5 1.5 1.5-.67 1.5-1.5-.67-1.5-1.5-1.5zm4.8 0c-.83 0-1.5.67-1.5 1.5s.67 1.5 1.5 1.5 1.5-.67 1.5-1.5-.67-1.5-1.5-1.5z"/>
                <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8 0-.55.45-1 1-1s1 .45 1 1c0 3.31 2.69 6 6 6s6-2.69 6-6c0-.55.45-1 1-1s1 .45 1 1c0 4.41-3.59 8-8 8z"/>
            `;
        }
    }

    function openNfcModal() {
        nfcBatchCount = 0;
        window.nfcBatchCount = 0;
        if (nfcResetTimer) {
            clearTimeout(nfcResetTimer);
            nfcResetTimer = null;
        }
        setNfcModalState('ready');
        const nfcOverlay = document.getElementById('nfcOverlay');
        if (nfcOverlay) nfcOverlay.classList.add('active');
    }

    function closeNfcModal() {
        if (nfcResetTimer) {
            clearTimeout(nfcResetTimer);
            nfcResetTimer = null;
        }
        const nfcOverlay = document.getElementById('nfcOverlay');
        if (nfcOverlay) nfcOverlay.classList.remove('active');

        if (window.AndroidNative && window.AndroidNative.cancelNfcWrite) {
            window.AndroidNative.cancelNfcWrite();
        }

        const dict = getDict();
        if (nfcBatchCount > 0 && window.showToast) {
            const toastMsg = (dict.toastNfcBatchSuccess || '').replace('{count}', nfcBatchCount);
            window.showToast(toastMsg, 'success');
        }
    }

    function startNfcWrite() {
        const url = window.getGeneratedReviewUrl ? window.getGeneratedReviewUrl() : '';
        if (!url) return;
        const dict = getDict();

        if (window.AndroidNative && window.AndroidNative.startNfcWrite) {
            openNfcModal();
            window.AndroidNative.startNfcWrite(url);
        } else if ('NDEFReader' in window) {
            openNfcModal();
            const ndef = new NDEFReader();
            ndef.write({
                records: [{ recordType: "url", data: url }]
            }, { overwrite: true }).then(() => {
                if (window.onNfcSuccess) window.onNfcSuccess(1);
            }).catch(() => {
                if (window.onNfcError) window.onNfcError('WRITE_FAILED');
            });
        } else {
            if (window.showToast) window.showToast(dict.nfcNoHardware || 'NFC not supported', 'warn');
        }
    }

    function startNfcRead() {
        const dict = getDict();
        if (window.AndroidNative && window.AndroidNative.startNfcRead) {
            setNfcModalState('read_ready');
            const nfcOverlay = document.getElementById('nfcOverlay');
            if (nfcOverlay) nfcOverlay.classList.add('active');
            window.AndroidNative.startNfcRead();
        } else {
            if (window.showToast) window.showToast(dict.nfcNoHardware || 'NFC not supported', 'warn');
        }
    }

    function startNfcPermanentLock() {
        const dict = getDict();
        if (window.AndroidNative && window.AndroidNative.startNfcPermanentLock) {
            setNfcModalState('perm_lock_ready');
            const nfcOverlay = document.getElementById('nfcOverlay');
            if (nfcOverlay) nfcOverlay.classList.add('active');
            window.AndroidNative.startNfcPermanentLock();
        } else {
            if (window.showToast) window.showToast(dict.nfcNoHardware || 'NFC not supported', 'warn');
        }
    }

    function startNfcPasswordLock(pin) {
        const dict = getDict();
        if (!pin || pin.length < 4) return;
        if (window.AndroidNative && window.AndroidNative.startNfcPasswordLock) {
            setNfcModalState('pwd_lock_ready');
            const nfcOverlay = document.getElementById('nfcOverlay');
            if (nfcOverlay) nfcOverlay.classList.add('active');
            window.AndroidNative.startNfcPasswordLock(pin);
        } else {
            if (window.showToast) window.showToast(dict.nfcNoHardware || 'NFC not supported', 'warn');
        }
    }

    function startNfcPasswordUnlock(pin) {
        const dict = getDict();
        if (!pin || pin.length < 4) return;
        if (window.AndroidNative && window.AndroidNative.startNfcPasswordUnlock) {
            setNfcModalState('pwd_unlock_ready');
            const nfcOverlay = document.getElementById('nfcOverlay');
            if (nfcOverlay) nfcOverlay.classList.add('active');
            window.AndroidNative.startNfcPasswordUnlock(pin);
        } else {
            if (window.showToast) window.showToast(dict.nfcNoHardware || 'NFC not supported', 'warn');
        }
    }

    // Bridge Callbacks from Android Native
    window.onNfcSuccess = function(count) {
        nfcBatchCount = typeof count === 'number' && count > 0 ? count : (nfcBatchCount + 1);
        window.nfcBatchCount = nfcBatchCount;
        
        // Haptic feedback trigger (gentle vibration)
        if (window.AndroidNative && typeof window.AndroidNative.triggerHapticFeedback === 'function') {
            try { window.AndroidNative.triggerHapticFeedback(); } catch (e) {}
        } else if (navigator.vibrate) {
            try { navigator.vibrate([140, 70, 180]); } catch (e) {}
        }

        setNfcModalState('success', nfcBatchCount);

        const dict = getDict();
        if (window.showToast) window.showToast(dict.toastNfcWritten || 'NFC Written', 'success');

        if (nfcResetTimer) clearTimeout(nfcResetTimer);
        nfcResetTimer = setTimeout(() => {
            setNfcModalState('next', nfcBatchCount);
        }, 1500);
    };

    window.onNfcTagRead = function(url) {
        if (!url) return;
        const dict = getDict();
        const urlInput = document.getElementById('urlInput');
        if (urlInput) {
            urlInput.value = url;
        }

        const nfcOverlay = document.getElementById('nfcOverlay');
        if (nfcOverlay) nfcOverlay.classList.remove('active');

        if (window.handleDirectUrlInput) {
            window.handleDirectUrlInput(url);
        }

        if (window.showToast) {
            window.showToast(dict.toastNfcReadSuccess || 'Link copied from card successfully', 'success');
        }
    };

    window.onNfcLockSuccess = function() {
        const dict = getDict();
        const nfcOverlay = document.getElementById('nfcOverlay');
        if (nfcOverlay) nfcOverlay.classList.remove('active');
        if (window.showToast) {
            window.showToast(dict.toastNfcPermLockSuccess || 'Card permanently locked to Read-Only', 'success');
        }
    };

    window.onNfcPasswordSuccess = function(action) {
        const dict = getDict();
        const nfcOverlay = document.getElementById('nfcOverlay');
        if (nfcOverlay) nfcOverlay.classList.remove('active');
        if (window.showToast) {
            const msg = action === 'LOCKED' ? (dict.toastNfcPwdLockSuccess || 'Card locked with PIN') : (dict.toastNfcPwdUnlockSuccess || 'Card unlocked successfully');
            window.showToast(msg, 'success');
        }
    };

    window.onNfcError = function(errorType) {
        const dict = getDict();
        let msg = dict.nfcWriteFailed || 'Operation failed';
        if (errorType === 'NOT_SUPPORTED') msg = dict.nfcNoHardware;
        else if (errorType === 'DISABLED') msg = dict.nfcDisabled;
        else if (errorType === 'LOCKED') msg = dict.nfcLocked;
        else if (errorType === 'CAPACITY') msg = dict.nfcCapacity;
        else if (errorType === 'UNSUPPORTED') msg = dict.nfcUnsupported;
        else if (errorType === 'EMPTY_TAG') msg = dict.toastNfcReadEmpty || 'Tag is empty';
        else if (errorType === 'WRONG_PWD') msg = dict.toastNfcWrongPwd || 'Incorrect PIN';
        else if (errorType === 'PWD_UNSUPPORTED') msg = 'NTAG security not supported on this tag';
        else if (errorType === 'LOCK_FAILED' || errorType === 'CANNOT_LOCK') msg = 'Locking failed on this tag';

        const nfcOverlay = document.getElementById('nfcOverlay');
        if (nfcOverlay) nfcOverlay.classList.remove('active');

        if (window.showToast) window.showToast(msg, 'error');
    };

    window.openNfcModal = openNfcModal;
    window.closeNfcModal = closeNfcModal;
    window.startNfcWrite = startNfcWrite;
    window.startNfcRead = startNfcRead;
    window.startNfcPermanentLock = startNfcPermanentLock;
    window.startNfcPasswordLock = startNfcPasswordLock;
    window.startNfcPasswordUnlock = startNfcPasswordUnlock;
    window.setNfcModalState = setNfcModalState;
})();
