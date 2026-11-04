// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for German (`de`).
class AppLocalizationsDe extends AppLocalizations {
  AppLocalizationsDe([String locale = 'de']) : super(locale);

  @override
  String get appTitle => 'Quick NFC';

  @override
  String get appSubtitle =>
      'Schnelles NFC-Tool für direkte Google Maps-Bewertungslinks';

  @override
  String get tabLink => 'Direktlink';

  @override
  String get tabSearch => 'Ort suchen';

  @override
  String get placeholder => 'Link hier einfügen...';

  @override
  String get trashTitle => 'Text löschen';

  @override
  String get pasteBtn => 'Einfügen';

  @override
  String get convertBtn => 'Link umwandeln';

  @override
  String get resolvingBtn => 'Wird aufgelöst...';

  @override
  String get searchPlaceholder => 'Name des Ortes & Stadt...';

  @override
  String get toastEnterQuery => 'Bitte zuerst einen Namen eingeben';

  @override
  String get fabGithubLabel => 'Projekt auf GitHub';

  @override
  String get resultLabel => 'Direktlink:';

  @override
  String get resultLabelReview => 'Direkter Bewertungslink:';

  @override
  String get resultLabelLocation => 'Standort auf Google Maps:';

  @override
  String get resultLabelCustom => 'Direktlink:';

  @override
  String get linkTypePrompt => 'Link-Typ zum Programmieren:';

  @override
  String get linkTypeReview => '5-Sterne-Bewertung';

  @override
  String get linkTypeLocation => 'Kartenstandort';

  @override
  String get toastSwitchedToReview => 'Auf Bewertungslink gewechselt';

  @override
  String get toastSwitchedToLocation => 'Auf Kartenstandort gewechselt';

  @override
  String get btnHelpGuideTitle => 'Bedienungsanleitung & Tour';

  @override
  String get btnGuideLabel => 'Hilfe';

  @override
  String get settingsTitle => 'Einstellungen';

  @override
  String get settingsGeneralSection => 'Allgemein';

  @override
  String get settingsLanguageLabel => 'Sprache';

  @override
  String get settingsLanguageSub => 'Wähle deine bevorzugte Sprache';

  @override
  String get settingsLangArabic => 'العربية (Arabic)';

  @override
  String get settingsLangEnglish => 'English';

  @override
  String get settingsAboutSection => 'Über die App';

  @override
  String get settingsVersionLabel => 'App-Version';

  @override
  String get settingsDeveloperLabel => 'Entwickler & Quellcode';

  @override
  String get settingsBackBtn => 'Zurück';

  @override
  String get obStep1Title => 'Smarte Links & 5-Sterne-Bewertungen';

  @override
  String get obStep1Desc =>
      'Füge einen Google Maps-Link ein, um ihn sofort in einen Bewertungs- oder Standortlink umzuwandeln.';

  @override
  String get obStep2Title => 'Direkte Unternehmenssuche';

  @override
  String get obStep2Desc =>
      'Gib Name & Stadt unter \'Ort suchen\' ein, um deinen Link mit einem Fingertipp zu erstellen.';

  @override
  String get obStep3Title => 'NFC-Tags, WLAN & Schutz';

  @override
  String get obStep3Desc =>
      'Schreibe Links & WLAN auf NFC-Karten und schütze sie per PIN oder Dauersperre.';

  @override
  String get obBtnNext => 'Weiter';

  @override
  String get obBtnStart => 'Starten';

  @override
  String get obBtnSkip => 'Überspringen';

  @override
  String get copyBtn => 'Kopieren';

  @override
  String get copySuccess => 'Kopiert!';

  @override
  String get openBtn => 'Öffnen';

  @override
  String get shareBtn => 'Teilen';

  @override
  String get qrBtn => 'QR-Code';

  @override
  String get qrModalTitle => 'Bewertungs-QR-Code';

  @override
  String get qrModalDesc =>
      'Mit der Handykamera scannen, um direkt zu bewerten';

  @override
  String get qrDownloadBtn => 'QR speichern';

  @override
  String get qrCloseBtn => 'Schließen';

  @override
  String get qrDownloaded => 'QR-Code gespeichert';

