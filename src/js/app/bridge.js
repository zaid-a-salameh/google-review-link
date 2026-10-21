// ========================================================
// Native Android Bridge Callbacks & Interop
// ========================================================
(function() {
    'use strict';

        // ── Native Bridge Callbacks ──
        window.onNativePaste = function(text) {
            const dict = I18N[currentLang];
            if (text) {
                switchMode('link');
                urlInput.value = text;
                showToast(dict.toastPasted, 'paste');
                if (pendingAutoConvert) {
                    pendingAutoConvert = false;
                    handleConvert();
                }
            } else {
                showToast(dict.toastEmptyClip, 'warn');
            }
        };

        window.onApkUpdateError = function() {
            const dict = I18N[currentLang];
            showToast(dict.toastUpdateError, 'error');
        };

        window.onSaveQrError = function() {
            const dict = I18N[currentLang];
            showToast(dict.toastQrSaveError, 'error');
        };

})();
