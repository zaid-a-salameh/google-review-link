import 'package:flutter/material.dart';

abstract final class AppColors {
  static bool isLight = false;

  // Obsidian / Alabaster Base Surfaces
  static Color get bg =>
      isLight ? const Color(0xFFF6F5F2) : const Color(0xFF0C0A09);
  static Color get cardGradTop =>
      isLight ? const Color(0xFAFFFFFF) : const Color(0xF51F1C1A);
  static Color get cardGradBottom =>
      isLight ? const Color(0xF7FAF9F7) : const Color(0xF5151312);
  static Color get modalGradTop =>
      isLight ? const Color(0xFFFFFFFF) : const Color(0xFC1E1B19);
  static Color get modalGradBottom =>
      isLight ? const Color(0xFFFAF9F6) : const Color(0xFC141211);
  static Color get inputBg =>
      isLight ? const Color(0xFFF0EEEA) : const Color(0xE0110F0E);
  static Color get pillTrackBg =>
      isLight ? const Color(0xFFE9E6E1) : const Color(0xE00A0908);
  static Color get surfaceDark =>
      isLight ? const Color(0xFFEFECE7) : const Color(0xFF141110);

  // Subtle Button & Container Fills
  static Color get subtleButtonBg =>
      isLight ? const Color(0x11000000) : const Color(0x14FFFFFF);
  static Color get topBarButtonBg =>
      isLight ? const Color(0xE6FFFFFF) : const Color(0xCC191615);
  static Color get secondaryBtnBg =>
      isLight ? const Color(0xFFF1EFEA) : const Color(0xB3221F1D);
  static Color get dockButtonBg =>
      isLight ? const Color(0xF2FFFFFF) : const Color(0xD9171413);
  static Color get urlBoxBg =>
      isLight ? const Color(0xFFEFECE6) : const Color(0xD90A0807);
  static Color get dropdownMenuBg =>
      isLight ? const Color(0xFCFFFFFF) : const Color(0xE6141110);
  static Color get toastBg =>
      isLight ? const Color(0xFAFFFFFF) : const Color(0xF51B1817);
  static Color get modalBarrier =>
      isLight ? const Color(0x8A1C1917) : const Color(0xC2060505);

  // Borders & Glass Highlights
  static Color get borderGlass =>
      isLight ? const Color(0x18000000) : const Color(0x17FFFFFF);
  static Color get borderLight =>
      isLight ? const Color(0x287C3AED) : const Color(0x29A78BFA);

  // Typography Hierarchy
  static Color get textPrimary =>
      isLight ? const Color(0xFF1C1917) : const Color(0xFFFAFAF9);
  static Color get textSub =>
      isLight ? const Color(0xFF57534E) : const Color(0xFFB5B0AC);
  static Color get textMuted =>
      isLight ? const Color(0xFF78716C) : const Color(0xFF7D7772);

  // Primary Brand Violet
  static const Color primary = Color(0xFF8B5CF6);
  static const Color primaryDark = Color(0xFF7C3AED);
  static Color get primaryLight =>
      isLight ? const Color(0xFF7C3AED) : const Color(0xFFA78BFA);
  static const Color primarySoft = Color(0xFFC4B5FD);

  // Semantic Accents
  static const Color success = Color(0xFF10B981);
  static const Color successDark = Color(0xFF059669);
  static Color get successLight =>
      isLight ? const Color(0xFF059669) : const Color(0xFF34D399);

  static const Color danger = Color(0xFFEF4444);
  static const Color dangerDark = Color(0xFFDC2626);
  static Color get dangerLight =>
      isLight ? const Color(0xFFDC2626) : const Color(0xFFF87171);

  static const Color amberWifi = Color(0xFFF59E0B);
  static const Color amberWifiDark = Color(0xFFD97706);
  static Color get amberWifiLight =>
      isLight ? const Color(0xFFD97706) : const Color(0xFFFBBF24);

  static const Color skyLocation = Color(0xFF0EA5E9);
  static const Color skyLocationDark = Color(0xFF0284C7);
  static Color get skyLocationLight =>
      isLight ? const Color(0xFF0284C7) : const Color(0xFF38BDF8);

  static const Color pinkLock = Color(0xFFF43F5E);
  static const Color pinkLockDark = Color(0xFFE11D48);
  static const Color pinkLockDeep = Color(0xFFBE123C);

  // Reusable Gradients
  static LinearGradient get cardGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[cardGradTop, cardGradBottom],
      );

  static LinearGradient get modalGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: <Color>[modalGradTop, modalGradBottom],
      );

  static const LinearGradient primaryGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[primaryDark, primary],
  );

  static LinearGradient get nfcWriteButtonGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isLight
            ? const <Color>[Color(0xFF7C3AED), Color(0xFF8B5CF6)]
            : const <Color>[Color(0x617C3AED), Color(0x3D8B5CF6)],
      );

  static const LinearGradient wifiAmberGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[amberWifi, amberWifiLightConst],
  );
  static const Color amberWifiLightConst = Color(0xFFFBBF24);

  static const LinearGradient pinkLockGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[pinkLock, pinkLockDark],
  );

  static const LinearGradient dangerPermGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[pinkLockDark, pinkLockDeep],
  );

  static const LinearGradient emeraldUnlockGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: <Color>[success, successDark],
  );

  static LinearGradient get reviewPillGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isLight
            ? const <Color>[Color(0xFF7C3AED), Color(0xFF8B5CF6)]
            : const <Color>[Color(0x528B5CF6), Color(0x387C3AED)],
      );

  static LinearGradient get locationPillGradient => LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: isLight
            ? const <Color>[Color(0xFF0284C7), Color(0xFF0EA5E9)]
            : const <Color>[Color(0x520EA5E9), Color(0x380284C7)],
      );
}
