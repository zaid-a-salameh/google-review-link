// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Chinese (`zh`).
class AppLocalizationsZh extends AppLocalizations {
  AppLocalizationsZh([String locale = 'zh']) : super(locale);

  @override
  String get appTitle => 'Quick NFC';

  @override
  String get appSubtitle => '快速将Google地图链接转为评价链接的NFC工具';

  @override
  String get tabLink => '直达链接';

  @override
  String get tabSearch => '搜索商家';

  @override
  String get placeholder => '在此粘贴链接...';

  @override
  String get trashTitle => '清空内容';

  @override
  String get pasteBtn => '粘贴';

  @override
  String get convertBtn => '转换链接';

  @override
  String get resolvingBtn => '解析中...';

  @override
  String get searchPlaceholder => '搜索地点名称和城市...';

  @override
  String get toastEnterQuery => '请先输入商家名称';

  @override
  String get fabGithubLabel => 'GitHub 项目';

  @override
  String get resultLabel => '直达链接：';

  @override
  String get resultLabelReview => '直达评价链接：';

  @override
  String get resultLabelLocation => 'Google 地图位置：';

  @override
  String get resultLabelCustom => '直达链接：';

  @override
  String get linkTypePrompt => '选择写入的链接类型：';

  @override
  String get linkTypeReview => '五星好评';

  @override
  String get linkTypeLocation => '地图位置';

  @override
  String get toastSwitchedToReview => '已切换为五星评价链接';

  @override
  String get toastSwitchedToLocation => '已切换为地图位置链接';

  @override
  String get btnHelpGuideTitle => '使用指南与功能演示';

  @override
  String get btnGuideLabel => '指南';

  @override
  String get settingsTitle => '设置';

  @override
  String get settingsGeneralSection => '通用设置';

  @override
  String get settingsLanguageLabel => '应用语言';

  @override
  String get settingsLanguageSub => '选择您偏好的语言';

  @override
  String get settingsLangArabic => 'العربية (Arabic)';

  @override
  String get settingsLangEnglish => 'English';

  @override
  String get settingsAboutSection => '关于';

  @override
  String get settingsVersionLabel => '应用版本';

  @override
  String get settingsDeveloperLabel => '开发者与开源仓库';

  @override
  String get settingsBackBtn => '返回';

  @override
  String get obStep1Title => '智能链接与五星好评';

  @override
  String get obStep1Desc => '粘贴任意Google地图链接，即刻转为五星好评或地图位置链接。';

  @override
  String get obStep2Title => '直接搜索商家';

  @override
  String get obStep2Desc => '在“搜索商家”中输入名称和城市，一键生成专属评价链接。';

  @override
  String get obStep3Title => 'NFC卡片、Wi-Fi与安全保护';

  @override
  String get obStep3Desc => '轻松写入链接或Wi-Fi至NFC卡，支持PIN码与永久锁定保护。';

  @override
  String get obBtnNext => '下一步';

  @override
  String get obBtnStart => '开始使用';

  @override
  String get obBtnSkip => '跳过';

  @override
  String get copyBtn => '复制';

  @override
  String get copySuccess => '已复制！';

  @override
  String get openBtn => '打开';

  @override
  String get shareBtn => '分享';

  @override
  String get qrBtn => '二维码';

  @override
  String get qrModalTitle => '评价二维码';

  @override
  String get qrModalDesc => '使用手机相机扫码即可直接留下好评';

  @override
  String get qrDownloadBtn => '保存二维码';

  @override
  String get qrCloseBtn => '关闭';

  @override
  String get qrDownloaded => '二维码已保存';

  @override
  String get lblReadTag => '读取卡片';

  @override
  String get lblWifiTag => 'Wi-Fi卡片';

  @override
  String get lblPwdLockTag => 'PIN码锁定';

  @override
  String get lblEraseTag => '清除卡片';

  @override
  String get lblPermLockTag => '永久锁定';

  @override
  String get wifiModalTitle => '设置 Wi-Fi 卡片';

  @override
  String get wifiStep1Title => '网络名称';

  @override
  String get wifiStep1Desc => '输入 Wi-Fi 名称 (SSID)';

  @override
  String get wifiStep2Title => '网络密码';

  @override
  String get wifiStep2Desc => '输入密码（开放网络请留空）';

  @override
  String get wifiStep3Title => '加密类型';

  @override
  String get wifiStep3Desc => '选择网络加密协议';

