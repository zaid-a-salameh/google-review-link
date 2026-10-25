// ========================================================
// Unified Toast Notification Engine
// ========================================================
(function() {
    'use strict';

    const ICONS = {
        success: '<svg viewBox="0 0 24 24" fill="#10b981"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41L9 16.17z"/></svg>',
        error: '<svg viewBox="0 0 24 24" fill="#F5277D"><path d="M12 2C6.47 2 2 6.47 2 12s4.47 10 10 10 10-4.47 10-10S17.53 2 12 2zm5 13.59L15.59 17 12 13.41 8.41 17 7 15.59 10.59 12 7 8.41 8.41 7 12 10.59 15.59 7 17 8.41 13.41 12 17 15.59z"/></svg>',
        warn: '<svg viewBox="0 0 24 24" fill="#f59e0b"><path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/></svg>',
        paste: '<svg viewBox="0 0 24 24" fill="#a78bfa"><path d="M19 2h-4.18C14.4.84 13.3 0 12 0c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm7 18H5V4h2v3h10V4h2v16z"/></svg>',
        copy: '<svg viewBox="0 0 24 24" fill="#38bdf8"><path d="M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12V1zm3 4H8c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h11c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm0 16H8V7h11v14z"/></svg>',
        download: '<svg viewBox="0 0 24 24" fill="#38bdf8"><path d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"/></svg>',
        trash: '<svg viewBox="0 0 24 24" fill="#f87171"><path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/></svg>',
        info: '<svg viewBox="0 0 24 24" fill="#a78bfa"><path d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z"/></svg>'
    };

    let toastTimer = null;
    function showToast(msg, type = 'info', customDuration = null) {
        if (toastTimer) clearTimeout(toastTimer);
        const toast = document.getElementById('toast');
        const toastIcon = document.getElementById('toastIcon');
        const toastText = document.getElementById('toastText');
        if (!toast) return;

        toast.classList.remove('error', 'success', 'warn', 'info');
        if (type) toast.classList.add(type);

        if (toastIcon) {
            toastIcon.innerHTML = ICONS[type] || '';
        }
        if (toastText) {
            toastText.textContent = msg;
        } else {
            toast.textContent = msg;
        }
        toast.classList.add('show');

        let duration = customDuration;
        if (!duration) {
            if (type === 'info' || (msg && msg.length > 35)) {
                duration = 4200;
            } else {
                duration = 2600;
            }
        }

        toastTimer = setTimeout(() => {
            if (toast) toast.classList.remove('show');
        }, duration);
    }

    // ========================================================
    // Smooth GPU Modal & Zero-Gap Handoff Engine
    // ========================================================
    function clearModalTimers(overlay, modalBox) {
        if (overlay && overlay._modalTimer) {
            clearTimeout(overlay._modalTimer);
            overlay._modalTimer = null;
        }
        if (modalBox && modalBox._modalTimer) {
            clearTimeout(modalBox._modalTimer);
            modalBox._modalTimer = null;
        }
        if (modalBox && modalBox._btnTimer) {
            clearTimeout(modalBox._btnTimer);
            modalBox._btnTimer = null;
        }
    }

    function resetModalInlineStyles(modalBox) {
        if (!modalBox) return;
        modalBox.classList.remove('morph-expanding', 'morph-collapsing', 'morph-active');
        modalBox.style.transition = '';
        modalBox.style.transform = '';
        modalBox.style.borderRadius = '';
        modalBox.style.opacity = '';
    }

    function clampNum(val, min, max) {
        return Math.max(min, Math.min(max, val));
    }

    function openMorphModal(overlay, modalBox, triggerBtn) {
        if (!overlay || !modalBox) return;

        if (document.activeElement && typeof document.activeElement.blur === 'function') {
            try { document.activeElement.blur(); } catch (e) {}
        }

        clearModalTimers(overlay, modalBox);
        overlay.classList.remove('handoff-enter', 'handoff-exit');
        resetModalInlineStyles(modalBox);

        const validBtn = (triggerBtn && triggerBtn.nodeType === 1 && typeof triggerBtn.getBoundingClientRect === 'function')
            ? triggerBtn
            : null;

        let dx = 0;
        let dy = 14;

        if (validBtn) {
            const btnRect = validBtn.getBoundingClientRect();
            if (btnRect.width > 0 && btnRect.height > 0) {
                const rawDx = (btnRect.left + btnRect.width * 0.5) - (window.innerWidth * 0.5);
                const rawDy = (btnRect.top + btnRect.height * 0.5) - (window.innerHeight * 0.5);
                dx = clampNum(rawDx * 0.16, -24, 24);
                dy = clampNum(rawDy * 0.16, -32, 32);
            }
            modalBox.dataset.originDx = dx.toFixed(1);
            modalBox.dataset.originDy = dy.toFixed(1);
            modalBox._morphTriggerBtn = validBtn;

            validBtn.classList.add('morph-active-btn');
            modalBox._btnTimer = setTimeout(() => {
                validBtn.classList.remove('morph-active-btn');
                modalBox._btnTimer = null;
            }, 200);
        } else {
            modalBox.dataset.originDx = '0';
            modalBox.dataset.originDy = '14';
            modalBox._morphTriggerBtn = null;
        }

        modalBox.style.transition = 'none';
        modalBox.style.opacity = '0';
        modalBox.style.transform = `translate3d(${dx.toFixed(1)}px, ${dy.toFixed(1)}px, 0) scale3d(0.92, 0.92, 1)`;

        overlay.classList.add('active');

        requestAnimationFrame(() => {
            requestAnimationFrame(() => {
                modalBox.style.transition = 'transform 0.24s cubic-bezier(0.22, 1, 0.36, 1), opacity 0.19s cubic-bezier(0.22, 1, 0.36, 1)';
                modalBox.style.opacity = '1';
                modalBox.style.transform = 'translate3d(0, 0, 0) scale3d(1, 1, 1)';
            });
        });

        modalBox._modalTimer = setTimeout(() => {
            modalBox._modalTimer = null;
            if (overlay.classList.contains('active')) {
                resetModalInlineStyles(modalBox);
            }
        }, 255);
    }

    function closeMorphModal(overlay, modalBox, callback) {
        if (!overlay || !overlay.classList.contains('active')) {
            if (typeof callback === 'function') callback();
            return;
        }

        clearModalTimers(overlay, modalBox);
        overlay.classList.remove('handoff-enter', 'handoff-exit');

        const triggerBtn = modalBox ? modalBox._morphTriggerBtn : null;
        if (triggerBtn) {
            triggerBtn.classList.remove('morph-active-btn');
        }

        if (modalBox) {
            const dx = (parseFloat(modalBox.dataset.originDx) || 0) * 0.65;
            const dy = (parseFloat(modalBox.dataset.originDy) || 14) * 0.65;

            modalBox.style.transition = 'transform 0.18s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.16s cubic-bezier(0.4, 0, 1, 1)';
            modalBox.style.opacity = '0';
            modalBox.style.transform = `translate3d(${dx.toFixed(1)}px, ${dy.toFixed(1)}px, 0) scale3d(0.94, 0.94, 1)`;
            overlay.classList.remove('active');

            modalBox._modalTimer = setTimeout(() => {
                modalBox._modalTimer = null;
                resetModalInlineStyles(modalBox);
                delete modalBox.dataset.originDx;
                delete modalBox.dataset.originDy;
                modalBox._morphTriggerBtn = null;
                if (typeof callback === 'function') callback();
            }, 195);
        } else {
            overlay.classList.remove('active');
            if (typeof callback === 'function') callback();
        }
    }

    function transitionModalToModal(fromOverlay, fromBox, toOverlay, toBox, onBeforeEnter) {
        if (!toOverlay || !toBox) {
            if (typeof onBeforeEnter === 'function') onBeforeEnter();
            return;
        }

        if (document.activeElement && typeof document.activeElement.blur === 'function') {
            try { document.activeElement.blur(); } catch (e) {}
        }

        clearModalTimers(fromOverlay, fromBox);
        clearModalTimers(toOverlay, toBox);

        // Pre-hide toBox immediately before onBeforeEnter runs
        // so any .active class applied to toOverlay inside onBeforeEnter cannot flash toBox visible
        toBox.style.transition = 'none';
        toBox.style.opacity = '0';
        toBox.style.transform = 'translate3d(0, 10px, 0) scale3d(0.95, 0.95, 1)';

        // Elevate toOverlay above fromOverlay so the entering modal sits cleanly on top
        toOverlay.style.zIndex = '1005';
        if (fromOverlay) {
            fromOverlay.style.zIndex = '1000';
            fromOverlay.style.pointerEvents = 'none';
        }

        if (fromBox && toBox) {
            if (fromBox.dataset.originDx && !toBox.dataset.originDx) {
                toBox.dataset.originDx = fromBox.dataset.originDx;
                toBox.dataset.originDy = fromBox.dataset.originDy || '14';
            }
            if (fromBox._morphTriggerBtn && !toBox._morphTriggerBtn) {
                toBox._morphTriggerBtn = fromBox._morphTriggerBtn;
            }
            if (fromBox._morphTriggerBtn) {
                fromBox._morphTriggerBtn.classList.remove('morph-active-btn');
            }
        }

        if (typeof onBeforeEnter === 'function') {
            onBeforeEnter();
        }

        const wasFromActive = fromOverlay && fromOverlay.classList.contains('active');

        // toOverlay becomes active smoothly without altering the existing dark backdrop
        toOverlay.classList.remove('handoff-exit');
        toOverlay.classList.add('handoff-enter', 'active');

        if (wasFromActive && fromOverlay && fromBox) {
            fromBox.style.transition = 'transform 0.16s cubic-bezier(0.4, 0, 0.2, 1), opacity 0.14s ease';
            fromBox.style.opacity = '0';
            fromBox.style.transform = 'translate3d(0, -8px, 0) scale3d(0.95, 0.95, 1)';

            fromOverlay._modalTimer = setTimeout(() => {
                fromOverlay._modalTimer = null;
                fromOverlay.classList.remove('active', 'handoff-exit');
                fromOverlay.style.zIndex = '';
                fromOverlay.style.pointerEvents = '';
                resetModalInlineStyles(fromBox);
            }, 180);
        } else if (fromOverlay) {
            fromOverlay.classList.remove('active', 'handoff-exit', 'handoff-enter');
            fromOverlay.style.zIndex = '';
            fromOverlay.style.pointerEvents = '';
            resetModalInlineStyles(fromBox);
        }

        requestAnimationFrame(() => {
            requestAnimationFrame(() => {
                toBox.style.transition = 'transform 0.22s cubic-bezier(0.22, 1, 0.36, 1), opacity 0.18s cubic-bezier(0.22, 1, 0.36, 1)';
                toBox.style.opacity = '1';
                toBox.style.transform = 'translate3d(0, 0, 0) scale3d(1, 1, 1)';
            });
        });

        toBox._modalTimer = setTimeout(() => {
            toBox._modalTimer = null;
            toOverlay.style.zIndex = '';
            toOverlay.classList.remove('handoff-enter');
            if (toOverlay.classList.contains('active')) {
                resetModalInlineStyles(toBox);
            }
        }, 240);
    }

    window.showToast = showToast;
    window.openMorphModal = openMorphModal;
    window.closeMorphModal = closeMorphModal;
    window.transitionModalToModal = transitionModalToModal;
})();
