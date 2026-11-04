import 'dart:typed_data';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../data/services/hardware_bridge_service.dart';
import '../../../domain/models/toast_message.dart';
import '../../../domain/models/wifi_credentials.dart';
import '../../../l10n/app_localizations.dart';
import '../../core/icons/app_svg_icons.dart';
import '../../core/theme/app_colors.dart';
import '../../core/widgets/morph_dialog.dart';
import '../../core/widgets/pressable_scale.dart';

enum QrModalTheme {
  review,
  wifi,
}

Future<void> showQrCodeModal({
  required BuildContext context,
  required String data,
  required HardwareBridgeService hardwareBridge,
  required void Function(String message, {ToastType type}) onShowToast,
  QrModalTheme theme = QrModalTheme.review,
  String? wifiSsid,
}) {
  return showAppMorphDialog<void>(
    context: context,
    builder: (_) => QrModalDialog(
      data: data,
      theme: theme,
      wifiSsid: wifiSsid,
      hardwareBridge: hardwareBridge,
      onShowToast: onShowToast,
    ),
  );
}

Future<void> showWifiQrCodeModal({
  required BuildContext context,
  required WifiCredentials credentials,
  required HardwareBridgeService hardwareBridge,
  required void Function(String message, {ToastType type}) onShowToast,
}) {
  return showQrCodeModal(
    context: context,
    data: credentials.toWifiQrPayload(),
    theme: QrModalTheme.wifi,
    wifiSsid: credentials.ssid,
    hardwareBridge: hardwareBridge,
    onShowToast: onShowToast,
  );
}

class QrModalDialog extends StatefulWidget {
  const QrModalDialog({
    super.key,
    required this.data,
    required this.hardwareBridge,
    required this.onShowToast,
    this.theme = QrModalTheme.review,
    this.wifiSsid,
  });

  final String data;
  final QrModalTheme theme;
  final String? wifiSsid;
  final HardwareBridgeService hardwareBridge;
  final void Function(String message, {ToastType type}) onShowToast;

  @override
  State<QrModalDialog> createState() => _QrModalDialogState();
}

class _QrModalDialogState extends State<QrModalDialog> {
  bool _saving = false;

  bool get _isWifi => widget.theme == QrModalTheme.wifi;

  Future<Uint8List?> _renderHighResQrPng() async {
    try {
      const totalSize = 1024.0;
      const quietZone = 88.0;
      const qrSize = totalSize - (quietZone * 2);

      final painter = QrPainter(
        data: widget.data,
        version: QrVersions.auto,
        errorCorrectionLevel: QrErrorCorrectLevel.H,
        eyeStyle: const QrEyeStyle(
          eyeShape: QrEyeShape.square,
          color: Color(0xFF0C0A09),
        ),
        dataModuleStyle: const QrDataModuleStyle(
          dataModuleShape: QrDataModuleShape.square,
          color: Color(0xFF0C0A09),
        ),
      );

      final recorder = ui.PictureRecorder();
      final canvas = Canvas(recorder);

      final bgPaint = Paint()..color = Colors.white;
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          const Rect.fromLTWH(0, 0, totalSize, totalSize),
          const Radius.circular(48),
        ),
        bgPaint,
      );

      canvas.save();
      canvas.translate(quietZone, quietZone);
      painter.paint(canvas, const Size(qrSize, qrSize));
      canvas.restore();