  @override
  String get lblReadTag => 'Karte lesen';

  @override
  String get lblWifiTag => 'WLAN-Karte';

  @override
  String get lblPwdLockTag => 'PIN-Sperre';

  @override
  String get lblEraseTag => 'Karte löschen';

  @override
  String get lblPermLockTag => 'Dauersperre';

  @override
  String get wifiModalTitle => 'WLAN-Karte einrichten';

  @override
  String get wifiStep1Title => 'Netzwerkname';

  @override
  String get wifiStep1Desc => 'WLAN-Namen (SSID) eingeben';

  @override
  String get wifiStep2Title => 'WLAN-Passwort';

  @override
  String get wifiStep2Desc => 'Passwort eingeben (oder leer für offenes Netz)';

  @override
  String get wifiStep3Title => 'Sicherheitstyp';

  @override
  String get wifiStep3Desc => 'Wähle den Verschlüsselungsstandard';

  @override
  String get wifiSsidPlaceholder => 'Netzwerkname (SSID)...';

  @override
  String get wifiPasswordPlaceholder => 'Passwort eingeben...';

  @override
  String get wifiEncWpa => 'WPA / WPA2 / WPA3';

  @override
  String get wifiEncWpaSub => 'Standard (Privat)';

  @override
  String get wifiEncWep => 'WEP';

  @override
  String get wifiEncWepSub => 'Ältere Netzwerke';

  @override
  String get wifiEncOpen => 'Offenes Netzwerk';

  @override
  String get wifiEncOpenSub => 'Kein Passwort erforderlich';

  @override
  String get wifiNext => 'Weiter';

  @override
  String get wifiBack => 'Zurück';

  @override
  String get wifiWriteTag => 'Karte beschreiben';

  @override
  String get wifiQrBtn => 'QR-Code';

  @override
  String get wifiQrModalTitle => 'WLAN-QR-Code';

  @override
  String get wifiQrModalDesc =>
      'Mit der Handykamera scannen, um direkt zu verbinden';

  @override
  String get wifiQrDownloaded => 'WLAN-QR-Code gespeichert';

  @override
  String get toastEnterSsid => 'Bitte Netzwerknamen (SSID) eingeben';

  @override
  String get toastWifiPassMinLength =>
      'Passwort muss mindestens 8 Zeichen lang sein';

  @override
  String get toastWifiWpaRequired =>
      'WPA erfordert ein Passwort mit mindestens 8 Zeichen';

  @override
  String get nfcTitleWifiReady => 'Bereit zum WLAN-Schreiben';

  @override
  String get nfcTitleWifiClone => 'WLAN-Karte duplizieren';

  @override
  String get nfcTitleWifiCloneSuccess => 'WLAN-Karte dupliziert!';

  @override
  String get nfcDescWifiReady =>
      'Halte das Smartphone an die NFC-Karte, um WLAN zu schreiben.';

  @override
  String nfcDescWifiReadyWithSsid(String ssid) {
    return 'Halte das Smartphone an die Karte, um \"$ssid\" zu schreiben.';
  }

  @override
  String nfcDescWifiCloneWithSsid(String ssid) {
    return 'Halte eine weitere Karte an das Telefon, um \"$ssid\" zu kopieren.';
  }

  @override
  String get nfcTitleWifiSuccess => 'WLAN-Karte programmiert!';

  @override
  String get nfcDescWifiSuccess =>
      'WLAN-Daten erfolgreich auf die Karte geschrieben.';

  @override
  String get nfcBtnWifiAnother => 'Weitere schreiben';

  @override
  String get nfcBtnWifiCloneAnother => 'Weitere klonen';

  @override
  String get toastNfcWifiSuccess => 'WLAN-Karte erfolgreich beschrieben!';

  @override
  String toastNfcWifiReadSuccess(String ssid) {
    return 'WLAN \"$ssid\" gelesen! Bereit zum Schreiben auf neue Karte.';
  }

  @override
  String get nfcBtn => 'NFC-Karte schreiben';

  @override
  String get nfcBtnWriteAnother => 'Weitere schreiben';

