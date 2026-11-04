import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_de.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_hi.dart';
import 'app_localizations_ja.dart';
import 'app_localizations_pt.dart';
import 'app_localizations_ru.dart';
import 'app_localizations_zh.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('de'),
    Locale('en'),
    Locale('es'),
    Locale('fr'),
    Locale('hi'),
    Locale('ja'),
    Locale('pt'),
    Locale('ru'),
    Locale('zh'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'Quick NFC'**
  String get appTitle;

  /// No description provided for @appSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fast & simple NFC tool with instant Google Maps review link conversion'**
  String get appSubtitle;

  /// No description provided for @tabLink.
  ///
  /// In en, this message translates to:
  /// **'Direct Link'**
  String get tabLink;

  /// No description provided for @tabSearch.
  ///
  /// In en, this message translates to:
  /// **'Find Business'**
  String get tabSearch;

  /// No description provided for @placeholder.
  ///
  /// In en, this message translates to:
  /// **'Paste link here...'**
  String get placeholder;

  /// No description provided for @trashTitle.
  ///
  /// In en, this message translates to:
  /// **'Clear text'**
  String get trashTitle;

  /// No description provided for @pasteBtn.
  ///
  /// In en, this message translates to:
  /// **'Paste'**
  String get pasteBtn;

  /// No description provided for @convertBtn.
  ///
  /// In en, this message translates to:
  /// **'Convert Link'**
  String get convertBtn;

  /// No description provided for @resolvingBtn.
  ///
  /// In en, this message translates to:
  /// **'Resolving link...'**
  String get resolvingBtn;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search place name & city...'**
  String get searchPlaceholder;

  /// No description provided for @toastEnterQuery.
  ///
  /// In en, this message translates to:
  /// **'Please enter a business name first'**
  String get toastEnterQuery;

  /// No description provided for @fabGithubLabel.
  ///
  /// In en, this message translates to:
  /// **'Project on GitHub'**
  String get fabGithubLabel;

  /// No description provided for @resultLabel.
  ///
  /// In en, this message translates to:
  /// **'Direct Link:'**
  String get resultLabel;

  /// No description provided for @resultLabelReview.
  ///
  /// In en, this message translates to:
  /// **'Direct Review Link:'**
  String get resultLabelReview;

  /// No description provided for @resultLabelLocation.
  ///
  /// In en, this message translates to:
  /// **'Location on Google Maps:'**
  String get resultLabelLocation;

  /// No description provided for @resultLabelCustom.
  ///
  /// In en, this message translates to:
  /// **'Direct Link:'**
  String get resultLabelCustom;

  /// No description provided for @linkTypePrompt.
  ///
  /// In en, this message translates to:
  /// **'Link Type to Program:'**
  String get linkTypePrompt;

  /// No description provided for @linkTypeReview.
  ///
  /// In en, this message translates to:
  /// **'5-Star Review'**
  String get linkTypeReview;

  /// No description provided for @linkTypeLocation.
  ///
  /// In en, this message translates to:
  /// **'Map Location'**
  String get linkTypeLocation;

  /// No description provided for @toastSwitchedToReview.
  ///
  /// In en, this message translates to:
  /// **'Switched to Direct 5-Star Review link'**
  String get toastSwitchedToReview;

  /// No description provided for @toastSwitchedToLocation.
  ///
  /// In en, this message translates to:
  /// **'Switched to Google Maps Location link'**
  String get toastSwitchedToLocation;

  /// No description provided for @btnHelpGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'User Guide & Feature Tour'**
  String get btnHelpGuideTitle;

  /// No description provided for @btnGuideLabel.
  ///
  /// In en, this message translates to:
  /// **'Guide'**
  String get btnGuideLabel;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsGeneralSection.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get settingsGeneralSection;

  /// No description provided for @settingsLanguageLabel.
  ///
  /// In en, this message translates to:
  /// **'Display Language'**
  String get settingsLanguageLabel;

  /// No description provided for @settingsLanguageSub.
  ///
  /// In en, this message translates to:
  /// **'Select your preferred app language'**
  String get settingsLanguageSub;

  /// No description provided for @settingsLangArabic.
  ///
  /// In en, this message translates to:
  /// **'العربية (Arabic)'**
  String get settingsLangArabic;

  /// No description provided for @settingsLangEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLangEnglish;

  /// No description provided for @settingsAboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get settingsAboutSection;

  /// No description provided for @settingsVersionLabel.
  ///
  /// In en, this message translates to:
  /// **'Application Version'**
  String get settingsVersionLabel;

  /// No description provided for @settingsDeveloperLabel.
  ///
  /// In en, this message translates to:
  /// **'Developer & Repository'**
  String get settingsDeveloperLabel;

  /// No description provided for @settingsBackBtn.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get settingsBackBtn;

  /// No description provided for @obStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Smart Links & 5-Star Reviews'**
  String get obStep1Title;

  /// No description provided for @obStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Paste any Google Maps link to instantly convert it into a 5-star review link or location link.'**
  String get obStep1Desc;

  /// No description provided for @obStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Direct Business Search'**
  String get obStep2Title;

  /// No description provided for @obStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Type your business name & city in \'Find Business\' tab to generate your review link in a single tap.'**
  String get obStep2Desc;

  /// No description provided for @obStep3Title.
  ///
  /// In en, this message translates to:
  /// **'NFC Tags, Wi-Fi & Protection'**
  String get obStep3Title;

  /// No description provided for @obStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Write links and Wi-Fi to NFC cards easily, and protect them with PIN or permanent lock.'**
  String get obStep3Desc;

  /// No description provided for @obBtnNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get obBtnNext;

  /// No description provided for @obBtnStart.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get obBtnStart;

  /// No description provided for @obBtnSkip.
  ///
  /// In en, this message translates to:
  /// **'Skip Tour'**
  String get obBtnSkip;

  /// No description provided for @copyBtn.
  ///
  /// In en, this message translates to:
  /// **'Copy'**
  String get copyBtn;

  /// No description provided for @copySuccess.
  ///
  /// In en, this message translates to:
  /// **'Copied!'**
  String get copySuccess;

  /// No description provided for @openBtn.
  ///
  /// In en, this message translates to:
  /// **'Open'**
  String get openBtn;

  /// No description provided for @shareBtn.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get shareBtn;

  /// No description provided for @qrBtn.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get qrBtn;

  /// No description provided for @qrModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Review QR Code'**
  String get qrModalTitle;

  /// No description provided for @qrModalDesc.
  ///
  /// In en, this message translates to:
  /// **'Scan with any phone camera to leave a review directly'**
  String get qrModalDesc;

  /// No description provided for @qrDownloadBtn.
  ///
  /// In en, this message translates to:
  /// **'Save QR'**
  String get qrDownloadBtn;

  /// No description provided for @qrCloseBtn.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get qrCloseBtn;

  /// No description provided for @qrDownloaded.
  ///
  /// In en, this message translates to:
  /// **'QR Code downloaded'**
  String get qrDownloaded;

  /// No description provided for @lblReadTag.
  ///
  /// In en, this message translates to:
  /// **'Read Card'**
  String get lblReadTag;

  /// No description provided for @lblWifiTag.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi Card'**
  String get lblWifiTag;

  /// No description provided for @lblPwdLockTag.
  ///
  /// In en, this message translates to:
  /// **'PIN Lock / Unlock'**
  String get lblPwdLockTag;

  /// No description provided for @lblEraseTag.
  ///
  /// In en, this message translates to:
  /// **'Erase Card'**
  String get lblEraseTag;

  /// No description provided for @lblPermLockTag.
  ///
  /// In en, this message translates to:
  /// **'Permanent Lock'**
  String get lblPermLockTag;

  /// No description provided for @wifiModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi Card Setup'**
  String get wifiModalTitle;

  /// No description provided for @wifiStep1Title.
  ///
  /// In en, this message translates to:
  /// **'Network Name'**
  String get wifiStep1Title;

  /// No description provided for @wifiStep1Desc.
  ///
  /// In en, this message translates to:
  /// **'Enter Wi-Fi network name (SSID)'**
  String get wifiStep1Desc;

  /// No description provided for @wifiStep2Title.
  ///
  /// In en, this message translates to:
  /// **'Network Password'**
  String get wifiStep2Title;

  /// No description provided for @wifiStep2Desc.
  ///
  /// In en, this message translates to:
  /// **'Enter password (or leave blank for open network)'**
  String get wifiStep2Desc;

  /// No description provided for @wifiStep3Title.
  ///
  /// In en, this message translates to:
  /// **'Security Type'**
  String get wifiStep3Title;

  /// No description provided for @wifiStep3Desc.
  ///
  /// In en, this message translates to:
  /// **'Select network encryption standard'**
  String get wifiStep3Desc;

  /// No description provided for @wifiSsidPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Network Name (SSID)...'**
  String get wifiSsidPlaceholder;

  /// No description provided for @wifiPasswordPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter password...'**
  String get wifiPasswordPlaceholder;

  /// No description provided for @wifiEncWpa.
  ///
  /// In en, this message translates to:
  /// **'WPA / WPA2 / WPA3'**
  String get wifiEncWpa;

  /// No description provided for @wifiEncWpaSub.
  ///
  /// In en, this message translates to:
  /// **'Standard (Personal)'**
  String get wifiEncWpaSub;

  /// No description provided for @wifiEncWep.
  ///
  /// In en, this message translates to:
  /// **'WEP'**
  String get wifiEncWep;

  /// No description provided for @wifiEncWepSub.
  ///
  /// In en, this message translates to:
  /// **'Legacy networks'**
  String get wifiEncWepSub;

  /// No description provided for @wifiEncOpen.
  ///
  /// In en, this message translates to:
  /// **'Open Network'**
  String get wifiEncOpen;

  /// No description provided for @wifiEncOpenSub.
  ///
  /// In en, this message translates to:
  /// **'No password required'**
  String get wifiEncOpenSub;

  /// No description provided for @wifiNext.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get wifiNext;

  /// No description provided for @wifiBack.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get wifiBack;

  /// No description provided for @wifiWriteTag.
  ///
  /// In en, this message translates to:
  /// **'Write Card'**
  String get wifiWriteTag;

  /// No description provided for @wifiQrBtn.
  ///
  /// In en, this message translates to:
  /// **'QR Code'**
  String get wifiQrBtn;

  /// No description provided for @wifiQrModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi QR Code'**
  String get wifiQrModalTitle;

  /// No description provided for @wifiQrModalDesc.
  ///
  /// In en, this message translates to:
  /// **'Scan with phone camera to connect directly'**
  String get wifiQrModalDesc;

  /// No description provided for @wifiQrDownloaded.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi QR Code downloaded'**
  String get wifiQrDownloaded;

  /// No description provided for @toastEnterSsid.
  ///
  /// In en, this message translates to:
  /// **'Please enter network name (SSID)'**
  String get toastEnterSsid;

  /// No description provided for @toastWifiPassMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get toastWifiPassMinLength;

  /// No description provided for @toastWifiWpaRequired.
  ///
  /// In en, this message translates to:
  /// **'WPA networks require a password of at least 8 characters'**
  String get toastWifiWpaRequired;

  /// No description provided for @nfcTitleWifiReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to Write Wi-Fi'**
  String get nfcTitleWifiReady;

  /// No description provided for @nfcTitleWifiClone.
  ///
  /// In en, this message translates to:
  /// **'Clone Wi-Fi Card'**
  String get nfcTitleWifiClone;

  /// No description provided for @nfcTitleWifiCloneSuccess.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi Card Cloned!'**
  String get nfcTitleWifiCloneSuccess;

  /// No description provided for @nfcDescWifiReady.
  ///
  /// In en, this message translates to:
  /// **'Hold phone near NFC card to write Wi-Fi credentials.'**
  String get nfcDescWifiReady;

  /// No description provided for @nfcDescWifiReadyWithSsid.
  ///
  /// In en, this message translates to:
  /// **'Hold phone near card to write \"{ssid}\".'**
  String nfcDescWifiReadyWithSsid(String ssid);

  /// No description provided for @nfcDescWifiCloneWithSsid.
  ///
  /// In en, this message translates to:
  /// **'Hold another card near phone to copy \"{ssid}\".'**
  String nfcDescWifiCloneWithSsid(String ssid);

  /// No description provided for @nfcTitleWifiSuccess.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi Card Programmed!'**
  String get nfcTitleWifiSuccess;

  /// No description provided for @nfcDescWifiSuccess.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi configuration written to card.'**
  String get nfcDescWifiSuccess;

  /// No description provided for @nfcBtnWifiAnother.
  ///
  /// In en, this message translates to:
  /// **'Write Another'**
  String get nfcBtnWifiAnother;

  /// No description provided for @nfcBtnWifiCloneAnother.
  ///
  /// In en, this message translates to:
  /// **'Clone Another'**
  String get nfcBtnWifiCloneAnother;

  /// No description provided for @toastNfcWifiSuccess.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi card written successfully!'**
  String get toastNfcWifiSuccess;

  /// No description provided for @toastNfcWifiReadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Wi-Fi network \"{ssid}\" read successfully! Ready to write to a new card.'**
  String toastNfcWifiReadSuccess(String ssid);

  /// No description provided for @nfcBtn.
  ///
  /// In en, this message translates to:
  /// **'Write NFC Card'**
  String get nfcBtn;

  /// No description provided for @nfcBtnWriteAnother.
  ///
  /// In en, this message translates to:
  /// **'Write Another'**
  String get nfcBtnWriteAnother;

  /// No description provided for @nfcTitleReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to Write'**
  String get nfcTitleReady;

  /// No description provided for @nfcDescReady.
  ///
  /// In en, this message translates to:
  /// **'Hold phone near NFC card to write the link.'**
  String get nfcDescReady;

  /// No description provided for @nfcTitleReadReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to Read Card'**
  String get nfcTitleReadReady;

  /// No description provided for @nfcDescReadReady.
  ///
  /// In en, this message translates to:
  /// **'Hold phone near card to read its link.'**
  String get nfcDescReadReady;

  /// No description provided for @nfcTitlePermLockReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to Lock'**
  String get nfcTitlePermLockReady;

  /// No description provided for @nfcDescPermLockReady.
  ///
  /// In en, this message translates to:
  /// **'Hold phone near card to apply permanent read-only lock.'**
  String get nfcDescPermLockReady;

  /// No description provided for @nfcTitlePwdLockReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to Lock'**
  String get nfcTitlePwdLockReady;

  /// No description provided for @nfcDescPwdLockReady.
  ///
  /// In en, this message translates to:
  /// **'Hold phone near card to set PIN...'**
  String get nfcDescPwdLockReady;

  /// No description provided for @nfcTitlePwdUnlockReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to Unlock'**
  String get nfcTitlePwdUnlockReady;

  /// No description provided for @nfcDescPwdUnlockReady.
  ///
  /// In en, this message translates to:
  /// **'Hold phone near card to unlock...'**
  String get nfcDescPwdUnlockReady;

  /// No description provided for @pwdModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Card Protection'**
  String get pwdModalTitle;

  /// No description provided for @pwdModalTitleLock.
  ///
  /// In en, this message translates to:
  /// **'Lock Card'**
  String get pwdModalTitleLock;

  /// No description provided for @pwdModalTitleUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock Card'**
  String get pwdModalTitleUnlock;

  /// No description provided for @pwdModalDesc.
  ///
  /// In en, this message translates to:
  /// **'Set a PIN to protect card'**
  String get pwdModalDesc;

  /// No description provided for @pwdModalDescLock.
  ///
  /// In en, this message translates to:
  /// **'Set a PIN to protect card'**
  String get pwdModalDescLock;

  /// No description provided for @pwdModalDescUnlock.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN to unlock card'**
  String get pwdModalDescUnlock;

  /// No description provided for @pwdHintText.
  ///
  /// In en, this message translates to:
  /// **'4 digits recommended'**
  String get pwdHintText;

  /// No description provided for @pwdInfoToast.
  ///
  /// In en, this message translates to:
  /// **'4 digits recommended'**
  String get pwdInfoToast;

  /// No description provided for @pwdPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Enter PIN...'**
  String get pwdPlaceholder;

  /// No description provided for @pwdTabLock.
  ///
  /// In en, this message translates to:
  /// **'Lock'**
  String get pwdTabLock;

  /// No description provided for @pwdTabUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock'**
  String get pwdTabUnlock;

  /// No description provided for @pwdSubmitLock.
  ///
  /// In en, this message translates to:
  /// **'Lock Card'**
  String get pwdSubmitLock;

  /// No description provided for @pwdSubmitUnlock.
  ///
  /// In en, this message translates to:
  /// **'Unlock Card'**
  String get pwdSubmitUnlock;

  /// No description provided for @pwdCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get pwdCancel;

  /// No description provided for @toastEnterPwd.
  ///
  /// In en, this message translates to:
  /// **'Please enter a PIN'**
  String get toastEnterPwd;

  /// No description provided for @permLockTitle.
  ///
  /// In en, this message translates to:
  /// **'Permanent Lock'**
  String get permLockTitle;

  /// No description provided for @permLockDesc.
  ///
  /// In en, this message translates to:
  /// **'Warning: Card will permanently become Read-Only. Cannot be edited or erased.'**
  String get permLockDesc;

  /// No description provided for @permLockConfirmBtn.
  ///
  /// In en, this message translates to:
  /// **'Lock Permanently'**
  String get permLockConfirmBtn;

  /// No description provided for @permLockCancelBtn.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get permLockCancelBtn;

  /// No description provided for @toastNfcReadSuccess.
  ///
  /// In en, this message translates to:
  /// **'Link read and loaded successfully'**
  String get toastNfcReadSuccess;

  /// No description provided for @toastNfcReadEmpty.
  ///
  /// In en, this message translates to:
  /// **'No valid URL found on this card'**
  String get toastNfcReadEmpty;

  /// No description provided for @toastNfcPermLockSuccess.
  ///
  /// In en, this message translates to:
  /// **'Card permanently locked to Read-Only'**
  String get toastNfcPermLockSuccess;

  /// No description provided for @toastNfcPwdLockSuccess.
  ///
  /// In en, this message translates to:
  /// **'Card locked with PIN successfully'**
  String get toastNfcPwdLockSuccess;

  /// No description provided for @toastNfcPwdUnlockSuccess.
  ///
  /// In en, this message translates to:
  /// **'Card unlocked successfully'**
  String get toastNfcPwdUnlockSuccess;

  /// No description provided for @toastNfcWrongPwd.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN or unlocking failed'**
  String get toastNfcWrongPwd;

  /// No description provided for @toastNfcPwdUnsupported.
  ///
  /// In en, this message translates to:
  /// **'PIN protection is not supported on this card'**
  String get toastNfcPwdUnsupported;

  /// No description provided for @toastNfcAlreadyUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Card is not locked'**
  String get toastNfcAlreadyUnlocked;

  /// No description provided for @toastNfcAlreadyLocked.
  ///
  /// In en, this message translates to:
  /// **'Card is already locked with a PIN. Unlock it first to change PIN.'**
  String get toastNfcAlreadyLocked;

  /// No description provided for @nfcTitleSuccess.
  ///
  /// In en, this message translates to:
  /// **'Write Successful!'**
  String get nfcTitleSuccess;

  /// No description provided for @nfcDescSuccess.
  ///
  /// In en, this message translates to:
  /// **'Card programmed successfully.'**
  String get nfcDescSuccess;

  /// No description provided for @nfcTitleNext.
  ///
  /// In en, this message translates to:
  /// **'Ready to Write'**
  String get nfcTitleNext;

  /// No description provided for @nfcDescNext.
  ///
  /// In en, this message translates to:
  /// **'Hold another card near phone, or tap Done.'**
  String get nfcDescNext;

  /// No description provided for @nfcCardsCount.
  ///
  /// In en, this message translates to:
  /// **'Cards written: {count}'**
  String nfcCardsCount(int count);

  /// No description provided for @nfcCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get nfcCancel;

  /// No description provided for @nfcDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get nfcDone;

  /// No description provided for @nfcOk.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get nfcOk;

  /// No description provided for @nfcBtnLockAnother.
  ///
  /// In en, this message translates to:
  /// **'Lock Another'**
  String get nfcBtnLockAnother;

  /// No description provided for @nfcBtnUnlockAnother.
  ///
  /// In en, this message translates to:
  /// **'Unlock Another'**
  String get nfcBtnUnlockAnother;

  /// No description provided for @nfcTitlePwdLockSuccess.
  ///
  /// In en, this message translates to:
  /// **'Card Locked'**
  String get nfcTitlePwdLockSuccess;

  /// No description provided for @nfcDescPwdLockSuccess.
  ///
  /// In en, this message translates to:
  /// **'Card is now protected against edits.'**
  String get nfcDescPwdLockSuccess;

  /// No description provided for @nfcTitlePwdUnlockSuccess.
  ///
  /// In en, this message translates to:
  /// **'Card Unlocked'**
  String get nfcTitlePwdUnlockSuccess;

  /// No description provided for @nfcDescPwdUnlockSuccess.
  ///
  /// In en, this message translates to:
  /// **'Card is ready for editing.'**
  String get nfcDescPwdUnlockSuccess;

  /// No description provided for @nfcTitleAlreadyUnlocked.
  ///
  /// In en, this message translates to:
  /// **'Card Not Locked'**
  String get nfcTitleAlreadyUnlocked;

  /// No description provided for @nfcDescAlreadyUnlocked.
  ///
  /// In en, this message translates to:
  /// **'This card is already unlocked.'**
  String get nfcDescAlreadyUnlocked;

  /// No description provided for @nfcTitleTagLost.
  ///
  /// In en, this message translates to:
  /// **'Connection Lost'**
  String get nfcTitleTagLost;

  /// No description provided for @nfcDescTagLost.
  ///
  /// In en, this message translates to:
  /// **'Hold phone steady over card center.'**
  String get nfcDescTagLost;

  /// No description provided for @nfcTitleLocked.
  ///
  /// In en, this message translates to:
  /// **'Card Is Protected'**
  String get nfcTitleLocked;

  /// No description provided for @nfcTitleReadLocked.
  ///
  /// In en, this message translates to:
  /// **'Card is Read-Protected'**
  String get nfcTitleReadLocked;

  /// No description provided for @nfcDescReadLocked.
  ///
  /// In en, this message translates to:
  /// **'Card data is protected against reading.'**
  String get nfcDescReadLocked;

  /// No description provided for @nfcTitleWrongPwd.
  ///
  /// In en, this message translates to:
  /// **'Incorrect PIN'**
  String get nfcTitleWrongPwd;

  /// No description provided for @nfcTitleAlreadyLocked.
  ///
  /// In en, this message translates to:
  /// **'Card Already Locked'**
  String get nfcTitleAlreadyLocked;

  /// No description provided for @nfcTitleCapacity.
  ///
  /// In en, this message translates to:
  /// **'Capacity Exceeded'**
  String get nfcTitleCapacity;

  /// No description provided for @nfcTitleEmptyTag.
  ///
  /// In en, this message translates to:
  /// **'Empty Card'**
  String get nfcTitleEmptyTag;

  /// No description provided for @nfcTitlePermLockSuccess.
  ///
  /// In en, this message translates to:
  /// **'Card Permanently Locked'**
  String get nfcTitlePermLockSuccess;

  /// No description provided for @nfcDescPermLockSuccess.
  ///
  /// In en, this message translates to:
  /// **'Card has been permanently set to Read-Only.'**
  String get nfcDescPermLockSuccess;

  /// No description provided for @nfcTitlePermLockStandby.
  ///
  /// In en, this message translates to:
  /// **'Card Permanently Locked!'**
  String get nfcTitlePermLockStandby;

  /// No description provided for @nfcDescPermLockStandby.
  ///
  /// In en, this message translates to:
  /// **'Paused for safety. Tap icon to reactivate.'**
  String get nfcDescPermLockStandby;

  /// No description provided for @nfcPermLockCount.
  ///
  /// In en, this message translates to:
  /// **'Locked: {count}'**
  String nfcPermLockCount(int count);

  /// No description provided for @nfcEraseCount.
  ///
  /// In en, this message translates to:
  /// **'Erased: {count}'**
  String nfcEraseCount(int count);

  /// No description provided for @nfcTitleCannotLock.
  ///
  /// In en, this message translates to:
  /// **'Cannot Lock'**
  String get nfcTitleCannotLock;

  /// No description provided for @nfcDescCannotLock.
  ///
  /// In en, this message translates to:
  /// **'Card is already read-only or unsupported.'**
  String get nfcDescCannotLock;

  /// No description provided for @nfcBackToPin.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get nfcBackToPin;

  /// No description provided for @nfcTitleDisabled.
  ///
  /// In en, this message translates to:
  /// **'NFC is Disabled'**
  String get nfcTitleDisabled;

  /// No description provided for @nfcTitleNoHardware.
  ///
  /// In en, this message translates to:
  /// **'NFC Not Supported'**
  String get nfcTitleNoHardware;

  /// No description provided for @nfcTitleOpFailed.
  ///
  /// In en, this message translates to:
  /// **'Operation Failed'**
  String get nfcTitleOpFailed;

  /// No description provided for @nfcDescOpFailed.
  ///
  /// In en, this message translates to:
  /// **'Operation failed. Keep phone steady and retry.'**
  String get nfcDescOpFailed;

  /// No description provided for @nfcTitleError.
  ///
  /// In en, this message translates to:
  /// **'Write Failed'**
  String get nfcTitleError;

  /// No description provided for @nfcDescLocked.
  ///
  /// In en, this message translates to:
  /// **'Card is password-protected or read-only. Unlock it first.'**
  String get nfcDescLocked;

  /// No description provided for @nfcDescCapacity.
  ///
  /// In en, this message translates to:
  /// **'Data exceeds card memory capacity.'**
  String get nfcDescCapacity;

  /// No description provided for @nfcDescUnsupported.
  ///
  /// In en, this message translates to:
  /// **'This card type is not supported.'**
  String get nfcDescUnsupported;

  /// No description provided for @nfcDescGenericError.
  ///
  /// In en, this message translates to:
  /// **'Write failed. Keep phone steady over card.'**
  String get nfcDescGenericError;

  /// No description provided for @nfcRetryBtn.
  ///
  /// In en, this message translates to:
  /// **'Try Again'**
  String get nfcRetryBtn;

  /// No description provided for @nfcNoHardware.
  ///
  /// In en, this message translates to:
  /// **'NFC is not supported on this device'**
  String get nfcNoHardware;

  /// No description provided for @nfcDisabled.
  ///
  /// In en, this message translates to:
  /// **'Please enable NFC in your phone settings'**
  String get nfcDisabled;

  /// No description provided for @nfcLocked.
  ///
  /// In en, this message translates to:
  /// **'NFC card is locked or read-only'**
  String get nfcLocked;

  /// No description provided for @nfcCapacity.
  ///
  /// In en, this message translates to:
  /// **'NFC card has insufficient memory'**
  String get nfcCapacity;

  /// No description provided for @nfcUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Unsupported NFC tag type'**
  String get nfcUnsupported;

  /// No description provided for @nfcWriteFailed.
  ///
  /// In en, this message translates to:
  /// **'Error writing to NFC tag. Try again.'**
  String get nfcWriteFailed;

  /// No description provided for @toastPasteFirst.
  ///
  /// In en, this message translates to:
  /// **'Please paste a link first'**
  String get toastPasteFirst;

  /// No description provided for @toastInvalid.
  ///
  /// In en, this message translates to:
  /// **'Could not extract Place ID'**
  String get toastInvalid;

  /// No description provided for @toastNoInternet.
  ///
  /// In en, this message translates to:
  /// **'No network connection'**
  String get toastNoInternet;

  /// No description provided for @toastSuccess.
  ///
  /// In en, this message translates to:
  /// **'Link converted successfully'**
  String get toastSuccess;

  /// No description provided for @toastNfcWritten.
  ///
  /// In en, this message translates to:
  /// **'Successfully written to NFC card'**
  String get toastNfcWritten;

  /// No description provided for @toastNfcBatchSuccess.
  ///
  /// In en, this message translates to:
  /// **'Successfully programmed {count} NFC card(s)'**
  String toastNfcBatchSuccess(int count);

  /// No description provided for @toastCleared.
  ///
  /// In en, this message translates to:
  /// **'Text cleared'**
  String get toastCleared;

  /// No description provided for @toastPasted.
  ///
  /// In en, this message translates to:
  /// **'Pasted from clipboard'**
  String get toastPasted;

  /// No description provided for @toastEmptyClip.
  ///
  /// In en, this message translates to:
  /// **'Clipboard is empty'**
  String get toastEmptyClip;

  /// No description provided for @toastClipDenied.
  ///
  /// In en, this message translates to:
  /// **'Press Ctrl+V to paste'**
  String get toastClipDenied;

  /// No description provided for @toastCopied.
  ///
  /// In en, this message translates to:
  /// **'Review link copied'**
  String get toastCopied;

  /// No description provided for @toastShareCopied.
  ///
  /// In en, this message translates to:
  /// **'Link copied for sharing'**
  String get toastShareCopied;

  /// No description provided for @shareTitle.
  ///
  /// In en, this message translates to:
  /// **'Google Review'**
  String get shareTitle;

  /// No description provided for @shareText.
  ///
  /// In en, this message translates to:
  /// **'Leave us a review on Google Maps'**
  String get shareText;

  /// No description provided for @toastHourlyLimit.
  ///
  /// In en, this message translates to:
  /// **'Hourly search limit reached to protect your quota'**
  String get toastHourlyLimit;

  /// No description provided for @toastSelectSuccess.
  ///
  /// In en, this message translates to:
  /// **'Link generated'**
  String get toastSelectSuccess;

  /// No description provided for @updateAvailable.
  ///
  /// In en, this message translates to:
  /// **'Update Available'**
  String get updateAvailable;

  /// No description provided for @updateReadyTitle.
  ///
  /// In en, this message translates to:
  /// **'New Version Ready'**
  String get updateReadyTitle;

  /// No description provided for @updateCurrent.
  ///
  /// In en, this message translates to:
  /// **'Current'**
  String get updateCurrent;

  /// No description provided for @updateNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get updateNew;

  /// No description provided for @updateSize.
  ///
  /// In en, this message translates to:
  /// **'Size: {size}'**
  String updateSize(String size);

  /// No description provided for @updateDate.
  ///
  /// In en, this message translates to:
  /// **'Published: {date}'**
  String updateDate(String date);

  /// No description provided for @updateHighlights.
  ///
  /// In en, this message translates to:
  /// **'What\'s New in this Release'**
  String get updateHighlights;

  /// No description provided for @updateInstallBtn.
  ///
  /// In en, this message translates to:
  /// **'Install Update'**
  String get updateInstallBtn;

  /// No description provided for @updateViewGithub.
  ///
  /// In en, this message translates to:
  /// **'Release Notes'**
  String get updateViewGithub;

  /// No description provided for @updateLater.
  ///
  /// In en, this message translates to:
  /// **'Later'**
  String get updateLater;

  /// No description provided for @toastCheckingUpdate.
  ///
  /// In en, this message translates to:
  /// **'Checking for updates...'**
  String get toastCheckingUpdate;

  /// No description provided for @toastUpToDate.
  ///
  /// In en, this message translates to:
  /// **'App is up to date ({version})'**
  String toastUpToDate(String version);

  /// No description provided for @toastUpdateFound.
  ///
  /// In en, this message translates to:
  /// **'New version {version} is available!'**
  String toastUpdateFound(String version);

  /// No description provided for @toastUpdateError.
  ///
  /// In en, this message translates to:
  /// **'Unable to check for updates right now'**
  String get toastUpdateError;

  /// No description provided for @toastDownloadStarted.
  ///
  /// In en, this message translates to:
  /// **'Downloading update in background...'**
  String get toastDownloadStarted;

  /// No description provided for @toastQrSaveError.
  ///
  /// In en, this message translates to:
  /// **'Failed to save QR image'**
  String get toastQrSaveError;

  /// No description provided for @eraseModalTitle.
  ///
  /// In en, this message translates to:
  /// **'Erase Card'**
  String get eraseModalTitle;

  /// No description provided for @eraseModalDesc.
  ///
  /// In en, this message translates to:
  /// **'All data will be erased and card restored to empty. Locks are unaffected.'**
  String get eraseModalDesc;

  /// No description provided for @eraseConfirmBtn.
  ///
  /// In en, this message translates to:
  /// **'Erase Card'**
  String get eraseConfirmBtn;

  /// No description provided for @eraseCancelBtn.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get eraseCancelBtn;

  /// No description provided for @nfcTitleEraseReady.
  ///
  /// In en, this message translates to:
  /// **'Ready to Erase'**
  String get nfcTitleEraseReady;

  /// No description provided for @nfcDescEraseReady.
  ///
  /// In en, this message translates to:
  /// **'Hold phone near card to erase data...'**
  String get nfcDescEraseReady;

  /// No description provided for @nfcTitleEraseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Card Erased!'**
  String get nfcTitleEraseSuccess;

  /// No description provided for @nfcDescEraseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Card is now empty and ready for use.'**
  String get nfcDescEraseSuccess;

  /// No description provided for @nfcBtnEraseAnother.
  ///
  /// In en, this message translates to:
  /// **'Erase Another'**
  String get nfcBtnEraseAnother;

  /// No description provided for @toastNfcEraseSuccess.
  ///
  /// In en, this message translates to:
  /// **'Card data erased successfully'**
  String get toastNfcEraseSuccess;

  /// No description provided for @githubProjectBtn.
  ///
  /// In en, this message translates to:
  /// **'GitHub'**
  String get githubProjectBtn;

  /// No description provided for @githubSupportBtn.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get githubSupportBtn;

  /// No description provided for @toastSupportComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Support option will be available soon'**
  String get toastSupportComingSoon;

  /// No description provided for @settingsThemeLabel.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get settingsThemeLabel;

  /// No description provided for @settingsThemeSub.
  ///
  /// In en, this message translates to:
  /// **'Choose your preferred app theme'**
  String get settingsThemeSub;

  /// No description provided for @settingsThemeSystem.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get settingsThemeSystem;

  /// No description provided for @settingsThemeDark.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get settingsThemeDark;

  /// No description provided for @settingsThemeLight.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get settingsThemeLight;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>[
    'ar',
    'de',
    'en',
    'es',
    'fr',
    'hi',
    'ja',
    'pt',
    'ru',
    'zh',
  ].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'de':
      return AppLocalizationsDe();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
    case 'hi':
      return AppLocalizationsHi();
    case 'ja':
      return AppLocalizationsJa();
    case 'pt':
      return AppLocalizationsPt();
    case 'ru':
      return AppLocalizationsRu();
    case 'zh':
      return AppLocalizationsZh();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
