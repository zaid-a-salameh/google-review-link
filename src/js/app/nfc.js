// ========================================================
// Native Android Hardware NFC Tag Writing Engine
// ========================================================
(function() {
    'use strict';

        // ── 5. NFC Write Action ──
        let nfcBatchCount = 0;
        let nfcResetTimer = null;

        function setNfcModalState(state, count = 0) {
            const dict = I18N[currentLang];
            if (state === 'ready') {
                nfcModalBox.classList.remove('success');
                nfcTitle.textContent = dict.nfcTitleReady;
                nfcDesc.textContent = dict.nfcDescReady;
                nfcCancelBtn.textContent = dict.nfcCancel;
                nfcCounterBadge.style.display = 'none';
                nfcSvgIcon.innerHTML = `
                    <path d="M4.5 10.5C3.67 10.5 3 11.17 3 12s.67 1.5 1.5 1.5S6 12.83 6 12s-.67-1.5-1.5-1.5zm4.8 0c-.83 0-1.5.67-1.5 1.5s.67 1.5 1.5 1.5 1.5-.67 1.5-1.5-.67-1.5-1.5-1.5zm4.8 0c-.83 0-1.5.67-1.5 1.5s.67 1.5 1.5 1.5 1.5-.67 1.5-1.5-.67-1.5-1.5-1.5zm4.8 0c-.83 0-1.5.67-1.5 1.5s.67 1.5 1.5 1.5 1.5-.67 1.5-1.5-.67-1.5-1.5-1.5z"/>
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8 0-.55.45-1 1-1s1 .45 1 1c0 3.31 2.69 6 6 6s6-2.69 6-6c0-.55.45-1 1-1s1 .45 1 1c0 4.41-3.59 8-8 8z"/>
                `;
            } else if (state === 'success') {
                nfcModalBox.classList.add('success');
                nfcTitle.textContent = dict.nfcTitleSuccess;
                nfcDesc.textContent = (dict.nfcDescSuccess || '').replace('{count}', count);
                nfcCancelBtn.textContent = dict.nfcDone;
                nfcCounterBadge.style.display = 'inline-flex';
                nfcCounterText.textContent = (dict.nfcCardsCount || '').replace('{count}', count);
                nfcSvgIcon.innerHTML = `<path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41L9 16.17z"/>`;
            } else if (state === 'next') {
                nfcModalBox.classList.remove('success');
                nfcTitle.textContent = dict.nfcTitleNext;
                nfcDesc.textContent = dict.nfcDescNext;
                nfcCancelBtn.textContent = dict.nfcDone;
                nfcCounterBadge.style.display = 'inline-flex';
                nfcCounterText.textContent = (dict.nfcCardsCount || '').replace('{count}', count);
                nfcSvgIcon.innerHTML = `
                    <path d="M4.5 10.5C3.67 10.5 3 11.17 3 12s.67 1.5 1.5 1.5S6 12.83 6 12s-.67-1.5-1.5-1.5zm4.8 0c-.83 0-1.5.67-1.5 1.5s.67 1.5 1.5 1.5 1.5-.67 1.5-1.5-.67-1.5-1.5-1.5zm4.8 0c-.83 0-1.5.67-1.5 1.5s.67 1.5 1.5 1.5 1.5-.67 1.5-1.5-.67-1.5-1.5-1.5zm4.8 0c-.83 0-1.5.67-1.5 1.5s.67 1.5 1.5 1.5 1.5-.67 1.5-1.5-.67-1.5-1.5-1.5z"/>
                    <path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8 0-.55.45-1 1-1s1 .45 1 1c0 3.31 2.69 6 6 6s6-2.69 6-6c0-.55.45-1 1-1s1 .45 1 1c0 4.41-3.59 8-8 8z"/>
                `;
            }
        }

        function openNfcModal() {
            nfcBatchCount = 0;
            if (nfcResetTimer) {
                clearTimeout(nfcResetTimer);
                nfcResetTimer = null;
            }
            setNfcModalState('ready');
            nfcOverlay.classList.add('active');
        }

        function closeNfcModal() {
            if (nfcResetTimer) {
                clearTimeout(nfcResetTimer);
                nfcResetTimer = null;
            }
            nfcOverlay.classList.remove('active');
            if (window.AndroidNative && window.AndroidNative.cancelNfcWrite) {
                window.AndroidNative.cancelNfcWrite();
            }
            const dict = I18N[currentLang];
            if (nfcBatchCount > 0) {
                const toastMsg = (dict.toastNfcBatchSuccess || '').replace('{count}', nfcBatchCount);
                showToast(toastMsg, 'success');
            }
        }

        nfcBtn.addEventListener('click', () => {
            if (!generatedReviewUrl) return;
            const dict = I18N[currentLang];

            if (window.AndroidNative && window.AndroidNative.startNfcWrite) {
                openNfcModal();
                window.AndroidNative.startNfcWrite(generatedReviewUrl);
            } else if ('NDEFReader' in window) {
                // Web NFC API fallback (supported in Chrome for Android)
                openNfcModal();
                const ndef = new NDEFReader();
                ndef.write({
                    records: [{ recordType: "url", data: generatedReviewUrl }]
                }, { overwrite: true }).then(() => {
                    window.onNfcSuccess(1);
                }).catch(err => {
                    window.onNfcError('WRITE_FAILED');
                });
            } else {
                showToast(dict.nfcNoHardware, 'warn');
            }
        });

        nfcCancelBtn.addEventListener('click', closeNfcModal);

        // Bridge Callbacks from Android Native
        window.onNfcSuccess = function(count) {
            nfcBatchCount = typeof count === 'number' && count > 0 ? count : (nfcBatchCount + 1);
            setNfcModalState('success', nfcBatchCount);
            
            if (nfcResetTimer) clearTimeout(nfcResetTimer);
            nfcResetTimer = setTimeout(() => {
                setNfcModalState('next', nfcBatchCount);
            }, 2000);
        };

        window.onNfcError = function(code) {
            const dict = I18N[currentLang];
            if (code === 'NO_HARDWARE') {
                closeNfcModal();
                showToast(dict.nfcNoHardware, 'warn');
                return;
            }
            if (code === 'DISABLED') {
                closeNfcModal();
                showToast(dict.nfcDisabled, 'warn');
                return;
            }

            let msg = dict.nfcWriteFailed;
            if (code === 'LOCKED') msg = dict.nfcLocked;
            else if (code === 'CAPACITY') msg = dict.nfcCapacity;
            else if (code === 'UNSUPPORTED') msg = dict.nfcUnsupported;

            nfcModalBox.classList.remove('success');
            nfcTitle.textContent = dict.nfcTitleError;
            nfcDesc.textContent = msg;
            showToast(msg, 'error');

            if (nfcResetTimer) clearTimeout(nfcResetTimer);
            nfcResetTimer = setTimeout(() => {
                if (nfcBatchCount > 0) {
                    setNfcModalState('next', nfcBatchCount);
                } else {
                    setNfcModalState('ready');
                }
            }, 2200);
        };

        window.onNfcCancelled = function() {
            closeNfcModal();
        };

    window.openNfcModal = openNfcModal;
    window.closeNfcModal = closeNfcModal;
    window.setNfcModalState = setNfcModalState;
})();
