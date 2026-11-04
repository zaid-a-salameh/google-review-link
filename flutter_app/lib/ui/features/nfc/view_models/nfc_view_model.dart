import 'dart:async';
import 'package:flutter/material.dart';

import '../../../../data/services/hardware_bridge_service.dart';
import '../../../../domain/models/nfc_models.dart';
import '../../../../domain/models/wifi_credentials.dart';

class NfcViewModel extends ChangeNotifier {
  NfcViewModel({
    required this._hardwareBridge,
    this.onUrlTagRead,
  }) {
    _eventsSub = _hardwareBridge.nfcEvents.listen(_handleHardwareEvent);
  }

  final HardwareBridgeService _hardwareBridge;
  final Future<void> Function(String url)? onUrlTagRead;

  StreamSubscription<NfcHardwareEvent>? _eventsSub;

  final TextEditingController pinController = TextEditingController();
  final TextEditingController wifiSsidController = TextEditingController();
  final TextEditingController wifiPasswordController = TextEditingController();

  bool _isDialogVisible = false;
  bool get isDialogVisible => _isDialogVisible;

  NfcSubView _subView = NfcSubView.sensor;
  NfcSubView get subView => _subView;

  NfcOperation _operation = NfcOperation.writeUrl;
  NfcOperation get operation => _operation;

  NfcSensorState _sensorState = NfcSensorState.ready;
  NfcSensorState get sensorState => _sensorState;

  String? _successDetail;
  String? get successDetail => _successDetail;

  String? _errorCode;
  String? get errorCode => _errorCode;

  int _writeBatchCount = 0;
  int get writeBatchCount => _writeBatchCount;

  int _permLockBatchCount = 0;
  int get permLockBatchCount => _permLockBatchCount;

  bool get isPermLockStandby => _sensorState == NfcSensorState.permLockStandby;

  int _eraseBatchCount = 0;
  int get eraseBatchCount => _eraseBatchCount;

  bool get isEraseStandby => _sensorState == NfcSensorState.eraseStandby;

  int _permLockThumpTick = 0;
  int get permLockThumpTick => _permLockThumpTick;

  int _errorShakeTick = 0;
  int get errorShakeTick => _errorShakeTick;

  int _wifiCloneMorphTick = 0;
  int get wifiCloneMorphTick => _wifiCloneMorphTick;

  bool _shouldReturnToPinModal = false;
  bool get shouldReturnToPinModal => _shouldReturnToPinModal;

  PinMode _pinMode = PinMode.lock;
  PinMode get pinMode => _pinMode;

  String _pendingUrl = '';
  String _savedPin = '';

  int _wifiStep = 1;
  int get wifiStep => _wifiStep;

  int _wifiStepDirection = 1;
  int get wifiStepDirection => _wifiStepDirection;

  WifiEncryption _wifiEncryption = WifiEncryption.wpa;
  WifiEncryption get wifiEncryption => _wifiEncryption;

  bool _isWifiPasswordObscured = true;
  bool get isWifiPasswordObscured => _isWifiPasswordObscured;

  bool _isWifiDropdownOpen = false;
  bool get isWifiDropdownOpen => _isWifiDropdownOpen;

  bool _isWifiCloneMode = false;
  bool get isWifiCloneMode => _isWifiCloneMode;

  String _pendingWifiSsid = '';
  String get pendingWifiSsid => _pendingWifiSsid;

  String _pendingWifiPassword = '';
  String get pendingWifiPassword => _pendingWifiPassword;

  WifiEncryption _pendingWifiEncryption = WifiEncryption.wpa;
  WifiEncryption get pendingWifiEncryption => _pendingWifiEncryption;

  VoidCallback? _requestCloseDialog;

  void attachDialogCloser(VoidCallback? closer) {
    _requestCloseDialog = closer;
  }