      final picture = recorder.endRecording();
      final img = await picture.toImage(totalSize.toInt(), totalSize.toInt());
      final byteData = await img.toByteData(format: ui.ImageByteFormat.png);
      return byteData?.buffer.asUint8List();
    } catch (_) {
      return null;
    }
  }

  Future<void> _handleDownload(AppLocalizations l10n) async {
    if (_saving) return;
    setState(() => _saving = true);

    final pngBytes = await _renderHighResQrPng();
    if (pngBytes == null) {
      if (mounted) {
        setState(() => _saving = false);
        widget.onShowToast(l10n.toastQrSaveError, type: ToastType.error);
      }
      return;
    }

    final sanitizedSsid = (widget.wifiSsid ?? '')
        .replaceAll(RegExp(r'[^A-Za-z0-9_-]'), '_')
        .trim();
    final filename = _isWifi
        ? 'wifi-${sanitizedSsid.isEmpty ? "network" : sanitizedSsid}-qr-${DateTime.now().millisecondsSinceEpoch}.png'
        : 'google-review-qr-${DateTime.now().millisecondsSinceEpoch}.png';

    final ok = await widget.hardwareBridge.saveQrImageBytes(pngBytes, filename);
    if (!mounted) return;
    setState(() => _saving = false);

    if (ok) {
      await widget.hardwareBridge.triggerSuccessHaptic();
      widget.onShowToast(
        _isWifi ? l10n.wifiQrDownloaded : l10n.qrDownloaded,
        type: ToastType.success,
      );
    } else {
      widget.onShowToast(l10n.toastQrSaveError, type: ToastType.error);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final accentColor =
        _isWifi ? AppColors.amberWifiLight : AppColors.primaryLight;
    final borderAccent = _isWifi
        ? AppColors.amberWifi.withValues(alpha: 0.30)
        : AppColors.borderLight;

    return Center(
      child: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Material(
          color: Colors.transparent,
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 380),
            child: Container(
              padding: const EdgeInsets.fromLTRB(22, 24, 22, 20),
              decoration: BoxDecoration(
                gradient: AppColors.modalGradient,
                borderRadius: BorderRadius.circular(30),
                border: Border.all(color: borderAccent, width: 1.1),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: (_isWifi ? AppColors.amberWifi : AppColors.primary)
                        .withValues(alpha: 0.16),
                    blurRadius: 36,
                    spreadRadius: 2,
                  ),
                  BoxShadow(
                    color: AppColors.isLight
                        ? const Color(0x28000000)
                        : const Color(0x99000000),
                    blurRadius: 32,
                    offset: const Offset(0, 16),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 52,
                    height: 52,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: _isWifi
                          ? AppColors.wifiAmberGradient
                          : AppColors.primaryGradient,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: accentColor.withValues(alpha: 0.35),
                          blurRadius: 18,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Center(
                      child: _isWifi
                          ? AppSvgIcons.wifiWaves(
                              size: 24,
                              color: const Color(0xFF140F0A),
                            )
                          : AppSvgIcons.qrGrid(size: 24, color: Colors.white),
                    ),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    _isWifi ? l10n.wifiQrModalTitle : l10n.qrModalTitle,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _isWifi ? l10n.wifiQrModalDesc : l10n.qrModalDesc,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.textSub,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w500,
                      height: 1.4,
                    ),
                  ),
                  if (_isWifi &&
                      widget.wifiSsid != null &&
                      widget.wifiSsid!.trim().isNotEmpty) ...<Widget>[
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.amberWifi.withValues(alpha: 0.14),
                        borderRadius: BorderRadius.circular(999),
                        border: Border.all(
                          color: AppColors.amberWifi.withValues(alpha: 0.34),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          AppSvgIcons.wifiWaves(
                            size: 14,
                            color: AppColors.amberWifiLight,
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              widget.wifiSsid!,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                color: AppColors.amberWifiLight,
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                  const SizedBox(height: 20),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(22),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color(0x4D000000),
                          blurRadius: 18,
                          offset: Offset(0, 8),
                        ),
                      ],
                    ),
                    child: QrImageView(
                      data: widget.data,
                      version: QrVersions.auto,
                      size: 210,
                      backgroundColor: Colors.white,
                      errorCorrectionLevel: QrErrorCorrectLevel.H,
                      eyeStyle: const QrEyeStyle(
                        eyeShape: QrEyeShape.square,
                        color: Color(0xFF0C0A09),
                      ),
                      dataModuleStyle: const QrDataModuleStyle(
                        dataModuleShape: QrDataModuleShape.square,
                        color: Color(0xFF0C0A09),
                      ),
                    ),
                  ),
                  const SizedBox(height: 22),
                  Row(
                    children: <Widget>[
                      Expanded(
                        flex: 6,
                        child: PressableScale(
                          key: const Key('btn_qr_download'),
                          onTap: _saving ? null : () => _handleDownload(l10n),
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 10),
                            decoration: BoxDecoration(
                              gradient: _isWifi
                                  ? AppColors.wifiAmberGradient
                                  : AppColors.primaryGradient,
                              borderRadius: BorderRadius.circular(15),
                              boxShadow: <BoxShadow>[
                                BoxShadow(
                                  color: (_isWifi
                                          ? AppColors.amberWifi
                                          : AppColors.primary)
                                      .withValues(alpha: 0.34),
                                  blurRadius: 14,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: <Widget>[
                                if (_saving)
                                  SizedBox(
                                    width: 17,
                                    height: 17,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2.2,
                                      color: _isWifi
                                          ? const Color(0xFF140F0A)
                                          : Colors.white,
                                    ),
                                  )
                                else
                                  AppSvgIcons.downloadTray(
                                    size: 18,
                                    color: _isWifi
                                        ? const Color(0xFF140F0A)
                                        : Colors.white,
                                  ),
                                const SizedBox(width: 7),
                                Flexible(
                                  child: FittedBox(
                                    fit: BoxFit.scaleDown,
                                    child: Text(
                                      l10n.qrDownloadBtn,
                                      maxLines: 1,
                                      style: TextStyle(
                                        color: _isWifi
                                            ? const Color(0xFF140F0A)
                                            : Colors.white,
                                        fontSize: 13.5,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        flex: 4,
                        child: PressableScale(
                          key: const Key('btn_qr_close'),
                          onTap: () => Navigator.of(context).maybePop(),
                          child: Container(
                            height: 48,
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            decoration: BoxDecoration(
                              color: AppColors.subtleButtonBg,
                              borderRadius: BorderRadius.circular(15),
                              border: Border.all(color: AppColors.borderGlass),
                            ),
                            alignment: Alignment.center,
                            child: FittedBox(
                              fit: BoxFit.scaleDown,
                              child: Text(
                                l10n.qrCloseBtn,
                                maxLines: 1,
                                style: TextStyle(
                                  color: AppColors.textSub,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
