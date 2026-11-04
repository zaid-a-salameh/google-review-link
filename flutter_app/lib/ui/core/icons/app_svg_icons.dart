import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

abstract final class AppSvgIcons {
  static String _hex(Color c) {
    final r = (c.r * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0');
    final g = (c.g * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0');
    final b = (c.b * 255.0).round().clamp(0, 255).toRadixString(16).padLeft(2, '0');
    return '#$r$g$b';
  }

  static Widget _singlePath(
    String d, {
    double size = 20,
    Color color = Colors.white,
  }) {
    final hex = _hex(color);
    return SvgPicture.string(
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">'
      '<path fill="$hex" d="$d"/>'
      '</svg>',
      width: size,
      height: size,
    );
  }

  static Widget appLogo({double size = 30}) {
    return SvgPicture.string(
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">'
      '<path fill="#FFFFFF" d="M10.8 1.8L3 12.5H8.2L5.8 22.2L14.2 10.5H9.5L11.8 1.8Z"/>'
      '<path d="M15.2 6.2C16.8 7.6 17.6 9.4 17.6 11.6C17.6 13.8 16.8 15.6 15.2 17" stroke="#FFFFFF" stroke-width="2" stroke-linecap="round" fill="none"/>'
      '<path d="M18.2 3.2C20.7 5.3 21.8 8.2 21.8 11.6C21.8 15 20.7 17.9 18.2 20" stroke="#FFFFFF" stroke-width="2" stroke-linecap="round" fill="none"/>'
      '</svg>',
      width: size,
      height: size,
    );
  }

  static Widget helpQuestion({double size = 18, Color color = Colors.white}) =>
      _singlePath(
        'M11 18h2v-2h-2v2zm1-16C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8s3.59-8 8-8 8 3.59 8 8-3.59 8-8 8zm0-14c-2.21 0-4 1.79-4 4h2c0-1.1.9-2 2-2s2 .9 2 2c0 2-3 1.75-3 5h2c0-2.25 3-2.5 3-5 0-2.21-1.79-4-4-4z',
        size: size,
        color: color,
      );

  static Widget settingsGear({double size = 20, Color color = Colors.white}) =>
      _singlePath(
        'M19.14 12.94c.04-.3.06-.61.06-.94 0-.32-.02-.64-.07-.94l2.03-1.58c.18-.14.23-.41.12-.61l-1.92-3.32c-.12-.22-.37-.29-.59-.22l-2.39.96c-.5-.38-1.03-.7-1.62-.94l-.36-2.54c-.04-.24-.24-.41-.48-.41h-3.84c-.24 0-.43.17-.47.41l-.36 2.54c-.59.24-1.13.57-1.62.94l-2.39-.96c-.22-.08-.47 0-.59.22L2.74 8.87c-.12.21-.08.47.12.61l2.03 1.58c-.05.3-.09.63-.09.94s.02.64.07.94l-2.03 1.58c-.18.14-.23.41-.12.61l1.92 3.32c.12.22.37.29.59.22l2.39-.96c.5.38 1.03.7 1.62.94l.36 2.54c.05.24.24.41.48.41h3.84c.24 0 .44-.17.47-.41l.36-2.54c.59-.24 1.13-.56 1.62-.94l2.39.96c.22.08.47 0 .59-.22l1.92-3.32c.12-.22.07-.47-.12-.61l-2.01-1.58zM12 15.6c-1.98 0-3.6-1.62-3.6-3.6s1.62-3.6 3.6-3.6 3.6 1.62 3.6 3.6-1.62 3.6-3.6 3.6z',
        size: size,
        color: color,
      );

  static Widget linkChain({double size = 18, Color color = Colors.white}) =>
      _singlePath(
        'M3.9 12c0-1.71 1.39-3.1 3.1-3.1h4V7H7c-2.76 0-5 2.24-5 5s2.24 5 5 5h4v-1.9H7c-1.71 0-3.1-1.39-3.1-3.1zM8 13h8v-2H8v2zm9-6h-4v1.9h4c1.71 0 3.1 1.39 3.1 3.1s-1.39 3.1-3.1 3.1h-4V17h4c2.76 0 5-2.24 5-5s-2.24-5-5-5z',
        size: size,
        color: color,
      );

  static Widget searchMagnifier({double size = 18, Color color = Colors.white}) =>
      _singlePath(
        'M15.5 14h-.79l-.28-.27A6.471 6.471 0 0 0 16 9.5 6.5 6.5 0 1 0 9.5 16c1.61 0 3.09-.59 4.23-1.57l.27.28v.79l5 4.99L20.49 19l-4.99-5zm-6 0C7.01 14 5 11.99 5 9.5S7.01 5 9.5 5 14 7.01 14 9.5 11.99 14 9.5 14z',
        size: size,
        color: color,
      );

  static Widget trash({double size = 18, Color color = Colors.white}) =>
      _singlePath(
        'M6 19c0 1.1.9 2 2 2h8c1.1 0 2-.9 2-2V7H6v12zM19 4h-3.5l-1-1h-5l-1 1H5v2h14V4z',
        size: size,
        color: color,
      );

  static Widget clipboardPaste({double size = 16, Color color = Colors.white}) =>
      _singlePath(
        'M19 2h-4.18C14.4.84 13.3 0 12 0c-1.3 0-2.4.84-2.82 2H5c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h14c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm-7 0c.55 0 1 .45 1 1s-.45 1-1 1-1-.45-1-1 .45-1 1-1zm7 18H5V4h2v3h10V4h2v16z',
        size: size,
        color: color,
      );

  static Widget readScanner({double size = 22, Color color = Colors.white}) {
    final hex = _hex(color);
    return SvgPicture.string(
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">'
      '<path fill="$hex" d="M3 5v4h2V5h4V3H5c-1.1 0-2 .9-2 2zm2 10H3v4c0 1.1.9 2 2 2h4v-2H5v-4zm14 4h-4v2h4c1.1 0 2-.9 2-2v-4h-2v4zm0-16h-4v2h4v4h2V5c0-1.1-.9-2-2-2z"/>'
      '<path fill="$hex" d="M8.8 10.65a1.35 1.35 0 1 0 0 2.7 1.35 1.35 0 1 0 0-2.7zm1.96-.96a.85.85 0 0 1 1.33-1.05 5.45 5.45 0 0 1 0 6.72.85.85 0 0 1-1.33-1.05 3.75 3.75 0 0 0 0-4.62zm2.44-1.91a.85.85 0 0 1 1.34-1.05 8.55 8.55 0 0 1 0 10.54.85.85 0 0 1-1.34-1.05 6.85 6.85 0 0 0 0-8.44z"/>'
      '</svg>',
      width: size,
      height: size,
    );
  }

  static Widget wifiWaves({double size = 22, Color color = Colors.white}) =>
      _singlePath(
        'M12 4C7.31 4 3.07 5.9 0 8.98L12 21 24 8.98A16.88 16.88 0 0 0 12 4zm0 2.9c3.8 0 7.27 1.41 9.94 3.73L12 18.59 2.06 10.63A14.88 14.88 0 0 1 12 6.9zM12 10c-2.48 0-4.73.91-6.47 2.41L12 19.58l6.47-7.17A9.87 9.87 0 0 0 12 10z',
        size: size,
        color: color,
      );

  static Widget lockClosed({double size = 22, Color color = Colors.white}) =>
      _singlePath(
        'M18 8h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm-6 9c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2zm3.1-9H8.9V6c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2z',
        size: size,
        color: color,
      );

  static Widget lockOpen({double size = 22, Color color = Colors.white}) =>
      _singlePath(
        'M12 17c1.1 0 2-.9 2-2s-.9-2-2-2-2 .9-2 2 .9 2 2 2zm6-9h-1V6c0-2.76-2.24-5-5-5S7 3.24 7 6h1.9c0-1.71 1.39-3.1 3.1-3.1 1.71 0 3.1 1.39 3.1 3.1v2H6c-1.1 0-2 .9-2 2v10c0 1.1.9 2 2 2h12c1.1 0 2-.9 2-2V10c0-1.1-.9-2-2-2zm0 12H6V10h12v10z',
        size: size,
        color: color,
      );

  static Widget shieldPermLock({double size = 22, Color color = Colors.white}) =>
      _singlePath(
        'M12 1L3 5v6c0 5.55 3.84 10.74 9 12 5.16-1.26 9-6.45 9-12V5l-9-4zm0 10.99h7c-.53 4.12-3.28 7.79-7 8.94V12H5V6.3l7-3.11v8.8z',
        size: size,
        color: color,
      );

  static Widget nfcTagSquare({double size = 20, Color color = Colors.white}) =>
      _singlePath(
        'M20 2H4c-1.1 0-2 .9-2 2v16c0 1.1.9 2 2 2h16c1.1 0 2-.9 2-2V4c0-1.1-.9-2-2-2zm0 18H4V4h16v16zM18 6h-5c-1.1 0-2 .9-2 2v2.15c-.47-.09-.97-.15-1.5-.15-3.03 0-5.5 2.47-5.5 5.5s2.47 5.5 5.5 5.5c3.03 0 5.5-2.47 5.5-5.5V10h3V6zm-8.5 13c-1.93 0-3.5-1.57-3.5-3.5s1.57-3.5 3.5-3.5 3.5 1.57 3.5 3.5-1.57 3.5-3.5 3.5z',
        size: size,
        color: color,
      );

  static Widget nfcSensorWaves({double size = 34, Color color = Colors.white}) {
    final hex = _hex(color);
    return SvgPicture.string(
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 24 24">'
      '<path fill="$hex" d="M4.5 10.5C3.67 10.5 3 11.17 3 12s.67 1.5 1.5 1.5S6 12.83 6 12s-.67-1.5-1.5-1.5zm4.8 0c-.83 0-1.5.67-1.5 1.5s.67 1.5 1.5 1.5 1.5-.67 1.5-1.5-.67-1.5-1.5-1.5zm4.8 0c-.83 0-1.5.67-1.5 1.5s.67 1.5 1.5 1.5 1.5-.67 1.5-1.5-.67-1.5-1.5-1.5zm4.8 0c-.83 0-1.5.67-1.5 1.5s.67 1.5 1.5 1.5 1.5-.67 1.5-1.5-.67-1.5-1.5-1.5z"/>'
      '<path fill="$hex" d="M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm0 18c-4.41 0-8-3.59-8-8 0-.55.45-1 1-1s1 .45 1 1c0 3.31 2.69 6 6 6s6-2.69 6-6c0-.55.45-1 1-1s1 .45 1 1c0 4.41-3.59 8-8 8z"/>'
      '</svg>',
      width: size,
      height: size,
    );
  }

  static Widget openExternal({double size = 18, Color color = Colors.white}) =>
      _singlePath(
        'M19 19H5V5h7V3H5c-1.11 0-2 .9-2 2v14c0 1.1.89 2 2 2h14c1.1 0 2-.9 2-2v-7h-2v7zM14 3v2h3.59l-9.83 9.83 1.41 1.41L19 6.41V10h2V3h-7z',
        size: size,
        color: color,
      );

  static Widget copyIcon({double size = 18, Color color = Colors.white}) =>
      _singlePath(
        'M16 1H4c-1.1 0-2 .9-2 2v14h2V3h12V1zm3 4H8c-1.1 0-2 .9-2 2v14c0 1.1.9 2 2 2h11c1.1 0 2-.9 2-2V7c0-1.1-.9-2-2-2zm0 16H8V7h11v14z',
        size: size,
        color: color,
      );

  static Widget shareNodes({double size = 18, Color color = Colors.white}) =>
      _singlePath(
        'M18 16.08c-.76 0-1.44.3-1.96.77L8.91 12.7c.05-.23.09-.46.09-.7s-.04-.47-.09-.7l7.05-4.11c.54.5 1.25.81 2.04.81 1.66 0 3-1.34 3-3s-1.34-3-3-3-3 1.34-3 3c0 .24.04.47.09.7L8.04 9.81C7.5 9.31 6.79 9 6 9c-1.66 0-3 1.34-3 3s1.34 3 3 3c.79 0 1.5-.31 2.04-.81l7.12 4.16c-.05.21-.08.43-.08.65 0 1.61 1.31 2.92 2.92 2.92s2.92-1.31 2.92-2.92-1.31-2.92-2.92-2.92z',
        size: size,
        color: color,
      );

  static Widget qrGrid({double size = 18, Color color = Colors.white}) =>
      _singlePath(
        'M3 3h8v8H3V3zm2 2v4h4V5H5zm8-2h8v8h-8V3zm2 2v4h4V5h-4zM3 13h8v8H3v-8zm2 2v4h4v-4H5zm13-2h3v2h-3v-2zm-5 0h2v3h-2v-3zm2 3h3v2h-3v-2zm3 3h3v3h-3v-3zm-3 0h2v3h-2v-3zm-2-3h2v3h-2v-3z',
        size: size,
        color: color,
      );

  static Widget githubOctocat({double size = 19, Color color = Colors.white}) =>
      _singlePath(
        'M12 0C5.37 0 0 5.37 0 12c0 5.31 3.435 9.795 8.205 11.385.6.105.825-.255.825-.57 0-.285-.015-1.23-.015-2.235-3.015.555-3.795-.735-4.035-1.41-.135-.345-.72-1.41-1.23-1.695-.42-.225-1.02-.78-.015-.795.945-.015 1.62.87 1.845 1.23 1.08 1.815 2.805 1.305 3.495.99.105-.78.42-1.305.765-1.605-2.67-.3-5.46-1.335-5.46-5.925 0-1.305.465-2.385 1.23-3.225-.12-.3-.54-1.53.12-3.18 0 0 1.005-.315 3.3 1.23.96-.27 1.98-.405 3-.405s2.04.135 3 .405c2.295-1.56 3.3-1.23 3.3-1.23.66 1.65.24 2.88.12 3.18.765.84 1.23 1.905 1.23 3.225 0 4.605-2.805 5.625-5.475 5.925.435.375.81 1.095.81 2.22 0 1.605-.015 2.895-.015 3.3 0 .315.225.69.825.57A12.02 12.02 0 0024 12c0-6.63-5.37-12-12-12z',
        size: size,
        color: color,
      );

  static Widget heartSponsor({double size = 18, Color color = Colors.white}) =>
      _singlePath(
        'M12 21.35l-1.45-1.32C5.4 15.36 2 12.28 2 8.5 2 5.42 4.42 3 7.5 3c1.74 0 3.41.81 4.5 2.09C13.09 3.81 14.76 3 16.5 3 19.58 3 22 5.42 22 8.5c0 3.78-3.4 6.86-8.55 11.54L12 21.35z',
        size: size,
        color: color,
      );

  static Widget checkmark({double size = 20, Color color = Colors.white}) =>
      _singlePath(
        'M9 16.17L4.83 12l-1.42 1.41L9 19 21 7l-1.41-1.41L9 16.17z',
        size: size,
        color: color,
      );

  static Widget closeX({double size = 20, Color color = Colors.white}) =>
      _singlePath(
        'M19 6.41L17.59 5 12 10.59 6.41 5 5 6.41 10.59 12 5 17.59 6.41 19 12 13.41 17.59 19 19 17.59 13.41 12z',
        size: size,
        color: color,
      );

  static Widget downloadTray({double size = 18, Color color = Colors.white}) =>
      _singlePath(
        'M19 9h-4V3H9v6H5l7 7 7-7zM5 18v2h14v-2H5z',
        size: size,
        color: color,
      );

  static Widget cloudDownload({double size = 28, Color color = Colors.white}) =>
      _singlePath(
        'M19.35 10.04C18.67 6.59 15.64 4 12 4 9.11 4 6.6 5.64 5.35 8.04 2.34 8.36 0 10.91 0 14c0 3.31 2.69 6 6 6h13c2.76 0 5-2.24 5-5 0-2.64-2.05-4.78-4.65-4.96zM17 13l-5 5-5-5h3V9h4v4h3z',
        size: size,
        color: color,
      );

  static Widget wepKey({double size = 18, Color color = Colors.white}) =>
      _singlePath(
        'M12.65 10C11.83 7.67 9.61 6 7 6c-3.31 0-6 2.69-6 6s2.69 6 6 6c2.61 0 4.83-1.67 5.65-4H17v4h4v-4h2v-4H12.65zM7 14c-1.1 0-2-.9-2-2s.9-2 2-2 2 .9 2 2-.9 2-2 2z',
        size: size,
        color: color,
      );

  static Widget placePin({double size = 17, Color color = Colors.white}) =>
      _singlePath(
        'M12 2C8.13 2 5 5.13 5 9c0 5.25 7 13 7 13s7-7.75 7-13c0-3.87-3.13-7-7-7zm0 9.5c-1.38 0-2.5-1.12-2.5-2.5s1.12-2.5 2.5-2.5 2.5 1.12 2.5 2.5-1.12 2.5-2.5 2.5z',
        size: size,
        color: color,
      );

  static Widget eyeOpen({double size = 19, Color color = Colors.white}) =>
      _singlePath(
        'M12 4.5C7 4.5 2.73 7.61 1 12c1.73 4.39 6 7.5 11 7.5s9.27-3.11 11-7.5c-1.73-4.39-6-7.5-11-7.5zM12 17c-2.76 0-5-2.24-5-5s2.24-5 5-5 5 2.24 5 5-2.24 5-5 5zm0-8c-1.66 0-3 1.34-3 3s1.34 3 3 3 3-1.34 3-3-1.34-3-3-3z',
        size: size,
        color: color,
      );

  static Widget eyeClosed({double size = 19, Color color = Colors.white}) =>
      _singlePath(
        'M12 7c2.76 0 5 2.24 5 5 0 .65-.13 1.26-.36 1.83l2.92 2.92c1.51-1.26 2.7-2.89 3.43-4.75-1.73-4.39-6-7.5-11-7.5-1.4 0-2.74.25-3.98.7l2.16 2.16C10.74 7.13 11.35 7 12 7zM2 4.27l2.28 2.28.46.46C3.08 8.3 1.78 10.02 1 12c1.73 4.39 6 7.5 11 7.5 1.55 0 3.03-.3 4.38-.84l.42.42L19.73 22 21 20.73 3.27 3 2 4.27zM7.53 9.8l1.55 1.55c-.05.21-.08.43-.08.65 0 1.66 1.34 3 3 3 .22 0 .44-.03.65-.08l1.55 1.55c-.67.33-1.41.53-2.2.53-2.76 0-5-2.24-5-5 0-.79.2-1.53.53-2.2zm4.31-.78l3.15 3.15.02-.16c0-1.66-1.34-3-3-3l-.17.01z',
        size: size,
        color: color,
      );

  static Widget retryRefresh({double size = 18, Color color = Colors.white}) =>
      _singlePath(
        'M17.65 6.35C16.2 4.9 14.21 4 12 4c-4.42 0-7.99 3.58-7.99 8s3.57 8 7.99 8c3.73 0 6.84-2.55 7.73-6h-2.08c-.82 2.33-3.04 4-5.65 4-3.31 0-6-2.69-6-6s2.69-6 6-6c1.66 0 3.14.69 4.22 1.78L13 11h7V4l-2.35 2.35z',
        size: size,
        color: color,
      );

  static Widget warningTriangle({
    double size = 28,
    Color color = Colors.white,
  }) =>
      _singlePath(
        'M1 21h22L12 2 1 21zm12-3h-2v-2h2v2zm0-4h-2v-4h2v4z',
        size: size,
        color: color,
      );

  static Widget infoCircle({double size = 15, Color color = Colors.white}) =>
      _singlePath(
        'M12 2C6.48 2 2 6.48 2 12s4.48 10 10 10 10-4.48 10-10S17.52 2 12 2zm1 15h-2v-6h2v6zm0-8h-2V7h2v2z',
        size: size,
        color: color,
      );

  static Widget googleWordmark({double width = 44, double height = 14}) {
    return SvgPicture.string(
      '<svg xmlns="http://www.w3.org/2000/svg" viewBox="0 0 74 24">'
      '<path fill="#4285F4" d="M9.24 9.19v2.45h5.86c-.24 1.37-1.6 4.02-5.86 4.02-3.53 0-6.4-2.91-6.4-6.49 0-3.58 2.87-6.49 6.4-6.49 2.01 0 3.36.86 4.13 1.6l1.94-1.87C13.98 1.15 11.78.25 9.24.25 4.31.25.29 4.28.29 9.17s4.02 8.92 8.95 8.92c5.15 0 8.57-3.62 8.57-8.73 0-.59-.06-1.03-.14-1.47H9.24z"/>'
      '<path fill="#EA4335" d="M23.95 6.36c-3.15 0-5.71 2.45-5.71 5.69 0 3.22 2.56 5.69 5.71 5.69 3.15 0 5.71-2.47 5.71-5.69 0-3.24-2.56-5.69-5.71-5.69zm0 9.13c-1.73 0-3.22-1.42-3.22-3.44 0-2.04 1.49-3.44 3.22-3.44 1.73 0 3.22 1.4 3.22 3.44 0 2.02-1.49 3.44-3.22 3.44z"/>'
      '<path fill="#FBBC05" d="M36.19 6.36c-3.15 0-5.71 2.45-5.71 5.69 0 3.22 2.56 5.69 5.71 5.69 3.15 0 5.71-2.47 5.71-5.69 0-3.24-2.56-5.69-5.71-5.69zm0 9.13c-1.73 0-3.22-1.42-3.22-3.44 0-2.04 1.49-3.44 3.22-3.44 1.73 0 3.22 1.4 3.22 3.44 0 2.02-1.49 3.44-3.22 3.44z"/>'
      '<path fill="#4285F4" d="M48.06 6.36c-3.04 0-5.46 2.47-5.46 5.69 0 3.2 2.42 5.69 5.46 5.69 1.83 0 2.87-.79 3.57-1.62v1.31c0 2.18-1.16 3.34-3.04 3.34-1.53 0-2.49-1.1-2.89-2.02l-2.18.91c.63 1.51 2.3 3.36 5.07 3.36 2.95 0 5.44-1.73 5.44-5.91V6.65h-2.39v1.07c-.7-.84-1.76-1.36-3.58-1.36zm.26 9.13c-1.69 0-3.08-1.42-3.08-3.44 0-2.04 1.39-3.44 3.08-3.44 1.67 0 2.97 1.4 2.97 3.44 0 2.02-1.3 3.44-2.97 3.44z"/>'
      '<path fill="#34A853" d="M55.85.5h2.51v17.25h-2.51z"/>'
      '<path fill="#EA4335" d="M64.71 15.49c-1.29 0-2.19-.59-2.79-1.76l7.65-3.15-.26-.65c-.48-1.31-1.95-3.57-4.9-3.57-2.95 0-5.4 2.31-5.4 5.69 0 3.2 2.43 5.69 5.7 5.69 2.64 0 4.17-1.62 4.8-2.56l-1.97-1.31c-.63.95-1.51 1.62-2.83 1.62zm-.19-7.08c1.01 0 1.87.52 2.15 1.25l-5.15 2.13c0-2.4 1.71-3.38 3-3.38z"/>'
      '</svg>',
      width: width,
      height: height,
    );
  }
}
