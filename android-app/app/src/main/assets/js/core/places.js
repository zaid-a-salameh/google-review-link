// ========================================================
// Google Maps Places Autocomplete & Search Mode Engine
// ========================================================
(function() {
    'use strict';

    const CONFIG_MAPS_API_KEY = 'AIzaSyB-s2VuNM3Cqbli4YF5YIry7qfR_r34_UE';

    let gmpPlacesLoaded = false;
    let gmpScriptLoadingPromise = null;
    let currentSessionToken = null;
    let autocompleteDebounceTimer = null;
    let highlightedSuggestionIndex = -1;
    let currentSuggestions = [];
    const autocompleteCache = new Map();

    let autocompleteHourlyCount = 0;
    let autocompleteHourlyResetTime = Date.now() + 3600000;

    function getDict() {
        const lang = window.getCurrentLang ? window.getCurrentLang() : 'en';
        return (window.I18N && window.I18N[lang]) ? window.I18N[lang] : {};
    }

    function checkHourlyRateLimit() {
        const now = Date.now();
        if (now > autocompleteHourlyResetTime) {
            autocompleteHourlyCount = 0;
            autocompleteHourlyResetTime = now + 3600000;
        }
        if (autocompleteHourlyCount >= 60) {
            return false;
        }
        autocompleteHourlyCount++;
        return true;
    }

    function escapeHtml(str) {
        if (!str) return '';
        return String(str).replace(/[&<>'"]/g, tag => ({
            '&': '&amp;',
            '<': '&lt;',
            '>': '&gt;',
            "'": '&#39;',
            '"': '&quot;'
        }[tag] || tag));
    }

    function isAuthorizedOrigin() {
        if (window.AndroidNative) return true;
        if (!window.location) return false;
        const proto = window.location.protocol || '';
        const host = window.location.hostname || '';
        if (host === 'zaid-a-salameh.github.io' || host === 'localhost' || host === '127.0.0.1') {
            return true;
        }
        if (proto === 'file:' && decodeURIComponent(window.location.href || '').indexOf('Zaid-PC') !== -1) {
            return true;
        }
        return false;
    }

    function getActiveMapsApiKey() {
        if (!isAuthorizedOrigin()) return '';
        return CONFIG_MAPS_API_KEY || '';
    }

    function getAutocompleteSessionToken() {
        if (!currentSessionToken && window.google && window.google.maps && window.google.maps.places && window.google.maps.places.AutocompleteSessionToken) {
            currentSessionToken = new google.maps.places.AutocompleteSessionToken();
        }
        return currentSessionToken;
    }

    function resetAutocompleteSessionToken() {
        if (window.google && window.google.maps && window.google.maps.places && window.google.maps.places.AutocompleteSessionToken) {
            currentSessionToken = new google.maps.places.AutocompleteSessionToken();
        } else {
            currentSessionToken = null;
        }
    }

    function initGoogleMapsPlaces() {
        const key = getActiveMapsApiKey();
        if (!key) {
            return Promise.resolve(false);
        }

        if (gmpPlacesLoaded && window.google && window.google.maps && window.google.maps.places && window.google.maps.places.AutocompleteSuggestion) {
            return Promise.resolve(true);
        }

        if (gmpScriptLoadingPromise) {
            return gmpScriptLoadingPromise;
        }

        gmpScriptLoadingPromise = new Promise((resolve) => {
            window.gm_authFailure = () => {
                console.error('Google Maps API authentication failed.');
                gmpPlacesLoaded = false;
                gmpScriptLoadingPromise = null;
                resolve(false);
            };

            window.__onGmpLoaded = async () => {
                try {
                    if (window.google && window.google.maps && window.google.maps.importLibrary) {
                        await google.maps.importLibrary("places");
                        gmpPlacesLoaded = true;
                        resolve(true);
                    } else {
                        gmpScriptLoadingPromise = null;
                        resolve(false);
                    }
                } catch (err) {
                    console.error('Error importing places library:', err);
                    gmpScriptLoadingPromise = null;
                    resolve(false);
                }
            };

            const existingScript = document.getElementById('gmpScript');
            if (existingScript) existingScript.remove();

            const script = document.createElement('script');
            script.id = 'gmpScript';
            script.src = `https://maps.googleapis.com/maps/api/js?key=${encodeURIComponent(key)}&v=weekly&libraries=places&loading=async&callback=__onGmpLoaded`;
            script.async = true;
            script.defer = true;
            script.onerror = () => {
                console.error('Failed to load Google Maps script.');
                gmpScriptLoadingPromise = null;
                resolve(false);
            };
            if (document.head) { document.head.appendChild(script); } else if (document.body) { document.body.appendChild(script); }
        });

        return gmpScriptLoadingPromise;
    }

    function hideDropdown() {
        const placesDropdown = document.getElementById('placesDropdown');
        const mainInputCard = document.getElementById('mainInputCard');
        const appContainer = document.getElementById('appContainer');
        const modeSearchContent = document.getElementById('modeSearchContent');
        const searchFieldWrapper = document.getElementById('searchFieldWrapper');
        const modeStage = document.getElementById('modeStage');

        if (placesDropdown) {
            placesDropdown.classList.remove('show');
            placesDropdown.innerHTML = '';
        }
        if (mainInputCard) mainInputCard.classList.remove('has-dropdown-open');
        if (appContainer) appContainer.classList.remove('has-dropdown-open');
        if (modeSearchContent) modeSearchContent.classList.remove('has-dropdown-open');
        if (searchFieldWrapper) searchFieldWrapper.classList.remove('has-dropdown-open');
        if (modeStage) modeStage.classList.remove('has-dropdown-open');
        highlightedSuggestionIndex = -1;
        currentSuggestions = [];
    }

    function highlightSuggestion(index) {
        const placesDropdown = document.getElementById('placesDropdown');
        if (!placesDropdown) return;
        const items = placesDropdown.querySelectorAll('.place-suggestion-item');
        items.forEach((item, i) => {
            if (i === index) {
                item.classList.add('selected');
                item.scrollIntoView({ block: 'nearest' });
            } else {
                item.classList.remove('selected');
            }
        });
    }

    async function fetchPlaceSuggestions(query) {
        const trimmed = query.trim();
        if (!trimmed || trimmed.length < 2) {
            hideDropdown();
            return;
        }

        if (!gmpPlacesLoaded) {
            const ready = await initGoogleMapsPlaces();
            if (!ready) return;
        }

        if (!window.google || !window.google.maps || !window.google.maps.places || !window.google.maps.places.AutocompleteSuggestion) {
            return;
        }

        const currentLang = window.getCurrentLang ? window.getCurrentLang() : 'en';
        const cacheKey = `${currentLang}:${trimmed.toLowerCase()}`;
        if (autocompleteCache.has(cacheKey)) {
            renderSuggestions(autocompleteCache.get(cacheKey));
            return;
        }

        if (!checkHourlyRateLimit()) {
            const dict = getDict();
            if (window.showToast) window.showToast(dict.toastHourlyLimit || 'Search limit reached', 'warn');
            return;
        }

        const searchSpinner = document.getElementById('searchSpinner');
        if (searchSpinner) searchSpinner.classList.add('active');

        try {
            const token = getAutocompleteSessionToken();
            const request = {
                input: trimmed,
                sessionToken: token,
                language: currentLang
            };

            const { suggestions } = await google.maps.places.AutocompleteSuggestion.fetchAutocompleteSuggestions(request);
            autocompleteCache.set(cacheKey, suggestions || []);
            renderSuggestions(suggestions || []);
        } catch (err) {
            console.warn('Autocomplete fetch error:', err);
            hideDropdown();
        } finally {
            if (searchSpinner) searchSpinner.classList.remove('active');
        }
    }

    function getPredictionStrings(pred) {
        const mainText = (pred.mainText && typeof pred.mainText.text === 'string')
            ? pred.mainText.text
            : ((pred.text && typeof pred.text.text === 'string') ? pred.text.text : String(pred.mainText || pred.text || ''));
        const secondaryText = (pred.secondaryText && typeof pred.secondaryText.text === 'string')
            ? pred.secondaryText.text
            : '';
        return { mainText, secondaryText };
    }

    function renderSuggestions(suggestions) {
        currentSuggestions = suggestions || [];
        highlightedSuggestionIndex = -1;

        if (!currentSuggestions.length) {
            hideDropdown();
            return;
        }

        const placesDropdown = document.getElementById('placesDropdown');
        const mainInputCard = document.getElementById('mainInputCard');
        const appContainer = document.getElementById('appContainer');
        const modeSearchContent = document.getElementById('modeSearchContent');
        const searchFieldWrapper = document.getElementById('searchFieldWrapper');

        if (!placesDropdown) return;
        placesDropdown.innerHTML = '';

        currentSuggestions.forEach((sugg, idx) => {
            const pred = sugg.placePrediction;
            if (!pred) return;

            const { mainText, secondaryText } = getPredictionStrings(pred);

            const item = document.createElement('div');
            item.className = 'place-suggestion-item';
            item.setAttribute('role', 'option');
            item.setAttribute('data-index', idx);
            item.innerHTML = `
                <div class="place-icon">
                    <svg viewBox="0 0 24 24"><path d="M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z"/></svg>
                </div>
                <div class="place-text">
                    <div class="place-main">${escapeHtml(mainText)}</div>
                    ${secondaryText ? `<div class="place-secondary">${escapeHtml(secondaryText)}</div>` : ''}
                </div>
            `;

            item.addEventListener('click', (e) => {
                e.stopPropagation();
                selectSuggestion(sugg);
            });

            placesDropdown.appendChild(item);
        });

        // Powered by Google Attribution (Mandatory under ToS)
        const attribution = document.createElement('div');
        attribution.className = 'places-attribution';
        attribution.innerHTML = `
            <span>powered by</span>
            <svg viewBox="0 0 74 24" height="14" width="44">
                <path fill="#4285F4" d="M9.24 9.19v2.45h5.86c-.24 1.37-1.6 4.02-5.86 4.02-3.53 0-6.4-2.91-6.4-6.49 0-3.58 2.87-6.49 6.4-6.49 2.01 0 3.36.86 4.13 1.6l1.94-1.87C13.98 1.15 11.78.25 9.24.25 4.31.25.29 4.28.29 9.17s4.02 8.92 8.95 8.92c5.15 0 8.57-3.62 8.57-8.73 0-.59-.06-1.03-.14-1.47H9.24z"/>
                <path fill="#EA4335" d="M23.95 6.36c-3.15 0-5.71 2.45-5.71 5.69 0 3.22 2.56 5.69 5.71 5.69 3.15 0 5.71-2.47 5.71-5.69 0-3.24-2.56-5.69-5.71-5.69zm0 9.13c-1.73 0-3.22-1.42-3.22-3.44 0-2.04 1.49-3.44 3.22-3.44 1.73 0 3.22 1.4 3.22 3.44 0 2.02-1.49 3.44-3.22 3.44z"/>
                <path fill="#FBBC05" d="M36.19 6.36c-3.15 0-5.71 2.45-5.71 5.69 0 3.22 2.56 5.69 5.71 5.69 3.15 0 5.71-2.47 5.71-5.69 0-3.24-2.56-5.69-5.71-5.69zm0 9.13c-1.73 0-3.22-1.42-3.22-3.44 0-2.04 1.49-3.44 3.22-3.44 1.73 0 3.22 1.4 3.22 3.44 0 2.02-1.49 3.44-3.22 3.44z"/>
                <path fill="#4285F4" d="M48.06 6.36c-3.04 0-5.46 2.47-5.46 5.69 0 3.2 2.42 5.69 5.46 5.69 1.83 0 2.87-.79 3.57-1.62v1.31c0 2.18-1.16 3.34-3.04 3.34-1.53 0-2.49-1.1-2.89-2.02l-2.18.91c.63 1.51 2.3 3.36 5.07 3.36 2.95 0 5.44-1.73 5.44-5.91V6.65h-2.39v1.07c-.7-.84-1.76-1.36-3.58-1.36zm.26 9.13c-1.69 0-3.08-1.42-3.08-3.44 0-2.04 1.39-3.44 3.08-3.44 1.67 0 2.97 1.4 2.97 3.44 0 2.02-1.3 3.44-2.97 3.44z"/>
                <path fill="#34A853" d="M55.85.5h2.51v17.25h-2.51z"/>
                <path fill="#EA4335" d="M64.71 15.49c-1.29 0-2.19-.59-2.79-1.76l7.65-3.15-.26-.65c-.48-1.31-1.95-3.57-4.9-3.57-2.95 0-5.4 2.31-5.4 5.69 0 3.2 2.43 5.69 5.7 5.69 2.64 0 4.17-1.62 4.8-2.56l-1.97-1.31c-.63.95-1.51 1.62-2.83 1.62zm-.19-7.08c1.01 0 1.87.52 2.15 1.25l-5.15 2.13c0-2.4 1.71-3.38 3-3.38z"/>
            </svg>
        `;
        placesDropdown.appendChild(attribution);

        placesDropdown.classList.add('show');
        if (mainInputCard) mainInputCard.classList.add('has-dropdown-open');
        if (appContainer) appContainer.classList.add('has-dropdown-open');
        if (modeSearchContent) modeSearchContent.classList.add('has-dropdown-open');
        if (searchFieldWrapper) searchFieldWrapper.classList.add('has-dropdown-open');
        const modeStage = document.getElementById('modeStage');
        if (modeStage) modeStage.classList.add('has-dropdown-open');
    }

    async function selectSuggestion(suggestion) {
        if (!suggestion || !suggestion.placePrediction) return;
        const pred = suggestion.placePrediction;
        const placeId = pred.placeId;
        const { mainText, secondaryText } = getPredictionStrings(pred);
        const dict = getDict();

        const businessSearchInput = document.getElementById('businessSearchInput');
        const searchClearBtn = document.getElementById('searchClearBtn');
        const urlInput = document.getElementById('urlInput');
        const resultCard = document.getElementById('resultCard');
        const resultLinkText = document.getElementById('resultLinkText');

        hideDropdown();
        if (businessSearchInput) {
            businessSearchInput.value = secondaryText ? `${mainText} - ${secondaryText}` : mainText;
        }
        if (searchClearBtn) searchClearBtn.classList.add('visible');

        resetAutocompleteSessionToken();

        if (placeId) {
            const wasResultActive = Boolean(resultCard && resultCard.classList.contains('active'));
            const reviewUrl = `https://search.google.com/local/writereview?placeid=${encodeURIComponent(placeId)}`;
            if (window.AppModes) {
                window.AppModes.setModeResult('search', reviewUrl);
            } else {
                if (window.setGeneratedReviewUrl) window.setGeneratedReviewUrl(reviewUrl);
                if (resultLinkText) resultLinkText.textContent = reviewUrl;
                if (resultCard) resultCard.classList.add('active');
            }
            if (resultCard && !wasResultActive && (!window.AppModes || window.AppModes.search.isResultActive)) {
                resultCard.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
            }
            if (window.showToast) window.showToast(dict.toastSelectSuccess || 'Business selected and review link generated', 'success');
        } else {
            if (window.showToast) window.showToast(dict.toastInvalid || 'Could not extract Place ID', 'error');
        }
    }

    function updateModeTabSlider() {
        const slider = document.getElementById('modeTabSlider');
        const activeTab = document.querySelector('.mode-tab.active');
        if (!slider || !activeTab) return;

        slider.style.left = '0px';
        slider.style.right = 'auto';
        slider.style.width = `${activeTab.offsetWidth}px`;
        slider.style.transform = `translate3d(${activeTab.offsetLeft}px, 0, 0)`;
    }

    function switchMode(mode) {
        const tabLinkMode = document.getElementById('tabLinkMode');
        const tabSearchMode = document.getElementById('tabSearchMode');
        const modeLinkContent = document.getElementById('modeLinkContent');
        const modeSearchContent = document.getElementById('modeSearchContent');
        const urlInput = document.getElementById('urlInput');
        const businessSearchInput = document.getElementById('businessSearchInput');
        const mainInputCard = document.getElementById('mainInputCard');

        const currentTab = mode === 'link' ? tabLinkMode : tabSearchMode;
        const currentContent = mode === 'link' ? modeLinkContent : modeSearchContent;
        const isDomActive = Boolean(currentTab && currentTab.classList.contains('active') &&
                                    currentContent && currentContent.classList.contains('active'));

        if (window.AppModes && window.AppModes.activeMode === mode && isDomActive) return;

        if (window.AppModes) {
            window.AppModes.activeMode = mode;
        }

        if (mode === 'link') {
            if (tabLinkMode) tabLinkMode.classList.add('active');
            if (tabSearchMode) tabSearchMode.classList.remove('active');
            if (modeLinkContent) modeLinkContent.classList.add('active');
            if (modeSearchContent) modeSearchContent.classList.remove('active');
            hideDropdown();
            if (urlInput && (!window.isTouchDevice || !window.isTouchDevice())) urlInput.focus();
        } else {
            if (tabSearchMode) tabSearchMode.classList.add('active');
            if (tabLinkMode) tabLinkMode.classList.remove('active');
            if (modeSearchContent) modeSearchContent.classList.add('active');
            if (modeLinkContent) modeLinkContent.classList.remove('active');
            if (businessSearchInput && (!window.isTouchDevice || !window.isTouchDevice())) businessSearchInput.focus();
            initGoogleMapsPlaces();
        }

        updateModeTabSlider();

        if (window.AppModes) {
            window.AppModes.syncResultCard();
        } else if (window.syncToolsVisibility) {
            window.syncToolsVisibility();
        }
    }

    window.initGoogleMapsPlaces = initGoogleMapsPlaces;
    window.fetchPlaceSuggestions = fetchPlaceSuggestions;
    window.hidePlacesDropdown = hideDropdown;
    window.selectSuggestion = selectSuggestion;
    window.switchMode = switchMode;
    window.updateModeTabSlider = updateModeTabSlider;
})();
