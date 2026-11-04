// ========================================================
// PIN Lock & Unlock Sub-View Controller (#nfcPwdView)
// ========================================================
(function() {
    'use strict';

    const $ = id => document.getElementById(id);

    let pwdCurrentAction = 'lock';

    function getDict() {
        const lang = window.getCurrentLang ? window.getCurrentLang() : 'en';
        return (window.I18N && window.I18N[lang]) ? window.I18N[lang] : {};
    }

    function updatePwdTabSlider() {
        const slider = $('pwdTabSlider');
        const activeTab = document.querySelector('#nfcPwdView .pwd-tab.active');
        if (!slider || !activeTab) return;

        slider.style.left = '0px';
        slider.style.right = 'auto';
        slider.style.width = `${activeTab.offsetWidth}px`;
        slider.style.transform = `translate3d(${activeTab.offsetLeft}px, 0, 0)`;
    }

    function syncPwdModalText() {
        const dict = getDict();
        const isLock = pwdCurrentAction === 'lock';
        const btnPwdSubmit = $('btnPwdSubmit');
        const pwdSubmitLockLabelEl = $('pwdSubmitLockLabel');
        const nfcModalBox = $('nfcModalBox');
        const nfcPinInput = $('nfcPinInput');
        const pwdIconCircle = $('pwdIconCircle');
        const slider = $('pwdTabSlider');

        if (btnPwdSubmit) {
            btnPwdSubmit.classList.toggle('unlock-mode', !isLock);
            if (!pwdSubmitLockLabelEl) {
                btnPwdSubmit.textContent = isLock
                    ? (dict.pwdSubmitLock || 'Lock Card')
                    : (dict.pwdSubmitUnlock || 'Unlock Card');
            }
        }

        if (nfcModalBox) {
            if (isLock) {
                nfcModalBox.classList.remove('unlock-mode', 'theme-unlock', 'theme-wifi', 'theme-perm-lock');
                nfcModalBox.classList.add('theme-lock');
            } else {
                nfcModalBox.classList.remove('theme-lock', 'theme-wifi', 'theme-perm-lock');
                nfcModalBox.classList.add('unlock-mode', 'theme-unlock');
            }
        }

        if (nfcPinInput && dict.pwdPlaceholder) {
            nfcPinInput.placeholder = dict.pwdPlaceholder;
        }

        if (pwdIconCircle) {
            pwdIconCircle.classList.toggle('unlock-mode', !isLock);
        }

        if (slider) {
            slider.classList.toggle('unlock-mode', !isLock);
        }

        updatePwdTabSlider();
        requestAnimationFrame(() => updatePwdTabSlider());
    }

    function returnToPasswordModal() {
        const nfcPinInput = $('nfcPinInput');
        syncPwdModalText();
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

    document.addEventListener('DOMContentLoaded', () => {
        const btnPwdLockTag = $('btnPwdLockTag');
        const pwdTabLock = $('pwdTabLock');
        const pwdTabUnlock = $('pwdTabUnlock');
        const nfcPinInput = $('nfcPinInput');
        const btnPwdToggleShow = $('btnPwdToggleShow');
        const eyeIconOpen = $('eyeIconOpen');
        const eyeIconClosed = $('eyeIconClosed');
        const btnPwdInfo = $('btnPwdInfo');
        const btnPwdSubmit = $('btnPwdSubmit');
        const btnPwdCancel = $('btnPwdCancel');

        if (btnPwdToggleShow && nfcPinInput) {
            btnPwdToggleShow.addEventListener('click', () => {
                const isPassword = nfcPinInput.type === 'password';
                nfcPinInput.type = isPassword ? 'text' : 'password';
                if (eyeIconOpen) eyeIconOpen.style.display = isPassword ? 'none' : 'block';
                if (eyeIconClosed) eyeIconClosed.style.display = isPassword ? 'block' : 'none';
            });
        }

        if (btnPwdInfo) {
            btnPwdInfo.addEventListener('click', e => {
                e.preventDefault();
                e.stopPropagation();
                const dict = getDict();
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
                    nfcModalBox.classList.remove('success', 'error', 'perm-lock-standby');
                    syncPwdModalText();
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
                }
            });
        }

        if (pwdTabLock && pwdTabUnlock) {
            pwdTabLock.addEventListener('click', () => {
                if (pwdCurrentAction === 'lock') return;
                pwdCurrentAction = 'lock';
                pwdTabLock.classList.add('active');
                pwdTabUnlock.classList.remove('active');
                syncPwdModalText();
            });
            pwdTabUnlock.addEventListener('click', () => {
                if (pwdCurrentAction === 'unlock') return;
                pwdCurrentAction = 'unlock';
                pwdTabUnlock.classList.add('active');
                pwdTabLock.classList.remove('active');
                syncPwdModalText();
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

        if (btnPwdSubmit) {
            btnPwdSubmit.addEventListener('click', () => {
                const pin = nfcPinInput ? nfcPinInput.value.trim() : '';
                const dict = getDict();
                if (!pin) {
                    if (window.showToast) window.showToast(dict.toastEnterPwd || 'Please enter a password or PIN', 'warn');
                    return;
                }
                if (nfcPinInput) nfcPinInput.blur();
                if (pwdCurrentAction === 'lock') {
                    if (window.startNfcPasswordLock) window.startNfcPasswordLock(pin, btnPwdLockTag, { skipOpenAnimation: true });
                } else {
                    if (window.startNfcPasswordUnlock) window.startNfcPasswordUnlock(pin, btnPwdLockTag, { skipOpenAnimation: true });
                }
            });
        }

        if (document.fonts && document.fonts.ready) {
            document.fonts.ready.then(() => updatePwdTabSlider()).catch(() => {});
        }
        window.addEventListener('resize', updatePwdTabSlider);
    });

    window.updatePwdTabSlider = updatePwdTabSlider;
    window.syncPwdModalText = syncPwdModalText;
    window.returnToPasswordModal = returnToPasswordModal;
})();