  @override
  String get nfcTitleReady => 'Bereit zum Schreiben';

  @override
  String get nfcDescReady =>
      'Halte das Smartphone an die NFC-Karte, um den Link zu schreiben.';

  @override
  String get nfcTitleReadReady => 'Bereit zum Lesen';

  @override
  String get nfcDescReadReady =>
      'Halte das Smartphone an die Karte, um den Link zu lesen.';

  @override
  String get nfcTitlePermLockReady => 'Bereit zur Sperre';

  @override
  String get nfcDescPermLockReady =>
      'Halte das Smartphone an die Karte für permanente Schreibsperre.';

  @override
  String get nfcTitlePwdLockReady => 'Bereit zum Sperren';

  @override
  String get nfcDescPwdLockReady =>
      'Halte das Smartphone an die Karte, um PIN zu setzen...';

  @override
  String get nfcTitlePwdUnlockReady => 'Bereit zum Entsperren';

  @override
  String get nfcDescPwdUnlockReady =>
      'Halte das Smartphone an die Karte zum Entsperren...';

  @override
  String get pwdModalTitle => 'Kartenschutz';

  @override
  String get pwdModalTitleLock => 'Karte sperren';

  @override
  String get pwdModalTitleUnlock => 'Karte entsperren';

  @override
  String get pwdModalDesc => 'PIN zum Schutz der Karte festlegen';

  @override
  String get pwdModalDescLock => 'PIN zum Schutz der Karte festlegen';

  @override
  String get pwdModalDescUnlock => 'PIN zum Entsperren eingeben';

  @override
  String get pwdHintText => '4 Ziffern empfohlen';

  @override
  String get pwdInfoToast => '4 Ziffern empfohlen';

  @override
  String get pwdPlaceholder => 'PIN eingeben...';

  @override
  String get pwdTabLock => 'Sperren';

  @override
  String get pwdTabUnlock => 'Entsperren';

  @override
  String get pwdSubmitLock => 'Karte sperren';

  @override
  String get pwdSubmitUnlock => 'Karte entsperren';

  @override
  String get pwdCancel => 'Abbrechen';

  @override
  String get toastEnterPwd => 'Bitte eine PIN eingeben';

  @override
  String get permLockTitle => 'Dauersperre';

  @override
  String get permLockDesc =>
      'Achtung: Karte wird dauerhaft schreibgeschützt. Kann nicht mehr geändert oder gelöscht werden.';

  @override
  String get permLockConfirmBtn => 'Dauerhaft sperren';

  @override
  String get permLockCancelBtn => 'Abbrechen';

  @override
  String get toastNfcReadSuccess => 'Link erfolgreich gelesen und geladen';

  @override
  String get toastNfcReadEmpty => 'Kein gültiger Link auf der Karte gefunden';

  @override
  String get toastNfcPermLockSuccess =>
      'Karte dauerhaft schreibgeschützt gesperrt';

  @override
  String get toastNfcPwdLockSuccess => 'Karte erfolgreich mit PIN geschützt';

  @override
  String get toastNfcPwdUnlockSuccess => 'Karte erfolgreich entsperrt';

  @override
  String get toastNfcWrongPwd => 'Falsche PIN oder Fehler beim Entsperren';

  @override
  String get toastNfcPwdUnsupported =>
      'PIN-Schutz wird von dieser Karte nicht unterstützt';

  @override
  String get toastNfcAlreadyUnlocked => 'Karte ist nicht gesperrt';

  @override
  String get toastNfcAlreadyLocked =>
      'Karte bereits mit PIN geschützt. Zuerst entsperren zum Ändern.';

  @override
  String get nfcTitleSuccess => 'Erfolgreich geschrieben!';

  @override
  String get nfcDescSuccess => 'Karte erfolgreich programmiert.';

  @override
  String get nfcTitleNext => 'Bereit zum Schreiben';

  @override
  String get nfcDescNext => 'Nächste Karte heranhalten oder Fertig tippen.';

  @override
  String nfcCardsCount(int count) {
    return 'Karten geschrieben: $count';
  }

  @override
  String get nfcCancel => 'Abbrechen';

