// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appTitle => 'Quick NFC';

  @override
  String get appSubtitle =>
      'Outil NFC rapide pour convertir des liens d\'avis Google Maps';

  @override
  String get tabLink => 'Lien direct';

  @override
  String get tabSearch => 'Rechercher';

  @override
  String get placeholder => 'Coller le lien ici...';

  @override
  String get trashTitle => 'Effacer';

  @override
  String get pasteBtn => 'Coller';

  @override
  String get convertBtn => 'Convertir';

  @override
  String get resolvingBtn => 'Traitement...';

  @override
  String get searchPlaceholder => 'Nom du lieu et ville...';

  @override
  String get toastEnterQuery => 'Entrez d\'abord un nom de lieu';

  @override
  String get fabGithubLabel => 'Projet sur GitHub';

  @override
  String get resultLabel => 'Lien direct :';

  @override
  String get resultLabelReview => 'Lien d\'avis direct :';

  @override
  String get resultLabelLocation => 'Position sur Google Maps :';

  @override
  String get resultLabelCustom => 'Lien direct :';

  @override
  String get linkTypePrompt => 'Type de lien à programmer :';

  @override
  String get linkTypeReview => 'Avis 5 étoiles';

  @override
  String get linkTypeLocation => 'Emplacement sur la carte';

  @override
  String get toastSwitchedToReview => 'Passé au lien d\'avis direct';

  @override
  String get toastSwitchedToLocation => 'Passé à l\'emplacement sur la carte';

  @override
  String get btnHelpGuideTitle => 'Guide d\'utilisation et visite';

  @override
  String get btnGuideLabel => 'Guide';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsGeneralSection => 'Général';

  @override
  String get settingsLanguageLabel => 'Langue';

  @override
  String get settingsLanguageSub => 'Choisissez votre langue';

  @override
  String get settingsLangArabic => 'العربية (Arabic)';

  @override
  String get settingsLangEnglish => 'English';

  @override
  String get settingsAboutSection => 'À propos';

  @override
  String get settingsVersionLabel => 'Version de l\'application';

  @override
  String get settingsDeveloperLabel => 'Développeur et dépôt';

  @override
  String get settingsBackBtn => 'Retour';

  @override
  String get obStep1Title => 'Liens intelligents & avis 5★';

  @override
  String get obStep1Desc =>
      'Collez un lien Google Maps pour le convertir instantanément en avis 5 étoiles ou localisation.';

  @override
  String get obStep2Title => 'Recherche directe d\'établissement';

  @override
  String get obStep2Desc =>
      'Saisissez le nom et la ville dans l\'onglet \'Rechercher\' pour générer votre lien en un clic.';

  @override
  String get obStep3Title => 'Badges NFC, Wi-Fi et protection';

  @override
  String get obStep3Desc =>
      'Écrivez liens et Wi-Fi sur cartes NFC et protégez-les par PIN ou verrouillage définitif.';

  @override
  String get obBtnNext => 'Suivant';

  @override
  String get obBtnStart => 'Commencer';

  @override
  String get obBtnSkip => 'Passer';

  @override
  String get copyBtn => 'Copier';

  @override
  String get copySuccess => 'Copié !';

  @override
  String get openBtn => 'Ouvrir';

  @override
  String get shareBtn => 'Partager';

  @override
  String get qrBtn => 'Code QR';

  @override
  String get qrModalTitle => 'Code QR d\'avis';

  @override
  String get qrModalDesc =>
      'Scannez avec l\'appareil photo pour laisser un avis direct';

  @override
  String get qrDownloadBtn => 'Enregistrer';

  @override
  String get qrCloseBtn => 'Fermer';

  @override
  String get qrDownloaded => 'Code QR enregistré';

  @override
  String get lblReadTag => 'Lire la carte';

  @override
  String get lblWifiTag => 'Carte Wi-Fi';

  @override
  String get lblPwdLockTag => 'Verrouillage PIN';

  @override
  String get lblEraseTag => 'Effacer la carte';

  @override
  String get lblPermLockTag => 'Verrouillage définitif';

  @override
  String get wifiModalTitle => 'Configuration carte Wi-Fi';

  @override
  String get wifiStep1Title => 'Nom du réseau';

  @override
  String get wifiStep1Desc => 'Entrez le nom du réseau (SSID)';

  @override
  String get wifiStep2Title => 'Mot de passe';

  @override
  String get wifiStep2Desc => 'Entrez le mot de passe (ou vide si ouvert)';

  @override
  String get wifiStep3Title => 'Sécurité';

  @override
  String get wifiStep3Desc => 'Sélectionnez le protocole de chiffrement';

  @override
  String get wifiSsidPlaceholder => 'Nom du réseau (SSID)...';

  @override
  String get wifiPasswordPlaceholder => 'Entrez le mot de passe...';

  @override
  String get wifiEncWpa => 'WPA / WPA2 / WPA3';

  @override
  String get wifiEncWpaSub => 'Standard (Personnel)';

  @override
  String get wifiEncWep => 'WEP';

  @override
  String get wifiEncWepSub => 'Anciens réseaux';

  @override
  String get wifiEncOpen => 'Réseau ouvert';

  @override
  String get wifiEncOpenSub => 'Sans mot de passe';

  @override
  String get wifiNext => 'Suivant';

  @override
  String get wifiBack => 'Retour';

  @override
  String get wifiWriteTag => 'Écrire la carte';

  @override
  String get wifiQrBtn => 'Code QR';

  @override
  String get wifiQrModalTitle => 'Code QR Wi-Fi';

  @override
  String get wifiQrModalDesc =>
      'Scannez avec l\'appareil photo pour vous connecter';

  @override
  String get wifiQrDownloaded => 'Code QR Wi-Fi enregistré';

  @override
  String get toastEnterSsid => 'Veuillez entrer le nom du réseau (SSID)';

  @override
  String get toastWifiPassMinLength =>
      'Le mot de passe doit comporter au moins 8 caractères';

  @override
  String get toastWifiWpaRequired =>
      'Les réseaux WPA exigent un mot de passe d\'au moins 8 caractères';

  @override
  String get nfcTitleWifiReady => 'Prêt à écrire le Wi-Fi';

  @override
  String get nfcTitleWifiClone => 'Cloner la carte Wi-Fi';

  @override
  String get nfcTitleWifiCloneSuccess => 'Carte Wi-Fi clonée !';

  @override
  String get nfcDescWifiReady =>
      'Approchez le téléphone du badge NFC pour écrire le Wi-Fi.';

  @override
  String nfcDescWifiReadyWithSsid(String ssid) {
    return 'Approchez le téléphone de la carte pour écrire \"$ssid\".';
  }

  @override
  String nfcDescWifiCloneWithSsid(String ssid) {
    return 'Approchez une autre carte pour copier \"$ssid\".';
  }

  @override
  String get nfcTitleWifiSuccess => 'Carte Wi-Fi programmée !';

  @override
  String get nfcDescWifiSuccess =>
      'Configuration Wi-Fi enregistrée sur la carte.';

  @override
  String get nfcBtnWifiAnother => 'Écrire une autre';

  @override
  String get nfcBtnWifiCloneAnother => 'Cloner une autre';

  @override
  String get toastNfcWifiSuccess => 'Carte Wi-Fi enregistrée avec succès !';

  @override
  String toastNfcWifiReadSuccess(String ssid) {
    return 'Réseau Wi-Fi \"$ssid\" lu ! Prêt à être écrit sur une nouvelle carte.';
  }

  @override
  String get nfcBtn => 'Écrire la carte NFC';

  @override
  String get nfcBtnWriteAnother => 'Écrire une autre';

  @override
  String get nfcTitleReady => 'Prêt à écrire';

  @override
  String get nfcDescReady =>
      'Approchez le téléphone de la carte NFC pour écrire le lien.';

  @override
  String get nfcTitleReadReady => 'Prêt à lire la carte';

  @override
  String get nfcDescReadReady =>
      'Approchez le téléphone de la carte pour lire le lien.';

  @override
  String get nfcTitlePermLockReady => 'Prêt à verrouiller';

  @override
  String get nfcDescPermLockReady =>
      'Approchez le téléphone pour appliquer le verrouillage définitif.';

  @override
  String get nfcTitlePwdLockReady => 'Prêt à verrouiller';

  @override
  String get nfcDescPwdLockReady =>
      'Approchez le téléphone pour définir le code PIN...';

  @override
  String get nfcTitlePwdUnlockReady => 'Prêt à déverrouiller';

  @override
  String get nfcDescPwdUnlockReady =>
      'Approchez le téléphone pour déverrouiller la carte...';

  @override
  String get pwdModalTitle => 'Protection de la carte';

  @override
  String get pwdModalTitleLock => 'Verrouiller la carte';

  @override
  String get pwdModalTitleUnlock => 'Déverrouiller la carte';

  @override
  String get pwdModalDesc => 'Définissez un code PIN de protection';

  @override
  String get pwdModalDescLock => 'Définissez un code PIN de protection';

  @override
  String get pwdModalDescUnlock => 'Entrez le code PIN pour déverrouiller';

  @override
  String get pwdHintText => '4 chiffres recommandés';

  @override
  String get pwdInfoToast => '4 chiffres recommandés';

  @override
  String get pwdPlaceholder => 'Entrez le code PIN...';

  @override
  String get pwdTabLock => 'Verrouiller';

  @override
  String get pwdTabUnlock => 'Déverrouiller';

  @override
  String get pwdSubmitLock => 'Verrouiller la carte';

  @override
  String get pwdSubmitUnlock => 'Déverrouiller la carte';

  @override
  String get pwdCancel => 'Annuler';

  @override
  String get toastEnterPwd => 'Veuillez entrer un code PIN';

  @override
  String get permLockTitle => 'Verrouillage définitif';

  @override
  String get permLockDesc =>
      'Attention : La carte deviendra définitivement en lecture seule. Non modifiable ni effaçable.';

  @override
  String get permLockConfirmBtn => 'Verrouiller pour toujours';

  @override
  String get permLockCancelBtn => 'Annuler';

  @override
  String get toastNfcReadSuccess => 'Lien lu et chargé avec succès';

  @override
  String get toastNfcReadEmpty => 'Aucun lien valide sur cette carte';

  @override
  String get toastNfcPermLockSuccess =>
      'Carte définitivement verrouillée en lecture seule';

  @override
  String get toastNfcPwdLockSuccess =>
      'Carte verrouillée par code PIN avec succès';

  @override
  String get toastNfcPwdUnlockSuccess => 'Carte déverrouillée avec succès';

  @override
  String get toastNfcWrongPwd => 'Code PIN incorrect ou échec';

  @override
  String get toastNfcPwdUnsupported =>
      'La protection par PIN n\'est pas supportée';

  @override
  String get toastNfcAlreadyUnlocked => 'La carte n\'est pas verrouillée';

  @override
  String get toastNfcAlreadyLocked =>
      'Carte déjà verrouillée par PIN. Déverrouillez-la d\'abord pour changer le PIN.';

  @override
  String get nfcTitleSuccess => 'Écriture réussie !';

  @override
  String get nfcDescSuccess => 'Carte programmée avec succès.';

  @override
  String get nfcTitleNext => 'Prêt à écrire';

  @override
  String get nfcDescNext => 'Approchez une autre carte ou appuyez sur Terminé.';

  @override
  String nfcCardsCount(int count) {
    return 'Cartes écrites : $count';
  }

  @override
  String get nfcCancel => 'Annuler';

  @override
  String get nfcDone => 'Terminé';

  @override
  String get nfcOk => 'OK';

  @override
  String get nfcBtnLockAnother => 'Verrouiller une autre';

  @override
  String get nfcBtnUnlockAnother => 'Déverrouiller une autre';

  @override
  String get nfcTitlePwdLockSuccess => 'Carte verrouillée';

  @override
  String get nfcDescPwdLockSuccess =>
      'La carte est protégée contre les modifications.';

  @override
  String get nfcTitlePwdUnlockSuccess => 'Carte déverrouillée';

  @override
  String get nfcDescPwdUnlockSuccess => 'La carte est prête à être modifiée.';

  @override
  String get nfcTitleAlreadyUnlocked => 'Carte non verrouillée';

  @override
  String get nfcDescAlreadyUnlocked => 'Cette carte est déjà déverrouillée.';

  @override
  String get nfcTitleTagLost => 'Connexion perdue';

  @override
  String get nfcDescTagLost => 'Maintenez le téléphone immobile sur la carte.';

  @override
  String get nfcTitleLocked => 'Carte protégée';

  @override
  String get nfcTitleReadLocked => 'Lecture protégée';

  @override
  String get nfcDescReadLocked =>
      'Les données sont protégées contre la lecture.';

  @override
  String get nfcTitleWrongPwd => 'Code PIN incorrect';

  @override
  String get nfcTitleAlreadyLocked => 'Carte déjà verrouillée';

  @override
  String get nfcTitleCapacity => 'Mémoire saturée';

  @override
  String get nfcTitleEmptyTag => 'Carte vide';

  @override
  String get nfcTitlePermLockSuccess => 'Carte définitivement verrouillée';

  @override
  String get nfcDescPermLockSuccess =>
      'La carte a été définitivement verrouillée en lecture seule.';

  @override
  String get nfcTitlePermLockStandby => 'Carte définitivement verrouillée !';

  @override
  String get nfcDescPermLockStandby =>
      'Pause de sécurité. Touchez l\'icône pour réactiver.';

  @override
  String nfcPermLockCount(int count) {
    return 'Verrouillées : $count';
  }

  @override
  String nfcEraseCount(int count) {
    return 'Effacées : $count';
  }

  @override
  String get nfcTitleCannotLock => 'Verrouillage impossible';

  @override
  String get nfcDescCannotLock =>
      'La carte est déjà en lecture seule ou incompatible.';

  @override
  String get nfcBackToPin => 'Retour';

  @override
  String get nfcTitleDisabled => 'NFC désactivé';

  @override
  String get nfcTitleNoHardware => 'NFC non supporté';

  @override
  String get nfcTitleOpFailed => 'Échec de l\'opération';

  @override
  String get nfcDescOpFailed =>
      'Opération échouée. Maintenez le téléphone immobile et réessayez.';

  @override
  String get nfcTitleError => 'Échec de l\'écriture';

  @override
  String get nfcDescLocked =>
      'Carte protégée ou en lecture seule. Déverrouillez-la d\'abord.';

  @override
  String get nfcDescCapacity =>
      'Les données dépassent la capacité de la carte.';

  @override
  String get nfcDescUnsupported => 'Ce type de carte n\'est pas supporté.';

  @override
  String get nfcDescGenericError =>
      'Échec de l\'écriture. Maintenez le téléphone immobile sur la carte.';

  @override
  String get nfcRetryBtn => 'Réessayer';

  @override
  String get nfcNoHardware => 'NFC non disponible sur cet appareil';

  @override
  String get nfcDisabled => 'Activez le NFC dans les paramètres du téléphone';

  @override
  String get nfcLocked => 'La carte NFC est verrouillée ou en lecture seule';

  @override
  String get nfcCapacity => 'Mémoire insuffisante sur la carte NFC';

  @override
  String get nfcUnsupported => 'Type de badge NFC non supporté';

  @override
  String get nfcWriteFailed =>
      'Erreur d\'écriture sur le badge NFC. Réessayez.';

  @override
  String get toastPasteFirst => 'Veuillez d\'abord coller un lien';

  @override
  String get toastInvalid => 'Impossible d\'extraire l\'ID du lieu';

  @override
  String get toastNoInternet => 'Pas de connexion internet';

  @override
  String get toastSuccess => 'Lien converti avec succès';

  @override
  String get toastNfcWritten => 'Écrit sur la carte NFC avec succès';

  @override
  String toastNfcBatchSuccess(int count) {
    return '$count carte(s) NFC programmée(s) avec succès';
  }

  @override
  String get toastCleared => 'Texte effacé';

  @override
  String get toastPasted => 'Collé depuis le presse-papiers';

  @override
  String get toastEmptyClip => 'Le presse-papiers est vide';

  @override
  String get toastClipDenied => 'Appuyez sur Ctrl+V pour coller';

  @override
  String get toastCopied => 'Lien d\'avis copié';

  @override
  String get toastShareCopied => 'Lien copié pour le partage';

  @override
  String get shareTitle => 'Avis Google';

  @override
  String get shareText => 'Laissez-nous un avis sur Google Maps';

  @override
  String get toastHourlyLimit => 'Limite horaire de recherche atteinte';

  @override
  String get toastSelectSuccess => 'Lien généré';

  @override
  String get updateAvailable => 'Mise à jour disponible';

  @override
  String get updateReadyTitle => 'Nouvelle version prête';

  @override
  String get updateCurrent => 'Actuelle';

  @override
  String get updateNew => 'Nouvelle';

  @override
  String updateSize(String size) {
    return 'Taille : $size';
  }

  @override
  String updateDate(String date) {
    return 'Date : $date';
  }

  @override
  String get updateHighlights => 'Nouveautés de cette version';

  @override
  String get updateInstallBtn => 'Installer la mise à jour';

  @override
  String get updateViewGithub => 'Notes de version';

  @override
  String get updateLater => 'Plus tard';

  @override
  String get toastCheckingUpdate => 'Recherche de mises à jour...';

  @override
  String toastUpToDate(String version) {
    return 'L\'application est à jour ($version)';
  }

  @override
  String toastUpdateFound(String version) {
    return 'Nouvelle version $version disponible !';
  }

  @override
  String get toastUpdateError => 'Impossible de vérifier les mises à jour';

  @override
  String get toastDownloadStarted => 'Téléchargement en arrière-plan...';

  @override
  String get toastQrSaveError => 'Échec de l\'enregistrement du QR';

  @override
  String get eraseModalTitle => 'Effacer la carte';

  @override
  String get eraseModalDesc =>
      'Toutes les données seront effacées. Les verrouillages ne sont pas affectés.';

  @override
  String get eraseConfirmBtn => 'Effacer la carte';

  @override
  String get eraseCancelBtn => 'Annuler';

  @override
  String get nfcTitleEraseReady => 'Prêt à effacer';

  @override
  String get nfcDescEraseReady =>
      'Approchez le téléphone pour effacer les données...';

  @override
  String get nfcTitleEraseSuccess => 'Carte effacée !';

  @override
  String get nfcDescEraseSuccess => 'La carte est vide et prête à l\'emploi.';

  @override
  String get nfcBtnEraseAnother => 'Effacer une autre';

  @override
  String get toastNfcEraseSuccess => 'Données de la carte effacées avec succès';

  @override
  String get githubProjectBtn => 'GitHub';

  @override
  String get githubSupportBtn => 'Support';

  @override
  String get toastSupportComingSoon =>
      'L\'option de support sera bientôt disponible';

  @override
  String get settingsThemeLabel => 'Apparence';

  @override
  String get settingsThemeSub => 'Choisissez votre thème préféré';

  @override
  String get settingsThemeSystem => 'Système';

  @override
  String get settingsThemeDark => 'Sombre';

  @override
  String get settingsThemeLight => 'Clair';
}
