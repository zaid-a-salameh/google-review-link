// ========================================================
// Desktop Marketing, FAQ Accordion & Navigation
// ========================================================
(function() {
    'use strict';

    document.addEventListener('DOMContentLoaded', function() {
        // Desktop Navbar Scroll Effect
        const desktopNavbar = document.getElementById('desktopNavbar');
        if (desktopNavbar) {
            window.addEventListener('scroll', () => {
                if (window.scrollY > 20) {
                    desktopNavbar.classList.add('scrolled');
                } else {
                    desktopNavbar.classList.remove('scrolled');
                }
            }, { passive: true });
        }

        // Smooth Scroll Back to Top
        const footerBackToTop = document.getElementById('footerBackToTop');
        if (footerBackToTop) {
            footerBackToTop.addEventListener('click', (e) => {
                e.preventDefault();
                window.scrollTo({ top: 0, behavior: 'smooth' });
            });
        }
    });
})();