  @override
  String get nfcDone => 'Fertig';

  @override
  String get nfcOk => 'OK';

  @override
  String get nfcBtnLockAnother => 'Weitere sperren';

  @override
  String get nfcBtnUnlockAnother => 'Weitere entsperren';

  @override
  String get nfcTitlePwdLockSuccess => 'Karte gesperrt';

  @override
  String get nfcDescPwdLockSuccess =>
      'Karte ist jetzt vor Änderungen geschützt.';

  @override
  String get nfcTitlePwdUnlockSuccess => 'Karte entsperrt';

  @override
  String get nfcDescPwdUnlockSuccess => 'Karte kann nun bearbeitet werden.';

  @override
  String get nfcTitleAlreadyUnlocked => 'Karte nicht gesperrt';

  @override
  String get nfcDescAlreadyUnlocked => 'Diese Karte ist bereits entsperrt.';

  @override
  String get nfcTitleTagLost => 'Verbindung verloren';

  @override
  String get nfcDescTagLost => 'Smartphone ruhig an die Kartenmitte halten.';

  @override
  String get nfcTitleLocked => 'Karte ist geschützt';

  @override
  String get nfcTitleReadLocked => 'Lesegeschützt';

  @override
  String get nfcDescReadLocked => 'Kartendaten sind vor dem Lesen geschützt.';

  @override
  String get nfcTitleWrongPwd => 'Falsche PIN';

  @override
  String get nfcTitleAlreadyLocked => 'Karte bereits gesperrt';

  @override
  String get nfcTitleCapacity => 'Speicher voll';

  @override
  String get nfcTitleEmptyTag => 'Leere Karte';

  @override
  String get nfcTitlePermLockSuccess => 'Karte dauerhaft gesperrt';

  @override
  String get nfcDescPermLockSuccess =>
      'Die Karte ist nun dauerhaft schreibgeschützt.';

  @override
  String get nfcTitlePermLockStandby => 'Karte dauerhaft gesperrt!';

  @override
  String get nfcDescPermLockStandby =>
      'Sicherheitspause. Tippe auf das Symbol zum Reaktivieren.';

  @override
  String nfcPermLockCount(int count) {
    return 'Gesperrt: $count';
  }

  @override
  String nfcEraseCount(int count) {
    return 'Gelöscht: $count';
  }

  @override
  String get nfcTitleCannotLock => 'Sperren nicht möglich';

  @override
  String get nfcDescCannotLock =>
      'Karte ist bereits schreibgeschützt oder inkompatibel.';

  @override
  String get nfcBackToPin => 'Zurück';

  @override
  String get nfcTitleDisabled => 'NFC deaktiviert';

  @override
  String get nfcTitleNoHardware => 'NFC nicht unterstützt';

  @override
  String get nfcTitleOpFailed => 'Vorgang fehlgeschlagen';

  @override
  String get nfcDescOpFailed =>
      'Fehlgeschlagen. Smartphone ruhig halten und erneut versuchen.';

  @override
  String get nfcTitleError => 'Schreibfehler';

  @override
  String get nfcDescLocked =>
      'Karte ist geschützt oder schreibgeschützt. Zuerst entsperren.';

  @override
  String get nfcDescCapacity => 'Daten übersteigen den Kartenspeicher.';

  @override
  String get nfcDescUnsupported => 'Dieser Kartentyp wird nicht unterstützt.';

  @override
  String get nfcDescGenericError =>
      'Schreiben fehlgeschlagen. Smartphone ruhig an die Karte halten.';

  @override
  String get nfcRetryBtn => 'Erneut versuchen';

  @override
  String get nfcNoHardware => 'NFC wird auf diesem Gerät nicht unterstützt';

  @override
  String get nfcDisabled => 'Bitte NFC in den Telefoneinstellungen aktivieren';

  @override
  String get nfcLocked => 'NFC-Karte ist gesperrt oder schreibgeschützt';

  @override
  String get nfcCapacity => 'NFC-Karte hat nicht genügend Speicher';

  @override
  String get nfcUnsupported => 'Nicht unterstützter NFC-Tag-Typ';

