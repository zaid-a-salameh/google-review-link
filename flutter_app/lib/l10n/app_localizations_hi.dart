// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Hindi (`hi`).
class AppLocalizationsHi extends AppLocalizations {
  AppLocalizationsHi([String locale = 'hi']) : super(locale);

  @override
  String get appTitle => 'Quick NFC';

  @override
  String get appSubtitle => 'Google Maps समीक्षा लिंक बनाने का तेज़ NFC टूल';

  @override
  String get tabLink => 'सीधा लिंक';

  @override
  String get tabSearch => 'व्यवसाय खोजें';

  @override
  String get placeholder => 'यहाँ लिंक पेस्ट करें...';

  @override
  String get trashTitle => 'टेक्स्ट हटाएं';

  @override
  String get pasteBtn => 'पेस्ट करें';

  @override
  String get convertBtn => 'कन्वर्ट करें';

  @override
  String get resolvingBtn => 'प्रोसेस हो रहा है...';

  @override
  String get searchPlaceholder => 'स्थान और शहर का नाम खोजें...';

  @override
  String get toastEnterQuery => 'कृपया पहले नाम दर्ज करें';

  @override
  String get fabGithubLabel => 'GitHub पर प्रोजेक्ट';

  @override
  String get resultLabel => 'सीधा लिंक:';

  @override
  String get resultLabelReview => 'सीधा समीक्षा लिंक:';

  @override
  String get resultLabelLocation => 'Google Maps पर स्थान:';

  @override
  String get resultLabelCustom => 'सीधा लिंक:';

  @override
  String get linkTypePrompt => 'प्रोग्राम करने योग्य लिंक प्रकार:';

  @override
  String get linkTypeReview => '5-स्टार समीक्षा';

  @override
  String get linkTypeLocation => 'मानचित्र स्थान';

  @override
  String get toastSwitchedToReview => 'समीक्षा लिंक पर बदला गया';

  @override
  String get toastSwitchedToLocation => 'मानचित्र स्थान लिंक पर बदला गया';

  @override
  String get btnHelpGuideTitle => 'उपयोगकर्ता मार्गदर्शिका';

  @override
  String get btnGuideLabel => 'गाइड';

  @override
  String get settingsTitle => 'सेटिंग्स';

  @override
  String get settingsGeneralSection => 'प्राथमिकताएं';

  @override
  String get settingsLanguageLabel => 'भाषा';

  @override
  String get settingsLanguageSub => 'अपनी पसंदीदा भाषा चुनें';

  @override
  String get settingsLangArabic => 'العربية (Arabic)';

  @override
  String get settingsLangEnglish => 'English';

  @override
  String get settingsAboutSection => 'के बारे में';

  @override
  String get settingsVersionLabel => 'ऐप संस्करण';

  @override
  String get settingsDeveloperLabel => 'डेवलपर और रिपॉजिटरी';

  @override
  String get settingsBackBtn => 'वापस';

  @override
  String get obStep1Title => 'स्मार्ट लिंक और 5-स्टार समीक्षा';

  @override
  String get obStep1Desc =>
      'Google Maps लिंक पेस्ट करके तुरंत 5-स्टार समीक्षा या स्थान लिंक में बदलें।';

  @override
  String get obStep2Title => 'सीधी व्यापार खोज';

  @override
  String get obStep2Desc =>
      '\'व्यवसाय खोजें\' में नाम व शहर लिखकर एक टैप में अपना समीक्षा लिंक बनाएं।';

  @override
  String get obStep3Title => 'NFC टैग, Wi-Fi और सुरक्षा';

  @override
  String get obStep3Desc =>
      'NFC कार्ड पर लिंक और Wi-Fi लिखें, और पिन या स्थायी लॉक से सुरक्षित करें।';

  @override
  String get obBtnNext => 'आगे';

  @override
  String get obBtnStart => 'शुरू करें';

  @override
  String get obBtnSkip => 'छोड़ें';

  @override
  String get copyBtn => 'कॉपी करें';

  @override
  String get copySuccess => 'कॉपी किया गया!';

  @override
  String get openBtn => 'खोलें';

  @override
  String get shareBtn => 'शेयर करें';

  @override
  String get qrBtn => 'QR कोड';

  @override
  String get qrModalTitle => 'समीक्षा QR कोड';

  @override
  String get qrModalDesc => 'सीधी समीक्षा के लिए कैमरा से स्कैन करें';

  @override
  String get qrDownloadBtn => 'QR सेव करें';

  @override
  String get qrCloseBtn => 'बंद करें';

  @override
  String get qrDownloaded => 'QR कोड सेव हो गया';