  NfcVisualTheme get visualTheme {
    if (_subView == NfcSubView.wifiWizard) {
      return NfcVisualTheme.wifi;
    }
    if (_subView == NfcSubView.permConfirm ||
        _subView == NfcSubView.eraseConfirm) {
      return NfcVisualTheme.permLock;
    }
    if (_subView == NfcSubView.pin) {
      return _pinMode == PinMode.unlock
          ? NfcVisualTheme.unlock
          : NfcVisualTheme.lock;
    }

    switch (_operation) {
      case NfcOperation.writeWifi:
        return NfcVisualTheme.wifi;
      case NfcOperation.permLock:
      case NfcOperation.erase:
        return NfcVisualTheme.permLock;
      case NfcOperation.pwdLock:
        return NfcVisualTheme.lock;
      case NfcOperation.pwdUnlock:
        return NfcVisualTheme.unlock;
      case NfcOperation.writeUrl:
      case NfcOperation.read:
        return NfcVisualTheme.link;
    }
  }

  WifiCredentials resolveEffectiveWifiCredentials() {
    final ssid = (_pendingWifiSsid.isNotEmpty
            ? _pendingWifiSsid
            : wifiSsidController.text)
        .trim();
    var pass = _pendingWifiPassword.isNotEmpty
        ? _pendingWifiPassword.trim()
        : wifiPasswordController.text.trim();
    var enc = _wifiEncryption;
    if (enc == WifiEncryption.open || pass.isEmpty) {
      enc = WifiEncryption.open;
      pass = '';
    }
    return WifiCredentials(
      ssid: ssid,
      password: pass,
      encryption: enc,
    );
  }

  // ---- Entry Points ----

  Future<void> prepareWriteUrl(String url) async {
    _isDialogVisible = true;
    _subView = NfcSubView.sensor;
    _operation = NfcOperation.writeUrl;
    _pendingUrl = url;
    _writeBatchCount = 0;
    _successDetail = null;
    _errorCode = null;
    _shouldReturnToPinModal = false;
    _isWifiCloneMode = false;
    _sensorState = NfcSensorState.ready;
    notifyListeners();

    final started = await _hardwareBridge.startNfcWrite(url);
    if (!started) {
      _setSensorError('NO_HARDWARE');
    }
  }

  Future<void> prepareReadCard() async {
    _isDialogVisible = true;
    _subView = NfcSubView.sensor;
    _operation = NfcOperation.read;
    _writeBatchCount = 0;
    _successDetail = null;
    _errorCode = null;
    _shouldReturnToPinModal = false;
    _isWifiCloneMode = false;
    _sensorState = NfcSensorState.readReady;
    notifyListeners();

    final started = await _hardwareBridge.startNfcRead();
    if (!started) {
      _setSensorError('NO_HARDWARE');
    }
  }

  void preparePinProtection() {
    _isDialogVisible = true;
    _subView = NfcSubView.pin;
    _pinMode = PinMode.lock;
    pinController.clear();
    _savedPin = '';
    _writeBatchCount = 0;
    _successDetail = null;
    _errorCode = null;
    _shouldReturnToPinModal = false;
    notifyListeners();
  }

  void setPinMode(PinMode mode) {
    if (_pinMode == mode) return;
    _pinMode = mode;
    unawaited(_hardwareBridge.triggerLightHaptic());
    notifyListeners();
  }

  Future<bool> submitPinForm() async {
    final pin = pinController.text.trim();
    if (pin.isEmpty) {
      return false;
    }
    _savedPin = pin;
    _shouldReturnToPinModal = true;
    _writeBatchCount = 0;
    _successDetail = null;
    _errorCode = null;
    _subView = NfcSubView.sensor;

    if (_pinMode == PinMode.lock) {
      _operation = NfcOperation.pwdLock;
      _sensorState = NfcSensorState.pwdLockReady;
      notifyListeners();
      final started = await _hardwareBridge.startNfcPasswordLock(pin);
      if (!started) _setSensorError('NO_HARDWARE');
    } else {
      _operation = NfcOperation.pwdUnlock;
      _sensorState = NfcSensorState.pwdUnlockReady;
      notifyListeners();
      final started = await _hardwareBridge.startNfcPasswordUnlock(pin);
      if (!started) _setSensorError('NO_HARDWARE');
    }
    return true;
  }