  @override
  String get wifiSsidPlaceholder => '网络名称 (SSID)...';

  @override
  String get wifiPasswordPlaceholder => '输入密码...';

  @override
  String get wifiEncWpa => 'WPA / WPA2 / WPA3';

  @override
  String get wifiEncWpaSub => '通用标准（个人）';

  @override
  String get wifiEncWep => 'WEP';

  @override
  String get wifiEncWepSub => '旧版旧式网络';

  @override
  String get wifiEncOpen => '开放网络';

  @override
  String get wifiEncOpenSub => '无需密码';

  @override
  String get wifiNext => '下一步';

  @override
  String get wifiBack => '返回';

  @override
  String get wifiWriteTag => '写入卡片';

  @override
  String get wifiQrBtn => '二维码';

  @override
  String get wifiQrModalTitle => 'Wi-Fi 二维码';

  @override
  String get wifiQrModalDesc => '使用手机相机扫码即可直接连接';

  @override
  String get wifiQrDownloaded => 'Wi-Fi 二维码已保存';

  @override
  String get toastEnterSsid => '请输入网络名称 (SSID)';

  @override
  String get toastWifiPassMinLength => '密码至少需要8位字符';

  @override
  String get toastWifiWpaRequired => 'WPA网络密码至少需要8位字符';

  @override
  String get nfcTitleWifiReady => '准备写入 Wi-Fi';

  @override
  String get nfcTitleWifiClone => '克隆 Wi-Fi 卡片';

  @override
  String get nfcTitleWifiCloneSuccess => 'Wi-Fi 卡片已克隆！';

  @override
  String get nfcDescWifiReady => '将手机贴近NFC卡以写入Wi-Fi信息。';

  @override
  String nfcDescWifiReadyWithSsid(String ssid) {
    return '将手机贴近卡片以写入 \"$ssid\"。';
  }

  @override
  String nfcDescWifiCloneWithSsid(String ssid) {
    return '将另一张卡贴近手机以复制 \"$ssid\"。';
  }

  @override
  String get nfcTitleWifiSuccess => 'Wi-Fi 卡片写入成功！';

  @override
  String get nfcDescWifiSuccess => 'Wi-Fi 配置已成功写入卡片。';

  @override
  String get nfcBtnWifiAnother => '写入下一张';

  @override
  String get nfcBtnWifiCloneAnother => '克隆下一张';

  @override
  String get toastNfcWifiSuccess => 'Wi-Fi 卡片写入成功！';

  @override
  String toastNfcWifiReadSuccess(String ssid) {
    return '已成功读取 Wi-Fi \"$ssid\"！可直接写入新卡。';
  }

  @override
  String get nfcBtn => '写入 NFC 卡片';

  @override
  String get nfcBtnWriteAnother => '写入下一张';

  @override
  String get nfcTitleReady => '准备写入';

  @override
  String get nfcDescReady => '将手机贴近NFC卡以写入链接。';

  @override
  String get nfcTitleReadReady => '准备读取卡片';

  @override
  String get nfcDescReadReady => '将手机贴近卡片以读取链接。';

  @override
  String get nfcTitlePermLockReady => '准备锁定';

  @override
  String get nfcDescPermLockReady => '将手机贴近卡片以应用永久只读锁定。';

  @override
  String get nfcTitlePwdLockReady => '准备锁定';

  @override
  String get nfcDescPwdLockReady => '将手机贴近卡片以设置PIN码...';

  @override
  String get nfcTitlePwdUnlockReady => '准备解锁';

  @override
  String get nfcDescPwdUnlockReady => '将手机贴近卡片以解锁...';

  @override
  String get pwdModalTitle => '卡片保护';

  @override
  String get pwdModalTitleLock => '锁定卡片';

  @override
  String get pwdModalTitleUnlock => '解锁卡片';

  @override
  String get pwdModalDesc => '设置PIN码以保护卡片';

  @override
  String get pwdModalDescLock => '设置PIN码以保护卡片';

  @override
  String get pwdModalDescUnlock => '输入PIN码以解锁卡片';

  @override
  String get pwdHintText => '推荐使用4位数字';

  @override
  String get pwdInfoToast => '推荐使用4位数字';

  @override
  String get pwdPlaceholder => '输入PIN码...';

  @override
  String get pwdTabLock => '锁定';

  @override
  String get pwdTabUnlock => '解锁';