  @override
  String get lblReadTag => 'कार्ड पढ़ें';

  @override
  String get lblWifiTag => 'Wi-Fi कार्ड';

  @override
  String get lblPwdLockTag => 'पिन लॉक';

  @override
  String get lblEraseTag => 'कार्ड मिटाएं';

  @override
  String get lblPermLockTag => 'स्थायी लॉक';

  @override
  String get wifiModalTitle => 'Wi-Fi कार्ड सेटअप';

  @override
  String get wifiStep1Title => 'नेटवर्क का नाम';

  @override
  String get wifiStep1Desc => 'Wi-Fi का नाम (SSID) दर्ज करें';

  @override
  String get wifiStep2Title => 'पासवर्ड';

  @override
  String get wifiStep2Desc =>
      'पासवर्ड दर्ज करें (ओपन नेटवर्क के लिए खाली छोड़ें)';

  @override
  String get wifiStep3Title => 'सुरक्षा का प्रकार';

  @override
  String get wifiStep3Desc => 'नेटवर्क एन्क्रिप्शन चुनें';

  @override
  String get wifiSsidPlaceholder => 'नेटवर्क का नाम (SSID)...';

  @override
  String get wifiPasswordPlaceholder => 'पासवर्ड दर्ज करें...';

  @override
  String get wifiEncWpa => 'WPA / WPA2 / WPA3';

  @override
  String get wifiEncWpaSub => 'मानक (व्यक्तिगत)';

  @override
  String get wifiEncWep => 'WEP';

  @override
  String get wifiEncWepSub => 'पुराने नेटवर्क';

  @override
  String get wifiEncOpen => 'ओपन नेटवर्क';

  @override
  String get wifiEncOpenSub => 'पासवर्ड की आवश्यकता नहीं';

  @override
  String get wifiNext => 'आगे';

  @override
  String get wifiBack => 'वापस';

  @override
  String get wifiWriteTag => 'कार्ड लिखें';

  @override
  String get wifiQrBtn => 'QR कोड';

  @override
  String get wifiQrModalTitle => 'Wi-Fi QR कोड';

  @override
  String get wifiQrModalDesc => 'सीधे कनेक्ट करने के लिए कैमरा से स्कैन करें';

  @override
  String get wifiQrDownloaded => 'Wi-Fi QR कोड सेव हो गया';

  @override
  String get toastEnterSsid => 'कृपया नेटवर्क नाम (SSID) दर्ज करें';

  @override
  String get toastWifiPassMinLength =>
      'पासवर्ड कम से कम 8 वर्णों का होना चाहिए';

  @override
  String get toastWifiWpaRequired =>
      'WPA के लिए कम से कम 8 वर्णों का पासवर्ड चाहिए';

  @override
  String get nfcTitleWifiReady => 'Wi-Fi लिखने के लिए तैयार';

  @override
  String get nfcTitleWifiClone => 'Wi-Fi कार्ड क्लोन करें';

  @override
  String get nfcTitleWifiCloneSuccess => 'Wi-Fi कार्ड क्लोन हो गया!';

  @override
  String get nfcDescWifiReady =>
      'Wi-Fi लिखने के लिए फोन को NFC कार्ड के पास लाएं।';

  @override
  String nfcDescWifiReadyWithSsid(String ssid) {
    return '\"$ssid\" लिखने के लिए फोन को कार्ड के पास लाएं।';
  }

  @override
  String nfcDescWifiCloneWithSsid(String ssid) {
    return '\"$ssid\" कॉपी करने के लिए दूसरा कार्ड पास लाएं।';
  }

  @override
  String get nfcTitleWifiSuccess => 'Wi-Fi कार्ड प्रोग्राम हो गया!';

  @override
  String get nfcDescWifiSuccess => 'Wi-Fi सेटिंग्स कार्ड पर लिख दी गई हैं।';

  @override
  String get nfcBtnWifiAnother => 'दूसरा लिखें';

  @override
  String get nfcBtnWifiCloneAnother => 'दूसरा क्लोन करें';

  @override
  String get toastNfcWifiSuccess => 'Wi-Fi कार्ड सफलतापूर्वक लिखा गया!';

  @override
  String toastNfcWifiReadSuccess(String ssid) {
    return 'Wi-Fi \"$ssid\" पढ़ लिया गया! नए कार्ड पर लिखने के लिए तैयार।';
  }

  @override
  String get nfcBtn => 'NFC कार्ड लिखें';

  @override
  String get nfcBtnWriteAnother => 'दूसरा लिखें';

  @override
  String get nfcTitleReady => 'लिखने के लिए तैयार';

