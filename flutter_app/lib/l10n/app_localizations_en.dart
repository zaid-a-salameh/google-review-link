// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Quick NFC';

  @override
  String get appSubtitle =>
      'Fast & simple NFC tool with instant Google Maps review link conversion';

  @override
  String get tabLink => 'Direct Link';

  @override
  String get tabSearch => 'Find Business';

  @override
  String get placeholder => 'Paste link here...';

  @override
  String get trashTitle => 'Clear text';

  @override
  String get pasteBtn => 'Paste';

  @override
  String get convertBtn => 'Convert Link';

  @override
  String get resolvingBtn => 'Resolving link...';

  @override
  String get searchPlaceholder => 'Search place name & city...';

  @override
  String get toastEnterQuery => 'Please enter a business name first';

  @override
  String get fabGithubLabel => 'Project on GitHub';

  @override
  String get resultLabel => 'Direct Link:';

  @override
  String get resultLabelReview => 'Direct Review Link:';

  @override
  String get resultLabelLocation => 'Location on Google Maps:';

  @override
  String get resultLabelCustom => 'Direct Link:';

  @override
  String get linkTypePrompt => 'Link Type to Program:';

  @override
  String get linkTypeReview => '5-Star Review';

  @override
  String get linkTypeLocation => 'Map Location';

  @override
  String get toastSwitchedToReview => 'Switched to Direct 5-Star Review link';

  @override
  String get toastSwitchedToLocation => 'Switched to Google Maps Location link';

  @override
  String get btnHelpGuideTitle => 'User Guide & Feature Tour';

  @override
  String get btnGuideLabel => 'Guide';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsGeneralSection => 'Preferences';

  @override
  String get settingsLanguageLabel => 'Display Language';

  @override
  String get settingsLanguageSub => 'Select your preferred app language';

  @override
  String get settingsLangArabic => 'العربية (Arabic)';

  @override
  String get settingsLangEnglish => 'English';

  @override
  String get settingsAboutSection => 'About';

  @override
  String get settingsVersionLabel => 'Application Version';

  @override
  String get settingsDeveloperLabel => 'Developer & Repository';

  @override
  String get settingsBackBtn => 'Back';

  @override
  String get obStep1Title => 'Smart Links & 5-Star Reviews';

  @override
  String get obStep1Desc =>
      'Paste any Google Maps link to instantly convert it into a 5-star review link or location link.';

  @override
  String get obStep2Title => 'Direct Business Search';

  @override
  String get obStep2Desc =>
      'Type your business name & city in \'Find Business\' tab to generate your review link in a single tap.';

  @override
  String get obStep3Title => 'NFC Tags, Wi-Fi & Protection';

  @override
  String get obStep3Desc =>
      'Write links and Wi-Fi to NFC cards easily, and protect them with PIN or permanent lock.';

  @override
  String get obBtnNext => 'Next';

  @override
  String get obBtnStart => 'Get Started';

  @override
  String get obBtnSkip => 'Skip Tour';

  @override
  String get copyBtn => 'Copy';

  @override
  String get copySuccess => 'Copied!';

  @override
  String get openBtn => 'Open';

  @override
  String get shareBtn => 'Share';

  @override
  String get qrBtn => 'QR Code';

  @override
  String get qrModalTitle => 'Review QR Code';

  @override
  String get qrModalDesc =>
      'Scan with any phone camera to leave a review directly';

  @override
  String get qrDownloadBtn => 'Save QR';

  @override
  String get qrCloseBtn => 'Close';

  @override
  String get qrDownloaded => 'QR Code downloaded';

  @override
  String get lblReadTag => 'Read Card';

  @override
  String get lblWifiTag => 'Wi-Fi Card';

  @override
  String get lblPwdLockTag => 'PIN Lock / Unlock';

  @override
  String get lblEraseTag => 'Erase Card';

  @override
  String get lblPermLockTag => 'Permanent Lock';

  @override
  String get wifiModalTitle => 'Wi-Fi Card Setup';

  @override
  String get wifiStep1Title => 'Network Name';

  @override
  String get wifiStep1Desc => 'Enter Wi-Fi network name (SSID)';

  @override
  String get wifiStep2Title => 'Network Password';

  @override
  String get wifiStep2Desc =>
      'Enter password (or leave blank for open network)';

  @override
  String get wifiStep3Title => 'Security Type';

  @override
  String get wifiStep3Desc => 'Select network encryption standard';

  @override
  String get wifiSsidPlaceholder => 'Network Name (SSID)...';

  @override
  String get wifiPasswordPlaceholder => 'Enter password...';

  @override
  String get wifiEncWpa => 'WPA / WPA2 / WPA3';

  @override
  String get wifiEncWpaSub => 'Standard (Personal)';

  @override
  String get wifiEncWep => 'WEP';

  @override
  String get wifiEncWepSub => 'Legacy networks';

  @override
  String get wifiEncOpen => 'Open Network';

  @override
  String get wifiEncOpenSub => 'No password required';

  @override
  String get wifiNext => 'Next';

  @override
  String get wifiBack => 'Back';

  @override
  String get wifiWriteTag => 'Write Card';

  @override
  String get wifiQrBtn => 'QR Code';

  @override
  String get wifiQrModalTitle => 'Wi-Fi QR Code';

  @override
  String get wifiQrModalDesc => 'Scan with phone camera to connect directly';

  @override
  String get wifiQrDownloaded => 'Wi-Fi QR Code downloaded';

  @override
  String get toastEnterSsid => 'Please enter network name (SSID)';

  @override
  String get toastWifiPassMinLength => 'Password must be at least 8 characters';

  @override
  String get toastWifiWpaRequired =>
      'WPA networks require a password of at least 8 characters';

  @override
  String get nfcTitleWifiReady => 'Ready to Write Wi-Fi';

  @override
  String get nfcTitleWifiClone => 'Clone Wi-Fi Card';

  @override
  String get nfcTitleWifiCloneSuccess => 'Wi-Fi Card Cloned!';

  @override
  String get nfcDescWifiReady =>
      'Hold phone near NFC card to write Wi-Fi credentials.';

  @override
  String nfcDescWifiReadyWithSsid(String ssid) {
    return 'Hold phone near card to write \"$ssid\".';
  }

  @override
  String nfcDescWifiCloneWithSsid(String ssid) {
    return 'Hold another card near phone to copy \"$ssid\".';
  }

  @override
  String get nfcTitleWifiSuccess => 'Wi-Fi Card Programmed!';

  @override
  String get nfcDescWifiSuccess => 'Wi-Fi configuration written to card.';

  @override
  String get nfcBtnWifiAnother => 'Write Another';

  @override
  String get nfcBtnWifiCloneAnother => 'Clone Another';

  @override
  String get toastNfcWifiSuccess => 'Wi-Fi card written successfully!';

  @override
  String toastNfcWifiReadSuccess(String ssid) {
    return 'Wi-Fi network \"$ssid\" read successfully! Ready to write to a new card.';
  }

  @override
  String get nfcBtn => 'Write NFC Card';

  @override
  String get nfcBtnWriteAnother => 'Write Another';

  @override
  String get nfcTitleReady => 'Ready to Write';

  @override
  String get nfcDescReady => 'Hold phone near NFC card to write the link.';

  @override
  String get nfcTitleReadReady => 'Ready to Read Card';

  @override
  String get nfcDescReadReady => 'Hold phone near card to read its link.';

  @override
  String get nfcTitlePermLockReady => 'Ready to Lock';

  @override
  String get nfcDescPermLockReady =>
      'Hold phone near card to apply permanent read-only lock.';

  @override
  String get nfcTitlePwdLockReady => 'Ready to Lock';

  @override
  String get nfcDescPwdLockReady => 'Hold phone near card to set PIN...';

  @override
  String get nfcTitlePwdUnlockReady => 'Ready to Unlock';

  @override
  String get nfcDescPwdUnlockReady => 'Hold phone near card to unlock...';

  @override
  String get pwdModalTitle => 'Card Protection';

  @override
  String get pwdModalTitleLock => 'Lock Card';

  @override
  String get pwdModalTitleUnlock => 'Unlock Card';

  @override
  String get pwdModalDesc => 'Set a PIN to protect card';

  @override
  String get pwdModalDescLock => 'Set a PIN to protect card';

  @override
  String get pwdModalDescUnlock => 'Enter PIN to unlock card';

  @override
  String get pwdHintText => '4 digits recommended';

  @override
  String get pwdInfoToast => '4 digits recommended';

  @override
  String get pwdPlaceholder => 'Enter PIN...';

  @override
  String get pwdTabLock => 'Lock';

  @override
  String get pwdTabUnlock => 'Unlock';

  @override
  String get pwdSubmitLock => 'Lock Card';

  @override
  String get pwdSubmitUnlock => 'Unlock Card';

  @override
  String get pwdCancel => 'Cancel';

  @override
  String get toastEnterPwd => 'Please enter a PIN';

  @override
  String get permLockTitle => 'Permanent Lock';

  @override
  String get permLockDesc =>
      'Warning: Card will permanently become Read-Only. Cannot be edited or erased.';

  @override
  String get permLockConfirmBtn => 'Lock Permanently';

  @override
  String get permLockCancelBtn => 'Cancel';

  @override
  String get toastNfcReadSuccess => 'Link read and loaded successfully';

  @override
  String get toastNfcReadEmpty => 'No valid URL found on this card';

  @override
  String get toastNfcPermLockSuccess => 'Card permanently locked to Read-Only';

  @override
  String get toastNfcPwdLockSuccess => 'Card locked with PIN successfully';

  @override
  String get toastNfcPwdUnlockSuccess => 'Card unlocked successfully';

  @override
  String get toastNfcWrongPwd => 'Incorrect PIN or unlocking failed';

  @override
  String get toastNfcPwdUnsupported =>
      'PIN protection is not supported on this card';

  @override
  String get toastNfcAlreadyUnlocked => 'Card is not locked';

  @override
  String get toastNfcAlreadyLocked =>
      'Card is already locked with a PIN. Unlock it first to change PIN.';

  @override
  String get nfcTitleSuccess => 'Write Successful!';

  @override
  String get nfcDescSuccess => 'Card programmed successfully.';

  @override
  String get nfcTitleNext => 'Ready to Write';

  @override
  String get nfcDescNext => 'Hold another card near phone, or tap Done.';

  @override
  String nfcCardsCount(int count) {
    return 'Cards written: $count';
  }

  @override
  String get nfcCancel => 'Cancel';

  @override
  String get nfcDone => 'Done';

  @override
  String get nfcOk => 'OK';

  @override
  String get nfcBtnLockAnother => 'Lock Another';

  @override
  String get nfcBtnUnlockAnother => 'Unlock Another';

  @override
  String get nfcTitlePwdLockSuccess => 'Card Locked';

  @override
  String get nfcDescPwdLockSuccess => 'Card is now protected against edits.';

  @override
  String get nfcTitlePwdUnlockSuccess => 'Card Unlocked';

  @override
  String get nfcDescPwdUnlockSuccess => 'Card is ready for editing.';

  @override
  String get nfcTitleAlreadyUnlocked => 'Card Not Locked';

  @override
  String get nfcDescAlreadyUnlocked => 'This card is already unlocked.';

  @override
  String get nfcTitleTagLost => 'Connection Lost';

  @override
  String get nfcDescTagLost => 'Hold phone steady over card center.';

  @override
  String get nfcTitleLocked => 'Card Is Protected';

  @override
  String get nfcTitleReadLocked => 'Card is Read-Protected';

  @override
  String get nfcDescReadLocked => 'Card data is protected against reading.';

  @override
  String get nfcTitleWrongPwd => 'Incorrect PIN';

  @override
  String get nfcTitleAlreadyLocked => 'Card Already Locked';

  @override
  String get nfcTitleCapacity => 'Capacity Exceeded';

  @override
  String get nfcTitleEmptyTag => 'Empty Card';

  @override
  String get nfcTitlePermLockSuccess => 'Card Permanently Locked';

  @override
  String get nfcDescPermLockSuccess =>
      'Card has been permanently set to Read-Only.';

  @override
  String get nfcTitlePermLockStandby => 'Card Permanently Locked!';

  @override
  String get nfcDescPermLockStandby =>
      'Paused for safety. Tap icon to reactivate.';

  @override
  String nfcPermLockCount(int count) {
    return 'Locked: $count';
  }

  @override
  String nfcEraseCount(int count) {
    return 'Erased: $count';
  }

  @override
  String get nfcTitleCannotLock => 'Cannot Lock';

  @override
  String get nfcDescCannotLock => 'Card is already read-only or unsupported.';

  @override
  String get nfcBackToPin => 'Back';

  @override
  String get nfcTitleDisabled => 'NFC is Disabled';

  @override
  String get nfcTitleNoHardware => 'NFC Not Supported';

  @override
  String get nfcTitleOpFailed => 'Operation Failed';

  @override
  String get nfcDescOpFailed =>
      'Operation failed. Keep phone steady and retry.';

  @override
  String get nfcTitleError => 'Write Failed';

  @override
  String get nfcDescLocked =>
      'Card is password-protected or read-only. Unlock it first.';

  @override
  String get nfcDescCapacity => 'Data exceeds card memory capacity.';

  @override
  String get nfcDescUnsupported => 'This card type is not supported.';

  @override
  String get nfcDescGenericError =>
      'Write failed. Keep phone steady over card.';

  @override
  String get nfcRetryBtn => 'Try Again';

  @override
  String get nfcNoHardware => 'NFC is not supported on this device';

  @override
  String get nfcDisabled => 'Please enable NFC in your phone settings';

  @override
  String get nfcLocked => 'NFC card is locked or read-only';

  @override
  String get nfcCapacity => 'NFC card has insufficient memory';

  @override
  String get nfcUnsupported => 'Unsupported NFC tag type';

  @override
  String get nfcWriteFailed => 'Error writing to NFC tag. Try again.';

  @override
  String get toastPasteFirst => 'Please paste a link first';

  @override
  String get toastInvalid => 'Could not extract Place ID';

  @override
  String get toastNoInternet => 'No network connection';

  @override
  String get toastSuccess => 'Link converted successfully';

  @override
  String get toastNfcWritten => 'Successfully written to NFC card';

  @override
  String toastNfcBatchSuccess(int count) {
    return 'Successfully programmed $count NFC card(s)';
  }

  @override
  String get toastCleared => 'Text cleared';

  @override
  String get toastPasted => 'Pasted from clipboard';

  @override
  String get toastEmptyClip => 'Clipboard is empty';

  @override
  String get toastClipDenied => 'Press Ctrl+V to paste';

  @override
  String get toastCopied => 'Review link copied';

  @override
  String get toastShareCopied => 'Link copied for sharing';

  @override
  String get shareTitle => 'Google Review';

  @override
  String get shareText => 'Leave us a review on Google Maps';

  @override
  String get toastHourlyLimit =>
      'Hourly search limit reached to protect your quota';

  @override
  String get toastSelectSuccess => 'Link generated';

  @override
  String get updateAvailable => 'Update Available';

  @override
  String get updateReadyTitle => 'New Version Ready';

  @override
  String get updateCurrent => 'Current';

  @override
  String get updateNew => 'New';

  @override
  String updateSize(String size) {
    return 'Size: $size';
  }

  @override
  String updateDate(String date) {
    return 'Published: $date';
  }

  @override
  String get updateHighlights => 'What\'s New in this Release';

  @override
  String get updateInstallBtn => 'Install Update';

  @override
  String get updateViewGithub => 'Release Notes';

  @override
  String get updateLater => 'Later';

  @override
  String get toastCheckingUpdate => 'Checking for updates...';

  @override
  String toastUpToDate(String version) {
    return 'App is up to date ($version)';
  }

  @override
  String toastUpdateFound(String version) {
    return 'New version $version is available!';
  }

  @override
  String get toastUpdateError => 'Unable to check for updates right now';

  @override
  String get toastDownloadStarted => 'Downloading update in background...';

  @override
  String get toastQrSaveError => 'Failed to save QR image';

  @override
  String get eraseModalTitle => 'Erase Card';

  @override
  String get eraseModalDesc =>
      'All data will be erased and card restored to empty. Locks are unaffected.';

  @override
  String get eraseConfirmBtn => 'Erase Card';

  @override
  String get eraseCancelBtn => 'Cancel';

  @override
  String get nfcTitleEraseReady => 'Ready to Erase';

  @override
  String get nfcDescEraseReady => 'Hold phone near card to erase data...';

  @override
  String get nfcTitleEraseSuccess => 'Card Erased!';

  @override
  String get nfcDescEraseSuccess => 'Card is now empty and ready for use.';

  @override
  String get nfcBtnEraseAnother => 'Erase Another';

  @override
  String get toastNfcEraseSuccess => 'Card data erased successfully';

  @override
  String get githubProjectBtn => 'GitHub';

  @override
  String get githubSupportBtn => 'Support';

  @override
  String get toastSupportComingSoon => 'Support option will be available soon';

  @override
  String get settingsThemeLabel => 'Appearance';

  @override
  String get settingsThemeSub => 'Choose your preferred app theme';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeDark => 'Dark';

  @override
  String get settingsThemeLight => 'Light';
}
