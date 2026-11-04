// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'Quick NFC';

  @override
  String get appSubtitle =>
      'أداة NFC سريعة وبسيطة لتحويل روابط الخرائط لتقييم فوري';

  @override
  String get tabLink => 'وضع الرابط';

  @override
  String get tabSearch => 'بحث عن مكان';

  @override
  String get placeholder => 'الصق رابط خرائط Google...';

  @override
  String get trashTitle => 'مسح النص';

  @override
  String get pasteBtn => 'لصق';

  @override
  String get convertBtn => 'تحويل الرابط';

  @override
  String get resolvingBtn => 'جاري التحويل...';

  @override
  String get searchPlaceholder => 'ابحث باسم المكان أو المدينة...';

  @override
  String get toastEnterQuery => 'يرجى كتابة اسم المكان أولاً';

  @override
  String get fabGithubLabel => 'المشروع على GitHub';

  @override
  String get resultLabel => 'الرابط:';

  @override
  String get resultLabelReview => 'رابط التقييم:';

  @override
  String get resultLabelLocation => 'رابط الموقع:';

  @override
  String get resultLabelCustom => 'الرابط المباشر:';

  @override
  String get linkTypePrompt => 'نوع الرابط:';

  @override
  String get linkTypeReview => 'تقييم 5 نجوم';

  @override
  String get linkTypeLocation => 'موقع الخريطة';

  @override
  String get toastSwitchedToReview =>
      'تم التبديل إلى رابط التقييم المباشر (5 نجوم)';

  @override
  String get toastSwitchedToLocation =>
      'تم التبديل إلى رابط الموقع على الخريطة';

  @override
  String get btnHelpGuideTitle => 'دليل الاستخدام والتعريف بالميزات';

  @override
  String get btnGuideLabel => 'دليل الاستخدام';

  @override
  String get settingsTitle => 'الإعدادات';

  @override
  String get settingsGeneralSection => 'التفضيلات';

  @override
  String get settingsLanguageLabel => 'لغة العرض';

  @override
  String get settingsLanguageSub => 'اختر لغة واجهة التطبيق المفضلة لديك';

  @override
  String get settingsLangArabic => 'العربية (Arabic)';

  @override
  String get settingsLangEnglish => 'English';

  @override
  String get settingsAboutSection => 'عن التطبيق';

  @override
  String get settingsVersionLabel => 'إصدار التطبيق';

  @override
  String get settingsDeveloperLabel => 'المطور والمشروع على GitHub';

  @override
  String get settingsBackBtn => 'رجوع';

  @override
  String get obStep1Title => 'تحويل الروابط والتقييم';

  @override
  String get obStep1Desc =>
      'الصق أي رابط من خرائط Google لتحويله فوراً إلى رابط تقييم 5 نجوم أو فتح الموقع، أو استخدم أي رابط خارجي.';

  @override
  String get obStep2Title => 'البحث عن الأنشطة';

  @override
  String get obStep2Desc =>
      'ابحث باسم محلك ومدينتك من تبويب \"بحث عن مكان\" لتوليد الرابط فوراً دون الحاجة لفتح الخرائط.';

  @override
  String get obStep3Title => 'كروت NFC وحماية البيانات';

  @override
  String get obStep3Desc =>
      'اكتب الروابط والـ Wi-Fi على كروت NFC بسهولة، واحمي بطاقاتك بقفل PIN أو قفل دائم.';

  @override
  String get obBtnNext => 'التالي';

  @override
  String get obBtnStart => 'ابدأ الآن';

  @override
  String get obBtnSkip => 'تخطي الشرح';

  @override
  String get copyBtn => 'نسخ';

  @override
  String get copySuccess => 'تم النسخ!';

  @override
  String get openBtn => 'فتح';

  @override
  String get shareBtn => 'مشاركة';

  @override
  String get qrBtn => 'رمز QR';

  @override
  String get qrModalTitle => 'رمز QR للتقييم';

  @override
  String get qrModalDesc => 'امسح الرمز بكاميرا الهاتف لفتح صفحة التقييم فوراً';

  @override
  String get qrDownloadBtn => 'حفظ الرمز';

  @override
  String get qrCloseBtn => 'إغلاق';

  @override
  String get qrDownloaded => 'تم تنزيل رمز الـ QR بنجاح';

  @override
  String get lblReadTag => 'قراءة كرت';

  @override
  String get lblWifiTag => 'كرت Wi-Fi';

  @override
  String get lblPwdLockTag => 'قفل برمز PIN';

  @override
  String get lblEraseTag => 'مسح البطاقة';

  @override
  String get lblPermLockTag => 'إقفال نهائي';

  @override
  String get wifiModalTitle => 'إعداد كرت Wi-Fi';

  @override
  String get wifiStep1Title => 'اسم الشبكة';

  @override
  String get wifiStep1Desc => 'أدخل اسم شبكة الواي فاي (SSID)';

  @override
  String get wifiStep2Title => 'كلمة المرور';

  @override
  String get wifiStep2Desc =>
      'أدخل كلمة السر (أو اتركها فارغة للشبكة المفتوحة)';

  @override
  String get wifiStep3Title => 'نوع التشفير';

  @override
  String get wifiStep3Desc => 'اختر نوع حماية وتشفير الشبكة';

  @override
  String get wifiSsidPlaceholder => 'اسم الشبكة (SSID)...';

  @override
  String get wifiPasswordPlaceholder => 'كلمة المرور...';

  @override
  String get wifiEncWpa => 'WPA / WPA2 / WPA3';

  @override
  String get wifiEncWpaSub => 'الأكثر شيوعاً';

  @override
  String get wifiEncWep => 'WEP';

  @override
  String get wifiEncWepSub => 'شبكات قديمة';

  @override
  String get wifiEncOpen => 'شبكة مفتوحة';

  @override
  String get wifiEncOpenSub => 'بدون كلمة سر';

  @override
  String get wifiNext => 'التالي';

  @override
  String get wifiBack => 'رجوع';

  @override
  String get wifiWriteTag => 'برمجة البطاقة';

  @override
  String get wifiQrBtn => 'رمز QR';

  @override
  String get wifiQrModalTitle => 'رمز QR للواي فاي';

  @override
  String get wifiQrModalDesc => 'امسح الرمز بكاميرا الهاتف للاتصال بالشبكة';

  @override
  String get wifiQrDownloaded => 'تم تنزيل رمز QR للواي فاي بنجاح';

  @override
  String get toastEnterSsid => 'يرجى إدخال اسم الشبكة (SSID)';

  @override
  String get toastWifiPassMinLength => 'كلمة المرور يجب ألا تقل عن 8 خانات';

  @override
  String get toastWifiWpaRequired =>
      'شبكات WPA تتطلب كلمة مرور من 8 خانات على الأقل';

  @override
  String get nfcTitleWifiReady => 'جاهز لنسخ الواي فاي';

  @override
  String get nfcTitleWifiClone => 'نسخ كرت Wi-Fi';

  @override
  String get nfcTitleWifiCloneSuccess => 'تم نسخ كرت Wi-Fi!';

  @override
  String get nfcDescWifiReady => 'قرّب ظهر الهاتف من البطاقة لنسخ الواي فاي.';

  @override
  String nfcDescWifiReadyWithSsid(String ssid) {
    return 'قرّب البطاقة لنسخ شبكة \"$ssid\".';
  }

  @override
  String nfcDescWifiCloneWithSsid(String ssid) {
    return 'قرّب البطاقة لنسخ شبكة \"$ssid\".';
  }

  @override
  String get nfcTitleWifiSuccess => 'تم نسخ كرت Wi-Fi!';

  @override
  String get nfcDescWifiSuccess => 'تم حفظ إعدادات الواي فاي على البطاقة.';

  @override
  String get nfcBtnWifiAnother => 'بطاقة أخرى';

  @override
  String get nfcBtnWifiCloneAnother => 'نسخ أخرى';

  @override
  String get toastNfcWifiSuccess =>
      'تم نسخ إعدادات الواي فاي على البطاقة بنجاح!';

  @override
  String toastNfcWifiReadSuccess(String ssid) {
    return 'تمت قراءة شبكة الواي فاي \"$ssid\" بنجاح! جاهز لنسخها على بطاقة جديدة.';
  }

  @override
  String get nfcBtn => 'برمجة بطاقة NFC';

  @override
  String get nfcBtnWriteAnother => 'بطاقة أخرى';

  @override
  String get nfcTitleReady => 'جاهز للكتابة';

  @override
  String get nfcDescReady => 'قرّب ظهر الهاتف من بطاقة NFC لكتابة الرابط.';

  @override
  String get nfcTitleReadReady => 'جاهز للقراءة';

  @override
  String get nfcDescReadReady => 'قرّب ظهر الهاتف من بطاقة NFC لقراءة الرابط.';

  @override
  String get nfcTitlePermLockReady => 'جاهز للقفل النهائي';

  @override
  String get nfcDescPermLockReady =>
      'قرّب ظهر الهاتف من البطاقة للقفل النهائي.';

  @override
  String get nfcTitlePwdLockReady => 'جاهز للقفل';

  @override
  String get nfcDescPwdLockReady =>
      'قرّب ظهر الهاتف من البطاقة للقفل برمز PIN.';

  @override
  String get nfcTitlePwdUnlockReady => 'جاهز لفك القفل';

  @override
  String get nfcDescPwdUnlockReady => 'قرّب ظهر الهاتف من البطاقة لفك رمز PIN.';

  @override
  String get pwdModalTitle => 'حماية البطاقة';

  @override
  String get pwdModalTitleLock => 'قفل البطاقة';

  @override
  String get pwdModalTitleUnlock => 'فك قفل البطاقة';

  @override
  String get pwdModalDesc => 'عيّن رمز PIN لحماية البطاقة';

  @override
  String get pwdModalDescLock => 'عيّن رمز PIN لحماية البطاقة';

  @override
  String get pwdModalDescUnlock => 'أدخل رمز PIN لفك حماية البطاقة';

  @override
  String get pwdHintText => 'يُفضّل 4 أرقام للتوافق';

  @override
  String get pwdInfoToast => 'يُفضّل 4 أرقام للتوافق';

  @override
  String get pwdPlaceholder => 'رمز PIN...';

  @override
  String get pwdTabLock => 'قفل البطاقة';

  @override
  String get pwdTabUnlock => 'فك القفل';

  @override
  String get pwdSubmitLock => 'قفل البطاقة';

  @override
  String get pwdSubmitUnlock => 'فك القفل';

  @override
  String get pwdCancel => 'إلغاء';

  @override
  String get toastEnterPwd => 'يرجى إدخال رمز PIN';

  @override
  String get permLockTitle => 'قفل نهائي للبطاقة';

  @override
  String get permLockDesc =>
      'تحذير: ستصبح البطاقة للقراءة فقط بشكل دائم وغير قابلة للتعديل أو المسح.';

  @override
  String get permLockConfirmBtn => 'قفل نهائي';

  @override
  String get permLockCancelBtn => 'إلغاء';

  @override
  String get toastNfcReadSuccess => 'تمت قراءة الرابط واستيراده بنجاح';

  @override
  String get toastNfcReadEmpty => 'لا يوجد رابط صالح على هذه البطاقة';

  @override
  String get toastNfcPermLockSuccess =>
      'تم إقفال البطاقة عتادياً نهائياً بنجاح';

  @override
  String get toastNfcPwdLockSuccess => 'تم قفل البطاقة برمز PIN بنجاح';

  @override
  String get toastNfcPwdUnlockSuccess => 'تم فك قفل البطاقة بنجاح';

  @override
  String get toastNfcWrongPwd => 'رمز PIN غير صحيح أو تعذر فك القفل';

  @override
  String get toastNfcPwdUnsupported =>
      'ميزة القفل برمز غير مدعومة على هذه البطاقة';

  @override
  String get toastNfcAlreadyUnlocked => 'البطاقة غير مقفلة بالفعل';

  @override
  String get toastNfcAlreadyLocked =>
      'البطاقة مقفلة برمز حماية مسبقاً، يرجى فك قفلها أولاً';

  @override
  String get nfcTitleSuccess => 'تمت الكتابة بنجاح!';

  @override
  String get nfcDescSuccess => 'تمت برمجة البطاقة بنجاح.';

  @override
  String get nfcTitleNext => 'جاهز للكتابة';

  @override
  String get nfcDescNext => 'قرّب بطاقة أخرى، أو انقر إنهاء.';

  @override
  String nfcCardsCount(int count) {
    return 'البطاقات المكتملة: $count';
  }

  @override
  String get nfcCancel => 'إلغاء';

  @override
  String get nfcDone => 'إنهاء';

  @override
  String get nfcOk => 'موافق';

  @override
  String get nfcBtnLockAnother => 'قفل أخرى';

  @override
  String get nfcBtnUnlockAnother => 'فك أخرى';

  @override
  String get nfcTitlePwdLockSuccess => 'تم قفل البطاقة';

  @override
  String get nfcDescPwdLockSuccess => 'البطاقة محمية الآن ضد التعديل.';

  @override
  String get nfcTitlePwdUnlockSuccess => 'تم فك القفل';

  @override
  String get nfcDescPwdUnlockSuccess => 'البطاقة مفتوحة وقابلة للتعديل الآن.';

  @override
  String get nfcTitleAlreadyUnlocked => 'البطاقة غير مقفلة';

  @override
  String get nfcDescAlreadyUnlocked => 'البطاقة مفتوحة وقابلة للتعديل مباشرة.';

  @override
  String get nfcTitleTagLost => 'انقطع الاتصال بالبطاقة';

  @override
  String get nfcDescTagLost => 'ثبّت الهاتف فوق منتصف البطاقة دون تحريكه.';

  @override
  String get nfcTitleLocked => 'البطاقة محمية برمز';

  @override
  String get nfcTitleReadLocked => 'البطاقة محمية من القراءة';

  @override
  String get nfcDescReadLocked => 'البطاقة محمية برمز قفل يمنع قراءة بياناتها.';

  @override
  String get nfcTitleWrongPwd => 'رمز الحماية غير صحيح';

  @override
  String get nfcTitleAlreadyLocked => 'البطاقة مقفلة مسبقاً';

  @override
  String get nfcTitleCapacity => 'سعة الذاكرة غير كافية';

  @override
  String get nfcTitleEmptyTag => 'البطاقة فارغة';

  @override
  String get nfcTitlePermLockSuccess => 'تم القفل النهائي بنجاح';

  @override
  String get nfcDescPermLockSuccess =>
      'تم تحويل البطاقة إلى وضع القراءة فقط بشكل دائم.';

  @override
  String get nfcTitlePermLockStandby => 'تم القفل نهائياً!';

  @override
  String get nfcDescPermLockStandby =>
      'توقفت العملية للأمان. انقر الشعار لإعادة التفعيل.';

  @override
  String nfcPermLockCount(int count) {
    return 'المقفلة: $count';
  }

  @override
  String nfcEraseCount(int count) {
    return 'الممسوحة: $count';
  }

  @override
  String get nfcTitleCannotLock => 'تعذر القفل النهائي';

  @override
  String get nfcDescCannotLock =>
      'البطاقة للقراءة فقط مسبقاً أو لا تدعم القفل الدائم.';

  @override
  String get nfcBackToPin => 'العودة';

  @override
  String get nfcTitleDisabled => 'خاصية NFC متوقفة';

  @override
  String get nfcTitleNoHardware => 'NFC غير مدعوم';

  @override
  String get nfcTitleOpFailed => 'فشلت العملية';

  @override
  String get nfcDescOpFailed =>
      'تعذرت العملية. ثبّت الهاتف فوق البطاقة وحاول مجدداً.';

  @override
  String get nfcTitleError => 'فشلت الكتابة';

  @override
  String get nfcDescLocked =>
      'البطاقة محمية برمز أو للقراءة فقط. يرجى فك قفلها.';

  @override
  String get nfcDescCapacity => 'البيانات أكبر من سعة ذاكرة البطاقة.';

  @override
  String get nfcDescUnsupported => 'نوع بطاقة NFC غير مدعوم.';

  @override
  String get nfcDescGenericError =>
      'تعذرت الكتابة. تأكد من ثبات الهاتف فوق البطاقة.';

  @override
  String get nfcRetryBtn => 'إعادة المحاولة';

  @override
  String get nfcNoHardware => 'جهازك لا يدعم خاصية NFC';

  @override
  String get nfcDisabled => 'يرجى تفعيل NFC من إعدادات الهاتف أولاً';

  @override
  String get nfcLocked => 'البطاقة محمية ضد الكتابة أو للقراءة فقط';

  @override
  String get nfcCapacity => 'سعة البطاقة غير كافية للبيانات';

  @override
  String get nfcUnsupported => 'نوع بطاقة NFC غير مدعوم';

  @override
  String get nfcWriteFailed => 'حدث خطأ أثناء الكتابة. يرجى المحاولة مجدداً.';

  @override
  String get toastPasteFirst => 'الرجاء لصق الرابط أولاً';

  @override
  String get toastInvalid => 'تعذر استخراج معرّف المكان';

  @override
  String get toastNoInternet => 'لا يوجد اتصال بالشبكة';

  @override
  String get toastSuccess => 'تم تحويل الرابط بنجاح';

  @override
  String get toastNfcWritten => 'تمت الكتابة على البطاقة بنجاح';

  @override
  String toastNfcBatchSuccess(int count) {
    return 'تمت برمجة $count بطاقات NFC بنجاح';
  }

  @override
  String get toastCleared => 'تم مسح النص';

  @override
  String get toastPasted => 'تم اللصق من الحافظة';

  @override
  String get toastEmptyClip => 'الحافظة فارغة';

  @override
  String get toastClipDenied => 'اضغط Ctrl+V للصق الرابط';

  @override
  String get toastCopied => 'تم نسخ رابط التقييم';

  @override
  String get toastShareCopied => 'تم نسخ الرابط للمشاركة';

  @override
  String get shareTitle => 'تقييم على Google';

  @override
  String get shareText => 'شاركنا تقييمك على خرائط Google';

  @override
  String get toastHourlyLimit =>
      'تم الوصول للحد الأقصى للبحث في هذه الساعة لحماية الرصيد';

  @override
  String get toastSelectSuccess => 'تم توليد الرابط';

  @override
  String get updateAvailable => 'تحديث جديد متوفر';

  @override
  String get updateReadyTitle => 'إصدار جديد جاهز للتثبيت';

  @override
  String get updateCurrent => 'الحالي';

  @override
  String get updateNew => 'الجديد';

  @override
  String updateSize(String size) {
    return 'الحجم: $size';
  }

  @override
  String updateDate(String date) {
    return 'تاريخ النشر: $date';
  }

  @override
  String get updateHighlights => 'أبرز مميزات هذا الإصدار';

  @override
  String get updateInstallBtn => 'تنزيل وتثبيت التحديث';

  @override
  String get updateViewGithub => 'ملاحظات الإصدار';

  @override
  String get updateLater => 'لاحقاً';

  @override
  String get toastCheckingUpdate => 'جاري التحقق من وجود تحديثات...';

  @override
  String toastUpToDate(String version) {
    return 'لديك أحدث إصدار ($version)';
  }

  @override
  String toastUpdateFound(String version) {
    return 'يتوفر إصدار جديد $version!';
  }

  @override
  String get toastUpdateError => 'تعذر التحقق من التحديثات حالياً';

  @override
  String get toastDownloadStarted => 'جاري تنزيل التحديث في الخلفية...';

  @override
  String get toastQrSaveError => 'فشل حفظ صورة رمز الـ QR';

  @override
  String get eraseModalTitle => 'مسح البطاقة';

  @override
  String get eraseModalDesc =>
      'سيتم مسح جميع البيانات وإعادة البطاقة فارغة. لا يؤثر ذلك على قفل البطاقة.';

  @override
  String get eraseConfirmBtn => 'مسح البطاقة';

  @override
  String get eraseCancelBtn => 'إلغاء';

  @override
  String get nfcTitleEraseReady => 'جاهز للمسح';

  @override
  String get nfcDescEraseReady => 'قرّب ظهر الهاتف من البطاقة لمسح البيانات...';

  @override
  String get nfcTitleEraseSuccess => 'تم مسح البطاقة بنجاح!';

  @override
  String get nfcDescEraseSuccess => 'البطاقة فارغة وجاهزة للاستخدام الآن.';

  @override
  String get nfcBtnEraseAnother => 'مسح أخرى';

  @override
  String get toastNfcEraseSuccess => 'تم مسح بيانات البطاقة بنجاح';

  @override
  String get githubProjectBtn => 'GitHub';

  @override
  String get githubSupportBtn => 'دعم المشروع';

  @override
  String get toastSupportComingSoon => 'سيكون خيار الدعم متاحاً قريباً';

  @override
  String get settingsThemeLabel => 'المظهر';

  @override
  String get settingsThemeSub => 'اختر نمط مظهر التطبيق المفضل';

  @override
  String get settingsThemeSystem => 'تابع للجهاز';

  @override
  String get settingsThemeDark => 'داكن';

  @override
  String get settingsThemeLight => 'فاتح';
}