  void preparePermLockConfirm() {
    _isDialogVisible = true;
    _subView = NfcSubView.permConfirm;
    _operation = NfcOperation.permLock;
    _permLockBatchCount = 0;
    _successDetail = null;
    _errorCode = null;
    _shouldReturnToPinModal = false;
    notifyListeners();
  }

  Future<void> confirmAndStartPermLock({bool preserveCount = false}) async {
    _subView = NfcSubView.sensor;
    _operation = NfcOperation.permLock;
    if (!preserveCount) {
      _permLockBatchCount = 0;
    }
    _successDetail = null;
    _errorCode = null;
    _sensorState = NfcSensorState.permLockReady;
    notifyListeners();

    final started = await _hardwareBridge.startNfcPermanentLock();
    if (!started) {
      _setSensorError('NO_HARDWARE');
    }
  }

  Future<void> rearmSequentialPermLock() async {
    if (!isPermLockStandby || _operation != NfcOperation.permLock) return;
    await _hardwareBridge.triggerLightHaptic();
    await confirmAndStartPermLock(preserveCount: true);
  }

  void prepareEraseConfirm() {
    _isDialogVisible = true;
    _subView = NfcSubView.eraseConfirm;
    _operation = NfcOperation.erase;
    _eraseBatchCount = 0;
    _successDetail = null;
    _errorCode = null;
    _shouldReturnToPinModal = false;
    notifyListeners();
  }

  Future<void> confirmAndStartErase({bool preserveCount = false}) async {
    _subView = NfcSubView.sensor;
    _operation = NfcOperation.erase;
    if (!preserveCount) {
      _eraseBatchCount = 0;
    }
    _successDetail = null;
    _errorCode = null;
    _sensorState = NfcSensorState.eraseReady;
    notifyListeners();

    final started = await _hardwareBridge.startNfcErase();
    if (!started) {
      _setSensorError('NO_HARDWARE');
    }
  }

  Future<void> rearmSequentialErase() async {
    if (!isEraseStandby || _operation != NfcOperation.erase) return;
    await _hardwareBridge.triggerLightHaptic();
    await confirmAndStartErase(preserveCount: true);
  }

  void prepareWifiWizard() {
    _isDialogVisible = true;
    _subView = NfcSubView.wifiWizard;
    _operation = NfcOperation.writeWifi;
    _wifiStep = 1;
    _wifiStepDirection = 1;
    _wifiEncryption = WifiEncryption.wpa;
    _isWifiPasswordObscured = true;
    _isWifiDropdownOpen = false;
    _isWifiCloneMode = false;
    _pendingWifiSsid = '';
    _pendingWifiPassword = '';
    _pendingWifiEncryption = WifiEncryption.wpa;
    _writeBatchCount = 0;
    wifiSsidController.clear();
    wifiPasswordController.clear();
    notifyListeners();
  }

  void toggleWifiPasswordVisibility() {
    _isWifiPasswordObscured = !_isWifiPasswordObscured;
    notifyListeners();
  }

  void clearWifiSsid() {
    wifiSsidController.clear();
    _pendingWifiSsid = '';
    notifyListeners();
  }

  void toggleWifiDropdown() {
    _isWifiDropdownOpen = !_isWifiDropdownOpen;
    notifyListeners();
  }

  void closeWifiDropdown() {
    if (_isWifiDropdownOpen) {
      _isWifiDropdownOpen = false;
      notifyListeners();
    }
  }

  void selectWifiEncryption(WifiEncryption enc) {
    _wifiEncryption = enc;
    if (enc == WifiEncryption.open) {
      _pendingWifiPassword = '';
      wifiPasswordController.clear();
    }
    _isWifiDropdownOpen = false;
    unawaited(_hardwareBridge.triggerLightHaptic());
    notifyListeners();
  }

