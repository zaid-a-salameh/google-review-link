// ========================================================
// Native Android Hardware NFC Tag Writing Engine
// ========================================================
(function() {
    'use strict';

    let nfcBatchCount = 0;
    let nfcResetTimer = null;
    let lastNfcOperation = 'write';
    let lastNfcPin = '';

    function getDict() {
        const lang = window.getCurrentLang ? window.getCurrentLang() : 'en';
        return (window.I18N && window.I18N[lang]) ? window.I18N[lang] : {};
    }

    function setNfcModalState(state, detail = null) {
        const dict = getDict();
        const nfcModalBox = document.getElementById('nfcModalBox');
        const nfcTitle = document.getElementById('nfcTitle');
        const nfcDesc = document.getElementById('nfcDesc');
        const nfcCancelBtn = document.getElementById('nfcCancelBtn');
        const nfcRetryBtn = document.getElementById('nfcRetryBtn');
        const nfcCounterBadge = document.getElementById('nfcCounterBadge');
        const nfcCounterText = document.getElementById('nfcCounterText');
        const nfcSvgIcon = document.getElementById('nfcSvgIcon');

        if (nfcModalBox && state !== 'error') {
            nfcModalBox.classList.remove('error');
        }
        if (nfcRetryBtn && state !== 'error') {
            nfcRetryBtn.style.display = 'none';
        }

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
                nfcModalBox.classList.remove('error');
                nfcModalBox.classList.add('success');
            }
            if (detail === 'PWD_UNLOCK') {
                if (nfcTitle) nfcTitle.textContent = dict.nfcTitlePwdUnlockSuccess || 'Card Unlocked Successfully';
                if (nfcDesc) nfcDesc.textContent = dict.nfcDescPwdUnlockSuccess || 'Card protection removed. You can now write or edit the card.';
                if (nfcCancelBtn) nfcCancelBtn.textContent = dict.nfcOk || 'OK';
            } else if (detail === 'ALREADY_UNLOCKED') {
                if (nfcTitle) nfcTitle.textContent = dict.nfcTitleAlreadyUnlocked || 'Card Is Not Locked';
                if (nfcDesc) nfcDesc.textContent = dict.nfcDescAlreadyUnlocked || 'This card does not have password protection enabled.';
                if (nfcCancelBtn) nfcCancelBtn.textContent = dict.nfcOk || 'OK';
            } else if (detail === 'PWD_LOCK') {
                if (nfcTitle) nfcTitle.textContent = dict.nfcTitlePwdLockSuccess || 'Card Locked Successfully';
                if (nfcDesc) nfcDesc.textContent = dict.nfcDescPwdLockSuccess || 'PIN protection enabled. Card modifications are locked.';
                if (nfcCancelBtn) nfcCancelBtn.textContent = dict.nfcOk || 'OK';
            } else if (detail === 'PERM_LOCK') {
                if (nfcTitle) nfcTitle.textContent = dict.nfcTitlePermLockSuccess || 'Card Permanently Locked';
                if (nfcDesc) nfcDesc.textContent = dict.nfcDescPermLockSuccess || 'Card permanently locked to Read-Only mode.';
                if (nfcCancelBtn) nfcCancelBtn.textContent = dict.nfcOk || 'OK';
            } else {
                if (nfcTitle) nfcTitle.textContent = dict.nfcTitleSuccess;
                if (nfcDesc) nfcDesc.textContent = dict.nfcDescSuccess || '';
                if (nfcCancelBtn) nfcCancelBtn.textContent = dict.nfcDone;
            }
            if (nfcCounterBadge) nfcCounterBadge.style.display = 'none';
            if (nfcRetryBtn) nfcRetryBtn.style.display = 'none';
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
        } else if (state === 'error') {
            if (nfcModalBox) {
                nfcModalBox.classList.remove('morph-to-ready');
                nfcModalBox.classList.remove('success');
                nfcModalBox.classList.add('error');
            }
            if (nfcTitle) {
                if (detail === 'TAG_LOST') nfcTitle.textContent = dict.nfcTitleTagLost || 'Connection Dropped';
                else if (detail === 'LOCKED') nfcTitle.textContent = dict.nfcTitleLocked || 'Card is Protected';
                else if (detail === 'READ_LOCKED') nfcTitle.textContent = dict.nfcTitleReadLocked || 'Card is Read-Protected';
                else if (detail === 'WRONG_PWD') nfcTitle.textContent = dict.nfcTitleWrongPwd || 'Incorrect PIN';
                else if (detail === 'ALREADY_LOCKED') nfcTitle.textContent = dict.nfcTitleAlreadyLocked || 'Card Already Locked';
                else if (detail === 'CAPACITY') nfcTitle.textContent = dict.nfcTitleCapacity || 'Capacity Exceeded';
                else if (detail === 'EMPTY_TAG') nfcTitle.textContent = dict.nfcTitleEmptyTag || 'Empty Card';
                else nfcTitle.textContent = dict.nfcTitleError || 'Operation Failed';
            }

            let detailMsg = dict.nfcDescGenericError || 'Operation failed. Ensure the phone is held steady near the card.';
            if (detail === 'TAG_LOST') detailMsg = dict.nfcDescTagLost || 'Connection lost due to phone movement or weak NFC signal. Please hold the phone steadily over the card without moving it.';
            else if (detail === 'LOCKED') detailMsg = dict.nfcDescLocked || 'This card is locked with a password or read-only and cannot be modified. Please unlock it first.';
            else if (detail === 'READ_LOCKED') detailMsg = dict.nfcDescReadLocked || 'Cannot read card data because it is password-protected.';
            else if (detail === 'CAPACITY') detailMsg = dict.nfcDescCapacity || 'Link size exceeds this card\'s memory capacity.';
            else if (detail === 'UNSUPPORTED') detailMsg = dict.nfcDescUnsupported || 'This card type is not supported for writing.';
            else if (detail === 'EMPTY_TAG') detailMsg = dict.toastNfcReadEmpty || 'No valid URL found on this card.';
            else if (detail === 'WRONG_PWD') detailMsg = dict.toastNfcWrongPwd || 'Incorrect PIN. The card is protected with a different password.';
            else if (detail === 'PWD_UNSUPPORTED') detailMsg = dict.toastNfcPwdUnsupported || 'PIN protection is not supported on this card.';
            else if (detail === 'ALREADY_LOCKED') detailMsg = dict.toastNfcAlreadyLocked || 'This card is already locked with a different PIN. Unlock it first.';

            if (nfcDesc) nfcDesc.textContent = detailMsg;
            if (nfcCounterBadge) nfcCounterBadge.style.display = 'none';
            if (nfcCancelBtn) nfcCancelBtn.textContent = dict.nfcCancel || 'Cancel';

            if (nfcRetryBtn) {
                nfcRetryBtn.style.display = 'inline-flex';
                const retryLabel = document.getElementById('nfcRetryBtnLabel');
                if (retryLabel) retryLabel.textContent = dict.nfcRetryBtn || 'Try Again';
            }

            if (nfcSvgIcon) {
                nfcSvgIcon.innerHTML = `<path d="M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z"/>`;
            }
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
        lastNfcOperation = 'write';

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
        lastNfcOperation = 'read';
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
        lastNfcOperation = 'perm_lock';
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
        if (!pin || !pin.trim()) return;
        lastNfcOperation = 'pwd_lock';
        lastNfcPin = pin;
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
        if (!pin || !pin.trim()) return;
        lastNfcOperation = 'pwd_unlock';
        lastNfcPin = pin;
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
        if (window.switchMode) {
            window.switchMode('link');
        }
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
        if (nfcResetTimer) {
            clearTimeout(nfcResetTimer);
            nfcResetTimer = null;
        }
        const dict = getDict();
        const nfcOverlay = document.getElementById('nfcOverlay');
        const isModalOpen = nfcOverlay && nfcOverlay.classList.contains('active');
        if (isModalOpen) {
            setNfcModalState('success', 'PERM_LOCK');
        } else {
            if (window.showToast) {
                window.showToast(dict.toastNfcPermLockSuccess || 'Card permanently locked to Read-Only', 'success');
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
            if (errorType === 'NOT_SUPPORTED') msg = dict.nfcNoHardware;
            else if (errorType === 'DISABLED') msg = dict.nfcDisabled;
            else if (errorType === 'TAG_LOST') msg = dict.nfcDescTagLost;
            else if (errorType === 'LOCKED') msg = dict.nfcDescLocked;
            else if (errorType === 'READ_LOCKED') msg = dict.nfcDescReadLocked;
            else if (errorType === 'CAPACITY') msg = dict.nfcCapacity;
            else if (errorType === 'UNSUPPORTED') msg = dict.nfcUnsupported;
            else if (errorType === 'EMPTY_TAG') msg = dict.toastNfcReadEmpty || 'Tag is empty';
            else if (errorType === 'WRONG_PWD') msg = dict.toastNfcWrongPwd || 'Incorrect PIN';
            else if (errorType === 'PWD_UNSUPPORTED') msg = dict.toastNfcPwdUnsupported || 'PIN protection is not supported on this card';
            else if (errorType === 'ALREADY_LOCKED') msg = dict.toastNfcAlreadyLocked || 'Card is already locked with a PIN';
            else if (errorType === 'LOCK_FAILED' || errorType === 'CANNOT_LOCK') msg = dict.nfcDescLocked || 'Locking failed on this tag';
            if (window.showToast) window.showToast(msg, 'error');
        }
    };

    document.addEventListener('DOMContentLoaded', () => {
        const nfcRetryBtn = document.getElementById('nfcRetryBtn');
        if (nfcRetryBtn) {
            nfcRetryBtn.addEventListener('click', () => {
                if (lastNfcOperation === 'write') {
                    startNfcWrite();
                } else if (lastNfcOperation === 'read') {
                    startNfcRead();
                } else if (lastNfcOperation === 'perm_lock') {
                    startNfcPermanentLock();
                } else if (lastNfcOperation === 'pwd_lock') {
                    startNfcPasswordLock(lastNfcPin);
                } else if (lastNfcOperation === 'pwd_unlock') {
                    startNfcPasswordUnlock(lastNfcPin);
                } else {
                    startNfcWrite();
                }
            });
        }
    });

    window.openNfcModal = openNfcModal;
    window.closeNfcModal = closeNfcModal;
    window.startNfcWrite = startNfcWrite;
    window.startNfcRead = startNfcRead;
    window.startNfcPermanentLock = startNfcPermanentLock;
    window.startNfcPasswordLock = startNfcPasswordLock;
    window.startNfcPasswordUnlock = startNfcPasswordUnlock;
    window.setNfcModalState = setNfcModalState;
})();
