// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get appTitle => 'Quick NFC';

  @override
  String get appSubtitle =>
      'Herramienta NFC rápida para crear enlaces de reseñas de Google Maps';

  @override
  String get tabLink => 'Enlace directo';

  @override
  String get tabSearch => 'Buscar negocio';

  @override
  String get placeholder => 'Pega el enlace aquí...';

  @override
  String get trashTitle => 'Borrar texto';

  @override
  String get pasteBtn => 'Pegar';

  @override
  String get convertBtn => 'Convertir enlace';

  @override
  String get resolvingBtn => 'Procesando...';

  @override
  String get searchPlaceholder => 'Nombre del lugar y ciudad...';

  @override
  String get toastEnterQuery => 'Introduce el nombre del lugar';

  @override
  String get fabGithubLabel => 'Proyecto en GitHub';

  @override
  String get resultLabel => 'Enlace directo:';

  @override
  String get resultLabelReview => 'Enlace directo de reseña:';

  @override
  String get resultLabelLocation => 'Ubicación en Google Maps:';

  @override
  String get resultLabelCustom => 'Enlace directo:';

  @override
  String get linkTypePrompt => 'Tipo de enlace a programar:';

  @override
  String get linkTypeReview => 'Reseña de 5 estrellas';

  @override
  String get linkTypeLocation => 'Ubicación en mapa';

  @override
  String get toastSwitchedToReview => 'Cambiado a enlace de reseña directa';

  @override
  String get toastSwitchedToLocation => 'Cambiado a ubicación en el mapa';

  @override
  String get btnHelpGuideTitle => 'Guía de uso y funciones';

  @override
  String get btnGuideLabel => 'Guía';

  @override
  String get settingsTitle => 'Ajustes';

  @override
  String get settingsGeneralSection => 'Preferencias';

  @override
  String get settingsLanguageLabel => 'Idioma';

  @override
  String get settingsLanguageSub => 'Elige tu idioma preferido';

  @override
  String get settingsLangArabic => 'العربية (Arabic)';

  @override
  String get settingsLangEnglish => 'English';

  @override
  String get settingsAboutSection => 'Acerca de';

  @override
  String get settingsVersionLabel => 'Versión de la app';

  @override
  String get settingsDeveloperLabel => 'Desarrollo y repositorio';

  @override
  String get settingsBackBtn => 'Volver';

  @override
  String get obStep1Title => 'Enlaces inteligentes y reseñas 5★';

  @override
  String get obStep1Desc =>
      'Pega un enlace de Google Maps para convertirlo al instante en enlace de reseña o ubicación.';

  @override
  String get obStep2Title => 'Búsqueda directa de negocios';

  @override
  String get obStep2Desc =>
      'Escribe el nombre y ciudad en \'Buscar negocio\' para generar el enlace con un solo toque.';

  @override
  String get obStep3Title => 'Tarjetas NFC, Wi-Fi y protección';

  @override
  String get obStep3Desc =>
      'Escribe enlaces y Wi-Fi en tarjetas NFC y protégelas con PIN o bloqueo permanente.';

  @override
  String get obBtnNext => 'Siguiente';

  @override
  String get obBtnStart => 'Empezar';

  @override
  String get obBtnSkip => 'Omitir';

  @override
  String get copyBtn => 'Copiar';

  @override
  String get copySuccess => '¡Copiado!';

  @override
  String get openBtn => 'Abrir';

  @override
  String get shareBtn => 'Compartir';

  @override
  String get qrBtn => 'Código QR';

  @override
  String get qrModalTitle => 'Código QR de reseña';

  @override
  String get qrModalDesc =>
      'Escanea con la cámara para escribir una reseña directamente';

  @override
  String get qrDownloadBtn => 'Guardar QR';

  @override
  String get qrCloseBtn => 'Cerrar';

  @override
  String get qrDownloaded => 'Código QR guardado';

  @override
  String get lblReadTag => 'Leer tarjeta';

  @override
  String get lblWifiTag => 'Tarjeta Wi-Fi';

  @override
  String get lblPwdLockTag => 'Bloqueo PIN';

  @override
  String get lblEraseTag => 'Borrar tarjeta';

  @override
  String get lblPermLockTag => 'Bloqueo permanente';

  @override
  String get wifiModalTitle => 'Configurar tarjeta Wi-Fi';

  @override
  String get wifiStep1Title => 'Nombre de red';

  @override
  String get wifiStep1Desc => 'Introduce el nombre de red (SSID)';

  @override
  String get wifiStep2Title => 'Contraseña';

  @override
  String get wifiStep2Desc =>
      'Introduce la contraseña (o en blanco si es abierta)';

  @override
  String get wifiStep3Title => 'Tipo de seguridad';

  @override
  String get wifiStep3Desc => 'Selecciona el tipo de cifrado';

  @override
  String get wifiSsidPlaceholder => 'Nombre de red (SSID)...';

  @override
  String get wifiPasswordPlaceholder => 'Introduce la contraseña...';

  @override
  String get wifiEncWpa => 'WPA / WPA2 / WPA3';

  @override
  String get wifiEncWpaSub => 'Estándar (Personal)';

  @override
  String get wifiEncWep => 'WEP';

  @override
  String get wifiEncWepSub => 'Redes antiguas';

  @override
  String get wifiEncOpen => 'Red abierta';

  @override
  String get wifiEncOpenSub => 'Sin contraseña';

  @override
  String get wifiNext => 'Siguiente';

  @override
  String get wifiBack => 'Atrás';

  @override
  String get wifiWriteTag => 'Escribir tarjeta';

  @override
  String get wifiQrBtn => 'Código QR';

  @override
  String get wifiQrModalTitle => 'Código QR de Wi-Fi';

  @override
  String get wifiQrModalDesc =>
      'Escanea con la cámara para conectarte directamente';

  @override
  String get wifiQrDownloaded => 'Código QR de Wi-Fi guardado';

  @override
  String get toastEnterSsid => 'Introduce el nombre de red (SSID)';

  @override
  String get toastWifiPassMinLength =>
      'La contraseña debe tener al menos 8 caracteres';

  @override
  String get toastWifiWpaRequired =>
      'Las redes WPA requieren al menos 8 caracteres';

  @override
  String get nfcTitleWifiReady => 'Listo para escribir Wi-Fi';

  @override
  String get nfcTitleWifiClone => 'Clonar tarjeta Wi-Fi';

  @override
  String get nfcTitleWifiCloneSuccess => '¡Tarjeta Wi-Fi clonada!';

  @override
  String get nfcDescWifiReady =>
      'Acerca el móvil a la tarjeta NFC para escribir el Wi-Fi.';

  @override
  String nfcDescWifiReadyWithSsid(String ssid) {
    return 'Acerca el móvil a la tarjeta para escribir \"$ssid\".';
  }

  @override
  String nfcDescWifiCloneWithSsid(String ssid) {
    return 'Acerca otra tarjeta al móvil para copiar \"$ssid\".';
  }

  @override
  String get nfcTitleWifiSuccess => '¡Tarjeta Wi-Fi programada!';

  @override
  String get nfcDescWifiSuccess =>
      'Configuración Wi-Fi guardada en la tarjeta.';

  @override
  String get nfcBtnWifiAnother => 'Escribir otra';

  @override
  String get nfcBtnWifiCloneAnother => 'Clonar otra';

  @override
  String get toastNfcWifiSuccess => '¡Tarjeta Wi-Fi escrita con éxito!';

  @override
  String toastNfcWifiReadSuccess(String ssid) {
    return '¡Red Wi-Fi \"$ssid\" leída! Lista para escribir en una nueva tarjeta.';
  }

  @override
  String get nfcBtn => 'Escribir tarjeta NFC';

  @override
  String get nfcBtnWriteAnother => 'Escribir otra';

  @override
  String get nfcTitleReady => 'Listo para escribir';

  @override
  String get nfcDescReady =>
      'Acerca el móvil a la tarjeta NFC para escribir el enlace.';

  @override
  String get nfcTitleReadReady => 'Listo para leer tarjeta';

  @override
  String get nfcDescReadReady =>
      'Acerca el móvil a la tarjeta para leer su enlace.';

  @override
  String get nfcTitlePermLockReady => 'Listo para bloquear';

  @override
  String get nfcDescPermLockReady =>
      'Acerca el móvil para aplicar bloqueo permanente de solo lectura.';

  @override
  String get nfcTitlePwdLockReady => 'Listo para bloquear';

  @override
  String get nfcDescPwdLockReady =>
      'Acerca el móvil a la tarjeta para asignar el PIN...';

  @override
  String get nfcTitlePwdUnlockReady => 'Listo para desbloquear';

  @override
  String get nfcDescPwdUnlockReady =>
      'Acerca el móvil a la tarjeta para desbloquear...';

  @override
  String get pwdModalTitle => 'Protección de tarjeta';

  @override
  String get pwdModalTitleLock => 'Bloquear tarjeta';

  @override
  String get pwdModalTitleUnlock => 'Desbloquear tarjeta';

  @override
  String get pwdModalDesc => 'Asigna un PIN para proteger la tarjeta';

  @override
  String get pwdModalDescLock => 'Asigna un PIN para proteger la tarjeta';

  @override
  String get pwdModalDescUnlock => 'Introduce el PIN para desbloquear';

  @override
  String get pwdHintText => 'Se recomiendan 4 dígitos';

  @override
  String get pwdInfoToast => 'Se recomiendan 4 dígitos';

  @override
  String get pwdPlaceholder => 'Introduce el PIN...';

  @override
  String get pwdTabLock => 'Bloquear';

  @override
  String get pwdTabUnlock => 'Desbloquear';

  @override
  String get pwdSubmitLock => 'Bloquear tarjeta';

  @override
  String get pwdSubmitUnlock => 'Desbloquear tarjeta';

  @override
  String get pwdCancel => 'Cancelar';

  @override
  String get toastEnterPwd => 'Introduce un PIN';

  @override
  String get permLockTitle => 'Bloqueo permanente';

  @override
  String get permLockDesc =>
      'Aviso: La tarjeta será de solo lectura para siempre. No se podrá editar ni borrar.';

  @override
  String get permLockConfirmBtn => 'Bloquear para siempre';

  @override
  String get permLockCancelBtn => 'Cancelar';

  @override
  String get toastNfcReadSuccess => 'Enlace leído y cargado con éxito';

  @override
  String get toastNfcReadEmpty => 'No se encontró ningún enlace válido';

  @override
  String get toastNfcPermLockSuccess =>
      'Tarjeta bloqueada en solo lectura para siempre';

  @override
  String get toastNfcPwdLockSuccess => 'Tarjeta bloqueada con PIN con éxito';

  @override
  String get toastNfcPwdUnlockSuccess => 'Tarjeta desbloqueada con éxito';

  @override
  String get toastNfcWrongPwd => 'PIN incorrecto o error al desbloquear';

  @override
  String get toastNfcPwdUnsupported =>
      'Esta tarjeta no admite protección por PIN';

  @override
  String get toastNfcAlreadyUnlocked => 'La tarjeta no está bloqueada';

  @override
  String get toastNfcAlreadyLocked =>
      'La tarjeta ya tiene PIN. Desbloquéala primero para cambiarlo.';

  @override
  String get nfcTitleSuccess => '¡Escritura correcta!';

  @override
  String get nfcDescSuccess => 'Tarjeta grabada correctamente.';

  @override
  String get nfcTitleNext => 'Listo para escribir';

  @override
  String get nfcDescNext => 'Acerca otra tarjeta o pulsa Hecho.';

  @override
  String nfcCardsCount(int count) {
    return 'Tarjetas grabadas: $count';
  }

  @override
  String get nfcCancel => 'Cancelar';

  @override
  String get nfcDone => 'Hecho';

  @override
  String get nfcOk => 'Aceptar';

  @override
  String get nfcBtnLockAnother => 'Bloquear otra';

  @override
  String get nfcBtnUnlockAnother => 'Desbloquear otra';

  @override
  String get nfcTitlePwdLockSuccess => 'Tarjeta bloqueada';

  @override
  String get nfcDescPwdLockSuccess =>
      'La tarjeta está protegida contra modificaciones.';

  @override
  String get nfcTitlePwdUnlockSuccess => 'Tarjeta desbloqueada';

  @override
  String get nfcDescPwdUnlockSuccess => 'La tarjeta ya se puede modificar.';

  @override
  String get nfcTitleAlreadyUnlocked => 'Tarjeta no bloqueada';

  @override
  String get nfcDescAlreadyUnlocked => 'Esta tarjeta ya está desbloqueada.';

  @override
  String get nfcTitleTagLost => 'Conexión perdida';

  @override
  String get nfcDescTagLost =>
      'Mantén el móvil firme sobre el centro de la tarjeta.';

  @override
  String get nfcTitleLocked => 'Tarjeta protegida';

  @override
  String get nfcTitleReadLocked => 'Lectura protegida';

  @override
  String get nfcDescReadLocked =>
      'Los datos de la tarjeta están protegidos contra lectura.';

  @override
  String get nfcTitleWrongPwd => 'PIN incorrecto';

  @override
  String get nfcTitleAlreadyLocked => 'Tarjeta ya bloqueada';

  @override
  String get nfcTitleCapacity => 'Capacidad superada';

  @override
  String get nfcTitleEmptyTag => 'Tarjeta vacía';

  @override
  String get nfcTitlePermLockSuccess => 'Tarjeta bloqueada permanentemente';

  @override
  String get nfcDescPermLockSuccess =>
      'La tarjeta se ha configurado como solo lectura permanente.';

  @override
  String get nfcTitlePermLockStandby => '¡Tarjeta bloqueada para siempre!';

  @override
  String get nfcDescPermLockStandby =>
      'En pausa por seguridad. Toca el icono para reactivar.';

  @override
  String nfcPermLockCount(int count) {
    return 'Bloqueadas: $count';
  }

  @override
  String nfcEraseCount(int count) {
    return 'Borradas: $count';
  }

  @override
  String get nfcTitleCannotLock => 'No se puede bloquear';

  @override
  String get nfcDescCannotLock =>
      'La tarjeta ya es de solo lectura o no es compatible.';

  @override
  String get nfcBackToPin => 'Volver';

  @override
  String get nfcTitleDisabled => 'NFC desactivado';

  @override
  String get nfcTitleNoHardware => 'NFC no compatible';

  @override
  String get nfcTitleOpFailed => 'Operación fallida';

  @override
  String get nfcDescOpFailed =>
      'Error en la operación. Mantén el móvil firme y reintenta.';

  @override
  String get nfcTitleError => 'Error de escritura';

  @override
  String get nfcDescLocked =>
      'Tarjeta protegida o de solo lectura. Desbloquéala primero.';

  @override
  String get nfcDescCapacity => 'Los datos superan la memoria de la tarjeta.';

  @override
  String get nfcDescUnsupported => 'Este tipo de tarjeta no es compatible.';

  @override
  String get nfcDescGenericError =>
      'Error al escribir. Mantén el móvil firme sobre la tarjeta.';

  @override
  String get nfcRetryBtn => 'Reintentar';

  @override
  String get nfcNoHardware => 'NFC no está disponible en este dispositivo';

  @override
  String get nfcDisabled => 'Activa el NFC en los ajustes del teléfono';

  @override
  String get nfcLocked => 'La tarjeta NFC está bloqueada o es de solo lectura';

  @override
  String get nfcCapacity => 'Memoria insuficiente en la tarjeta NFC';

  @override
  String get nfcUnsupported => 'Tipo de tarjeta NFC no compatible';

  @override
  String get nfcWriteFailed =>
      'Error al escribir en la tarjeta NFC. Reintenta.';

  @override
  String get toastPasteFirst => 'Pega un enlace primero';

  @override
  String get toastInvalid => 'No se pudo extraer el ID del lugar';

  @override
  String get toastNoInternet => 'Sin conexión a internet';

  @override
  String get toastSuccess => 'Enlace convertido con éxito';

  @override
  String get toastNfcWritten => 'Escrito en la tarjeta NFC con éxito';

  @override
  String toastNfcBatchSuccess(int count) {
    return 'Se programaron $count tarjeta(s) con éxito';
  }

  @override
  String get toastCleared => 'Texto borrado';

  @override
  String get toastPasted => 'Pegado desde el portapapeles';

  @override
  String get toastEmptyClip => 'El portapapeles está vacío';

  @override
  String get toastClipDenied => 'Pulsa Ctrl+V para pegar';

  @override
  String get toastCopied => 'Enlace de reseña copiado';

  @override
  String get toastShareCopied => 'Enlace copiado para compartir';

  @override
  String get shareTitle => 'Reseña de Google';

  @override
  String get shareText => 'Déjanos una reseña en Google Maps';

  @override
  String get toastHourlyLimit => 'Límite horario de búsquedas alcanzado';

  @override
  String get toastSelectSuccess => 'Enlace generado';

  @override
  String get updateAvailable => 'Actualización disponible';

  @override
  String get updateReadyTitle => 'Nueva versión lista';

  @override
  String get updateCurrent => 'Actual';

  @override
  String get updateNew => 'Nueva';

  @override
  String updateSize(String size) {
    return 'Tamaño: $size';
  }

  @override
  String updateDate(String date) {
    return 'Fecha: $date';
  }

  @override
  String get updateHighlights => 'Novedades de esta versión';

  @override
  String get updateInstallBtn => 'Instalar actualización';

  @override
  String get updateViewGithub => 'Notas de la versión';

  @override
  String get updateLater => 'Más tarde';

  @override
  String get toastCheckingUpdate => 'Buscando actualizaciones...';

  @override
  String toastUpToDate(String version) {
    return 'La app está actualizada ($version)';
  }

  @override
  String toastUpdateFound(String version) {
    return '¡Nueva versión $version disponible!';
  }

  @override
  String get toastUpdateError => 'No se pudo comprobar la actualización';

  @override
  String get toastDownloadStarted =>
      'Descargando actualización en segundo plano...';

  @override
  String get toastQrSaveError => 'Error al guardar el código QR';

  @override
  String get eraseModalTitle => 'Borrar tarjeta';

  @override
  String get eraseModalDesc =>
      'Se borrarán todos los datos y la tarjeta quedará vacía. No afecta a los bloqueos.';

  @override
  String get eraseConfirmBtn => 'Borrar tarjeta';

  @override
  String get eraseCancelBtn => 'Cancelar';

  @override
  String get nfcTitleEraseReady => 'Listo para borrar';

  @override
  String get nfcDescEraseReady =>
      'Acerca el móvil a la tarjeta para borrar los datos...';

  @override
  String get nfcTitleEraseSuccess => '¡Tarjeta borrada!';

  @override
  String get nfcDescEraseSuccess => 'La tarjeta está vacía y lista para usar.';

  @override
  String get nfcBtnEraseAnother => 'Borrar otra';

  @override
  String get toastNfcEraseSuccess => 'Datos de la tarjeta borrados con éxito';

  @override
  String get githubProjectBtn => 'GitHub';

  @override
  String get githubSupportBtn => 'Soporte';

  @override
  String get toastSupportComingSoon =>
      'La opción de soporte estará disponible pronto';

  @override
  String get settingsThemeLabel => 'Apariencia';

  @override
  String get settingsThemeSub => 'Elige el tema de la aplicación';

  @override
  String get settingsThemeSystem => 'Sistema';

  @override
  String get settingsThemeDark => 'Oscuro';

  @override
  String get settingsThemeLight => 'Claro';
}
