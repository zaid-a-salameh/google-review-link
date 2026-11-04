// ========================================================
// Permanent Hardware Lock Sub-View Controller (#nfcPermConfirmView)
// ========================================================
(function() {
    'use strict';

    const $ = id => document.getElementById(id);

    document.addEventListener('DOMContentLoaded', () => {
        const btnPermLockTag = $('btnPermLockTag');
        const btnPermLockConfirm = $('btnPermLockConfirm');
        const btnPermLockCancel = $('btnPermLockCancel');

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
                    nfcModalBox.classList.remove('theme-unlock', 'unlock-mode', 'theme-wifi', 'success', 'error', 'perm-lock-standby');
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
    });
})();