  String? advanceWifiWizardOrValidate() {
    _isWifiDropdownOpen = false;
    if (_wifiStep == 1) {
      final ssid = wifiSsidController.text.trim();
      if (ssid.isEmpty) {
        return 'EMPTY_SSID';
      }
      _pendingWifiSsid = ssid;
      _wifiStepDirection = 1;
      _wifiStep = 2;
      notifyListeners();
      return null;
    }

    if (_wifiStep == 2) {
      final pass = wifiPasswordController.text.trim();
      if (pass.isNotEmpty &&
          pass.length < 8 &&
          _wifiEncryption != WifiEncryption.wep) {
        return 'SHORT_PASSWORD';
      }
      _pendingWifiPassword = pass;
      if (pass.isEmpty) {
        _wifiEncryption = WifiEncryption.open;
      } else if (_wifiEncryption == WifiEncryption.open) {
        _wifiEncryption = WifiEncryption.wpa;
      }
      _wifiStepDirection = 1;
      _wifiStep = 3;
      notifyListeners();
      return null;
    }

    // Step 3 -> Validate & start NFC Wi-Fi write
    return validateWifiStep3ForAction();
  }

  String? validateWifiStep3ForAction() {
    _isWifiDropdownOpen = false;
    final ssid = wifiSsidController.text.trim();
    if (ssid.isEmpty) {
      _wifiStepDirection = -1;
      _wifiStep = 1;
      notifyListeners();
      return 'EMPTY_SSID';
    }

    var pass = wifiPasswordController.text.trim();
    var enc = _wifiEncryption;
    if (enc == WifiEncryption.open || pass.isEmpty) {
      if (enc == WifiEncryption.wpa && pass.isEmpty) {
        _wifiStepDirection = -1;
        _wifiStep = 2;
        notifyListeners();
        return 'WPA_REQUIRED';
      }
      enc = WifiEncryption.open;
      pass = '';
      wifiPasswordController.clear();
    } else if (enc == WifiEncryption.wpa && pass.length < 8) {
      _wifiStepDirection = -1;
      _wifiStep = 2;
      notifyListeners();
      return 'WPA_REQUIRED';
    }

    _pendingWifiSsid = ssid;
    _pendingWifiPassword = pass;
    _pendingWifiEncryption = enc;
    _wifiEncryption = enc;
    return null;
  }

  Future<void> startWifiNfcWriteFromWizard({
    bool resetBatch = true,
    bool isClone = false,
    bool preserveCloneMode = false,
  }) async {
    _operation = NfcOperation.writeWifi;
    if (isClone) {
      _isWifiCloneMode = true;
    } else if (!preserveCloneMode) {
      _isWifiCloneMode = false;
    }
    if (resetBatch) {
      _writeBatchCount = 0;
    }
    _successDetail = null;
    _errorCode = null;
    _subView = NfcSubView.sensor;
    _sensorState = NfcSensorState.wifiReady;
    notifyListeners();

    final started = await _hardwareBridge.startNfcWifiWrite(
      ssid: _pendingWifiSsid,
      password: _pendingWifiEncryption == WifiEncryption.open
          ? ''
          : _pendingWifiPassword,
      encType: _pendingWifiEncryption.protocolCode,
    );
    if (!started) {
      _setSensorError('NO_HARDWARE');
    }
  }

  // ---- Write Another / Retry / Back & Cancel ----

  Future<void> handleNextCardAction() async {
    _successDetail = null;
    _errorCode = null;

    switch (_operation) {
      case NfcOperation.writeUrl:
        _sensorState = NfcSensorState.ready;
        notifyListeners();
        final ok = await _hardwareBridge.startNfcWrite(_pendingUrl);
        if (!ok) _setSensorError('NO_HARDWARE');
      case NfcOperation.writeWifi:
        await startWifiNfcWriteFromWizard(
          resetBatch: false,
          preserveCloneMode: true,
        );
      case NfcOperation.pwdLock:
        _sensorState = NfcSensorState.pwdLockReady;
        notifyListeners();
        final ok = await _hardwareBridge.startNfcPasswordLock(_savedPin);
        if (!ok) _setSensorError('NO_HARDWARE');
      case NfcOperation.pwdUnlock:
        _sensorState = NfcSensorState.pwdUnlockReady;
        notifyListeners();
        final ok = await _hardwareBridge.startNfcPasswordUnlock(_savedPin);
        if (!ok) _setSensorError('NO_HARDWARE');
      case NfcOperation.erase:
        await confirmAndStartErase(preserveCount: true);
      case NfcOperation.read:
      case NfcOperation.permLock:
        break;
    }
  }