  @override
  String get pwdSubmitLock => '锁定卡片';

  @override
  String get pwdSubmitUnlock => '解锁卡片';

  @override
  String get pwdCancel => '取消';

  @override
  String get toastEnterPwd => '请输入PIN码';

  @override
  String get permLockTitle => '永久锁定';

  @override
  String get permLockDesc => '警告：卡片将永久变为只读状态，无法再修改或清除。';

  @override
  String get permLockConfirmBtn => '确认永久锁定';

  @override
  String get permLockCancelBtn => '取消';

  @override
  String get toastNfcReadSuccess => '已成功读取并载入链接';

  @override
  String get toastNfcReadEmpty => '此卡片中未发现有效链接';

  @override
  String get toastNfcPermLockSuccess => '卡片已永久锁定为只读状态';

  @override
  String get toastNfcPwdLockSuccess => '已成功为卡片设置PIN码锁定';

  @override
  String get toastNfcPwdUnlockSuccess => '卡片解锁成功';

  @override
  String get toastNfcWrongPwd => 'PIN码错误或解锁失败';

  @override
  String get toastNfcPwdUnsupported => '此卡片不支持PIN码保护';

  @override
  String get toastNfcAlreadyUnlocked => '卡片未处于锁定状态';

  @override
  String get toastNfcAlreadyLocked => '卡片已有PIN码保护，更改前请先解锁。';

  @override
  String get nfcTitleSuccess => '写入成功！';

  @override
  String get nfcDescSuccess => '卡片已成功写入数据。';

  @override
  String get nfcTitleNext => '准备写入';

  @override
  String get nfcDescNext => '请贴近下一张卡片，或点击完成。';

  @override
  String nfcCardsCount(int count) {
    return '已写入卡片：$count';
  }

  @override
  String get nfcCancel => '取消';

  @override
  String get nfcDone => '完成';

  @override
  String get nfcOk => '确定';

  @override
  String get nfcBtnLockAnother => '锁定下一张';

  @override
  String get nfcBtnUnlockAnother => '解锁下一张';

  @override
  String get nfcTitlePwdLockSuccess => '卡片已锁定';

  @override
  String get nfcDescPwdLockSuccess => '卡片已受保护，防止被意外修改。';

  @override
  String get nfcTitlePwdUnlockSuccess => '卡片已解锁';

  @override
  String get nfcDescPwdUnlockSuccess => '卡片现在可以写入或修改。';

  @override
  String get nfcTitleAlreadyUnlocked => '卡片未锁定';

  @override
  String get nfcDescAlreadyUnlocked => '此卡片本来就未处于锁定状态。';

  @override
  String get nfcTitleTagLost => '连接中断';

  @override
  String get nfcDescTagLost => '请将手机平稳对准卡片中心。';

  @override
  String get nfcTitleLocked => '卡片受保护';

  @override
  String get nfcTitleReadLocked => '卡片读取受保护';

  @override
  String get nfcDescReadLocked => '卡片数据已受保护，无法直接读取。';

  @override
  String get nfcTitleWrongPwd => 'PIN码错误';

  @override
  String get nfcTitleAlreadyLocked => '卡片已锁定';

  @override
  String get nfcTitleCapacity => '超出容量';

  @override
  String get nfcTitleEmptyTag => '空白卡片';

  @override
  String get nfcTitlePermLockSuccess => '卡片已永久锁定';

  @override
  String get nfcDescPermLockSuccess => '卡片已被永久设为只读模式。';

  @override
  String get nfcTitlePermLockStandby => '卡片已永久锁定！';

  @override
  String get nfcDescPermLockStandby => '安全保护已暂停。点击图标重新激活。';

  @override
  String nfcPermLockCount(int count) {
    return '已锁定：$count';
  }

  @override
  String nfcEraseCount(int count) {
    return '已清除：$count';
  }

  @override
  String get nfcTitleCannotLock => '无法锁定';

  @override
  String get nfcDescCannotLock => '卡片已是只读状态或不支持此操作。';

  @override
  String get nfcBackToPin => '返回';

  @override
  String get nfcTitleDisabled => 'NFC 已关闭';

  @override
  String get nfcTitleNoHardware => '不支持 NFC';

  @override
  String get nfcTitleOpFailed => '操作失败';

  @override
  String get nfcDescOpFailed => '操作失败。请保持手机平稳并重试。';

  @override
  String get nfcTitleError => '写入失败';

