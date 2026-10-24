// ========================================================
// Unified Toast Notification Engine
// ========================================================
(function() {
    'use strict';

    const ICONS = {
        success: '<svg viewBox="0 0 24 24" fill="#10b981"><path d="M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41L9 16.17z"/></svg>',
        error: '<svg viewBox="0 0 24 24" fill="#ef4444"><path d="M12 2C6.47 2 2 6.47 2 12s4.47 10 10 10 10-4.47 10-10S17.53 2 12 2zm5 13.59L15.59 17 12 13.41 8.41 17 7 15.59 10.59 12 7 8.41 8.41 7 12 10.59 15.59 7 17 8.41 13.41 12 17 15.59z"/></svg>',
        warn: '<svg viewBox="0 0 24 24" fill="#f59e0b"><path d="M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z"/></svg>',
        paste: '<svg viewBox="0 0 24 24" fill="#a78bfa"><path d="M19 2h-4.18C14.4.84 13.3 0 12 0c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm7 18H5V4h2v3h10V4h2v16z"/></svg>',
        copy: '<svg viewBox="0 0 24 24" fill="#38bdf8"><path d="M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12V1zm3 4H8c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h11c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm0 16H8V7h11v14z"/></svg>',
        download: '<svg viewBox="0 0 24 24" fill="#38bdf8"><path d="M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z"/></svg>',
        trash: '<svg viewBox="0 0 24 24" fill="#f87171"><path d="M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z"/></svg>'
    };

    let toastTimer = null;
    function showToast(msg, type = 'info') {
        if (toastTimer) clearTimeout(toastTimer);
        const toast = document.getElementById('toast');
        const toastIcon = document.getElementById('toastIcon');
        const toastText = document.getElementById('toastText');
        if (!toast) return;

        if (toastIcon) {
            toastIcon.innerHTML = ICONS[type] || '';
        }
        if (toastText) {
            toastText.textContent = msg;
        } else {
            toast.textContent = msg;
        }
        toast.classList.add('show');
        toastTimer = setTimeout(() => {
            if (toast) toast.classList.remove('show');
        }, 2500);
    }

    window.showToast = showToast;
})();
