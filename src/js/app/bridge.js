// ========================================================
// Native Android Bridge Callbacks & Interop
// ========================================================
(function() {
    'use strict';

    function getDict() {
        const lang = window.getCurrentLang ? window.getCurrentLang() : 'en';
        return (window.I18N && window.I18N[lang]) ? window.I18N[lang] : {};
    }

    // ── Native Bridge Callbacks ──
    window.onNativePaste = function(text) {
        const dict = getDict();
        const urlInput = document.getElementById('urlInput');
        if (text) {
            if (window.switchMode) window.switchMode('link');
            if (urlInput) {
                urlInput.value = text;
                urlInput.blur();
            }
            if (window.showToast) window.showToast(dict.toastPasted || 'Pasted', 'paste');
            if (window.handleConvert) window.handleConvert();
        } else {
            if (window.showToast) window.showToast(dict.toastEmptyClip || 'Clipboard is empty', 'warn');
        }
    };

    window.onApkUpdateError = function() {
        const dict = getDict();
        if (window.showToast) window.showToast(dict.toastUpdateError || 'Update error', 'error');
    };

    window.onSaveQrError = function() {
        const dict = getDict();
        if (window.showToast) window.showToast(dict.toastQrSaveError || 'Error saving QR', 'error');
    };
})();