  @override
  String get nfcDescReady => 'लिंक लिखने के लिए फोन को NFC कार्ड के पास लाएं।';

  @override
  String get nfcTitleReadReady => 'कार्ड पढ़ने के लिए तैयार';

  @override
  String get nfcDescReadReady => 'लिंक पढ़ने के लिए फोन को कार्ड के पास लाएं।';

  @override
  String get nfcTitlePermLockReady => 'लॉक करने के लिए तैयार';

  @override
  String get nfcDescPermLockReady =>
      'स्थायी रीड-ओनली लॉक लगाने के लिए फोन को कार्ड के पास लाएं।';

  @override
  String get nfcTitlePwdLockReady => 'लॉक के लिए तैयार';

  @override
  String get nfcDescPwdLockReady =>
      'पिन सेट करने के लिए फोन को कार्ड के पास लाएं...';

  @override
  String get nfcTitlePwdUnlockReady => 'अनलॉक के लिए तैयार';

  @override
  String get nfcDescPwdUnlockReady =>
      'अनलॉक करने के लिए फोन को कार्ड के पास लाएं...';

  @override
  String get pwdModalTitle => 'कार्ड सुरक्षा';

  @override
  String get pwdModalTitleLock => 'कार्ड लॉक करें';

  @override
  String get pwdModalTitleUnlock => 'कार्ड अनलॉक करें';

  @override
  String get pwdModalDesc => 'कार्ड सुरक्षित करने के लिए पिन सेट करें';

  @override
  String get pwdModalDescLock => 'कार्ड सुरक्षित करने के लिए पिन सेट करें';

  @override
  String get pwdModalDescUnlock => 'कार्ड अनलॉक करने के लिए पिन दर्ज करें';

  @override
  String get pwdHintText => '4 अंक अनुशंसित';

  @override
  String get pwdInfoToast => '4 अंक अनुशंसित';

  @override
  String get pwdPlaceholder => 'पिन दर्ज करें...';

  @override
  String get pwdTabLock => 'लॉक';

  @override
  String get pwdTabUnlock => 'अनलॉक';

  @override
  String get pwdSubmitLock => 'कार्ड लॉक करें';

  @override
  String get pwdSubmitUnlock => 'कार्ड अनलॉक करें';

  @override
  String get pwdCancel => 'रद्द करें';

  @override
  String get toastEnterPwd => 'कृपया पिन दर्ज करें';

  @override
  String get permLockTitle => 'स्थायी लॉक';

  @override
  String get permLockDesc =>
      'चेतावनी: कार्ड हमेशा के लिए केवल पढ़ने योग्य (Read-Only) हो जाएगा। इसे बदला या मिटाया नहीं जा सकेगा।';

  @override
  String get permLockConfirmBtn => 'स्थायी लॉक करें';

  @override
  String get permLockCancelBtn => 'रद्द करें';

  @override
  String get toastNfcReadSuccess => 'लिंक सफलतापूर्वक पढ़ा और लोड किया गया';

  @override
  String get toastNfcReadEmpty => 'इस कार्ड पर कोई मान्य लिंक नहीं मिला';

  @override
  String get toastNfcPermLockSuccess =>
      'कार्ड स्थायी रूप से केवल पढ़ने योग्य लॉक किया गया';

  @override
  String get toastNfcPwdLockSuccess => 'कार्ड सफलतापूर्वक पिन से लॉक किया गया';

  @override
  String get toastNfcPwdUnlockSuccess => 'कार्ड सफलतापूर्वक अनलॉक किया गया';

  @override
  String get toastNfcWrongPwd => 'गलत पिन या अनलॉक विफल';

  @override
  String get toastNfcPwdUnsupported =>
      'इस कार्ड पर पिन सुरक्षा समर्थित नहीं है';

  @override
  String get toastNfcAlreadyUnlocked => 'कार्ड लॉक नहीं है';

  @override
  String get toastNfcAlreadyLocked =>
      'कार्ड पहले से पिन से लॉक है। बदलने के लिए पहले अनलॉक करें।';

  @override
  String get nfcTitleSuccess => 'सफलतापूर्वक लिखा गया!';

  @override
  String get nfcDescSuccess => 'कार्ड सफलतापूर्वक प्रोग्राम किया गया।';

  @override
  String get nfcTitleNext => 'लिखने के लिए तैयार';

  @override
  String get nfcDescNext => 'दूसरा कार्ड पास लाएं या \'पूर्ण\' पर टैप करें।';

  @override
  String nfcCardsCount(int count) {
    return 'लिखे गए कार्ड: $count';
  }

  @override
  String get nfcCancel => 'रद्द करें';