  @override
  String get nfcWriteFailed =>
      'Fehler beim Schreiben auf NFC-Tag. Bitte wiederholen.';

  @override
  String get toastPasteFirst => 'Bitte zuerst einen Link einfügen';

  @override
  String get toastInvalid => 'Place ID konnte nicht ermittelt werden';

  @override
  String get toastNoInternet => 'Keine Internetverbindung';

  @override
  String get toastSuccess => 'Link erfolgreich umgewandelt';

  @override
  String get toastNfcWritten => 'Erfolgreich auf NFC-Karte geschrieben';

  @override
  String toastNfcBatchSuccess(int count) {
    return '$count NFC-Karte(n) erfolgreich programmiert';
  }

  @override
  String get toastCleared => 'Text gelöscht';

  @override
  String get toastPasted => 'Aus Zwischenablage eingefügt';

  @override
  String get toastEmptyClip => 'Zwischenablage ist leer';

  @override
  String get toastClipDenied => 'Drücke Strg+V zum Einfügen';

  @override
  String get toastCopied => 'Bewertungslink kopiert';

  @override
  String get toastShareCopied => 'Link zum Teilen kopiert';

  @override
  String get shareTitle => 'Google-Bewertung';

  @override
  String get shareText => 'Hinterlasse uns eine Bewertung auf Google Maps';

  @override
  String get toastHourlyLimit => 'Stündliches Suchlimit erreicht';

  @override
  String get toastSelectSuccess => 'Link erstellt';

  @override
  String get updateAvailable => 'Update verfügbar';

  @override
  String get updateReadyTitle => 'Neue Version bereit';

  @override
  String get updateCurrent => 'Aktuell';

  @override
  String get updateNew => 'Neu';

  @override
  String updateSize(String size) {
    return 'Größe: $size';
  }

  @override
  String updateDate(String date) {
    return 'Datum: $date';
  }

  @override
  String get updateHighlights => 'Neuerungen dieser Version';

  @override
  String get updateInstallBtn => 'Update installieren';

  @override
  String get updateViewGithub => 'Versionshinweise';

  @override
  String get updateLater => 'Später';

  @override
  String get toastCheckingUpdate => 'Nach Updates suchen...';

  @override
  String toastUpToDate(String version) {
    return 'App ist aktuell ($version)';
  }

  @override
  String toastUpdateFound(String version) {
    return 'Neue Version $version verfügbar!';
  }

  @override
  String get toastUpdateError => 'Updates konnten nicht geprüft werden';

  @override
  String get toastDownloadStarted => 'Update lädt im Hintergrund...';

  @override
  String get toastQrSaveError => 'Fehler beim Speichern des QR-Codes';

  @override
  String get eraseModalTitle => 'Karte löschen';

  @override
  String get eraseModalDesc =>
      'Alle Daten werden gelöscht und die Karte geleert. Sperren bleiben unberührt.';

  @override
  String get eraseConfirmBtn => 'Karte löschen';

  @override
  String get eraseCancelBtn => 'Abbrechen';

  @override
  String get nfcTitleEraseReady => 'Bereit zum Löschen';

  @override
  String get nfcDescEraseReady =>
      'Halte das Smartphone an die Karte, um Daten zu löschen...';

  @override
  String get nfcTitleEraseSuccess => 'Karte gelöscht!';

  @override
  String get nfcDescEraseSuccess =>
      'Die Karte ist jetzt leer und einsatzbereit.';

  @override
  String get nfcBtnEraseAnother => 'Weitere löschen';

  @override
  String get toastNfcEraseSuccess => 'Kartendaten erfolgreich gelöscht';

  @override
  String get githubProjectBtn => 'GitHub';

  @override
  String get githubSupportBtn => 'Support';

  @override
  String get toastSupportComingSoon =>
      'Support-Option wird bald verfügbar sein';

  @override
  String get settingsThemeLabel => 'Erscheinungsbild';

  @override
  String get settingsThemeSub => 'Wähle dein bevorzugtes App-Design';

  @override
  String get settingsThemeSystem => 'System';

  @override
  String get settingsThemeDark => 'Dunkel';

  @override
  String get settingsThemeLight => 'Hell';
}
