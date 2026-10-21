// ========================================================
// Bilingual Translation Dictionary & Localization Engine
// ========================================================
(function() {
    'use strict';

        const I18N = {
            en: {
                apkDownload: "Get Android App",
                docTitle: "Review Link Generator",
                metaDesc: "Convert any Google Maps link into an instant 5-star review link. Generate QR codes and write to NFC cards effortlessly.",
                appTitle: "Review Link Generator",
                appSubtitle: "Convert Google Maps links to instant review links",
                tabLink: "Direct Link",
                tabSearch: "Find Business",
                placeholder: "Paste Google Maps link here...",
                trashTitle: "Clear text",
                pasteBtn: "Paste",
                convertBtn: "Convert Link",
                resolvingBtn: "Resolving link...",
                searchPlaceholder: "Enter business name & city (e.g. Al-Quds Restaurant Amman)...",
                searchStep1: "Type business name & click Search Maps",
                searchStep2: "Click 'Share' & copy link on Google Maps",
                searchStep3: "Click 'Auto-Paste & Convert' below!",
                btnLaunchMaps: "Search on Google Maps ↗",
                btnAutoPasteConvert: "Auto-Paste & Convert",
                toastEnterQuery: "Please enter a business name first",
                navApk: "Get APK",
                navGithub: "GitHub",
                tagHowItWorks: "Workflow",
                titleHowItWorks: "How It Works in 3 Simple Steps",
                subHowItWorks: "Generate frictionless review links that skyrocket your 5-star customer feedback",
                step1Title: "Copy or Find Link",
                step1Desc: "Search your place or copy your business share link directly from Google Maps app or browser.",
                step2Title: "Instant 5-Star Conversion",
                step2Desc: "Our engine extracts the Place ID and constructs a direct URL that pops open the 5-star rating window automatically.",
                step3Title: "Print QR or Tap NFC",
                step3Desc: "Download crisp QR codes for table tents and counter stands, or tap your phone to write to NFC cards with our Android app.",
                tagFeatures: "Advantages",
                titleFeatures: "Why Businesses Choose Our Tool",
                subFeatures: "Designed for speed, customer conversion, and modern contactless technology",
                feat1Title: "Direct 5-Star Pre-Selection",
                feat1Desc: "Customers don't have to search for the review button. The 5-star popup opens immediately upon opening the link.",
                feat2Title: "Free NFC Tag Writer",
                feat2Desc: "Program NFC review cards, stands, and stickers directly from our native Android app without subscription fees.",
                feat3Title: "High-Res Vector QR Codes",
                feat3Desc: "Download instant, clean QR codes formatted perfectly for print menus, flyers, and point-of-sale displays.",
                feat4Title: "Zero Tracking & 100% Free",
                feat4Desc: "No account required, no link redirection, no rate limits, and 100% open-source software you can trust.",
                tagFaq: "Knowledge Base",
                titleFaq: "Frequently Asked Questions",
                subFaq: "Everything you need to know about Google review links, QR codes, and NFC contactless cards",
                faq1Q: "How do I create a direct 5-star Google review link?",
                faq1A: "Simply search for your business name using our Find Business tool or copy your Google Maps share link and paste it here. Our system resolves your Google Place ID and crafts a direct URL that immediately opens the 5-star review submission pop-up for your customers.",
                faq2Q: "How does writing to NFC review cards work?",
                faq2A: "Download our free Android APK. After generating your review URL, tap 'Write to NFC Tag', then hold your NFC card, coin, or sticker to the back of your phone. The app formats the tag and writes your review link in under a second with zero subscription fees.",
                faq3Q: "Can I print the generated QR code for my business?",
                faq3A: "Yes! The generated QR code is high-resolution and downloadable in PNG format. You can print it on table talkers, restaurant menus, cash register counters, business cards, and packaging stickers.",
                faq4Q: "Is ReviewLinkGenerator free and does it require an API key?",
                faq4A: "Yes, it is 100% free and open-source. It does not require any Google Cloud API key, credit card, or user registration. All Place ID resolution and link formatting runs directly in your browser or Android device.",
                footerTagline: "Free open-source 5-star Google review link creator & NFC tool.",
                footerApk: "Android APK",
                footerBackToTop: "↑ Back to Top",
                footerCopyright: '© 2026 Developed by <a href="https://github.com/zaid-a-salameh" target="_blank" rel="noopener noreferrer">Zaid Salameh</a>. MIT License.',
                resultLabel: "Direct Review Link:",
                copyBtn: "Copy Link",
                copySuccess: "Copied!",
                openBtn: "Open Link",
                shareBtn: "Share Link",
                qrBtn: "Generate QR Code",
                qrModalTitle: "Google Review QR Code",
                qrModalDesc: "Scan with any smartphone camera to leave a review directly",
                qrDownloadBtn: "Download QR Image",
                qrCloseBtn: "Close",
                qrDownloaded: "QR Code downloaded",
                nfcBtn: "Write to NFC Tag",
                nfcTitleReady: "Ready to Write",
                nfcDescReady: "Hold your phone near an NFC card or sticker. Multi-tag writing is active.",
                nfcTitleSuccess: "Write Successful!",
                nfcDescSuccess: "Tag #{count} programmed! Hold next card to continue...",
                nfcTitleNext: "Ready for Next Card",
                nfcDescNext: "Hold the next NFC tag near your phone to write...",
                nfcCardsCount: "{count} tag(s) written",
                nfcCancel: "Cancel",
                nfcDone: "Done & Close",
                nfcTitleError: "Write Failed",
                nfcNoHardware: "NFC is not supported on this device",
                nfcDisabled: "Please enable NFC in your phone settings",
                nfcLocked: "NFC card is locked or read-only",
                nfcCapacity: "NFC card has insufficient memory",
                nfcUnsupported: "Unsupported NFC tag type",
                nfcWriteFailed: "Error writing to NFC tag. Try again.",
                toastPasteFirst: "Please paste a link first",
                toastInvalid: "Could not extract Place ID",
                toastNoInternet: "No network connection",
                toastSuccess: "Link converted successfully",
                toastNfcWritten: "Successfully written to NFC card",
                toastNfcBatchSuccess: "Successfully programmed {count} NFC card(s)",
                toastCleared: "Text cleared",
                toastPasted: "Pasted from clipboard",
                toastEmptyClip: "Clipboard is empty",
                toastClipDenied: "Press Ctrl+V to paste",
                toastCopied: "Review link copied",
                toastShareCopied: "Link copied for sharing",
                shareTitle: "Google Review",
                shareText: "Leave us a review on Google Maps",
                apiKeyConnected: "Google Maps Autocomplete Active",
                apiKeyAuthError: "API Key Authentication Error",
                apiKeyNotSet: "Configure Maps API / Demo Key",
                btnKeyConfigure: "API Key",
                gmpKeyTitle: "Google Maps Search Key",
                gmpKeyDesc: "Connect a Google Maps API Key or free Maps Demo Key to enable real-time business search predictions as you type.",
                gmpDemoHeadline: "Free Maps Demo Key (No Card Required):",
                gmpDemoSub: "Get an official demo key for prototyping in 1 click without any Google Cloud billing account.",
                gmpDemoLink: "Get Free Demo Key ↗",
                gmpApiKeyLabel: "Enter API Key:",
                gmpSafetySession: "Session Tokens: Keystrokes bundled into 1 single session",
                gmpSafetyFields: "Field Masking: Only basic ID & Name queried (no paid tiers)",
                gmpSafetyDebounce: "Debounce: 350ms delay & 3-character threshold",
                btnKeySave: "Save & Connect",
                btnKeyRemove: "Remove Key",
                toastKeySaved: "API Key saved. Connecting...",
                toastKeyRemoved: "API Key removed",
                toastHourlyLimit: "Hourly search limit reached to protect your quota",
                toastSelectSuccess: "Business selected and review link generated",
                updateAvailable: "Update Available",
                updateReadyTitle: "New Version Ready",
                updateCurrent: "Current",
                updateNew: "New",
                updateSize: "Size: {size}",
                updateDate: "Published: {date}",
                updateHighlights: "What's New in this Release",
                updateInstallBtn: "Download & Install Update",
                updateViewGithub: "Release Notes",
                updateLater: "Later",
                toastCheckingUpdate: "Checking for updates...",
                toastUpToDate: "You are already using the latest version ({version})",
                toastUpdateFound: "New version {version} is available!",
                toastUpdateError: "Unable to check for updates right now",
                toastDownloadStarted: "Downloading update in background...",
                toastQrSaveError: "Failed to save QR image"
            },
            ar: {
                apkDownload: "تحميل تطبيق الأندرويد",
                docTitle: "محوّل روابط التقييم",
                metaDesc: "حوّل أي رابط خرائط جوجل إلى رابط تقييم 5 نجوم مباشر مع إنشاء رمز QR والبرمجة على بطاقات NFC.",
                appTitle: "محوّل روابط التقييم",
                appSubtitle: "تحويل رابط خرائط جوجل إلى رابط تقييم فوري",
                tabLink: "وضع الرابط",
                tabSearch: "بحث عن مكان",
                placeholder: "الصق رابط Google Maps هنا...",
                trashTitle: "مسح النص",
                pasteBtn: "لصق",
                convertBtn: "تحويل الرابط",
                resolvingBtn: "جاري فك اختصار الرابط...",
                searchPlaceholder: "اكتب اسم المكان والمدينة (مثال: مطعم القدس عمان)...",
                searchStep1: "اكتب اسم نشاطك واضغط بحث في الخرائط",
                searchStep2: "اضغط مشاركة ثم نسخ الرابط من خرائط جوجل",
                searchStep3: "اضغط لصق ذكي وتحويل بالأسفل!",
                btnLaunchMaps: "بحث في خرائط جوجل ↗",
                btnAutoPasteConvert: "لصق ذكي وتحويل فوري",
                toastEnterQuery: "يرجى كتابة اسم المكان أولاً",
                navApk: "تحميل التطبيق",
                navGithub: "المستودع",
                tagHowItWorks: "طريقة العمل",
                titleHowItWorks: "كيف يعمل في 3 خطوات بسيطة؟",
                subHowItWorks: "أنشئ روابط تقييم مباشرة تضاعف تقييمات الـ 5 نجوم لعملائك دون أي تعقيد",
                step1Title: "ابحث أو انسخ الرابط",
                step1Desc: "ابحث عن نشاطك أو انسخ رابط المشاركة مباشرة من تطبيق خرائط جوجل أو المتصفح.",
                step2Title: "تحويل فوري إلى 5 نجوم",
                step2Desc: "محركنا الذكي يستخرج معرّف المكان (Place ID) ويولد رابطاً يفتح نافذة الـ 5 نجوم تلقائياً.",
                step3Title: "طباعة QR أو برمجة NFC",
                step3Desc: "نزّل كود QR عالي الدقة لطاولات ومكاتب الاستقبال، أو برمج بطاقات NFC بلمسة واحدة عبر تطبيق الأندرويد.",
                tagFeatures: "المميزات",
                titleFeatures: "لماذا تختار منصتنا لنشاطك التجاري؟",
                subFeatures: "صُممت خصيصاً لتحقيق أعلى معدل استجابة من العملاء باستخدام أحدث تقنيات اللمس",
                feat1Title: "فتح نافذة 5 نجوم مباشرة",
                feat1Desc: "لا حاجة للبحث عن زر التقييم داخل الخريطة؛ تنبثق شاشة تقييم الـ 5 نجوم فور فتح الرابط.",
                feat2Title: "برمجة بطاقات NFC مجاناً",
                feat2Desc: "برمج بطاقات واستندات وميداليات NFC الخاصة بتقييمك مباشرة من تطبيقنا دون رسوم أو اشتراكات.",
                feat3Title: "رموز QR فائقة الدقة",
                feat3Desc: "حمّل رموز استجابة سريعة فورية مهيأة للطباعة على القوائم، المنشورات، وشاشات نقاط البيع.",
                feat4Title: "مجاني 100% وبلا تتبع",
                feat4Desc: "بدون تسجيل دخول، بدون روابط وسيطة أو إعلانات، ومفتوح المصدر بالكامل مع خصوصية تامة.",
                tagFaq: "الأسئلة الشائعة",
                titleFaq: "الأسئلة الأكثر تكراراً",
                subFaq: "كل ما تحتاج معرفته حول روابط تقييم خرائط Google ورموز QR وبطاقات NFC",
                faq1Q: "كيف أنشئ رابط تقييم خرائط Google مباشر 5 نجوم؟",
                faq1A: "ابحث عن اسم نشاطك التجاري عبر أداة البحث أو الصق رابط مشاركة خرائط Google. سيقوم نظامنا باستخراج معرّف المكان (Place ID) وتوليد رابط مباشر يفتح نافذة كتابة التقييم مع تقييم 5 نجوم تلقائياً لعملائك.",
                faq2Q: "كيف تتم برمجة بطاقات الـ NFC لتقييمات Google؟",
                faq2A: "حمّل تطبيقنا المجاني لنظام أندرويد. بعد استخراج رابط التقييم، اضغط 'كتابة على بطاقة NFC'، ثم قرّب بطاقة أو ملصق NFC من ظهر الهاتف ليتم مسح وبرمجة الرابط فوراً في ثانية واحدة دون أي اشتراكات.",
                faq3Q: "هل يمكنني طباعة رمز QR للتقييم على مطبوعات نشاطي التجاري؟",
                faq3A: "نعم! رمز QR المُولد عالي الدقة وقابل للتنزيل بصيغة PNG، مما يجعله مثالياً للطباعة على استندات الطاولات، القوائم، كاونتر المحاسبة، كروت العمل والملصقات.",
                faq4Q: "هل الأداة مجانية وهل تتطلب مفتاح API أو بطاقة بنكية؟",
                faq4A: "الأداة مجانية ومفتوحة المصدر بالكامل بنسبة 100%. لا تتطلب أي مفتاح Google Cloud API أو بطاقة بنكية أو تسجيل حساب، وتعمل مباشرة عبر المتصفح أو تطبيق الأندرويد.",
                footerTagline: "أداة مفتوحة المصدر ومجانية لإنشاء روابط تقييم جوجل 5 نجوم وبرمجة بطاقات NFC.",
                footerApk: "تطبيق أندرويد",
                footerBackToTop: "↑ العودة للأعلى",
                footerCopyright: '© 2026 تم التطوير بواسطة <a href="https://github.com/zaid-a-salameh" target="_blank" rel="noopener noreferrer">زيد سلامة</a>. رخصة MIT.',
                resultLabel: "رابط التقييم المباشر:",
                copyBtn: "نسخ الرابط",
                copySuccess: "تم النسخ!",
                openBtn: "فتح الرابط",
                shareBtn: "مشاركة الرابط",
                qrBtn: "إنشاء رمز QR",
                qrModalTitle: "رمز QR لتقييم جوجل",
                qrModalDesc: "امسح الرمز بكاميرا أي هاتف ليفتح صفحة التقييم فوراً",
                qrDownloadBtn: "تنزيل صورة الـ QR",
                qrCloseBtn: "إغلاق",
                qrDownloaded: "تم تنزيل رمز الـ QR بنجاح",
                nfcBtn: "كتابة على بطاقة NFC",
                nfcTitleReady: "جاهز للكتابة على البطاقة",
                nfcDescReady: "قرّب بطاقة أو ملصق NFC من ظهر الهاتف. وضع الكتابة المتتالية مفعّل.",
                nfcTitleSuccess: "تمت الكتابة بنجاح!",
                nfcDescSuccess: "تمت برمجة البطاقة {count} بنجاح. جهّز البطاقة التالية...",
                nfcTitleNext: "جاهز للبطاقة التالية",
                nfcDescNext: "قرّب البطاقة التالية من ظهر الهاتف للبرمجة...",
                nfcCardsCount: "تمت برمجة: {count} بطاقات",
                nfcCancel: "إلغاء",
                nfcDone: "إنهاء وإغلاق",
                nfcTitleError: "فشلت الكتابة",
                nfcNoHardware: "جهازك لا يدعم خاصية الـ NFC",
                nfcDisabled: "يرجى تفعيل الـ NFC من إعدادات الهاتف أولاً",
                nfcLocked: "البطاقة محمية ضد الكتابة أو للقراءة فقط",
                nfcCapacity: "سعة البطاقة غير كافية للرابط",
                nfcUnsupported: "نوع بطاقة الـ NFC غير مدعوم",
                nfcWriteFailed: "حدث خطأ أثناء الكتابة. يرجى المحاولة مجدداً.",
                toastPasteFirst: "الرجاء لصق الرابط أولاً",
                toastInvalid: "تعذر استخراج معرّف المكان",
                toastNoInternet: "لا يوجد اتصال بالشبكة",
                toastSuccess: "تم تحويل الرابط بنجاح",
                toastNfcWritten: "تمت الكتابة على البطاقة بنجاح",
                toastNfcBatchSuccess: "تمت برمجة {count} بطاقات NFC بنجاح",
                toastCleared: "تم مسح النص",
                toastPasted: "تم اللصق من الحافظة",
                toastEmptyClip: "الحافظة فارغة",
                toastClipDenied: "اضغط Ctrl+V للصق الرابط",
                toastCopied: "تم نسخ رابط التقييم",
                toastShareCopied: "تم نسخ الرابط للمشاركة",
                shareTitle: "تقييم على Google",
                shareText: "شاركنا تقييمك على خرائط Google",
                apiKeyConnected: "البحث الحي عبر خرائط Google مفعّل",
                apiKeyAuthError: "خطأ في التحقق من مفتاح الـ API",
                apiKeyNotSet: "ربط مفتاح خرائط Google / المفتاح التجريبي",
                btnKeyConfigure: "مفتاح الـ API",
                gmpKeyTitle: "مفتاح بحث خرائط Google",
                gmpKeyDesc: "اربط مفتاح Google Maps API أو المفتاح التجريبي المجاني لتفعيل اقتراحات الأماكن الحية أثناء الكتابة.",
                gmpDemoHeadline: "مفتاح تجريبي مجاني (بدون أي بطاقة بنكية):",
                gmpDemoSub: "استخرج مفتاح تجريبي رسمي للتطوير بنقرة زر واحدة دون الحاجة لحساب فوترة في Google Cloud.",
                gmpDemoLink: "استخراج المفتاح التجريبي مجاناً ↗",
                gmpApiKeyLabel: "أدخل مفتاح الـ API:",
                gmpSafetySession: "رموز الجلسة (Sessions): دمج كل الحروف في طلب فوترة واحد",
                gmpSafetyFields: "حصر الحقول (Field Mask): طلب الاسم والمعرف فقط لحماية الرصيد",
                gmpSafetyDebounce: "مؤقت الأمان: تأخير 350ms وحد أدنى 3 أحرف لمنع استهلاك الطلبات",
                btnKeySave: "حفظ وتفعيل",
                btnKeyRemove: "إزالة المفتاح",
                toastKeySaved: "تم حفظ المفتاح، جاري الاتصال...",
                toastKeyRemoved: "تمت إزالة المفتاح",
                toastHourlyLimit: "تم الوصول للحد الأقصى للبحث في هذه الساعة لحماية الرصيد",
                toastSelectSuccess: "تم اختيار النشاط التجاري وتوليد رابط التقييم",
                updateAvailable: "تحديث جديد متوفر",
                updateReadyTitle: "إصدار جديد جاهز للتثبيت",
                updateCurrent: "الحالي",
                updateNew: "الجديد",
                updateSize: "الحجم: {size}",
                updateDate: "تاريخ النشر: {date}",
                updateHighlights: "أبرز مميزات هذا الإصدار",
                updateInstallBtn: "تنزيل وتثبيت التحديث الآن",
                updateViewGithub: "ملاحظات الإصدار",
                updateLater: "لاحقاً",
                toastCheckingUpdate: "جاري التحقق من وجود تحديثات...",
                toastUpToDate: "أنت تستخدم أحدث إصدار بالفعل ({version})",
                toastUpdateFound: "يتوفر إصدار جديد {version}!",
                toastUpdateError: "تعذر التحقق من التحديثات حالياً",
                toastDownloadStarted: "جاري تنزيل التحديث في الخلفية...",
                toastQrSaveError: "فشل حفظ صورة رمز الـ QR"
            }
        };

    let currentLang = localStorage.getItem('app_lang') || 'en';
    let isLangSwitching = false;

        function updateSliderPill(lang) {
            const isAr = lang === 'ar';
            const offset = isAr ? '48px' : '0px';

            if (btnEn && btnAr && langSlider) {
                if (isAr) {
                    btnEn.classList.remove('active');
                    btnAr.classList.add('active');
                } else {
                    btnAr.classList.remove('active');
                    btnEn.classList.add('active');
                }
                langSlider.style.transform = `translateX(${offset})`;
            }

            if (navBtnEn && navBtnAr && navLangSlider) {
                if (isAr) {
                    navBtnEn.classList.remove('active');
                    navBtnAr.classList.add('active');
                } else {
                    navBtnAr.classList.remove('active');
                    navBtnEn.classList.add('active');
                }
                navLangSlider.style.transform = `translateX(${offset})`;
            }
        }

        function updateDomLanguageStrings(lang, dict) {
            // Update HTML attributes
            document.documentElement.lang = lang;
            document.documentElement.dir = lang === 'ar' ? 'rtl' : 'ltr';
            document.title = dict.docTitle;
            if (metaDescription) metaDescription.setAttribute('content', dict.metaDesc);

            // Update text content
            if (apkDownloadLabel) apkDownloadLabel.textContent = dict.apkDownload;
            appTitle.textContent = dict.appTitle;
            appSubtitle.textContent = dict.appSubtitle;
            
            // Mode Switcher & Inputs
            if (tabLinkLabel) tabLinkLabel.textContent = dict.tabLink;
            if (tabSearchLabel) tabSearchLabel.textContent = dict.tabSearch;
            urlInput.placeholder = dict.placeholder;
            clearBtn.title = dict.trashTitle;
            pasteBtnLabel.textContent = dict.pasteBtn;
            pasteBtn.title = dict.pasteBtn;

            if (businessSearchInput) businessSearchInput.placeholder = dict.searchPlaceholder;
            
            if (!convertBtn.disabled) {
                btnText.textContent = dict.convertBtn;
            }
            
            resultLabelText.textContent = dict.resultLabel;
            if (!copyBtn.classList.contains('copied')) {
                copyBtnLabel.textContent = dict.copyBtn;
            }
            openBtnLabel.textContent = dict.openBtn;
            shareBtnLabel.textContent = dict.shareBtn;
            if (qrBtnLabel) qrBtnLabel.textContent = dict.qrBtn;
            if (qrModalTitle) qrModalTitle.textContent = dict.qrModalTitle;
            if (qrModalDesc) qrModalDesc.textContent = dict.qrModalDesc;
            if (qrDownloadBtnLabel) qrDownloadBtnLabel.textContent = dict.qrDownloadBtn;
            if (qrCloseBtn) qrCloseBtn.textContent = dict.qrCloseBtn;
            if (nfcBtnLabel) nfcBtnLabel.textContent = dict.nfcBtn;
            if (nfcCancelBtn) nfcCancelBtn.textContent = (nfcBatchCount > 0) ? dict.nfcDone : dict.nfcCancel;

            // Desktop Navbar
            if (navApkLabel) navApkLabel.textContent = dict.navApk;
            if (navGithubLabel) navGithubLabel.textContent = dict.navGithub;

            // Desktop Marketing & Footer
            if (tagHowItWorks) tagHowItWorks.textContent = dict.tagHowItWorks;
            if (titleHowItWorks) titleHowItWorks.textContent = dict.titleHowItWorks;
            if (subHowItWorks) subHowItWorks.textContent = dict.subHowItWorks;
            if (step1Title) step1Title.textContent = dict.step1Title;
            if (step1Desc) step1Desc.textContent = dict.step1Desc;
            if (step2Title) step2Title.textContent = dict.step2Title;
            if (step2Desc) step2Desc.textContent = dict.step2Desc;
            if (step3Title) step3Title.textContent = dict.step3Title;
            if (step3Desc) step3Desc.textContent = dict.step3Desc;
            if (tagFeatures) tagFeatures.textContent = dict.tagFeatures;
            if (titleFeatures) titleFeatures.textContent = dict.titleFeatures;
            if (subFeatures) subFeatures.textContent = dict.subFeatures;
            if (feat1Title) feat1Title.textContent = dict.feat1Title;
            if (feat1Desc) feat1Desc.textContent = dict.feat1Desc;
            if (feat2Title) feat2Title.textContent = dict.feat2Title;
            if (feat2Desc) feat2Desc.textContent = dict.feat2Desc;
            if (feat3Title) feat3Title.textContent = dict.feat3Title;
            if (feat3Desc) feat3Desc.textContent = dict.feat3Desc;
            if (feat4Title) feat4Title.textContent = dict.feat4Title;
            if (feat4Desc) feat4Desc.textContent = dict.feat4Desc;
            if (tagFaq) tagFaq.textContent = dict.tagFaq;
            if (titleFaq) titleFaq.textContent = dict.titleFaq;
            if (subFaq) subFaq.textContent = dict.subFaq;
            if (faq1Q) faq1Q.textContent = dict.faq1Q;
            if (faq1A) faq1A.textContent = dict.faq1A;
            if (faq2Q) faq2Q.textContent = dict.faq2Q;
            if (faq2A) faq2A.textContent = dict.faq2A;
            if (faq3Q) faq3Q.textContent = dict.faq3Q;
            if (faq3A) faq3A.textContent = dict.faq3A;
            if (faq4Q) faq4Q.textContent = dict.faq4Q;
            if (faq4A) faq4A.textContent = dict.faq4A;
            if (footerTagline) footerTagline.textContent = dict.footerTagline;
            if (footerApkLink) footerApkLink.textContent = dict.footerApk;
            if (footerBackToTop) footerBackToTop.textContent = dict.footerBackToTop;
            if (footerCopyright) footerCopyright.innerHTML = dict.footerCopyright;

            // App Update Modal
            if (updateBadgeText) updateBadgeText.textContent = dict.updateAvailable;
            if (updateModalTitle) updateModalTitle.textContent = dict.updateReadyTitle;
            if (lblCurrentVer) lblCurrentVer.textContent = dict.updateCurrent;
            if (lblLatestVer) lblLatestVer.textContent = dict.updateNew;
            if (updateChangelogHeader) updateChangelogHeader.textContent = dict.updateHighlights;
            if (btnUpdateNowLabel) btnUpdateNowLabel.textContent = dict.updateInstallBtn;
            if (btnUpdateGithubLabel) btnUpdateGithubLabel.textContent = dict.updateViewGithub;
            if (btnUpdateLater) btnUpdateLater.textContent = dict.updateLater;
        }

        function applyLanguage(lang, animate = true) {
            if (animate && (lang === currentLang || isLangSwitching)) return;

            currentLang = lang;
            localStorage.setItem('app_lang', lang);
            const dict = I18N[lang];

            // 1. Instant feedback: glide slider pill immediately with spring physics
            updateSliderPill(lang);

            if (!animate) {
                updateDomLanguageStrings(lang, dict);
                return;
            }

            // 2. Coordinated cross-dissolve with layout lock
            isLangSwitching = true;
            document.body.classList.add('is-lang-switching');

            // Phase 1: Wait for fade-out and subtle blur to reach apex (~140ms)
            setTimeout(() => {
                // Update DOM text & layout direction while completely invisible
                updateDomLanguageStrings(lang, dict);

                // Force layout reflow so the browser computes new RTL/LTR geometry and typography
                void document.documentElement.offsetHeight;

                // Phase 2: Smoothly bloom into focus
                requestAnimationFrame(() => {
                    document.body.classList.remove('is-lang-switching');
                    setTimeout(() => {
                        isLangSwitching = false;
                    }, 240);
                });
            }, 140);
        }

        // Toggle Listeners (Mobile Header)
        btnEn.addEventListener('click', () => {
            if (currentLang !== 'en') applyLanguage('en', true);
        });
        btnAr.addEventListener('click', () => {
            if (currentLang !== 'ar') applyLanguage('ar', true);
        });

        // Toggle Listeners (Desktop Navbar)
        if (navBtnEn) {
            navBtnEn.addEventListener('click', () => {
                if (currentLang !== 'en') applyLanguage('en', true);
            });
        }
        if (navBtnAr) {
            navBtnAr.addEventListener('click', () => {
                if (currentLang !== 'ar') applyLanguage('ar', true);
            });
        }

    function switchLanguage(lang) {
        if (lang === currentLang) return;
        currentLang = lang;
        try {
            localStorage.setItem('app_lang', lang);
        } catch (e) {}
        applyLanguage(lang, true);
    }

    // Expose globals
    window.I18N = I18N;
    window.getCurrentLang = function() { return currentLang; };
    window.setCurrentLang = function(l) { currentLang = l; try { localStorage.setItem('app_lang', l); } catch(e){} };
    window.updateSliderPill = updateSliderPill;
    window.updateDomLanguageStrings = updateDomLanguageStrings;
    window.applyLanguage = applyLanguage;
    window.switchLanguage = switchLanguage;
})();
