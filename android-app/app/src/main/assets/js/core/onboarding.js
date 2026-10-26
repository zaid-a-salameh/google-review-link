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

        // 1. Update slide active, prev, and next states for smooth directional sliding
        const slides = document.querySelectorAll('.onboarding-slide');
        slides.forEach(slide => {
            const slideNum = parseInt(slide.getAttribute('data-slide'), 10);
            slide.classList.remove('active', 'slide-prev', 'slide-next');
            if (slideNum === currentSlide) {
                slide.classList.add('active');
            } else if (slideNum < currentSlide) {
                slide.classList.add('slide-prev');
            } else {
                slide.classList.add('slide-next');
            }
        });

        // 2. Trigger morph pulse on top icon circle & crossfade active SVG
        const iconWrap = document.getElementById('obTopIconWrap');
        if (iconWrap) {
            iconWrap.classList.remove('morphing');
            void iconWrap.offsetWidth; // Force reflow to retrigger animation
            iconWrap.classList.add('morphing');

            iconWrap.classList.remove('theme-purple', 'theme-cyan', 'theme-gold');
            if (currentSlide === 1) iconWrap.classList.add('theme-purple');
            else if (currentSlide === 2) iconWrap.classList.add('theme-cyan');
            else if (currentSlide === 3) iconWrap.classList.add('theme-gold');
        }
        const icon1 = document.getElementById('obIcon1');
        const icon2 = document.getElementById('obIcon2');
        const icon3 = document.getElementById('obIcon3');
        if (icon1) icon1.classList.toggle('active', currentSlide === 1);
        if (icon2) icon2.classList.toggle('active', currentSlide === 2);
        if (icon3) icon3.classList.toggle('active', currentSlide === 3);

        // 3. Update numbered steps progress indicator (1) —— (2) —— (3) with animated lines
        const indicator = document.getElementById('onboardingStepsIndicator');
        if (indicator) {
            const stepItems = indicator.querySelectorAll('.onboarding-step-item');
            const stepLines = indicator.querySelectorAll('.onboarding-step-line');
            stepItems.forEach((item, idx) => {
                const stepNum = idx + 1;
                item.classList.remove('active', 'completed');
                if (stepNum === currentSlide) {
                    item.classList.add('active');
                } else if (stepNum < currentSlide) {
                    item.classList.add('completed');
                }
            });
            stepLines.forEach((line, idx) => {
                line.classList.toggle('active', (idx + 1) < currentSlide);
            });
        }

        // 4. Update actions layout for final step (hide skip button, expand next button to 100%)
        const actionsContainer = document.getElementById('onboardingActions');
        if (actionsContainer) {
            actionsContainer.classList.toggle('is-last-step', currentSlide === TOTAL_SLIDES);
        }

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

        overlay.classList.remove('closing');
        modal.classList.remove('closing');

        overlay.classList.add('active');
        modal.classList.add('active');

        if (window.AndroidNative && typeof window.AndroidNative.triggerLightHaptic === 'function') {
            try { window.AndroidNative.triggerLightHaptic(); } catch (e) {}
        } else if (navigator.vibrate) {
            try { navigator.vibrate(18); } catch (e) {}
        }
    }

    function closeOnboarding(markAsSeen = true) {
        const overlay = document.getElementById('onboardingOverlay');
        const modal = document.getElementById('onboardingModalBox');
        if (!overlay) return;

        overlay.classList.add('closing');
        if (modal) modal.classList.add('closing');

        setTimeout(() => {
            overlay.classList.remove('active', 'closing');
            if (modal) modal.classList.remove('active', 'closing');
        }, 240);

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
        const indicator = document.getElementById('onboardingStepsIndicator');
        const btnOpenHelpGuide = document.getElementById('btnOpenHelpGuide');

        if (btnObNext) btnObNext.addEventListener('click', nextSlide);
        if (btnObSkip) btnObSkip.addEventListener('click', () => closeOnboarding(true));
        if (onboardingCloseBtn) onboardingCloseBtn.addEventListener('click', () => closeOnboarding(true));
        if (btnOpenHelpGuide) btnOpenHelpGuide.addEventListener('click', openOnboarding);

        if (overlay) {
            overlay.addEventListener('click', (e) => {
                if (e.target === overlay) closeOnboarding(true);
            });
        }

        if (indicator) {
            const stepItems = indicator.querySelectorAll('.onboarding-step-item');
            stepItems.forEach(item => {
                item.addEventListener('click', () => {
                    const stepNum = parseInt(item.getAttribute('data-step'), 10);
                    if (stepNum) goToSlide(stepNum);
                });
            });
        }

        // First-launch check with smooth delayed entrance
        try {
            const hasSeen = localStorage.getItem(STORAGE_KEY);
            if (!hasSeen) {
                setTimeout(() => {
                    openOnboarding();
                }, 450);
            }
        } catch (e) {}
    });

    window.openOnboardingModal = openOnboarding;
    window.closeOnboardingModal = closeOnboarding;
    window.updateOnboardingUiStrings = updateOnboardingUiStrings;
})();
