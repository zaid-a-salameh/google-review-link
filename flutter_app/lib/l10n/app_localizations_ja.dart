// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class AppLocalizationsJa extends AppLocalizations {
  AppLocalizationsJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'Quick NFC';

  @override
  String get appSubtitle => 'Googleマップのレビューリンクを即座に作成できるNFCツール';

  @override
  String get tabLink => 'ダイレクトリンク';

  @override
  String get tabSearch => '店舗・施設検索';

  @override
  String get placeholder => 'リンクを貼り付け...';

  @override
  String get trashTitle => 'テキスト消去';

  @override
  String get pasteBtn => '貼り付け';

  @override
  String get convertBtn => 'リンク変換';

  @override
  String get resolvingBtn => '解析中...';

  @override
  String get searchPlaceholder => '場所や店舗名・都市名...';

  @override
  String get toastEnterQuery => '店舗・場所名を入力してください';

  @override
  String get fabGithubLabel => 'GitHubプロジェクト';

  @override
  String get resultLabel => 'ダイレクトリンク：';

  @override
  String get resultLabelReview => '直接レビューリンク：';

  @override
  String get resultLabelLocation => 'Googleマップの位置：';

  @override
  String get resultLabelCustom => 'ダイレクトリンク：';

  @override
  String get linkTypePrompt => '書き込むリンクの種類：';

  @override
  String get linkTypeReview => '★5 レビュー';

  @override
  String get linkTypeLocation => 'マップ位置';

  @override
  String get toastSwitchedToReview => 'レビューリンクに切り替えました';

  @override
  String get toastSwitchedToLocation => 'マップ位置リンクに切り替えました';

  @override
  String get btnHelpGuideTitle => '使い方ガイド';

  @override
  String get btnGuideLabel => 'ガイド';

  @override
  String get settingsTitle => '設定';

  @override
  String get settingsGeneralSection => '一般設定';

  @override
  String get settingsLanguageLabel => '表示言語';

  @override
  String get settingsLanguageSub => '使用する言語を選択';

  @override
  String get settingsLangArabic => 'العربية (Arabic)';

  @override
  String get settingsLangEnglish => 'English';

  @override
  String get settingsAboutSection => 'アプリについて';

  @override
  String get settingsVersionLabel => 'アプリバージョン';

  @override
  String get settingsDeveloperLabel => '開発者とリポジトリ';

  @override
  String get settingsBackBtn => '戻る';

  @override
  String get obStep1Title => 'スマートリンクと★5レビュー';

  @override
  String get obStep1Desc => 'Googleマップのリンクを貼り付けて、直接レビューや位置リンクに即座に変換します。';

  @override
  String get obStep2Title => '店舗・施設の直接検索';

  @override
  String get obStep2Desc => '「店舗・施設検索」で名前と都市を入力するだけで、ワンタップでリンクを作成。';

  @override
  String get obStep3Title => 'NFCタグ・Wi-Fi・保護';

  @override
  String get obStep3Desc => 'リンクやWi-FiをNFCカードに書き込み、PINや完全ロックで保護できます。';

  @override
  String get obBtnNext => '次へ';

  @override
  String get obBtnStart => 'はじめる';

  @override
  String get obBtnSkip => 'スキップ';

  @override
  String get copyBtn => 'コピー';

  @override
  String get copySuccess => 'コピーしました！';

  @override
  String get openBtn => '開く';

  @override
  String get shareBtn => '共有';

  @override
  String get qrBtn => 'QRコード';

  @override
  String get qrModalTitle => 'レビュー用QRコード';

  @override
  String get qrModalDesc => 'カメラで読み取って直接レビューを投稿';

  @override
  String get qrDownloadBtn => 'QRを保存';

  @override
  String get qrCloseBtn => '閉じる';

  @override
  String get qrDownloaded => 'QRコードを保存しました';

  @override
  String get lblReadTag => 'カード読み取り';

  @override
  String get lblWifiTag => 'Wi-Fiカード';

  @override
  String get lblPwdLockTag => 'PINロック';

  @override
  String get lblEraseTag => 'カード初期化';

  @override
  String get lblPermLockTag => '完全ロック';

  @override
  String get wifiModalTitle => 'Wi-Fiカード設定';

  @override
  String get wifiStep1Title => 'ネットワーク名';

  @override
  String get wifiStep1Desc => 'Wi-Fi名(SSID)を入力';

  @override
  String get wifiStep2Title => 'パスワード';

  @override
  String get wifiStep2Desc => 'パスワードを入力（オープン時は空欄）';

  @override
  String get wifiStep3Title => 'セキュリティ形式';

  @override
  String get wifiStep3Desc => '暗号化規格を選択';

  @override
  String get wifiSsidPlaceholder => 'ネットワーク名 (SSID)...';

  @override
  String get wifiPasswordPlaceholder => 'パスワードを入力...';

  @override
  String get wifiEncWpa => 'WPA / WPA2 / WPA3';

  @override
  String get wifiEncWpaSub => '標準 (パーソナル)';

  @override
  String get wifiEncWep => 'WEP';

  @override
  String get wifiEncWepSub => '旧型ネットワーク';

  @override
  String get wifiEncOpen => 'オープンネットワーク';

  @override
  String get wifiEncOpenSub => 'パスワード不要';

  @override
  String get wifiNext => '次へ';

  @override
  String get wifiBack => '戻る';

  @override
  String get wifiWriteTag => 'カードに書き込み';

  @override
  String get wifiQrBtn => 'QRコード';

  @override
  String get wifiQrModalTitle => 'Wi-Fi用QRコード';

  @override
  String get wifiQrModalDesc => 'カメラで読み取って直接接続';

  @override
  String get wifiQrDownloaded => 'Wi-Fi用QRコードを保存しました';

  @override
  String get toastEnterSsid => 'ネットワーク名(SSID)を入力してください';

  @override
  String get toastWifiPassMinLength => 'パスワードは8文字以上必要です';

  @override
  String get toastWifiWpaRequired => 'WPAネットワークには8文字以上のパスワードが必要です';

  @override
  String get nfcTitleWifiReady => 'Wi-Fi書き込み準備完了';

  @override
  String get nfcTitleWifiClone => 'Wi-Fiカードを複製';

  @override
  String get nfcTitleWifiCloneSuccess => 'Wi-Fiカードを複製しました！';

  @override
  String get nfcDescWifiReady => 'スマホをNFCカードにかざしてWi-Fiを書き込みます。';

  @override
  String nfcDescWifiReadyWithSsid(String ssid) {
    return 'スマホをカードにかざして「$ssid」を書き込みます。';
  }

  @override
  String nfcDescWifiCloneWithSsid(String ssid) {
    return '別のカードをかざして「$ssid」を複製します。';
  }

  @override
  String get nfcTitleWifiSuccess => 'Wi-Fiカードの作成完了！';

  @override
  String get nfcDescWifiSuccess => 'Wi-Fi設定がカードに書き込まれました。';

  @override
  String get nfcBtnWifiAnother => '続けて書き込む';

  @override
  String get nfcBtnWifiCloneAnother => '続けて複製する';

  @override
  String get toastNfcWifiSuccess => 'Wi-Fiカードの書き込みに成功しました！';

  @override
  String toastNfcWifiReadSuccess(String ssid) {
    return 'Wi-Fi「$ssid」を読み取りました！新しいカードに書き込めます。';
  }

  @override
  String get nfcBtn => 'NFCカードに書き込み';

  @override
  String get nfcBtnWriteAnother => '続けて書き込む';

  @override
  String get nfcTitleReady => '書き込み準備完了';

  @override
  String get nfcDescReady => 'スマホをNFCカードにかざしてリンクを書き込みます。';

  @override
  String get nfcTitleReadReady => '読み取り準備完了';

  @override
  String get nfcDescReadReady => 'スマホをカードにかざしてリンクを読み取ります。';

  @override
  String get nfcTitlePermLockReady => 'ロック準備完了';

  @override
  String get nfcDescPermLockReady => 'スマホをカードにかざして完全書き込み禁止を適用します。';

  @override
  String get nfcTitlePwdLockReady => 'ロック準備完了';

  @override
  String get nfcDescPwdLockReady => 'スマホをカードにかざしてPINを設定...';

  @override
  String get nfcTitlePwdUnlockReady => '解除準備完了';

  @override
  String get nfcDescPwdUnlockReady => 'スマホをカードにかざしてロックを解除...';

  @override
  String get pwdModalTitle => 'カード保護';

  @override
  String get pwdModalTitleLock => 'カードをロック';

  @override
  String get pwdModalTitleUnlock => 'カードのロック解除';

  @override
  String get pwdModalDesc => 'カード保護用のPINを設定';

  @override
  String get pwdModalDescLock => 'カード保護用のPINを設定';

  @override
  String get pwdModalDescUnlock => '解除用のPINを入力';

  @override
  String get pwdHintText => '4桁を推奨';

  @override
  String get pwdInfoToast => '4桁を推奨';

  @override
  String get pwdPlaceholder => 'PINを入力...';

  @override
  String get pwdTabLock => 'ロック';

  @override
  String get pwdTabUnlock => '解除';

  @override
  String get pwdSubmitLock => 'カードをロック';

  @override
  String get pwdSubmitUnlock => 'ロック解除';

  @override
  String get pwdCancel => 'キャンセル';

  @override
  String get toastEnterPwd => 'PINを入力してください';

  @override
  String get permLockTitle => '完全ロック';

  @override
  String get permLockDesc => '警告：カードは完全に読み取り専用になります。変更や初期化はできなくなります。';

  @override
  String get permLockConfirmBtn => '完全にロック';

  @override
  String get permLockCancelBtn => 'キャンセル';

  @override
  String get toastNfcReadSuccess => 'リンクを正常に読み込みました';

  @override
  String get toastNfcReadEmpty => '有効なリンクが見つかりません';

  @override
  String get toastNfcPermLockSuccess => 'カードを完全に読み取り専用にロックしました';

  @override
  String get toastNfcPwdLockSuccess => 'カードをPINでロックしました';

  @override
  String get toastNfcPwdUnlockSuccess => 'カードのロックを解除しました';

  @override
  String get toastNfcWrongPwd => 'PINが正しくないか解除に失敗しました';

  @override
  String get toastNfcPwdUnsupported => 'このカードはPIN保護に対応していません';

  @override
  String get toastNfcAlreadyUnlocked => 'カードはロックされていません';

  @override
  String get toastNfcAlreadyLocked => '既にPINで保護されています。変更前に解除してください。';

  @override
  String get nfcTitleSuccess => '書き込み完了！';

  @override
  String get nfcDescSuccess => 'カードが正常に書き込まれました。';

  @override
  String get nfcTitleNext => '書き込み準備完了';

  @override
  String get nfcDescNext => '次のカードをかざすか「完了」をタップ。';

  @override
  String nfcCardsCount(int count) {
    return '書き込み完了数: $count';
  }

  @override
  String get nfcCancel => 'キャンセル';

  @override
  String get nfcDone => '完了';

  @override
  String get nfcOk => 'OK';

  @override
  String get nfcBtnLockAnother => '続けてロックする';

  @override
  String get nfcBtnUnlockAnother => '続けて解除する';

  @override
  String get nfcTitlePwdLockSuccess => 'カードをロックしました';

  @override
  String get nfcDescPwdLockSuccess => 'カードの変更が防止されています。';

  @override
  String get nfcTitlePwdUnlockSuccess => 'カードのロックを解除しました';

  @override
  String get nfcDescPwdUnlockSuccess => 'カードの編集が可能になりました。';

  @override
  String get nfcTitleAlreadyUnlocked => 'ロックされていません';

  @override
  String get nfcDescAlreadyUnlocked => 'このカードは既に解除されています。';

  @override
  String get nfcTitleTagLost => '通信が途切れました';

  @override
  String get nfcDescTagLost => 'スマホをカードの中心にしっかりかざしてください。';

  @override
  String get nfcTitleLocked => '保護されたカード';

  @override
  String get nfcTitleReadLocked => '読み取り制限中';

  @override
  String get nfcDescReadLocked => 'カードデータが保護されており読み取れません。';

  @override
  String get nfcTitleWrongPwd => 'PINが違います';

  @override
  String get nfcTitleAlreadyLocked => '既にロックされています';

  @override
  String get nfcTitleCapacity => '容量オーバー';

  @override
  String get nfcTitleEmptyTag => '空のカード';

  @override
  String get nfcTitlePermLockSuccess => '完全ロック完了';

  @override
  String get nfcDescPermLockSuccess => 'カードが恒久的に読み取り専用に設定されました。';

  @override
  String get nfcTitlePermLockStandby => '完全ロック完了！';

  @override
  String get nfcDescPermLockStandby => '安全のため一時停止中。再開するにはアイコンをタップ。';

  @override
  String nfcPermLockCount(int count) {
    return 'ロック完了: $count';
  }

  @override
  String nfcEraseCount(int count) {
    return '初期化完了: $count';
  }

  @override
  String get nfcTitleCannotLock => 'ロックできません';

  @override
  String get nfcDescCannotLock => 'カードが既に読み取り専用か、未対応のタイプです。';

  @override
  String get nfcBackToPin => '戻る';

  @override
  String get nfcTitleDisabled => 'NFCが無効です';

  @override
  String get nfcTitleNoHardware => 'NFC非対応';

  @override
  String get nfcTitleOpFailed => '処理に失敗しました';

  @override
  String get nfcDescOpFailed => '処理に失敗しました。スマホをしっかりかざして再試行してください。';

  @override
  String get nfcTitleError => '書き込み失敗';

  @override
  String get nfcDescLocked => 'カードが保護されているか読み取り専用です。先に解除してください。';

  @override
  String get nfcDescCapacity => 'データがカードの容量を超えています。';

  @override
  String get nfcDescUnsupported => 'このカードの種類には対応していません。';

  @override
  String get nfcDescGenericError => '書き込みに失敗しました。スマホをしっかりかざしてください。';

  @override
  String get nfcRetryBtn => '再試行';

  @override
  String get nfcNoHardware => 'この端末はNFCに対応していません';

  @override
  String get nfcDisabled => '端末の設定でNFCを有効にしてください';

  @override
  String get nfcLocked => 'NFCカードがロックされているか読み取り専用です';

  @override
  String get nfcCapacity => 'NFCカードの空き容量が不足しています';

  @override
  String get nfcUnsupported => '未対応のNFCタグ形式です';

  @override
  String get nfcWriteFailed => 'NFCへの書き込みに失敗しました。再試行してください。';

  @override
  String get toastPasteFirst => '先にリンクを貼り付けてください';

  @override
  String get toastInvalid => '場所IDを取得できませんでした';

  @override
  String get toastNoInternet => 'ネットワークに接続されていません';

  @override
  String get toastSuccess => 'リンクの変換に成功しました';

  @override
  String get toastNfcWritten => 'NFCカードへの書き込みが完了しました';

  @override
  String toastNfcBatchSuccess(int count) {
    return '$count枚のNFCカードに書き込み完了';
  }

  @override
  String get toastCleared => '消去しました';

  @override
  String get toastPasted => 'クリップボードから貼り付けました';

  @override
  String get toastEmptyClip => 'クリップボードが空です';

  @override
  String get toastClipDenied => 'Ctrl+Vで貼り付けてください';

  @override
  String get toastCopied => 'レビューリンクをコピーしました';

  @override
  String get toastShareCopied => '共有用リンクをコピーしました';

  @override
  String get shareTitle => 'Googleレビュー';

  @override
  String get shareText => 'Googleマップでレビューをお願いします';

  @override
  String get toastHourlyLimit => '1時間あたりの検索制限に達しました';

  @override
  String get toastSelectSuccess => 'リンクを生成しました';

  @override
  String get updateAvailable => 'アップデートがあります';

  @override
  String get updateReadyTitle => '新しいバージョンが利用可能です';

  @override
  String get updateCurrent => '現在';

  @override
  String get updateNew => '最新';

  @override
  String updateSize(String size) {
    return 'サイズ: $size';
  }

  @override
  String updateDate(String date) {
    return '公開日: $date';
  }

  @override
  String get updateHighlights => '新機能と改善点';

  @override
  String get updateInstallBtn => '更新をインストール';

  @override
  String get updateViewGithub => 'リリースノート';

  @override
  String get updateLater => '後で';

  @override
  String get toastCheckingUpdate => 'アップデートを確認中...';

  @override
  String toastUpToDate(String version) {
    return '最新バージョンです ($version)';
  }

  @override
  String toastUpdateFound(String version) {
    return '新バージョン $version が利用可能です！';
  }

  @override
  String get toastUpdateError => 'アップデートを確認できませんでした';

  @override
  String get toastDownloadStarted => 'バックグラウンドでダウンロード中...';

  @override
  String get toastQrSaveError => 'QR画像の保存に失敗しました';

  @override
  String get eraseModalTitle => 'カード初期化';

  @override
  String get eraseModalDesc => '全データが消去され空のカードに戻ります。ロック状態には影響しません。';

  @override
  String get eraseConfirmBtn => '初期化する';

  @override
  String get eraseCancelBtn => 'キャンセル';

  @override
  String get nfcTitleEraseReady => '初期化準備完了';

  @override
  String get nfcDescEraseReady => 'スマホをカードにかざしてデータを消去...';

  @override
  String get nfcTitleEraseSuccess => '初期化完了！';

  @override
  String get nfcDescEraseSuccess => 'カードが初期化され、再利用可能です。';

  @override
  String get nfcBtnEraseAnother => '続けて初期化する';

  @override
  String get toastNfcEraseSuccess => 'カードデータを正常に初期化しました';

  @override
  String get githubProjectBtn => 'GitHub';

  @override
  String get githubSupportBtn => 'サポート';

  @override
  String get toastSupportComingSoon => 'サポート機能は近日公開予定です';

  @override
  String get settingsThemeLabel => '外観';

  @override
  String get settingsThemeSub => 'お好みのテーマを選択';

  @override
  String get settingsThemeSystem => 'システム連動';

  @override
  String get settingsThemeDark => 'ダーク';

  @override
  String get settingsThemeLight => 'ライト';
}
