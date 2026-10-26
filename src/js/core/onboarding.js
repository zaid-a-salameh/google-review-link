// ========================================================
// Onboarding Walkthrough & Feature Tour Engine
// ========================================================
(function() {
    'use strict';

    const STORAGE_KEY = 'review_link_onboarding_v1';
    let currentSlide = 1;
    const TOTAL_SLIDES = 3;

    function getDict() {
        const lang = window.getCurrentLang ? window.getCurrentLang() : 'en';
        return (window.I18N && window.I18N[lang]) ? window.I18N[lang] : {};
    }

    function updateOnboardingUiStrings(dict) {
        const d = dict || getDict();
        const btnObNextLabel = document.getElementById('btnObNextLabel');
        const btnObSkip = document.getElementById('btnObSkip');

        if (btnObNextLabel) {
            btnObNextLabel.textContent = (currentSlide === TOTAL_SLIDES)
                ? (d.obBtnStart || 'Get Started')
                : (d.obBtnNext || 'Next');
        }
        if (btnObSkip) {
            btnObSkip.textContent = d.obBtnSkip || 'Skip Tour';
        }
    }

    function goToSlide(index) {
        if (index < 1 || index > TOTAL_SLIDES) return;
        currentSlide = index;

        const slides = document.querySelectorAll('.onboarding-slide');
        slides.forEach(slide => {
            const slideNum = parseInt(slide.getAttribute('data-slide'), 10);
            slide.classList.toggle('active', slideNum === currentSlide);
        });

        const dots = document.querySelectorAll('.onboarding-dots .ob-dot');
        dots.forEach(dot => {
            const dotNum = parseInt(dot.getAttribute('data-index'), 10);
            dot.classList.toggle('active', dotNum === currentSlide);
        });

        updateOnboardingUiStrings();

        if (window.AndroidNative && typeof window.AndroidNative.triggerLightHaptic === 'function') {
            try { window.AndroidNative.triggerLightHaptic(); } catch (e) {}
        } else if (navigator.vibrate) {
            try { navigator.vibrate(14); } catch (e) {}
        }
    }

    function openOnboarding() {
        const overlay = document.getElementById('onboardingOverlay');
        const modal = document.getElementById('onboardingModalBox');
        if (!overlay || !modal) return;

        goToSlide(1);
        overlay.classList.add('active');
        modal.classList.add('active');

        if (window.AndroidNative && typeof window.AndroidNative.triggerLightHaptic === 'function') {
            try { window.AndroidNative.triggerLightHaptic(); } catch (e) {}
        }
    }

    function closeOnboarding(markAsSeen = true) {
        const overlay = document.getElementById('onboardingOverlay');
        const modal = document.getElementById('onboardingModalBox');
        if (!overlay) return;

        overlay.classList.remove('active');
        if (modal) modal.classList.remove('active');

        if (markAsSeen) {
            try {
                localStorage.setItem(STORAGE_KEY, 'true');
            } catch (e) {}
        }
    }

    function nextSlide() {
        if (currentSlide < TOTAL_SLIDES) {
            goToSlide(currentSlide + 1);
        } else {
            closeOnboarding(true);
        }
    }

    function prevSlide() {
        if (currentSlide > 1) {
            goToSlide(currentSlide - 1);
        }
    }

    document.addEventListener('DOMContentLoaded', () => {
        const btnObNext = document.getElementById('btnObNext');
        const btnObSkip = document.getElementById('btnObSkip');
        const onboardingCloseBtn = document.getElementById('onboardingCloseBtn');
        const overlay = document.getElementById('onboardingOverlay');
        const dots = document.querySelectorAll('.onboarding-dots .ob-dot');

        if (btnObNext) btnObNext.addEventListener('click', nextSlide);
        if (btnObSkip) btnObSkip.addEventListener('click', () => closeOnboarding(true));
        if (onboardingCloseBtn) onboardingCloseBtn.addEventListener('click', () => closeOnboarding(true));

        if (overlay) {
            overlay.addEventListener('click', (e) => {
                if (e.target === overlay) closeOnboarding(true);
            });
        }

        dots.forEach(dot => {
            dot.addEventListener('click', () => {
                const idx = parseInt(dot.getAttribute('data-index'), 10);
                if (idx) goToSlide(idx);
            });
        });

        // First-launch check
        try {
            const hasSeen = localStorage.getItem(STORAGE_KEY);
            if (!hasSeen) {
                setTimeout(() => {
                    openOnboarding();
                }, 400);
            }
        } catch (e) {}
    });

    window.openOnboardingModal = openOnboarding;
    window.closeOnboardingModal = closeOnboarding;
    window.updateOnboardingUiStrings = updateOnboardingUiStrings;
})();