  @override
  String get nfcDone => 'पूर्ण';

  @override
  String get nfcOk => 'ठीक है';

  @override
  String get nfcBtnLockAnother => 'दूसरा लॉक करें';

  @override
  String get nfcBtnUnlockAnother => 'दूसरा अनलॉक करें';

  @override
  String get nfcTitlePwdLockSuccess => 'कार्ड लॉक हो गया';

  @override
  String get nfcDescPwdLockSuccess => 'कार्ड अब बदलावों से सुरक्षित है।';

  @override
  String get nfcTitlePwdUnlockSuccess => 'कार्ड अनलॉक हो गया';

  @override
  String get nfcDescPwdUnlockSuccess => 'कार्ड अब संपादन के लिए तैयार है।';

  @override
  String get nfcTitleAlreadyUnlocked => 'कार्ड लॉक नहीं है';

  @override
  String get nfcDescAlreadyUnlocked => 'यह कार्ड पहले से ही खुला हुआ है।';

  @override
  String get nfcTitleTagLost => 'कनेक्शन टूट गया';

  @override
  String get nfcDescTagLost => 'फोन को कार्ड के केंद्र पर स्थिर रखें।';

  @override
  String get nfcTitleLocked => 'कार्ड सुरक्षित है';

  @override
  String get nfcTitleReadLocked => 'कार्ड पढ़ना सुरक्षित है';

  @override
  String get nfcDescReadLocked => 'कार्ड का डेटा पढ़ने से सुरक्षित है।';

  @override
  String get nfcTitleWrongPwd => 'गलत पिन';

  @override
  String get nfcTitleAlreadyLocked => 'कार्ड पहले से लॉक है';

  @override
  String get nfcTitleCapacity => 'मेमोरी भर गई';

  @override
  String get nfcTitleEmptyTag => 'खाली कार्ड';

  @override
  String get nfcTitlePermLockSuccess => 'कार्ड स्थायी रूप से लॉक हुआ';

  @override
  String get nfcDescPermLockSuccess =>
      'कार्ड को स्थायी रूप से केवल पढ़ने योग्य बनाया गया है।';

  @override
  String get nfcTitlePermLockStandby => 'कार्ड स्थायी रूप से लॉक हो गया!';

  @override
  String get nfcDescPermLockStandby =>
      'सुरक्षा के लिए रोका गया। फिर से चालू करने के लिए आइकन टैप करें।';

  @override
  String nfcPermLockCount(int count) {
    return 'लॉक किए गए: $count';
  }

  @override
  String nfcEraseCount(int count) {
    return 'मिटाए गए: $count';
  }

  @override
  String get nfcTitleCannotLock => 'लॉक नहीं किया जा सकता';

  @override
  String get nfcDescCannotLock =>
      'कार्ड पहले से केवल पढ़ने योग्य है या असमर्थित है।';

  @override
  String get nfcBackToPin => 'वापस';

  @override
  String get nfcTitleDisabled => 'NFC बंद है';

  @override
  String get nfcTitleNoHardware => 'NFC समर्थित नहीं है';

  @override
  String get nfcTitleOpFailed => 'ऑपरेशन विफल रहा';

  @override
  String get nfcDescOpFailed =>
      'ऑपरेशन विफल। फोन स्थिर रखें और पुनः प्रयास करें।';

  @override
  String get nfcTitleError => 'लिखना विफल रहा';

  @override
  String get nfcDescLocked =>
      'कार्ड पासवर्ड से सुरक्षित या रीड-ओनली है। पहले अनलॉक करें।';

  @override
  String get nfcDescCapacity => 'डेटा कार्ड की क्षमता से अधिक है।';

  @override
  String get nfcDescUnsupported => 'यह कार्ड प्रकार समर्थित नहीं है।';

  @override
  String get nfcDescGenericError => 'लिखना विफल। फोन को कार्ड पर स्थिर रखें।';

  @override
  String get nfcRetryBtn => 'पुनः प्रयास करें';

  @override
  String get nfcNoHardware => 'इस डिवाइस पर NFC समर्थित नहीं है';

  @override
  String get nfcDisabled => 'कृपया फोन सेटिंग्स में NFC चालू करें';

  @override
  String get nfcLocked => 'NFC कार्ड लॉक है या केवल पढ़ने योग्य है';

  @override
  String get nfcCapacity => 'NFC कार्ड में अपर्याप्त मेमोरी है';

  @override
  String get nfcUnsupported => 'असमर्थित NFC टैग प्रकार';

  @override
  String get nfcWriteFailed => 'NFC टैग पर लिखने में त्रुटि। पुनः प्रयास करें।';

