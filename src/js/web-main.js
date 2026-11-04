// ========================================================
// Web Application Main Bootstrapper & Event Orchestrator
// ========================================================
(function() {
    'use strict';

    const $ = id => document.getElementById(id);

    document.addEventListener('DOMContentLoaded', () => {
        const urlInput = $('urlInput');
        const clearBtn = $('clearBtn');
        const pasteBtn = $('pasteBtn');
        const convertBtn = $('convertBtn');
        const copyBtn = $('copyBtn');
        const copyBtnLabel = $('copyBtnLabel');
        const openBtn = $('openBtn');
        const shareBtn = $('shareBtn');
        const qrBtn = $('qrBtn');
        const qrOverlay = $('qrOverlay');
        const qrCloseBtn = $('qrCloseBtn');
        const qrDownloadBtn = $('qrDownloadBtn');
        const tabLinkMode = $('tabLinkMode');
        const tabSearchMode = $('tabSearchMode');
        const businessSearchInput = $('businessSearchInput');
        const searchClearBtn = $('searchClearBtn');
        const searchFieldWrapper = $('searchFieldWrapper');
        const placesDropdown = $('placesDropdown');
        const resultCard = $('resultCard');
        
        let autocompleteDebounceTimer = null;
        let highlightedSuggestionIndex = -1;

        // ── Mode Switcher ──
        if (tabLinkMode) tabLinkMode.addEventListener('click', () => window.switchMode('link'));
        if (tabSearchMode) tabSearchMode.addEventListener('click', () => window.switchMode('search'));

        // ── Input & Convert Listeners ──
        if (convertBtn) convertBtn.addEventListener('click', window.handleConvert);
        if (urlInput) {
            urlInput.addEventListener('keydown', e => {
                if (e.key === 'Enter') window.handleConvert();
            });
            urlInput.addEventListener('input', () => {
                const val = urlInput.value.trim();
                if (val.length >= 3 && !/^https?:\/\//i.test(val) && !/maps\.app\.goo\.gl/i.test(val) && !/goo\.gl/i.test(val) && !/placeid/i.test(val) && !/ChIJ/i.test(val)) {
                    window.switchMode('search');
                    if (businessSearchInput) {
                        businessSearchInput.value = val;
                        businessSearchInput.dispatchEvent(new Event('input'));
                    }
                }
            });
        }

        // ── Clear / Trash ──
        if (clearBtn) {
            clearBtn.addEventListener('click', () => {
                const dict = window.I18N[window.getCurrentLang()];
                if (urlInput) {
                    urlInput.value = '';
                    if (!window.isTouchDevice || !window.isTouchDevice()) urlInput.focus();
                }
                if (window.AppModes) {
                    window.AppModes.clearModeResult('link');
                } else if (resultCard) {
                    resultCard.classList.remove('active');
                }
                if (window.showToast) window.showToast(dict.toastCleared, 'trash');
            });
        }

        // ── Paste Action (Web Clipboard API) ──
        if (pasteBtn) {
            pasteBtn.addEventListener('click', async () => {
                const dict = window.I18N[window.getCurrentLang()];
                if (navigator.clipboard && navigator.clipboard.readText) {
                    try {
                        const text = await navigator.clipboard.readText();
                        if (text && text.trim()) {
                            window.switchMode('link');
                            if (urlInput) {
                                urlInput.value = text.trim();
                                if (!window.isTouchDevice || !window.isTouchDevice()) urlInput.focus();
                            }
                            if (window.showToast) window.showToast(dict.toastPasted, 'paste');
                            window.handleConvert();
                            return;
                        } else {
                            if (window.showToast) window.showToast(dict.toastEmptyClip, 'warn');
                            if (urlInput && (!window.isTouchDevice || !window.isTouchDevice())) urlInput.focus();
                            return;
                        }
                    } catch (err) {
                        console.warn('Clipboard readText failed or was blocked by browser:', err);
                    }
                }
                if (urlInput && (!window.isTouchDevice || !window.isTouchDevice())) {
                    urlInput.focus();
                    urlInput.select();
                }
                if (window.showToast) window.showToast(dict.toastClipDenied, 'paste');
            });
        }

        // ── Action Buttons (Copy, Open, Share, QR) ──
        if (copyBtn) {
            copyBtn.addEventListener('click', async () => {
                const reviewUrl = window.getGeneratedReviewUrl();
                if (!reviewUrl) return;
                const dict = window.I18N[window.getCurrentLang()];
                try {
                    await navigator.clipboard.writeText(reviewUrl);
                    copyBtn.classList.add('copied');
                    if (copyBtnLabel) copyBtnLabel.textContent = dict.copySuccess;
                    if (window.showToast) window.showToast(dict.toastCopied, 'copy');
                    setTimeout(() => {
                        copyBtn.classList.remove('copied');
                        if (copyBtnLabel) copyBtnLabel.textContent = dict.copyBtn;
                    }, 2000);
                } catch (e) {
                    if (window.showToast) window.showToast(dict.toastCopied, 'copy');
                }
            });
        }

        if (openBtn) {
            openBtn.addEventListener('click', () => {
                const reviewUrl = window.getGeneratedReviewUrl();
                if (reviewUrl) window.open(reviewUrl, '_blank');
            });
        }

        if (shareBtn) {
            shareBtn.addEventListener('click', async () => {
                const reviewUrl = window.getGeneratedReviewUrl();
                if (!reviewUrl) return;
                const dict = window.I18N[window.getCurrentLang()];
                if (navigator.share) {
                    try {
                        await navigator.share({
                            title: dict.shareTitle,
                            text: dict.shareText,
                            url: reviewUrl
                        });
                    } catch (err) {}
                } else {
                    await navigator.clipboard.writeText(reviewUrl);
                    if (window.showToast) window.showToast(dict.toastShareCopied, 'copy');
                }
            });
        }

        if (qrBtn) qrBtn.addEventListener('click', () => window.openQrModal(qrBtn));

        // ── Link Type Segmented Selector (Review vs Location) ──
        const btnTypeReview = $('btnTypeReview');
        const btnTypeLocation = $('btnTypeLocation');
        if (btnTypeReview) {
            btnTypeReview.addEventListener('click', () => {
                if (window.AppModes && window.AppModes.setLinkType) {
                    window.AppModes.setLinkType('review');
                }
            });
        }
        if (btnTypeLocation) {
            btnTypeLocation.addEventListener('click', () => {
                if (window.AppModes && window.AppModes.setLinkType) {
                    window.AppModes.setLinkType('location');
                }
            });
        }

        // ── Search Business Input Events ──
        if (searchClearBtn) {
            searchClearBtn.addEventListener('click', () => {
                if (businessSearchInput) {
                    businessSearchInput.value = '';
                    searchClearBtn.classList.remove('visible');
                    window.hidePlacesDropdown();
                    if (!window.isTouchDevice || !window.isTouchDevice()) businessSearchInput.focus();
                }
                if (window.AppModes) {
                    window.AppModes.clearModeResult('search');
                }
            });
        }

        document.addEventListener('click', e => {
            if (searchFieldWrapper && !searchFieldWrapper.contains(e.target)) {
                window.hidePlacesDropdown();
            }
        });

        if (businessSearchInput) {
            businessSearchInput.addEventListener('keydown', e => {
                if (placesDropdown && placesDropdown.classList.contains('show')) {
                    const items = placesDropdown.querySelectorAll('.place-suggestion-item');
                    if (e.key === 'ArrowDown') {
                        e.preventDefault();
                        highlightedSuggestionIndex = Math.min(highlightedSuggestionIndex + 1, items.length - 1);
                        items.forEach((item, i) => item.classList.toggle('selected', i === highlightedSuggestionIndex));
                        if (items[highlightedSuggestionIndex]) items[highlightedSuggestionIndex].scrollIntoView({ block: 'nearest' });
                        return;
                    }
                    if (e.key === 'ArrowUp') {
                        e.preventDefault();
                        highlightedSuggestionIndex = Math.max(highlightedSuggestionIndex - 1, 0);
                        items.forEach((item, i) => item.classList.toggle('selected', i === highlightedSuggestionIndex));
                        if (items[highlightedSuggestionIndex]) items[highlightedSuggestionIndex].scrollIntoView({ block: 'nearest' });
                        return;
                    }
                    if (e.key === 'Enter') {
                        e.preventDefault();
                        if (highlightedSuggestionIndex >= 0 && items[highlightedSuggestionIndex]) {
                            items[highlightedSuggestionIndex].click();
                        } else if (items.length > 0) {
                            items[0].click();
                        }
                        return;
                    }
                    if (e.key === 'Escape') {
                        window.hidePlacesDropdown();
                        return;
                    }
                }
            });

            businessSearchInput.addEventListener('input', () => {
                const val = businessSearchInput.value;
                const trimmed = val.trim();

                if (searchClearBtn) {
                    searchClearBtn.classList.toggle('visible', trimmed.length > 0);
                }

                if (/https?:\/\//i.test(trimmed) || /maps\.app\.goo\.gl/i.test(trimmed) || /goo\.gl\/maps/i.test(trimmed) || /placeid/i.test(trimmed) || /ChIJ/i.test(trimmed)) {
                    window.switchMode('link');
                    if (urlInput) urlInput.value = trimmed;
                    businessSearchInput.value = '';
                    window.hidePlacesDropdown();
                    if (window.showToast) window.showToast(window.I18N[window.getCurrentLang()].toastPasted, 'paste');
                    window.handleConvert();
                    return;
                }

                clearTimeout(autocompleteDebounceTimer);
                if (trimmed.length >= 2) {
                    autocompleteDebounceTimer = setTimeout(() => {
                        window.fetchPlaceSuggestions(trimmed);
                    }, 250);
                } else {
                    window.hidePlacesDropdown();
                }
            });
        }

        // ── Floating GitHub Button ──
        const fabGithub = $('fabGithub');
        if (fabGithub) {
            fabGithub.addEventListener('click', e => {
                e.preventDefault();
                window.open('https://github.com/zaid-a-salameh/quick-nfc', '_blank');
            });
        }

        // ── Language Selector Dropdown (10 Languages) ──
        const langDropdownContainers = document.querySelectorAll('.lang-selector-dropdown');
        langDropdownContainers.forEach(container => {
            const btn = container.querySelector('.lang-select-btn');
            if (!btn) return;

            btn.addEventListener('click', e => {
                e.stopPropagation();
                const isOpen = container.classList.contains('open');
                langDropdownContainers.forEach(c => {
                    if (c !== container) c.classList.remove('open');
                });
                container.classList.toggle('open', !isOpen);
                btn.setAttribute('aria-expanded', String(!isOpen));
            });

            container.querySelectorAll('.lang-dropdown-item').forEach(item => {
                item.addEventListener('click', e => {
                    e.stopPropagation();
                    const chosen = item.getAttribute('data-lang');
                    if (chosen && window.switchLanguage) {
                        window.switchLanguage(chosen);
                    }
                    container.classList.remove('open');
                    btn.setAttribute('aria-expanded', 'false');
                });
            });
        });

        document.addEventListener('click', () => {
            langDropdownContainers.forEach(c => {
                c.classList.remove('open');
                const b = c.querySelector('.lang-select-btn');
                if (b) b.setAttribute('aria-expanded', 'false');
            });
        });

        document.addEventListener('keydown', e => {
            if (e.key === 'Escape') {
                langDropdownContainers.forEach(c => {
                    c.classList.remove('open');
                    const b = c.querySelector('.lang-select-btn');
                    if (b) b.setAttribute('aria-expanded', 'false');
                });
            }
        });

        // ── Initialize ──
        window.applyLanguage(window.getCurrentLang(), false);
        window.initGoogleMapsPlaces();
        if (window.updateModeTabSlider) setTimeout(window.updateModeTabSlider, 60);
        if (document.fonts && document.fonts.ready) {
            document.fonts.ready.then(() => {
                if (window.updateModeTabSlider) window.updateModeTabSlider();
            }).catch(() => {});
        }
        window.addEventListener('resize', () => { if (window.updateModeTabSlider) window.updateModeTabSlider(); });
        // ── Scroll-driven Reveal Animation for Explanation Cards ──
        function initScrollReveal() {
            const targets = document.querySelectorAll('.step-card, .feat-card, .faq-item, .section-header');
            if (!targets.length) return;

            if (!('IntersectionObserver' in window)) {
                targets.forEach(el => el.classList.add('is-revealed'));
                return;
            }

            const observer = new IntersectionObserver((entries, obs) => {
                entries.forEach(entry => {
                    if (entry.isIntersecting) {
                        entry.target.classList.add('is-revealed');
                        obs.unobserve(entry.target);
                    }
                });
            }, {
                root: null,
                rootMargin: '0px 0px -40px 0px',
                threshold: 0.12
            });

            targets.forEach(el => {
                el.classList.add('reveal-on-scroll');
                observer.observe(el);
            });
        }
        initScrollReveal();


        const CURRENT_VERSION = 'v2.0.0';
        const navSupportBtn = $('navSupportBtn');
        const navBrandBadge = $('navBrandBadge');
        const appVersionText = $('appVersionText');
        if (navSupportBtn) {
            navSupportBtn.addEventListener('click', e => {
                e.preventDefault();
                window.open('https://github.com/sponsors/zaid-a-salameh', '_blank');
            });
        }
        if (navBrandBadge) {
            navBrandBadge.textContent = CURRENT_VERSION;
            navBrandBadge.addEventListener('click', e => {
                e.preventDefault();
                window.open('https://github.com/zaid-a-salameh/quick-nfc/releases/latest', '_blank');
            });
        }
        if (appVersionText) {
            appVersionText.textContent = CURRENT_VERSION;
        }
    });
})();