  Future<void> handleRetryAction() async {
    _errorCode = null;
    switch (_operation) {
      case NfcOperation.writeUrl:
        _sensorState = NfcSensorState.ready;
        notifyListeners();
        final ok = await _hardwareBridge.startNfcWrite(_pendingUrl);
        if (!ok) _setSensorError('NO_HARDWARE');
      case NfcOperation.writeWifi:
        await startWifiNfcWriteFromWizard(
          resetBatch: false,
          preserveCloneMode: true,
        );
      case NfcOperation.read:
        _sensorState = NfcSensorState.readReady;
        notifyListeners();
        final ok = await _hardwareBridge.startNfcRead();
        if (!ok) _setSensorError('NO_HARDWARE');
      case NfcOperation.permLock:
        await confirmAndStartPermLock(preserveCount: true);
      case NfcOperation.erase:
        await confirmAndStartErase(preserveCount: true);
      case NfcOperation.pwdLock:
        _sensorState = NfcSensorState.pwdLockReady;
        notifyListeners();
        final ok = await _hardwareBridge.startNfcPasswordLock(_savedPin);
        if (!ok) _setSensorError('NO_HARDWARE');
      case NfcOperation.pwdUnlock:
        _sensorState = NfcSensorState.pwdUnlockReady;
        notifyListeners();
        final ok = await _hardwareBridge.startNfcPasswordUnlock(_savedPin);
        if (!ok) _setSensorError('NO_HARDWARE');
    }
  }

  bool get isCancelButtonActingAsBack {
    if (_subView != NfcSubView.sensor) return false;
    if (_sensorState == NfcSensorState.wifiReady && _writeBatchCount == 0) {
      return true;
    }
    if (_sensorState == NfcSensorState.error) {
      if (_operation == NfcOperation.writeWifi) return true;
      if (_operation == NfcOperation.pwdUnlock) return true;
      if (_operation == NfcOperation.pwdLock &&
          (_errorCode == 'ALREADY_LOCKED' ||
              _errorCode == 'LOCKED' ||
              _errorCode == 'WRONG_PWD' ||
              _errorCode == 'PWD_FAILED' ||
              _errorCode == 'MISSING_PIN')) {
        return true;
      }
    }
    return false;
  }

  /// Handles Back/Cancel inside the NFC modal.
  /// Returns `true` if handled internally without closing the dialog,
  /// or `false` if the dialog itself should close.
  Future<bool> handleCancelOrBack() async {
    if (_subView == NfcSubView.wifiWizard) {
      if (_isWifiDropdownOpen) {
        _isWifiDropdownOpen = false;
        notifyListeners();
        return true;
      }
      if (_wifiStep > 1) {
        _wifiStepDirection = -1;
        _wifiStep -= 1;
        notifyListeners();
        return true;
      }
      await closeAndResetSession();
      return false;
    }

    if (_subView == NfcSubView.pin ||
        _subView == NfcSubView.permConfirm ||
        _subView == NfcSubView.eraseConfirm) {
      await closeAndResetSession();
      return false;
    }

    // Sensor view
    if (_sensorState == NfcSensorState.success ||
        _sensorState == NfcSensorState.permLockStandby ||
        _sensorState == NfcSensorState.eraseStandby ||
        _writeBatchCount > 0) {
      await closeAndResetSession();
      return false;
    }

    if (_operation == NfcOperation.writeWifi) {
      await _hardwareBridge.cancelNfcSession();
      _wifiStep = 3;
      _wifiStepDirection = -1;
      _subView = NfcSubView.wifiWizard;
      notifyListeners();
      return true;
    }

    if (isCancelButtonActingAsBack && _shouldReturnToPinModal) {
      await _hardwareBridge.cancelNfcSession();
      _shouldReturnToPinModal = false;
      _subView = NfcSubView.pin;
      notifyListeners();
      return true;
    }

    await closeAndResetSession();
    return false;
  }