  @override
  String get toastPasteFirst => 'कृपया पहले एक लिंक पेस्ट करें';

  @override
  String get toastInvalid => 'स्थान आईडी (Place ID) नहीं मिल सकी';

  @override
  String get toastNoInternet => 'कोई इंटरनेट कनेक्शन नहीं';

  @override
  String get toastSuccess => 'लिंक सफलतापूर्वक बदला गया';

  @override
  String get toastNfcWritten => 'NFC कार्ड पर सफलतापूर्वक लिखा गया';

  @override
  String toastNfcBatchSuccess(int count) {
    return 'सफलतापूर्वक $count NFC कार्ड लिखे गए';
  }

  @override
  String get toastCleared => 'टेक्स्ट साफ किया गया';

  @override
  String get toastPasted => 'क्लिपबोर्ड से पेस्ट किया गया';

  @override
  String get toastEmptyClip => 'क्लिपबोर्ड खाली है';

  @override
  String get toastClipDenied => 'पेस्ट करने के लिए Ctrl+V दबाएं';

  @override
  String get toastCopied => 'समीक्षा लिंक कॉपी हो गया';

  @override
  String get toastShareCopied => 'शेयर करने के लिए लिंक कॉपी किया';

  @override
  String get shareTitle => 'Google समीक्षा';

  @override
  String get shareText => 'Google Maps पर हमें एक समीक्षा दें';

  @override
  String get toastHourlyLimit => 'प्रति घंटा खोज सीमा समाप्त हो गई है';

  @override
  String get toastSelectSuccess => 'लिंक बन गया';

  @override
  String get updateAvailable => 'अपडेट उपलब्ध है';

  @override
  String get updateReadyTitle => 'नया संस्करण तैयार है';

  @override
  String get updateCurrent => 'वर्तमान';

  @override
  String get updateNew => 'नया';

  @override
  String updateSize(String size) {
    return 'आकार: $size';
  }

  @override
  String updateDate(String date) {
    return 'तारीख: $date';
  }

  @override
  String get updateHighlights => 'इस संस्करण में नया क्या है';

  @override
  String get updateInstallBtn => 'अपडेट इंस्टॉल करें';

  @override
  String get updateViewGithub => 'रिलीज़ नोट्स';

  @override
  String get updateLater => 'बाद में';

  @override
  String get toastCheckingUpdate => 'अपडेट की जांच हो रही है...';

  @override
  String toastUpToDate(String version) {
    return 'ऐप अपडेट है ($version)';
  }

  @override
  String toastUpdateFound(String version) {
    return 'नया संस्करण $version उपलब्ध है!';
  }

  @override
  String get toastUpdateError => 'अभी अपडेट की जांच नहीं हो सकती';

  @override
  String get toastDownloadStarted =>
      'बैकग्राउंड में अपडेट डाउनलोड हो रहा है...';

  @override
  String get toastQrSaveError => 'QR इमेज सेव करने में विफल';

  @override
  String get eraseModalTitle => 'कार्ड मिटाएं';

  @override
  String get eraseModalDesc =>
      'सारा डेटा मिट जाएगा और कार्ड खाली हो जाएगा। लॉक प्रभावित नहीं होंगे।';

  @override
  String get eraseConfirmBtn => 'कार्ड मिटाएं';

  @override
  String get eraseCancelBtn => 'रद्द करें';

  @override
  String get nfcTitleEraseReady => 'मिटाने के लिए तैयार';

  @override
  String get nfcDescEraseReady =>
      'डेटा मिटाने के लिए फोन को कार्ड के पास लाएं...';

  @override
  String get nfcTitleEraseSuccess => 'कार्ड मिटा दिया गया!';

  @override
  String get nfcDescEraseSuccess =>
      'कार्ड अब खाली है और उपयोग के लिए तैयार है।';

  @override
  String get nfcBtnEraseAnother => 'दूसरा मिटाएं';

  @override
  String get toastNfcEraseSuccess => 'कार्ड का डेटा सफलतापूर्वक मिटा दिया गया';

  @override
  String get githubProjectBtn => 'GitHub';

  @override
  String get githubSupportBtn => 'सपोर्ट';

  @override
  String get toastSupportComingSoon => 'सपोर्ट विकल्प जल्द उपलब्ध होगा';

  @override
  String get settingsThemeLabel => 'दिखावट (थीम)';

  @override
  String get settingsThemeSub => 'पसंदीदा ऐप थीम चुनें';

  @override
  String get settingsThemeSystem => 'सिस्टम';

  @override
  String get settingsThemeDark => 'डार्क';

  @override
  String get settingsThemeLight => 'लाइट';
}
