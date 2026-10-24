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
    // Morphing Container Transform Engine (Button-to-Modal)
    // ========================================================
    function openMorphModal(overlay, modalBox, triggerBtn) {
        if (!overlay || !modalBox) return;

        // Dismiss virtual keyboard to avoid viewport shifts
        if (document.activeElement && typeof document.activeElement.blur === 'function') {
            try { document.activeElement.blur(); } catch (e) {}
        }

        if (!triggerBtn || typeof triggerBtn.getBoundingClientRect !== 'function') {
            overlay.classList.add('active');
            return;
        }

        const btnRect = triggerBtn.getBoundingClientRect();
        const modalRect = modalBox.getBoundingClientRect();

        // Calculate center offsets between the button and the centered modal
        const modalCenterX = modalRect.left + (modalRect.width / 2);
        const modalCenterY = modalRect.top + (modalRect.height / 2);
        const btnCenterX = btnRect.left + (btnRect.width / 2);
        const btnCenterY = btnRect.top + (btnRect.height / 2);

        const deltaX = btnCenterX - modalCenterX;
        const deltaY = btnCenterY - modalCenterY;
        const scaleX = modalRect.width > 0 ? (btnRect.width / modalRect.width) : 0.3;
        const scaleY = modalRect.height > 0 ? (btnRect.height / modalRect.height) : 0.2;

        // Save origin parameters for collapse animation
        modalBox.dataset.morphDeltaX = deltaX.toFixed(2);
        modalBox.dataset.morphDeltaY = deltaY.toFixed(2);
        modalBox.dataset.morphScaleX = scaleX.toFixed(3);
        modalBox.dataset.morphScaleY = scaleY.toFixed(3);
        modalBox._morphTriggerBtn = triggerBtn;

        // Mark trigger button as active
        triggerBtn.classList.add('morph-active-btn');

        // Set initial state: collapsed down to button bounds
        modalBox.classList.add('morph-expanding');
        modalBox.style.transition = 'none';
        modalBox.style.transform = `translate3d(${deltaX.toFixed(2)}px, ${deltaY.toFixed(2)}px, 0) scale(${scaleX.toFixed(3)}, ${scaleY.toFixed(3)})`;
        modalBox.style.borderRadius = '14px';
        modalBox.style.opacity = '0.45';

        // Show overlay backdrop
        overlay.classList.add('active');

        // Next paint frames: expand smoothly to center
        requestAnimationFrame(() => {
            requestAnimationFrame(() => {
                modalBox.style.transition = 'transform 0.32s cubic-bezier(0.16, 1, 0.3, 1), border-radius 0.32s cubic-bezier(0.16, 1, 0.3, 1), opacity 0.22s ease';
                modalBox.style.transform = 'translate3d(0, 0, 0) scale(1, 1)';
                modalBox.style.borderRadius = '28px';
                modalBox.style.opacity = '1';
                modalBox.classList.remove('morph-expanding');
            });
        });
    }

    function closeMorphModal(overlay, modalBox, callback) {
        if (!overlay || !overlay.classList.contains('active')) {
            if (typeof callback === 'function') callback();
            return;
        }

        const deltaX = modalBox ? modalBox.dataset.morphDeltaX : null;
        const deltaY = modalBox ? modalBox.dataset.morphDeltaY : null;
        const scaleX = modalBox ? modalBox.dataset.morphScaleX : null;
        const scaleY = modalBox ? modalBox.dataset.morphScaleY : null;
        const triggerBtn = modalBox ? modalBox._morphTriggerBtn : null;

        if (modalBox && deltaX !== null && deltaY !== null && scaleX && scaleY) {
            modalBox.classList.add('morph-collapsing');
            modalBox.style.transition = 'transform 0.24s cubic-bezier(0.16, 1, 0.3, 1), border-radius 0.24s cubic-bezier(0.16, 1, 0.3, 1), opacity 0.18s ease';
            modalBox.style.transform = `translate3d(${deltaX}px, ${deltaY}px, 0) scale(${scaleX}, ${scaleY})`;
            modalBox.style.borderRadius = '14px';
            modalBox.style.opacity = '0';
            overlay.classList.remove('active');

            setTimeout(() => {
                modalBox.classList.remove('morph-collapsing');
                modalBox.style.transition = '';
                modalBox.style.transform = '';
                modalBox.style.borderRadius = '';
                modalBox.style.opacity = '';
                delete modalBox.dataset.morphDeltaX;
                delete modalBox.dataset.morphDeltaY;
                delete modalBox.dataset.morphScaleX;
                delete modalBox.dataset.morphScaleY;
                if (triggerBtn) {
                    triggerBtn.classList.remove('morph-active-btn');
                    modalBox._morphTriggerBtn = null;
                }
                if (typeof callback === 'function') callback();
            }, 260);
        } else {
            overlay.classList.remove('active');
            if (triggerBtn) {
                triggerBtn.classList.remove('morph-active-btn');
                if (modalBox) modalBox._morphTriggerBtn = null;
            }
            if (typeof callback === 'function') callback();
        }
    }

    window.showToast = showToast;
    window.openMorphModal = openMorphModal;
    window.closeMorphModal = closeMorphModal;
})();