  Future<void> closeAndResetSession() async {
    _isDialogVisible = false;
    _writeBatchCount = 0;
    _permLockBatchCount = 0;
    _eraseBatchCount = 0;
    _successDetail = null;
    _errorCode = null;
    _shouldReturnToPinModal = false;
    _isWifiCloneMode = false;
    _isWifiDropdownOpen = false;
    await _hardwareBridge.cancelNfcSession();
    notifyListeners();
  }

  // ---- Hardware Event Handling ----

  void _setSensorError(String code) {
    _sensorState = NfcSensorState.error;
    _errorCode = code;
    _errorShakeTick++;
    notifyListeners();
  }

  @visibleForTesting
  void handleHardwareEventForTest(NfcHardwareEvent event) {
    _handleHardwareEvent(event);
  }

  void _handleHardwareEvent(NfcHardwareEvent event) {
    if (!_isDialogVisible) return;

    switch (event.type) {
      case NfcHardwareEventType.writeSuccess:
        _writeBatchCount = event.count > _writeBatchCount
            ? event.count
            : (_writeBatchCount + 1);
        _sensorState = NfcSensorState.success;
        _successDetail = (_operation == NfcOperation.writeWifi ||
                event.operationCode == 'WRITE_WIFI')
            ? 'WRITE_WIFI'
            : null;
        notifyListeners();

      case NfcHardwareEventType.wifiRead:
        final creds = event.wifiCredentials;
        if (creds == null) return;
        _pendingWifiSsid = creds.ssid;
        _pendingWifiPassword = creds.effectivePassword;
        _pendingWifiEncryption = creds.effectiveEncryption;
        _wifiEncryption = creds.effectiveEncryption;
        wifiSsidController.text = creds.ssid;
        wifiPasswordController.text = creds.effectivePassword;
        _wifiStep = 3;
        _isWifiCloneMode = true;
        _wifiCloneMorphTick++;
        unawaited(
          startWifiNfcWriteFromWizard(
            resetBatch: true,
            isClone: true,
          ),
        );

      case NfcHardwareEventType.urlRead:
        final readUrl = event.url;
        if (readUrl == null || readUrl.isEmpty) return;
        _isDialogVisible = false;
        notifyListeners();
        _requestCloseDialog?.call();
        if (onUrlTagRead != null) {
          unawaited(onUrlTagRead!(readUrl));
        }

      case NfcHardwareEventType.permLockSuccess:
        _permLockBatchCount += 1;
        _sensorState = NfcSensorState.permLockStandby;
        _permLockThumpTick++;
        notifyListeners();

      case NfcHardwareEventType.eraseSuccess:
        _eraseBatchCount += 1;
        _sensorState = NfcSensorState.eraseStandby;
        notifyListeners();

      case NfcHardwareEventType.pwdSuccess:
        _writeBatchCount += 1;
        _sensorState = NfcSensorState.success;
        if (event.pwdAction == 'LOCKED') {
          _successDetail = 'PWD_LOCK';
        } else if (event.pwdAction == 'ALREADY_UNLOCKED') {
          _successDetail = 'ALREADY_UNLOCKED';
        } else {
          _successDetail = 'PWD_UNLOCK';
        }
        notifyListeners();

      case NfcHardwareEventType.error:
        _setSensorError(event.errorCode ?? 'WRITE_FAILED');

      case NfcHardwareEventType.sessionPaused:
        if (_operation == NfcOperation.permLock && _permLockBatchCount > 0) {
          _sensorState = NfcSensorState.permLockStandby;
          notifyListeners();
        } else if (_operation == NfcOperation.erase && _eraseBatchCount > 0) {
          _sensorState = NfcSensorState.eraseStandby;
          notifyListeners();
        } else if (_sensorState != NfcSensorState.error &&
            _sensorState != NfcSensorState.success &&
            _sensorState != NfcSensorState.permLockStandby &&
            _sensorState != NfcSensorState.eraseStandby) {
          _isDialogVisible = false;
          notifyListeners();
          _requestCloseDialog?.call();
        }
    }
  }

  @override
  void dispose() {
    _eventsSub?.cancel();
    pinController.dispose();
    wifiSsidController.dispose();
    wifiPasswordController.dispose();
    super.dispose();
  }
}
