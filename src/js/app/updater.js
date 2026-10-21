// ========================================================
// In-App Version Checker & Self-Updating Engine
// ========================================================
(function() {
    'use strict';

        const GITHUB_REPO_OWNER = 'zaid-a-salameh';
        const GITHUB_REPO_NAME = 'google-review-link';
        const GITHUB_LATEST_RELEASE_URL = `https://api.github.com/repos/${GITHUB_REPO_OWNER}/${GITHUB_REPO_NAME}/releases/latest`;
        
        // Detect native app version if available, fallback to 1.0.0
        let currentAppVersion = '1.1.0';
        if (window.AndroidNative && typeof window.AndroidNative.getAppVersion === 'function') {
            try {
                currentAppVersion = window.AndroidNative.getAppVersion() || '1.1.0';
            } catch (e) {
                currentAppVersion = '1.1.0';
            }
        }
        
        // Update version labels in DOM on startup
        const displayVersion = 'v' + currentAppVersion.replace(/^v/i, '');
        if (appVersionText) appVersionText.textContent = displayVersion;
        if (navBrandBadge) navBrandBadge.textContent = displayVersion;
        if (updateCurrentVer) updateCurrentVer.textContent = displayVersion;

        let latestReleaseData = null;
        let latestApkDownloadUrl = '';
        let isCheckingUpdate = false;

        function parseSemVer(verStr) {
            if (!verStr) return [0, 0, 0];
            const cleaned = String(verStr).trim().replace(/^v/i, '');
            const parts = cleaned.split('.').map(p => parseInt(p, 10) || 0);
            while (parts.length < 3) parts.push(0);
            return parts.slice(0, 3);
        }

        function compareVersions(v1, v2) {
            const p1 = parseSemVer(v1);
            const p2 = parseSemVer(v2);
            for (let i = 0; i < 3; i++) {
                if (p1[i] > p2[i]) return 1;
                if (p1[i] < p2[i]) return -1;
            }
            return 0;
        }

        function formatBytes(bytes) {
            if (!bytes || isNaN(bytes)) return '';
            const mb = (bytes / (1024 * 1024)).toFixed(1);
            return `${mb} MB`;
        }

        function formatReleaseDate(dateStr) {
            if (!dateStr) return '';
            try {
                const d = new Date(dateStr);
                return d.toLocaleDateString(currentLang === 'ar' ? 'ar-EG' : 'en-US', {
                    year: 'numeric',
                    month: 'short',
                    day: 'numeric'
                });
            } catch (e) {
                return dateStr;
            }
        }

        function renderReleaseMarkdown(md) {
            if (!md) return '';
            let html = md
                .replace(/&/g, '&amp;')
                .replace(/</g, '&lt;')
                .replace(/>/g, '&gt;');

            // Headings
            html = html.replace(/^### (.*$)/gim, '<h4 style="margin:8px 0 4px;color:#fdba74;font-size:12px;">$1</h4>');
            html = html.replace(/^## (.*$)/gim, '<h3 style="margin:10px 0 6px;color:#fff;font-size:13px;">$1</h3>');

            // Bold & Code
            html = html.replace(/\*\*(.*?)\*\*/g, '<strong>$1</strong>');
            html = html.replace(/`(.*?)`/g, '<code style="background:rgba(255,255,255,0.08);padding:1px 4px;border-radius:4px;font-size:11px;">$1</code>');

            // Bullet points
            const lines = html.split('\n');
            let inList = false;
            let outputLines = [];

            for (let line of lines) {
                const trimmed = line.trim();
                if (trimmed.startsWith('- ') || trimmed.startsWith('* ')) {
                    if (!inList) {
                        outputLines.push('<ul>');
                        inList = true;
                    }
                    outputLines.push('<li>' + trimmed.substring(2) + '</li>');
                } else {
                    if (inList) {
                        outputLines.push('</ul>');
                        inList = false;
                    }
                    if (trimmed) {
                        outputLines.push('<p style="margin:3px 0;">' + trimmed + '</p>');
                    }
                }
            }
            if (inList) outputLines.push('</ul>');

            return outputLines.join('');
        }

        function openUpdateModal(release, apkAsset) {
            if (!release) return;
            const dict = I18N[currentLang];

            if (updateCurrentVer) updateCurrentVer.textContent = 'v' + currentAppVersion.replace(/^v/i, '');
            if (updateLatestVer) updateLatestVer.textContent = release.tag_name || 'v1.1.0';

            if (updateFileSize) {
                const sizeText = apkAsset ? formatBytes(apkAsset.size) : '~2.4 MB';
                updateFileSize.textContent = dict.updateSize.replace('{size}', sizeText);
            }

            if (updateReleaseDate) {
                const dateText = formatReleaseDate(release.published_at);
                updateReleaseDate.textContent = dict.updateDate.replace('{date}', dateText);
            }

            if (updateChangelogBody) {
                updateChangelogBody.innerHTML = renderReleaseMarkdown(release.body) || '<p>No details provided for this release.</p>';
            }

            if (btnUpdateGithub) {
                btnUpdateGithub.href = release.html_url || `https://github.com/${GITHUB_REPO_OWNER}/${GITHUB_REPO_NAME}/releases`;
            }

            latestApkDownloadUrl = apkAsset ? apkAsset.browser_download_url : `https://github.com/${GITHUB_REPO_OWNER}/${GITHUB_REPO_NAME}/releases/latest/download/ReviewLinkGenerator.apk`;

            if (updateOverlay) {
                updateOverlay.classList.add('active');
            }
        }

        function closeUpdateModal() {
            if (updateOverlay) {
                updateOverlay.classList.remove('active');
            }
        }

        async function checkForAppUpdates(isManual = false) {
            if (isCheckingUpdate) return;
            isCheckingUpdate = true;
            const dict = I18N[currentLang];

            if (isManual) {
                showToast(dict.toastCheckingUpdate, 'download');
            }

            try {
                const controller = (typeof AbortController !== 'undefined') ? new AbortController() : null;
                const timeoutId = controller ? setTimeout(() => controller.abort(), 3500) : null;

                const res = await fetch(GITHUB_LATEST_RELEASE_URL, {
                    headers: { 'Accept': 'application/vnd.github.v3+json' },
                    cache: 'no-cache',
                    signal: controller ? controller.signal : undefined
                });
                if (timeoutId) clearTimeout(timeoutId);

                if (!res.ok) {
                    throw new Error(`HTTP status ${res.status}`);
                }

                const data = await res.json();
                latestReleaseData = data;

                const latestTag = data.tag_name || '';
                const assets = data.assets || [];
                const apkAsset = assets.find(a => a.name && a.name.toLowerCase().endsWith('.apk')) || assets[0];

                if (compareVersions(latestTag, currentAppVersion) > 0) {
                    // Newer version detected
                    if (btnCheckUpdate) {
                        btnCheckUpdate.classList.add('has-update');
                        btnCheckUpdate.title = dict.updateAvailable + ` (${latestTag})`;
                    }
                    if (navBrandBadge) {
                        navBrandBadge.classList.add('has-update');
                        navBrandBadge.title = dict.updateAvailable + ` (${latestTag})`;
                    }

                    openUpdateModal(data, apkAsset);

                    if (isManual) {
                        showToast(dict.toastUpdateFound.replace('{version}', latestTag), 'success');
                    }
                } else {
                    // Up-to-date
                    if (btnCheckUpdate) {
                        btnCheckUpdate.classList.remove('has-update');
                    }
                    if (navBrandBadge) {
                        navBrandBadge.classList.remove('has-update');
                    }
                    if (isManual) {
                        showToast(dict.toastUpToDate.replace('{version}', currentAppVersion), 'success');
                    }
                }
            } catch (err) {
                console.warn('Update check bypassed:', err.name === 'AbortError' ? 'timeout' : err.message);
                if (isManual) {
                    showToast(dict.toastUpdateError, 'error');
                }
            } finally {
                isCheckingUpdate = false;
            }
        }

    window.checkForAppUpdates = checkForAppUpdates;
    window.openUpdateModal = openUpdateModal;
    window.closeUpdateModal = closeUpdateModal;
})();
