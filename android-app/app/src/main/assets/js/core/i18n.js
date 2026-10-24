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
                placeholder: "Paste link here...",
                trashTitle: "Clear text",
                pasteBtn: "Paste",
                convertBtn: "Convert Link",
                resolvingBtn: "Resolving link...",
                searchPlaceholder: "Search place name & city...",
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
                step1Desc: "Copy your Google Maps link or search for your place directly.",
                step2Title: "Instant 5-Star Conversion",
                step2Desc: "The link automatically converts into an instant 5-star review prompt.",
                step3Title: "Print QR or Tap NFC",
                step3Desc: "Download a print-ready QR code or write to an NFC card with one tap.",
                tagFeatures: "Advantages",
                titleFeatures: "Why Businesses Choose Our Tool",
                subFeatures: "Designed for speed, customer conversion, and modern contactless technology",
                feat1Title: "Direct 5-Star Pre-Selection",
                feat1Desc: "The 5-star rating popup opens directly without searching through Maps.",
                feat2Title: "Free NFC Tag Writer",
                feat2Desc: "Program NFC review cards and stands directly from the app for free.",
                feat3Title: "High-Res Vector QR Codes",
                feat3Desc: "Get crisp, high-resolution QR codes ready for printing on tables and menus.",
                feat4Title: "Zero Tracking & 100% Free",
                feat4Desc: "Free forever, no login required, no ads or redirects, and 100% open-source.",
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
                footerGithub: "GitHub Repository",
                footerBackToTop: "↑ Back to Top",
                footerCopyright: '© 2026 Developed by <a href="https://github.com/zaid-a-salameh" target="_blank" rel="noopener noreferrer">Zaid Salameh</a>. MIT License.',
                resultLabel: "Direct Link:",
                resultLabelReview: "Direct Review Link:",
                resultLabelCustom: "Direct Link:",
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
                lblReadTag: "Read Card to Copy",
                lblPwdLockTag: "PIN Lock / Unlock",
                lblPermLockTag: "Permanent Lock",
                nfcBtn: "Write to NFC Tag",
                nfcTitleReady: "Ready to Write",
                nfcDescReady: "Hold your phone near an NFC card or sticker to write the link.",
                nfcTitleReadReady: "Ready to Read Card",
                nfcDescReadReady: "Hold phone near NFC card or sticker to read its link.",
                nfcTitlePermLockReady: "Ready to Permanently Lock",
                nfcDescPermLockReady: "Hold phone near NFC card to apply permanent read-only lock.",
                nfcTitlePwdLockReady: "Ready to Set PIN",
                nfcDescPwdLockReady: "Hold phone near NFC card to lock with your PIN.",
                nfcTitlePwdUnlockReady: "Ready to Unlock",
                nfcDescPwdUnlockReady: "Hold phone near NFC card to remove PIN protection.",
                pwdModalTitle: "Card Password Protection",
                pwdModalTitleLock: "Lock Card",
                pwdModalTitleUnlock: "Unlock Card",
                pwdModalDesc: "Set a password or PIN to prevent unauthorized modifications",
                pwdModalDescLock: "Set a password or PIN to prevent unauthorized modifications",
                pwdModalDescUnlock: "Enter current PIN to remove protection and allow editing",
                pwdHintText: "4 characters recommended for standard NFC compatibility",
                pwdInfoToast: "4 characters recommended for 100% universal compatibility across all NFC tools",
                pwdPlaceholder: "Enter password or PIN...",
                pwdTabLock: "Lock Card",
                pwdTabUnlock: "Unlock Card",
                pwdSubmitLock: "Lock Card & Touch Phone",
                pwdSubmitUnlock: "Unlock & Touch Phone",
                pwdCancel: "Cancel",
                toastEnterPwd: "Please enter a password or PIN",
                permLockTitle: "Permanent Hardware Lock",
                permLockDesc: "Warning: This permanently locks the NFC card to Read-Only mode. It CANNOT be edited or unlocked ever again.",
                permLockConfirmBtn: "Confirm Permanent Lock",
                permLockCancelBtn: "Cancel",
                toastNfcReadSuccess: "Link read and loaded successfully",
                toastNfcReadEmpty: "No valid URL found on this card",
                toastNfcPermLockSuccess: "Card permanently locked to Read-Only",
                toastNfcPwdLockSuccess: "Card locked with PIN successfully",
                toastNfcPwdUnlockSuccess: "Card unlocked successfully",
                toastNfcWrongPwd: "Incorrect PIN or unlocking failed",
                toastNfcPwdUnsupported: "PIN protection is not supported on this card",
                toastNfcAlreadyUnlocked: "Card is not locked",
                toastNfcAlreadyLocked: "Card is already locked with a PIN. Unlock it first to change PIN.",
                nfcTitleSuccess: "Write Successful!",
                nfcDescSuccess: "The review link was successfully programmed onto the card.",
                nfcTitleNext: "Ready to Write",
                nfcDescNext: "Hold another card near your phone to write, or tap Done.",
                nfcCardsCount: "Cards written: {count}",
                nfcCancel: "Cancel",
                nfcDone: "Done & Close",
                nfcOk: "OK",
                nfcTitlePwdLockSuccess: "Card Locked Successfully",
                nfcDescPwdLockSuccess: "PIN protection enabled. Card modifications are locked.",
                nfcTitlePwdUnlockSuccess: "Card Unlocked Successfully",
                nfcDescPwdUnlockSuccess: "Protection removed. You can now write or modify the card freely.",
                nfcTitleAlreadyUnlocked: "Card Is Not Locked",
                nfcDescAlreadyUnlocked: "This card does not have password protection enabled and is already fully writable.",
                nfcTitleTagLost: "Connection Dropped / Weak Signal",
                nfcDescTagLost: "Communication lost due to phone movement or weak NFC signal. Please hold the phone steadily over the card without moving it.",
                nfcTitleLocked: "Card Is Protected",
                nfcTitleReadLocked: "Card is Read-Protected",
                nfcDescReadLocked: "Cannot read card data because it is password protected against reading.",
                nfcTitleWrongPwd: "Incorrect PIN",
                nfcTitleAlreadyLocked: "Card Already Locked",
                nfcTitleCapacity: "Memory Capacity Exceeded",
                nfcTitleEmptyTag: "Empty Card",
                nfcTitlePermLockSuccess: "Card Permanently Locked",
                nfcDescPermLockSuccess: "Card has been permanently set to Read-Only mode.",
                nfcTitleError: "Write Failed",
                nfcDescLocked: "Operation failed because this card is password-protected or read-only. Please unlock it first.",
                nfcDescCapacity: "Link size exceeds this card's memory capacity.",
                nfcDescUnsupported: "This card type is not supported for writing.",
                nfcDescGenericError: "Write operation failed. Ensure the phone is held steady near the card.",
                nfcRetryBtn: "Try Again",
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
                toastUpToDate: "App is up to date ({version})",
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
                placeholder: "الصق رابط الخريطة هنا...",
                trashTitle: "مسح النص",
                pasteBtn: "لصق",
                convertBtn: "تحويل الرابط",
                resolvingBtn: "جاري فك اختصار الرابط...",
                searchPlaceholder: "ابحث باسم المكان والمدينة...",
                searchStep1: "اكتب اسم نشاطك واضغط بحث في الخرائط",
                searchStep2: "اضغط مشاركة ثم نسخ الرابط من خرائط جوجل",
                searchStep3: "اضغط لصق ذكي وتحويل بالأسفل!",
                btnLaunchMaps: "بحث في خرائط جوجل ↗",
                btnAutoPasteConvert: "لصق ذكي وتحويل فوري",
                toastEnterQuery: "يرجى كتابة اسم المكان أولاً",
                navApk: "تحميل التطبيق",
                navGithub: "GitHub",
                tagHowItWorks: "طريقة العمل",
                titleHowItWorks: "كيف يعمل في 3 خطوات بسيطة؟",
                subHowItWorks: "أنشئ روابط تقييم مباشرة تضاعف تقييمات الـ 5 نجوم لعملائك دون أي تعقيد",
                step1Title: "ابحث أو انسخ الرابط",
                step1Desc: "انسخ رابط مكانك من خرائط Google أو ابحث عنه مباشرة باسمه.",
                step2Title: "تحويل فوري إلى 5 نجوم",
                step2Desc: "يتحول الرابط تلقائياً إلى رابط تقييم يفتح نافذة الـ 5 نجوم للعميل فوراً.",
                step3Title: "طباعة QR أو برمجة NFC",
                step3Desc: "حمّل كود QR للطباعة أو برمج بطاقة NFC بلمسة واحدة من هاتفك.",
                tagFeatures: "المميزات",
                titleFeatures: "لماذا تختار منصتنا لنشاطك التجاري؟",
                subFeatures: "صُممت خصيصاً لتحقيق أعلى معدل استجابة من العملاء باستخدام أحدث تقنيات اللمس",
                feat1Title: "فتح نافذة 5 نجوم مباشرة",
                feat1Desc: "تفتح نافذة الـ 5 نجوم للعميل بضغطة واحدة دون الحاجة للبحث في الخريطة.",
                feat2Title: "برمجة بطاقات NFC مجاناً",
                feat2Desc: "برمج بطاقات واستندات NFC لتقييمك مباشرة من التطبيق مجاناً وبلا اشتراكات.",
                feat3Title: "رموز QR فائقة الدقة",
                feat3Desc: "احصل على كود QR واضح وعالي الدقة جاهز للطباعة على الطاولات والمطبوعات.",
                feat4Title: "مجاني 100% وبلا تتبع",
                feat4Desc: "استخدام فوري بدون حساب، وبلا إعلانات أو روابط وسيطة، ومفتوح المصدر بالكامل.",
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
                footerGithub: "مستودع GitHub",
                footerBackToTop: "↑ العودة للأعلى",
                footerCopyright: '© 2026 تم التطوير بواسطة <a href="https://github.com/zaid-a-salameh" target="_blank" rel="noopener noreferrer">زيد سلامة</a>. رخصة MIT.',
                resultLabel: "الرابط المباشر:",
                resultLabelReview: "رابط التقييم المباشر:",
                resultLabelCustom: "الرابط المباشر:",
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
                lblReadTag: "قراءة كارت للنسخ",
                lblPwdLockTag: "قفل / فك برمز",
                lblPermLockTag: "إقفال نهائي",
                nfcBtn: "كتابة على بطاقة NFC",
                nfcTitleReady: "جاهز للكتابة على البطاقة",
                nfcDescReady: "قرب ظهر هاتفك من بطاقة NFC أو الملصق لكتابة الرابط.",
                nfcTitleReadReady: "جاهز لقراءة البطاقة",
                nfcDescReadReady: "قرّب ظهر الهاتف من بطاقة NFC لقراءة الرابط المخزن...",
                nfcTitlePermLockReady: "جاهز للإقفال النهائي",
                nfcDescPermLockReady: "قرّب ظهر الهاتف من البطاقة لتطبيق القفل العتادي الدائم...",
                nfcTitlePwdLockReady: "جاهز للقفل برمز PIN",
                nfcDescPwdLockReady: "قرّب ظهر الهاتف من البطاقة لتفعيل القفل بالرمز...",
                nfcTitlePwdUnlockReady: "جاهز لفك القفل",
                nfcDescPwdUnlockReady: "قرّب ظهر الهاتف من البطاقة لإزالة رمز الحماية...",
                pwdModalTitle: "حماية البطاقة بكلمة مرور",
                pwdModalTitleLock: "قفل البطاقة",
                pwdModalTitleUnlock: "فك قفل البطاقة",
                pwdModalDesc: "عيّن كلمة مرور أو رمز PIN لحماية البطاقة من التعديل",
                pwdModalDescLock: "عيّن رمز PIN أو كلمة مرور لحماية البطاقة من التعديل",
                pwdModalDescUnlock: "أدخل رمز PIN الحالي لإلغاء حماية البطاقة والسماح بالتعديل",
                pwdHintText: "يُفضّل استخدام 4 خانات للتوافق الكامل مع كافة أجهزة وقارئات NFC",
                pwdInfoToast: "يُفضّل استخدام 4 خانات للتوافق العالمي الكامل مع كافة أجهزة وقارئات NFC مثل NFC Tools",
                pwdPlaceholder: "أدخل كلمة المرور أو رمز PIN...",
                pwdTabLock: "قفل البطاقة",
                pwdTabUnlock: "فك القفل",
                pwdSubmitLock: "قفل البطاقة وتقريب الهاتف",
                pwdSubmitUnlock: "فك القفل وتقريب الهاتف",
                pwdCancel: "إلغاء",
                toastEnterPwd: "يرجى إدخال كلمة المرور أو الرمز",
                permLockTitle: "الإقفال النهائي للبطاقة",
                permLockDesc: "تحذير: سيتم تحويل البطاقة إلى وضع القراءة فقط بشكل دائم وغير قابل للتراجع. لن يمكن تعديلها أو مسحها أبداً.",
                permLockConfirmBtn: "تأكيد وقفل البطاقة نهائياً",
                permLockCancelBtn: "إلغاء",
                toastNfcReadSuccess: "تمت قراءة الرابط واستيراده بنجاح",
                toastNfcReadEmpty: "لا يوجد رابط صالح على هذه البطاقة",
                toastNfcPermLockSuccess: "تم إقفال البطاقة عتادياً نهائياً بنجاح",
                toastNfcPwdLockSuccess: "تم قفل البطاقة برمز PIN بنجاح",
                toastNfcPwdUnlockSuccess: "تم فك قفل البطاقة بنجاح",
                toastNfcWrongPwd: "رمز PIN غير صحيح أو تعذر فك القفل",
                toastNfcPwdUnsupported: "ميزة القفل برمز غير مدعومة على هذه البطاقة",
                toastNfcAlreadyUnlocked: "البطاقة غير مقفلة بالفعل",
                toastNfcAlreadyLocked: "البطاقة مقفلة برمز حماية مسبقاً، يرجى فك قفلها أولاً",
                nfcTitleSuccess: "تمت الكتابة بنجاح!",
                nfcDescSuccess: "تمت برمجة بطاقة التقييم بنجاح.",
                nfcTitleNext: "جاهز للكتابة",
                nfcDescNext: "قرب بطاقة أخرى لبرمجتها، أو انقر إنهاء.",
                nfcCardsCount: "البطاقات المكتملة: {count}",
                nfcCancel: "إلغاء",
                nfcDone: "إنهاء وإغلاق",
                nfcOk: "موافق",
                nfcTitlePwdLockSuccess: "تم قفل البطاقة بنجاح",
                nfcDescPwdLockSuccess: "تم تفعيل رمز الحماية وقفل التعديل على البطاقة.",
                nfcTitlePwdUnlockSuccess: "تم فك قفل البطاقة بنجاح",
                nfcDescPwdUnlockSuccess: "تمت إزالة الحماية بنجاح، ويمكنك الآن الكتابة والتعديل على البطاقة.",
                nfcTitleAlreadyUnlocked: "البطاقة غير مقفلة",
                nfcDescAlreadyUnlocked: "هذه البطاقة لا تحتوي على أي رمز قفل، وهي مفتوحة بالفعل وقابلة للكتابة والتعديل بالكامل.",
                nfcTitleTagLost: "ضعف في إشارة الاتصال",
                nfcDescTagLost: "انقطع الاتصال بالبطاقة بسبب تحريك الهاتف أو ضعف التماس (NFC). يرجى تثبيت الهاتف جيداً وثباته فوق منتصف البطاقة دون تحريكه حتى تكتمل العملية.",
                nfcTitleLocked: "البطاقة محمية برمز قفل",
                nfcTitleReadLocked: "البطاقة محمية من القراءة",
                nfcDescReadLocked: "تعذرت قراءة البطاقة لأنها محمية برمز قفل يمنع قراءة البيانات.",
                nfcTitleWrongPwd: "رمز الحماية غير صحيح",
                nfcTitleAlreadyLocked: "البطاقة مقفلة مسبقاً",
                nfcTitleCapacity: "سعة الذاكرة غير كافية",
                nfcTitleEmptyTag: "البطاقة فارغة",
                nfcTitlePermLockSuccess: "تم الإقفال النهائي بنجاح",
                nfcDescPermLockSuccess: "تم تحويل البطاقة إلى وضع القراءة فقط بشكل دائم.",
                nfcTitleError: "فشلت عملية الكتابة",
                nfcDescLocked: "تعذرت العملية لأن هذه البطاقة محمية بكلمة مرور أو للقراءة فقط. يرجى فك قفلها أولاً قبل المتابعة.",
                nfcDescCapacity: "حجم الرابط أكبر من سعة ذاكرة البطاقة.",
                nfcDescUnsupported: "نوع هذه البطاقة غير مدعوم للكتابة.",
                nfcDescGenericError: "تعذرت الكتابة على البطاقة. تأكد من ثبات الهاتف فوق البطاقة.",
                nfcRetryBtn: "إعادة المحاولة",
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
                toastUpToDate: "لديك أحدث إصدار ({version})",
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

        const btnEn = document.getElementById('btnEn');
        const btnAr = document.getElementById('btnAr');
        const langSlider = document.getElementById('langSlider');
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

        const navBtnEn = document.getElementById('navBtnEn');
        const navBtnAr = document.getElementById('navBtnAr');
        const navLangSlider = document.getElementById('navLangSlider');
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
        if (!dict) return;

        const setTxt = (id, text) => {
            const el = document.getElementById(id);
            if (el && text !== undefined && text !== null) el.textContent = text;
        };
        const setHtml = (id, html) => {
            const el = document.getElementById(id);
            if (el && html !== undefined && html !== null) el.innerHTML = html;
        };

        // Update HTML attributes
        document.documentElement.lang = lang;
        document.documentElement.dir = lang === 'ar' ? 'rtl' : 'ltr';
        if (dict.docTitle) document.title = dict.docTitle;

        const metaDesc = document.querySelector('meta[name="description"]');
        if (metaDesc && dict.metaDesc) metaDesc.setAttribute('content', dict.metaDesc);

        // Desktop Navbar
        setTxt('navGithubLabel', dict.navGithub);
        setTxt('navApkLabel', dict.navApk);

        // Top bar & Header
        setTxt('apkDownloadLabel', dict.apkDownload);
        setTxt('appTitle', dict.appTitle);
        setTxt('appSubtitle', dict.appSubtitle);

        // Mode Switcher & Inputs
        setTxt('tabLinkLabel', dict.tabLink);
        setTxt('tabSearchLabel', dict.tabSearch);

        const urlInput = document.getElementById('urlInput');
        if (urlInput && dict.placeholder) urlInput.placeholder = dict.placeholder;

        const clearBtn = document.getElementById('clearBtn');
        if (clearBtn && dict.trashTitle) clearBtn.title = dict.trashTitle;

        setTxt('pasteBtnLabel', dict.pasteBtn);
        const pasteBtn = document.getElementById('pasteBtn');
        if (pasteBtn && dict.pasteBtn) pasteBtn.title = dict.pasteBtn;

        const businessSearchInput = document.getElementById('businessSearchInput');
        if (businessSearchInput && dict.searchPlaceholder) businessSearchInput.placeholder = dict.searchPlaceholder;

        const searchClearBtn = document.getElementById('searchClearBtn');
        if (searchClearBtn && dict.trashTitle) searchClearBtn.title = dict.trashTitle;

        const convertBtn = document.getElementById('convertBtn');
        if (convertBtn && !convertBtn.disabled) {
            setTxt('btnText', dict.convertBtn);
        }

        // Results Card
        const resultLinkText = document.getElementById('resultLinkText');
        const currentUrl = (resultLinkText ? resultLinkText.textContent : '').trim();
        const isReview = /writereview\?placeid=/i.test(currentUrl);
        setTxt('resultLabelText', isReview ? (dict.resultLabelReview || 'Direct Review Link:') : (dict.resultLabelCustom || 'Direct Link:'));

        const copyBtn = document.getElementById('copyBtn');
        if (copyBtn && !copyBtn.classList.contains('copied')) {
            setTxt('copyBtnLabel', dict.copyBtn);
        }
        setTxt('openBtnLabel', dict.openBtn);
        setTxt('shareBtnLabel', dict.shareBtn);
        setTxt('qrBtnLabel', dict.qrBtn);
        setTxt('nfcBtnLabel', dict.nfcBtn);

        // NFC Card Tools & Security
        setTxt('lblReadTag', dict.lblReadTag);
        setTxt('lblPwdLockTag', dict.lblPwdLockTag);
        setTxt('lblPermLockTag', dict.lblPermLockTag);
        setTxt('pwdModalTitle', dict.pwdModalTitle);
        setTxt('pwdModalDesc', dict.pwdModalDesc);
        setTxt('pwdHintText', dict.pwdHintText);
        setTxt('pwdTabLock', dict.pwdTabLock);
        setTxt('pwdTabUnlock', dict.pwdTabUnlock);
        setTxt('btnPwdCancel', dict.pwdCancel);
        const pwdTabLockEl = document.getElementById('pwdTabLock');
        const btnPwdSubmitEl = document.getElementById('btnPwdSubmit');
        if (btnPwdSubmitEl) {
            const isLockActive = !pwdTabLockEl || pwdTabLockEl.classList.contains('active');
            btnPwdSubmitEl.textContent = isLockActive ? (dict.pwdSubmitLock || 'Lock Card & Touch Phone') : (dict.pwdSubmitUnlock || 'Unlock & Touch Phone');
        }
        const nfcPinInputEl = document.getElementById('nfcPinInput');
        if (nfcPinInputEl && dict.pwdPlaceholder) {
            nfcPinInputEl.placeholder = dict.pwdPlaceholder;
        }
        setTxt('permLockTitle', dict.permLockTitle);
        setTxt('permLockDesc', dict.permLockDesc);
        setTxt('btnPermLockConfirm', dict.permLockConfirmBtn);
        setTxt('btnPermLockCancel', dict.permLockCancelBtn);
        setTxt('nfcRetryBtnLabel', dict.nfcRetryBtn || 'Try Again');

        // QR Modal
        setTxt('qrModalTitle', dict.qrModalTitle);
        setTxt('qrModalDesc', dict.qrModalDesc);
        setTxt('qrDownloadBtnLabel', dict.qrDownloadBtn);
        setTxt('qrCloseBtn', dict.qrCloseBtn);

        // NFC Modal (Native App)
        setTxt('nfcTitle', dict.nfcTitleReady);
        setTxt('nfcDesc', dict.nfcDescReady);
        const nfcCancelBtn = document.getElementById('nfcCancelBtn');
        if (nfcCancelBtn) {
            nfcCancelBtn.textContent = (window.nfcBatchCount && window.nfcBatchCount > 0) ? dict.nfcDone : dict.nfcCancel;
        }

        // Desktop Marketing (Web)
        setTxt('tagHowItWorks', dict.tagHowItWorks);
        setTxt('titleHowItWorks', dict.titleHowItWorks);
        setTxt('subHowItWorks', dict.subHowItWorks);
        setTxt('step1Title', dict.step1Title);
        setTxt('step1Desc', dict.step1Desc);
        setTxt('step2Title', dict.step2Title);
        setTxt('step2Desc', dict.step2Desc);
        setTxt('step3Title', dict.step3Title);
        setTxt('step3Desc', dict.step3Desc);

        setTxt('tagFeatures', dict.tagFeatures);
        setTxt('titleFeatures', dict.titleFeatures);
        setTxt('subFeatures', dict.subFeatures);
        setTxt('feat1Title', dict.feat1Title);
        setTxt('feat1Desc', dict.feat1Desc);
        setTxt('feat2Title', dict.feat2Title);
        setTxt('feat2Desc', dict.feat2Desc);
        setTxt('feat3Title', dict.feat3Title);
        setTxt('feat3Desc', dict.feat3Desc);
        setTxt('feat4Title', dict.feat4Title);
        setTxt('feat4Desc', dict.feat4Desc);

        setTxt('tagFaq', dict.tagFaq);
        setTxt('titleFaq', dict.titleFaq);
        setTxt('subFaq', dict.subFaq);
        setTxt('faq1Q', dict.faq1Q);
        setTxt('faq1A', dict.faq1A);
        setTxt('faq2Q', dict.faq2Q);
        setTxt('faq2A', dict.faq2A);
        setTxt('faq3Q', dict.faq3Q);
        setTxt('faq3A', dict.faq3A);
        setTxt('faq4Q', dict.faq4Q);
        setTxt('faq4A', dict.faq4A);

        // Footer
        setTxt('footerTagline', dict.footerTagline);
        setTxt('footerApkLink', dict.footerApk);
        setTxt('footerGithubLink', dict.footerGithub);
        setTxt('footerBackToTop', dict.footerBackToTop);
        setHtml('footerCopyright', dict.footerCopyright);

        // App Update Modal (Native App)
        setTxt('updateBadgeText', dict.updateAvailable);
        setTxt('updateModalTitle', dict.updateReadyTitle);
        setTxt('lblCurrentVer', dict.updateCurrent);
        setTxt('lblLatestVer', dict.updateNew);
        setTxt('updateChangelogHeader', dict.updateHighlights);
        setTxt('btnUpdateNowLabel', dict.updateInstallBtn);
        setTxt('btnUpdateGithubLabel', dict.updateViewGithub);
        setTxt('btnUpdateLater', dict.updateLater);
    }

    function applyLanguage(lang, animate = true) {
        if (animate && (lang === currentLang || isLangSwitching)) return;

        currentLang = lang;
        try {
            localStorage.setItem('app_lang', lang);
        } catch (e) {}
        const dict = I18N[lang];
        if (!dict) return;

        // 1. Instant feedback: glide slider pill immediately with spring physics
        updateSliderPill(lang);

        if (!animate) {
            try {
                updateDomLanguageStrings(lang, dict);
                if (window.updateModeTabSlider) window.updateModeTabSlider();
                if (window.updatePwdTabSlider) window.updatePwdTabSlider();
            } catch (e) {
                console.error('Error applying language strings:', e);
            }
            return;
        }

        // 2. Coordinated cross-dissolve with layout lock
        isLangSwitching = true;
        document.body.classList.add('is-lang-switching');

        setTimeout(() => {
            try {
                updateDomLanguageStrings(lang, dict);
                if (window.updateModeTabSlider) window.updateModeTabSlider();
                if (window.updatePwdTabSlider) window.updatePwdTabSlider();
                void document.documentElement.offsetHeight;
            } catch (e) {
                console.error('Error during language switch:', e);
            } finally {
                requestAnimationFrame(() => {
                    document.body.classList.remove('is-lang-switching');
                    if (window.updateModeTabSlider) setTimeout(window.updateModeTabSlider, 50);
                    if (window.updatePwdTabSlider) setTimeout(window.updatePwdTabSlider, 50);
                    setTimeout(() => {
                        isLangSwitching = false;
                    }, 240);
                });
            }
        }, 140);
    }

    function switchLanguage(lang) {
        if (lang === currentLang) return;
        applyLanguage(lang, true);
    }

    function isTouchDevice() {
        return Boolean(
            window.AndroidNative ||
            (window.matchMedia && (window.matchMedia('(pointer: coarse)').matches || window.matchMedia('(hover: none)').matches)) ||
            ('ontouchstart' in window) ||
            (navigator.maxTouchPoints && navigator.maxTouchPoints > 0) ||
            /Android|webOS|iPhone|iPad|iPod|BlackBerry|IEMobile|Opera Mini/i.test(navigator.userAgent || '')
        );
    }

    // Expose globals
    window.I18N = I18N;
    window.getCurrentLang = function() { return currentLang; };
    window.setCurrentLang = function(l) { currentLang = l; try { localStorage.setItem('app_lang', l); } catch(e){} };
    window.updateSliderPill = updateSliderPill;
    window.updateDomLanguageStrings = updateDomLanguageStrings;
    window.applyLanguage = applyLanguage;
    window.switchLanguage = switchLanguage;
    window.isTouchDevice = isTouchDevice;
})();