  @override
  String get nfcDescLocked => '卡片已受密码保护或为只读。请先解锁。';

  @override
  String get nfcDescCapacity => '数据大小超出了卡片容量。';

  @override
  String get nfcDescUnsupported => '不支持此类 NFC 卡片。';

  @override
  String get nfcDescGenericError => '写入失败。请将手机稳定贴在卡片上。';

  @override
  String get nfcRetryBtn => '重试';

  @override
  String get nfcNoHardware => '此设备不支持 NFC 功能';

  @override
  String get nfcDisabled => '请在系统设置中开启 NFC';

  @override
  String get nfcLocked => 'NFC 卡片已锁定或为只读';

  @override
  String get nfcCapacity => 'NFC 卡片存储空间不足';

  @override
  String get nfcUnsupported => '不支持的 NFC 卡片类型';

  @override
  String get nfcWriteFailed => '写入 NFC 标签失败，请重试。';

  @override
  String get toastPasteFirst => '请先粘贴链接';

  @override
  String get toastInvalid => '未能提取地点识别码';

  @override
  String get toastNoInternet => '无网络连接';

  @override
  String get toastSuccess => '链接转换成功';

  @override
  String get toastNfcWritten => '成功写入 NFC 卡片';

  @override
  String toastNfcBatchSuccess(int count) {
    return '成功写入 $count 张 NFC 卡片';
  }

  @override
  String get toastCleared => '内容已清空';

  @override
  String get toastPasted => '已从剪贴板粘贴';

  @override
  String get toastEmptyClip => '剪贴板为空';

  @override
  String get toastClipDenied => '请按 Ctrl+V 粘贴';

  @override
  String get toastCopied => '评价链接已复制';

  @override
  String get toastShareCopied => '链接已复制，可直接分享';

  @override
  String get shareTitle => 'Google 评价';

  @override
  String get shareText => '在 Google 地图上为我们留下评价';

  @override
  String get toastHourlyLimit => '已达到每小时搜索上限';

  @override
  String get toastSelectSuccess => '链接已生成';

  @override
  String get updateAvailable => '发现新版本';

  @override
  String get updateReadyTitle => '新版本已就绪';

  @override
  String get updateCurrent => '当前版本';

  @override
  String get updateNew => '最新版本';

  @override
  String updateSize(String size) {
    return '大小：$size';
  }

  @override
  String updateDate(String date) {
    return '发布日期：$date';
  }

  @override
  String get updateHighlights => '版本更新内容';

  @override
  String get updateInstallBtn => '安装更新';

  @override
  String get updateViewGithub => '查看更新日志';

  @override
  String get updateLater => '稍后';

  @override
  String get toastCheckingUpdate => '正在检查更新...';

  @override
  String toastUpToDate(String version) {
    return '已是最新版本 ($version)';
  }

  @override
  String toastUpdateFound(String version) {
    return '发现新版本 $version！';
  }

  @override
  String get toastUpdateError => '暂时无法检查更新';

  @override
  String get toastDownloadStarted => '正在后台下载更新...';

  @override
  String get toastQrSaveError => '保存二维码失败';

  @override
  String get eraseModalTitle => '清除卡片';

  @override
  String get eraseModalDesc => '所有数据将被清空并恢复为空白卡。锁定状态不受影响。';

  @override
  String get eraseConfirmBtn => '确认清除';

  @override
  String get eraseCancelBtn => '取消';

  @override
  String get nfcTitleEraseReady => '准备清除';

  @override
  String get nfcDescEraseReady => '将手机贴近卡片以清除数据...';

  @override
  String get nfcTitleEraseSuccess => '卡片已清除！';

  @override
  String get nfcDescEraseSuccess => '卡片现已清空，可重新使用。';

  @override
  String get nfcBtnEraseAnother => '清除下一张';

  @override
  String get toastNfcEraseSuccess => '卡片数据清除成功';

  @override
  String get githubProjectBtn => 'GitHub';

  @override
  String get githubSupportBtn => '支持';

  @override
  String get toastSupportComingSoon => '支持选项即将推出';

  @override
  String get settingsThemeLabel => '外观主题';

  @override
  String get settingsThemeSub => '选择您喜爱的应用主题';

  @override
  String get settingsThemeSystem => '跟随系统';

  @override
  String get settingsThemeDark => '深色';

  @override
  String get settingsThemeLight => '浅色';
}
