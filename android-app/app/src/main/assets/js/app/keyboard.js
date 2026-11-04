// ========================================================
// Soft Keyboard & Native IME Avoidance Controller
// ========================================================
(function() {
    'use strict';

    const $ = id => document.getElementById(id);

    let keyboardBlurTimer = null;
    let lastKnownImeHeight = Math.round(Math.min(310, Math.max(250, window.innerHeight * 0.39)));

    function isInputElement(el) {
        if (!el || !el.tagName) return false;
        const tag = el.tagName.toUpperCase();
        return tag === 'INPUT' || tag === 'TEXTAREA';
    }

    function isActiveModalInput() {
        const activeEl = document.activeElement;
        const nfcOverlayEl = $('nfcOverlay');
        return Boolean(
            isInputElement(activeEl) &&
            nfcOverlayEl &&
            nfcOverlayEl.classList.contains('active') &&
            nfcOverlayEl.contains(activeEl)
        );
    }

    function computeModalKbShift(imeHeightPx) {
        const vh = window.innerHeight || 780;
        const kbH = Math.max(220, imeHeightPx || lastKnownImeHeight);
        const nfcModalBoxEl = $('nfcModalBox');
        const modalH = (nfcModalBoxEl && nfcModalBoxEl.offsetHeight > 100) ? nfcModalBoxEl.offsetHeight : 344;
        const centeredTop = (vh - modalH) * 0.5;
        const minShift = Math.min(0, 12 - centeredTop);
        const bottomClearanceShift = centeredTop - kbH - 14;
        const rawShift = Math.min(-kbH * 0.5, bottomClearanceShift);
        return Math.round(Math.max(-240, minShift, Math.min(0, rawShift)));
    }

    function setModalKeyboardShift(active, imeHeightPx) {
        if (!active || !isActiveModalInput()) {
            document.documentElement.style.setProperty('--kb-shift', '0px');
            return;
        }
        const shift = computeModalKbShift(imeHeightPx);
        document.documentElement.style.setProperty('--kb-shift', `${shift}px`);
    }

    window.__onNativeKeyboardInset = function(imeBottomDp, imeVisible) {
        if (imeBottomDp >= 120) {
            lastKnownImeHeight = imeBottomDp;
        }
        if (!imeVisible || imeBottomDp <= 20) {
            document.body.classList.remove('keyboard-open');
            setModalKeyboardShift(false, 0);
        } else {
            document.body.classList.add('keyboard-open');
            if (isActiveModalInput()) {
                setModalKeyboardShift(true, imeBottomDp >= 120 ? imeBottomDp : lastKnownImeHeight);
            } else {
                setModalKeyboardShift(false, 0);
            }
        }
    };

    document.addEventListener('DOMContentLoaded', () => {
        document.addEventListener('focusin', e => {
            if (isInputElement(e.target)) {
                if (keyboardBlurTimer) {
                    clearTimeout(keyboardBlurTimer);
                    keyboardBlurTimer = null;
                }
                document.body.classList.add('keyboard-open');
                const nfcOverlayEl = $('nfcOverlay');
                if (nfcOverlayEl && nfcOverlayEl.contains(e.target)) {
                    setModalKeyboardShift(true, lastKnownImeHeight);
                }
            }
        });

        document.addEventListener('focusout', e => {
            if (isInputElement(e.target)) {
                const nfcOverlayEl = $('nfcOverlay');
                if (nfcOverlayEl && nfcOverlayEl.contains(e.target)) {
                    setModalKeyboardShift(false, 0);
                }
                if (keyboardBlurTimer) clearTimeout(keyboardBlurTimer);
                keyboardBlurTimer = setTimeout(() => {
                    if (!isInputElement(document.activeElement)) {
                        document.body.classList.remove('keyboard-open');
                        setModalKeyboardShift(false, 0);
                    }
                }, 120);
            }
        });
    });
})();
