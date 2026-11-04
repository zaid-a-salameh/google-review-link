// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'Quick NFC';

  @override
  String get appSubtitle =>
      'Быстрый NFC-инструмент для ссылок на отзывы в Google Картах';

  @override
  String get tabLink => 'Прямая ссылка';

  @override
  String get tabSearch => 'Поиск места';

  @override
  String get placeholder => 'Вставьте ссылку...';

  @override
  String get trashTitle => 'Очистить';

  @override
  String get pasteBtn => 'Вставить';

  @override
  String get convertBtn => 'Преобразовать';

  @override
  String get resolvingBtn => 'Обработка...';

  @override
  String get searchPlaceholder => 'Название места и город...';

  @override
  String get toastEnterQuery => 'Сначала введите название места';

  @override
  String get fabGithubLabel => 'Проект на GitHub';

  @override
  String get resultLabel => 'Прямая ссылка:';

  @override
  String get resultLabelReview => 'Ссылка на отзыв:';

  @override
  String get resultLabelLocation => 'Место в Google Картах:';

  @override
  String get resultLabelCustom => 'Прямая ссылка:';

  @override
  String get linkTypePrompt => 'Тип ссылки для записи:';

  @override
  String get linkTypeReview => 'Отзыв 5 звёзд';

  @override
  String get linkTypeLocation => 'Точка на карте';

  @override
  String get toastSwitchedToReview => 'Переключено на ссылку для отзыва';

  @override
  String get toastSwitchedToLocation => 'Переключено на точку на карте';

  @override
  String get btnHelpGuideTitle => 'Руководство пользователя';

  @override
  String get btnGuideLabel => 'Гид';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsGeneralSection => 'Общие';

  @override
  String get settingsLanguageLabel => 'Язык интерфейса';

  @override
  String get settingsLanguageSub => 'Выберите предпочтительный язык';

  @override
  String get settingsLangArabic => 'العربية (Arabic)';

  @override
  String get settingsLangEnglish => 'English';

  @override
  String get settingsAboutSection => 'О приложении';

  @override
  String get settingsVersionLabel => 'Версия приложения';

  @override
  String get settingsDeveloperLabel => 'Разработчик и репозиторий';

  @override
  String get settingsBackBtn => 'Назад';

  @override
  String get obStep1Title => 'Умные ссылки и отзывы 5★';

  @override
  String get obStep1Desc =>
      'Вставьте ссылку Google Maps для мгновенного создания ссылки на отзыв или локацию.';

  @override
  String get obStep2Title => 'Прямой поиск заведений';

  @override
  String get obStep2Desc =>
      'Введите название и город во вкладке \'Поиск места\' для создания ссылки в одно касание.';

  @override
  String get obStep3Title => 'NFC, Wi-Fi и защита карт';

  @override
  String get obStep3Desc =>
      'Записывайте ссылки и Wi-Fi на NFC-карты и защищайте их PIN-кодом или блокировкой.';

  @override
  String get obBtnNext => 'Далее';

  @override
  String get obBtnStart => 'Начать';

  @override
  String get obBtnSkip => 'Пропустить';

  @override
  String get copyBtn => 'Копировать';

  @override
  String get copySuccess => 'Скопировано!';

  @override
  String get openBtn => 'Открыть';

  @override
  String get shareBtn => 'Поделиться';

  @override
  String get qrBtn => 'QR-код';

  @override
  String get qrModalTitle => 'QR-код отзыва';

  @override
  String get qrModalDesc =>
      'Отсканируйте камерой телефона, чтобы оставить отзыв';

  @override
  String get qrDownloadBtn => 'Сохранить QR';

  @override
  String get qrCloseBtn => 'Закрыть';

  @override
  String get qrDownloaded => 'QR-код сохранён';

  @override
  String get lblReadTag => 'Считать карту';

  @override
  String get lblWifiTag => 'Wi-Fi карта';

  @override
  String get lblPwdLockTag => 'Блокировка PIN';

  @override
  String get lblEraseTag => 'Очистить карту';

  @override
  String get lblPermLockTag => 'Вечная блокировка';

  @override
  String get wifiModalTitle => 'Настройка Wi-Fi карты';

  @override
  String get wifiStep1Title => 'Имя сети';

  @override
  String get wifiStep1Desc => 'Введите имя сети (SSID)';

  @override
  String get wifiStep2Title => 'Пароль сети';

  @override
  String get wifiStep2Desc => 'Введите пароль (или оставьте пустым)';

  @override
  String get wifiStep3Title => 'Тип безопасности';

  @override
  String get wifiStep3Desc => 'Выберите тип шифрования сети';

  @override
  String get wifiSsidPlaceholder => 'Имя сети (SSID)...';

  @override
  String get wifiPasswordPlaceholder => 'Введите пароль...';

  @override
  String get wifiEncWpa => 'WPA / WPA2 / WPA3';

  @override
  String get wifiEncWpaSub => 'Стандартная (Персональная)';

  @override
  String get wifiEncWep => 'WEP';

  @override
  String get wifiEncWepSub => 'Устаревшие сети';

  @override
  String get wifiEncOpen => 'Открытая сеть';

  @override
  String get wifiEncOpenSub => 'Без пароля';

  @override
  String get wifiNext => 'Далее';

  @override
  String get wifiBack => 'Назад';

  @override
  String get wifiWriteTag => 'Записать карту';

  @override
  String get wifiQrBtn => 'QR-код';

  @override
  String get wifiQrModalTitle => 'QR-код Wi-Fi';

  @override
  String get wifiQrModalDesc => 'Отсканируйте камерой телефона для подключения';

  @override
  String get wifiQrDownloaded => 'QR-код Wi-Fi сохранён';

  @override
  String get toastEnterSsid => 'Введите имя сети (SSID)';

  @override
  String get toastWifiPassMinLength => 'Пароль должен быть не менее 8 символов';

  @override
  String get toastWifiWpaRequired =>
      'Для WPA требуется пароль не менее 8 символов';

  @override
  String get nfcTitleWifiReady => 'Готово к записи Wi-Fi';

  @override
  String get nfcTitleWifiClone => 'Клонировать Wi-Fi карту';

  @override
  String get nfcTitleWifiCloneSuccess => 'Wi-Fi карта клонирована!';

  @override
  String get nfcDescWifiReady =>
      'Поднесите телефон к NFC-карте для записи Wi-Fi.';

  @override
  String nfcDescWifiReadyWithSsid(String ssid) {
    return 'Поднесите телефон к карте для записи \"$ssid\".';
  }

  @override
  String nfcDescWifiCloneWithSsid(String ssid) {
    return 'Поднесите другую карту для копирования \"$ssid\".';
  }

  @override
  String get nfcTitleWifiSuccess => 'Wi-Fi карта записана!';

  @override
  String get nfcDescWifiSuccess => 'Настройки Wi-Fi записаны на карту.';

  @override
  String get nfcBtnWifiAnother => 'Записать ещё';

  @override
  String get nfcBtnWifiCloneAnother => 'Клонировать ещё';

  @override
  String get toastNfcWifiSuccess => 'Wi-Fi карта успешно записана!';

  @override
  String toastNfcWifiReadSuccess(String ssid) {
    return 'Сеть \"$ssid\" считана! Готово к записи на новую карту.';
  }

  @override
  String get nfcBtn => 'Записать NFC-карту';

  @override
  String get nfcBtnWriteAnother => 'Записать ещё';

  @override
  String get nfcTitleReady => 'Готово к записи';

  @override
  String get nfcDescReady => 'Поднесите телефон к NFC-карте для записи ссылки.';

  @override
  String get nfcTitleReadReady => 'Готово к чтению карты';

  @override
  String get nfcDescReadReady => 'Поднесите телефон к карте для чтения ссылки.';

  @override
  String get nfcTitlePermLockReady => 'Готово к блокировке';

  @override
  String get nfcDescPermLockReady =>
      'Поднесите телефон к карте для вечной блокировки записи.';

  @override
  String get nfcTitlePwdLockReady => 'Готово к блокировке';

  @override
  String get nfcDescPwdLockReady =>
      'Поднесите телефон к карте для установки PIN...';

  @override
  String get nfcTitlePwdUnlockReady => 'Готово к разблокировке';

  @override
  String get nfcDescPwdUnlockReady =>
      'Поднесите телефон к карте для разблокировки...';

  @override
  String get pwdModalTitle => 'Защита карты';

  @override
  String get pwdModalTitleLock => 'Заблокировать карту';

  @override
  String get pwdModalTitleUnlock => 'Разблокировать карту';

  @override
  String get pwdModalDesc => 'Задайте PIN для защиты карты';

  @override
  String get pwdModalDescLock => 'Задайте PIN для защиты карты';

  @override
  String get pwdModalDescUnlock => 'Введите PIN для разблокировки';

  @override
  String get pwdHintText => 'Рекомендуется 4 цифры';

  @override
  String get pwdInfoToast => 'Рекомендуется 4 цифры';

  @override
  String get pwdPlaceholder => 'Введите PIN...';

  @override
  String get pwdTabLock => 'Заблокировать';

  @override
  String get pwdTabUnlock => 'Разблокировать';

  @override
  String get pwdSubmitLock => 'Заблокировать';

  @override
  String get pwdSubmitUnlock => 'Разблокировать';

  @override
  String get pwdCancel => 'Отмена';

  @override
  String get toastEnterPwd => 'Введите PIN-код';

  @override
  String get permLockTitle => 'Вечная блокировка';

  @override
  String get permLockDesc =>
      'Внимание: Карта навсегда станет доступна только для чтения. Её нельзя будет изменить или очистить.';

  @override
  String get permLockConfirmBtn => 'Заблокировать навсегда';

  @override
  String get permLockCancelBtn => 'Отмена';

  @override
  String get toastNfcReadSuccess => 'Ссылка успешно считана и загружена';

  @override
  String get toastNfcReadEmpty => 'На этой карте нет действующей ссылки';

  @override
  String get toastNfcPermLockSuccess => 'Карта навсегда защищена от записи';

  @override
  String get toastNfcPwdLockSuccess => 'Карта успешно заблокирована PIN-кодом';

  @override
  String get toastNfcPwdUnlockSuccess => 'Карта успешно разблокирована';

  @override
  String get toastNfcWrongPwd => 'Неверный PIN или ошибка разблокировки';

  @override
  String get toastNfcPwdUnsupported =>
      'Эта карта не поддерживает защиту PIN-кодом';

  @override
  String get toastNfcAlreadyUnlocked => 'Карта не заблокирована';

  @override
  String get toastNfcAlreadyLocked =>
      'Карта уже защищена PIN-кодом. Сначала разблокируйте её.';

  @override
  String get nfcTitleSuccess => 'Успешно записано!';

  @override
  String get nfcDescSuccess => 'Карта успешно запрограммирована.';

  @override
  String get nfcTitleNext => 'Готово к записи';

  @override
  String get nfcDescNext => 'Поднесите следующую карту или нажмите Готово.';

  @override
  String nfcCardsCount(int count) {
    return 'Записано карт: $count';
  }

  @override
  String get nfcCancel => 'Отмена';

  @override
  String get nfcDone => 'Готово';

  @override
  String get nfcOk => 'ОК';

  @override
  String get nfcBtnLockAnother => 'Заблокировать ещё';

  @override
  String get nfcBtnUnlockAnother => 'Разблокировать ещё';

  @override
  String get nfcTitlePwdLockSuccess => 'Карта заблокирована';

  @override
  String get nfcDescPwdLockSuccess => 'Карта защищена от изменений.';

  @override
  String get nfcTitlePwdUnlockSuccess => 'Карта разблокирована';

  @override
  String get nfcDescPwdUnlockSuccess => 'Карта готова к редактированию.';

  @override
  String get nfcTitleAlreadyUnlocked => 'Карта не заблокирована';

  @override
  String get nfcDescAlreadyUnlocked => 'Эта карта уже разблокирована.';

  @override
  String get nfcTitleTagLost => 'Связь потеряна';

  @override
  String get nfcDescTagLost => 'Держите телефон неподвижно над картой.';

  @override
  String get nfcTitleLocked => 'Карта защищена';

  @override
  String get nfcTitleReadLocked => 'Защита от чтения';

  @override
  String get nfcDescReadLocked => 'Данные на карте защищены от чтения.';

  @override
  String get nfcTitleWrongPwd => 'Неверный PIN';

  @override
  String get nfcTitleAlreadyLocked => 'Карта уже заблокирована';

  @override
  String get nfcTitleCapacity => 'Недостаточно памяти';

  @override
  String get nfcTitleEmptyTag => 'Пустая карта';

  @override
  String get nfcTitlePermLockSuccess => 'Карта навсегда заблокирована';

  @override
  String get nfcDescPermLockSuccess =>
      'Карта навсегда переведена в режим \'только чтение\'.';

  @override
  String get nfcTitlePermLockStandby => 'Карта навсегда заблокирована!';

  @override
  String get nfcDescPermLockStandby =>
      'Приостановлено для безопасности. Нажмите на значок.';

  @override
  String nfcPermLockCount(int count) {
    return 'Заблокировано: $count';
  }

  @override
  String nfcEraseCount(int count) {
    return 'Очищено: $count';
  }

  @override
  String get nfcTitleCannotLock => 'Невозможно заблокировать';

  @override
  String get nfcDescCannotLock =>
      'Карта уже доступна только для чтения или не поддерживается.';

  @override
  String get nfcBackToPin => 'Назад';

  @override
  String get nfcTitleDisabled => 'NFC выключен';

  @override
  String get nfcTitleNoHardware => 'NFC не поддерживается';

  @override
  String get nfcTitleOpFailed => 'Ошибка операции';

  @override
  String get nfcDescOpFailed =>
      'Сбой операции. Держите телефон неподвижно и повторите.';

  @override
  String get nfcTitleError => 'Ошибка записи';

  @override
  String get nfcDescLocked =>
      'Карта защищена или только для чтения. Сначала разблокируйте её.';

  @override
  String get nfcDescCapacity => 'Объем данных превышает память карты.';

  @override
  String get nfcDescUnsupported => 'Этот тип карты не поддерживается.';

  @override
  String get nfcDescGenericError =>
      'Запись не удалась. Держите телефон неподвижно над картой.';

  @override
  String get nfcRetryBtn => 'Повторить';

  @override
  String get nfcNoHardware => 'NFC не поддерживается на этом устройстве';

  @override
  String get nfcDisabled => 'Включите NFC в настройках телефона';

  @override
  String get nfcLocked =>
      'NFC-карта заблокирована или доступна только для чтения';

  @override
  String get nfcCapacity => 'Недостаточно памяти на NFC-карте';

  @override
  String get nfcUnsupported => 'Неподдерживаемый тип NFC-метки';

  @override
  String get nfcWriteFailed => 'Ошибка записи на NFC-метку. Попробуйте снова.';

  @override
  String get toastPasteFirst => 'Сначала вставьте ссылку';

  @override
  String get toastInvalid => 'Не удалось получить идентификатор места';

  @override
  String get toastNoInternet => 'Нет подключения к интернету';

  @override
  String get toastSuccess => 'Ссылка успешно преобразована';

  @override
  String get toastNfcWritten => 'Успешно записано на NFC-карту';

  @override
  String toastNfcBatchSuccess(int count) {
    return 'Успешно записано карт: $count';
  }

  @override
  String get toastCleared => 'Текст очищен';

  @override
  String get toastPasted => 'Вставлено из буфера';

  @override
  String get toastEmptyClip => 'Буфер обмена пуст';

  @override
  String get toastClipDenied => 'Нажмите Ctrl+V для вставки';

  @override
  String get toastCopied => 'Ссылка на отзыв скопирована';

  @override
  String get toastShareCopied => 'Ссылка скопирована для отправки';

  @override
  String get shareTitle => 'Отзыв в Google';

  @override
  String get shareText => 'Оставьте нам отзыв в Google Картах';

  @override
  String get toastHourlyLimit => 'Достигнут часовой лимит поиска';

  @override
  String get toastSelectSuccess => 'Ссылка создана';

  @override
  String get updateAvailable => 'Доступно обновление';

  @override
  String get updateReadyTitle => 'Новая версия готова';

  @override
  String get updateCurrent => 'Текущая';

  @override
  String get updateNew => 'Новая';

  @override
  String updateSize(String size) {
    return 'Размер: $size';
  }

  @override
  String updateDate(String date) {
    return 'Дата: $date';
  }

  @override
  String get updateHighlights => 'Что нового в этой версии';

  @override
  String get updateInstallBtn => 'Установить обновление';

  @override
  String get updateViewGithub => 'Список изменений';

  @override
  String get updateLater => 'Позже';

  @override
  String get toastCheckingUpdate => 'Проверка обновлений...';

  @override
  String toastUpToDate(String version) {
    return 'Установлена последняя версия ($version)';
  }

  @override
  String toastUpdateFound(String version) {
    return 'Доступна новая версия $version!';
  }

  @override
  String get toastUpdateError => 'Не удалось проверить обновления';

  @override
  String get toastDownloadStarted => 'Загрузка обновления в фоне...';

  @override
  String get toastQrSaveError => 'Не удалось сохранить QR-код';

  @override
  String get eraseModalTitle => 'Очистка карты';

  @override
  String get eraseModalDesc =>
      'Все данные будут удалены, а карта станет пустой. Блокировки не затронуты.';

  @override
  String get eraseConfirmBtn => 'Очистить карту';

  @override
  String get eraseCancelBtn => 'Отмена';

  @override
  String get nfcTitleEraseReady => 'Готово к очистке';

  @override
  String get nfcDescEraseReady => 'Поднесите телефон к карте для очистки...';

  @override
  String get nfcTitleEraseSuccess => 'Карта очищена!';

  @override
  String get nfcDescEraseSuccess =>
      'Карта теперь пуста и готова к использованию.';

  @override
  String get nfcBtnEraseAnother => 'Очистить ещё';

  @override
  String get toastNfcEraseSuccess => 'Данные карты успешно очищены';

  @override
  String get githubProjectBtn => 'GitHub';

  @override
  String get githubSupportBtn => 'Поддержка';

  @override
  String get toastSupportComingSoon => 'Поддержка скоро станет доступна';

  @override
  String get settingsThemeLabel => 'Оформление';

  @override
  String get settingsThemeSub => 'Выберите тему оформления';

  @override
  String get settingsThemeSystem => 'Системная';

  @override
  String get settingsThemeDark => 'Тёмная';

  @override
  String get settingsThemeLight => 'Светлая';
}
