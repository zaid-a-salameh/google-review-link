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
        } else if (state === 'success') {
            if (nfcModalBox) nfcModalBox.classList.add('success');
            if (nfcTitle) nfcTitle.textContent = dict.nfcTitleSuccess;
            if (nfcDesc) nfcDesc.textContent = (dict.nfcDescSuccess || '').replace('{count}', count);
            if (nfcCancelBtn) nfcCancelBtn.textContent = dict.nfcDone;
            if (nfcCounterBadge) nfcCounterBadge.style.display = 'inline-flex';
            if (nfcCounterText) nfcCounterText.textContent = (dict.nfcCardsCount || '').replace('{count}', count);
            if (nfcSvgIcon) nfcSvgIcon.innerHTML = `<path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41L9 16.17z"/>`;
        } else if (state === 'next') {
            if (nfcModalBox) nfcModalBox.classList.remove('success');
            if (nfcTitle) nfcTitle.textContent = dict.nfcTitleNext;
            if (nfcDesc) nfcDesc.textContent = dict.nfcDescNext;
            if (nfcCancelBtn) nfcCancelBtn.textContent = dict.nfcDone;
            if (nfcCounterBadge) nfcCounterBadge.style.display = 'inline-flex';
            if (nfcCounterText) nfcCounterText.textContent = (dict.nfcCardsCount || '').replace('{count}', count);
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

    // Bridge Callbacks from Android Native
    window.onNfcSuccess = function(count) {
        nfcBatchCount = typeof count === 'number' && count > 0 ? count : (nfcBatchCount + 1);
        window.nfcBatchCount = nfcBatchCount;
        setNfcModalState('success', nfcBatchCount);

        const dict = getDict();
        if (window.showToast) window.showToast(dict.toastNfcWritten || 'NFC Written', 'success');

        if (nfcResetTimer) clearTimeout(nfcResetTimer);
        nfcResetTimer = setTimeout(() => {
            setNfcModalState('next', nfcBatchCount);
        }, 1500);
    };

    window.onNfcError = function(errorType) {
        const dict = getDict();
        let msg = dict.nfcWriteFailed || 'Write failed';
        if (errorType === 'NOT_SUPPORTED') msg = dict.nfcNoHardware;
        else if (errorType === 'DISABLED') msg = dict.nfcDisabled;
        else if (errorType === 'LOCKED') msg = dict.nfcLocked;
        else if (errorType === 'CAPACITY') msg = dict.nfcCapacity;
        else if (errorType === 'UNSUPPORTED') msg = dict.nfcUnsupported;

        if (window.showToast) window.showToast(msg, 'error');
    };

    window.openNfcModal = openNfcModal;
    window.closeNfcModal = closeNfcModal;
    window.startNfcWrite = startNfcWrite;
    window.setNfcModalState = setNfcModalState;
})();
