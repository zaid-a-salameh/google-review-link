import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:review_link_generator/data/services/hardware_bridge_service.dart';
import 'package:review_link_generator/data/services/preferences_service.dart';
import 'package:review_link_generator/domain/models/app_release_info.dart';
import 'package:review_link_generator/domain/models/nfc_models.dart';
import 'package:review_link_generator/main.dart';
import 'package:review_link_generator/ui/core/theme/app_colors.dart';
import 'package:review_link_generator/domain/models/place_suggestion.dart';
import 'package:review_link_generator/l10n/app_localizations.dart';
import 'package:review_link_generator/ui/features/home/view_models/home_view_model.dart';
import 'package:review_link_generator/ui/features/nfc/view_models/nfc_view_model.dart';
import 'package:review_link_generator/ui/features/updater/update_modal_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FakeHardwareBridgeService extends HardwareBridgeService {
  int startWriteCalls = 0;
  int startWifiWriteCalls = 0;
  int startReadCalls = 0;
  int startPermLockCalls = 0;
  int startPinLockCalls = 0;
  int startPinUnlockCalls = 0;
  int startEraseCalls = 0;
  int cancelCalls = 0;

  String? lastWrittenUrl;
  String? lastWifiSsid;
  String? lastWifiPassword;
  String? lastWifiEnc;

  final StreamController<NfcHardwareEvent> _controller =
      StreamController<NfcHardwareEvent>.broadcast();

  @override
  Stream<NfcHardwareEvent> get nfcEvents => _controller.stream;

  void emitEvent(NfcHardwareEvent event) {
    _controller.add(event);
  }

  @override
  Future<String> getNfcStatus() async => 'ENABLED';

  @override
  Future<bool> isNetworkConnected() async => true;

  @override
  Future<String> getAppVersion() async => '2.0.0';

  @override
  Future<void> triggerLightHaptic() async {}

  @override
  Future<void> triggerSuccessHaptic() async {}

  @override
  Future<void> triggerErrorHaptic() async {}

  @override
  Future<bool> startNfcWrite(String url) async {
    startWriteCalls++;
    lastWrittenUrl = url;
    return true;
  }

  @override
  Future<bool> startNfcWifiWrite({
    required String ssid,
    required String password,
    required String encType,
  }) async {
    startWifiWriteCalls++;
    lastWifiSsid = ssid;
    lastWifiPassword = password;
    lastWifiEnc = encType;
    return true;
  }

  @override
  Future<bool> startNfcRead() async {
    startReadCalls++;
    return true;
  }

  @override
  Future<bool> startNfcPermanentLock() async {
    startPermLockCalls++;
    return true;
  }

  @override
  Future<bool> startNfcPasswordLock(String pin) async {
    startPinLockCalls++;
    return true;
  }

  @override
  Future<bool> startNfcPasswordUnlock(String pin) async {
    startPinUnlockCalls++;
    return true;
  }

  @override
  Future<bool> startNfcErase() async {
    startEraseCalls++;
    return true;
  }

  @override
  Future<void> cancelNfcSession() async {
    cancelCalls++;
  }

  void dispose() {
    _controller.close();
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  Future<({
    PreferencesService prefs,
    FakeHardwareBridgeService bridge,
    HomeViewModel homeVm,
    NfcViewModel nfcVm,
  })> createTestHarness({String initialLang = 'en'}) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'app_lang': initialLang,
      'review_link_flutter_onboarding_v1': true,
    });
    final prefs = await PreferencesService.create();
    final bridge = FakeHardwareBridgeService();
    final homeVm = HomeViewModel(
      preferencesService: prefs,
      hardwareBridge: bridge,
    );
    final nfcVm = NfcViewModel(hardwareBridge: bridge);
    return (prefs: prefs, bridge: bridge, homeVm: homeVm, nfcVm: nfcVm);
  }

  testWidgets(
    'Converts Google Maps link, switches unified 5-Star Review / Map Location, and toggles EN <-> AR RTL',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final harness = await createTestHarness();
      addTearDown(() {
        harness.nfcVm.dispose();
        harness.homeVm.dispose();
        harness.bridge.dispose();
      });

      await tester.pumpWidget(
        ReviewLinkGeneratorApp(
          preferencesService: harness.prefs,
          hardwareBridge: harness.bridge,
          homeViewModel: harness.homeVm,
          nfcViewModel: harness.nfcVm,
          enableAutoOnboarding: false,
          enableStartupUpdateCheck: false,
        ),
      );
      await tester.pumpAndSettle();

      // Verify initial English LTR UI
      expect(find.text('Quick NFC'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byKey(const Key('input_direct_url')))),
        equals(TextDirection.ltr),
      );

      // Enter a Google Maps URL with Place ID and tap Convert
      const sampleMapsUrl =
          'https://www.google.com/maps/place/?q=place_id:ChIJN1t_tDeuEmsRUsoyG83frY4';
      await tester.enterText(
        find.byKey(const Key('input_direct_url')),
        sampleMapsUrl,
      );
      await tester.tap(find.byKey(const Key('btn_convert_link')));
      await tester.pumpAndSettle();

      // ResultCard should appear with 5-Star Review URL
      expect(find.byKey(const Key('result_card')), findsOneWidget);
      expect(
        find.text(
          'https://search.google.com/local/writereview?placeid=ChIJN1t_tDeuEmsRUsoyG83frY4',
        ),
        findsOneWidget,
      );

      // Verify unified icon-free Link Type switcher labels
      expect(find.text('5-Star Review'), findsOneWidget);
      expect(find.text('Map Location'), findsOneWidget);

      // Switch to Map Location output
      await tester.ensureVisible(find.byKey(const Key('btn_type_location')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('btn_type_location')));
      await tester.pumpAndSettle();
      expect(find.text(sampleMapsUrl), findsWidgets);

      // Switch back to 5-Star Review output
      await tester.tap(find.byKey(const Key('btn_type_review')));
      await tester.pumpAndSettle();
      expect(
        find.text(
          'https://search.google.com/local/writereview?placeid=ChIJN1t_tDeuEmsRUsoyG83frY4',
        ),
        findsOneWidget,
      );

      // Open Settings and switch language to Arabic (RTL)
      await tester.ensureVisible(find.byKey(const Key('btn_open_settings')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('btn_open_settings')));
      await tester.pumpAndSettle();

      // Open language dropdown and select Arabic
      await tester.tap(find.byKey(const Key('btn_language_dropdown')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('settings_lang_ar')), findsOneWidget);
      await tester.tap(find.byKey(const Key('settings_lang_ar')));
      await tester.pumpAndSettle();

      // Navigate back to Home
      await tester.tap(find.byKey(const Key('btn_settings_back')));
      await tester.pumpAndSettle();

      expect(find.text('Quick NFC'), findsOneWidget);
      expect(find.text('تقييم 5 نجوم'), findsOneWidget);
      expect(find.text('موقع الخريطة'), findsOneWidget);
      expect(
        Directionality.of(tester.element(find.byKey(const Key('result_card')))),
        equals(TextDirection.rtl),
      );

      // Clear toast timer cleanly before teardown
      await tester.pump(const Duration(seconds: 3));
    },
  );

  testWidgets(
    'Wi-Fi Card 3-Step Wizard writes NFC once, shows 2+1 success layout, and only re-arms on Write Another',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final harness = await createTestHarness(initialLang: 'ar');
      addTearDown(() {
        harness.nfcVm.dispose();
        harness.homeVm.dispose();
        harness.bridge.dispose();
      });

      await tester.pumpWidget(
        ReviewLinkGeneratorApp(
          preferencesService: harness.prefs,
          hardwareBridge: harness.bridge,
          homeViewModel: harness.homeVm,
          nfcViewModel: harness.nfcVm,
          enableAutoOnboarding: false,
          enableStartupUpdateCheck: false,
        ),
      );
      await tester.pumpAndSettle();

      // Open Wi-Fi Card Wizard
      await tester.tap(find.byKey(const Key('btn_tool_wifi_card')));
      await tester.pumpAndSettle();

      // Step 1: Enter SSID
      await tester.enterText(
        find.byKey(const Key('input_wifi_ssid')),
        'ZaidCafe_5G',
      );
      await tester.tap(find.byKey(const Key('btn_wifi_next')));
      await tester.pumpAndSettle();

      // Step 2: Enter Password
      await tester.enterText(
        find.byKey(const Key('input_wifi_password')),
        'strongpass123',
      );
      await tester.tap(find.byKey(const Key('btn_wifi_next')));
      await tester.pumpAndSettle();

      // Step 3: Tap Write to Card
      expect(find.byKey(const Key('btn_wifi_write_nfc')), findsOneWidget);
      await tester.tap(find.byKey(const Key('btn_wifi_write_nfc')));
      // Pump morph transition into scanning state (pulse animation runs while scanning)
      await tester.pump(const Duration(milliseconds: 350));

      expect(harness.bridge.startWifiWriteCalls, equals(1));
      expect(harness.bridge.lastWifiSsid, equals('ZaidCafe_5G'));
      expect(harness.bridge.lastWifiEnc, equals('WPA'));

      // Simulate native Kotlin writing 1 card (which pauses NFC session automatically)
      harness.nfcVm.handleHardwareEventForTest(
        const NfcHardwareEvent(
          type: NfcHardwareEventType.writeSuccess,
          count: 1,
          operationCode: 'WRITE_WIFI',
        ),
      );
      await tester.pumpAndSettle();

      // Verify 2+1 Wi-Fi Success Layout:
      // Top row: [Write Another] + [QR Code] at identical vertical Y
      // Bottom row: Full-width [Done] button below them
      final writeAnotherFinder = find.byKey(const Key('btn_wifi_write_another'));
      final qrBtnFinder = find.byKey(const Key('btn_wifi_success_qr'));
      final doneBtnFinder = find.byKey(const Key('btn_wifi_success_done'));

      expect(writeAnotherFinder, findsOneWidget);
      expect(qrBtnFinder, findsOneWidget);
      expect(doneBtnFinder, findsOneWidget);

      final writeAnotherRect = tester.getRect(writeAnotherFinder);
      final qrBtnRect = tester.getRect(qrBtnFinder);
      final doneBtnRect = tester.getRect(doneBtnFinder);

      expect((writeAnotherRect.top - qrBtnRect.top).abs(), lessThan(1.0));
      expect(doneBtnRect.top, greaterThan(writeAnotherRect.bottom));
      expect(
        doneBtnRect.width,
        greaterThan(writeAnotherRect.width + qrBtnRect.width),
      );

      // Verify hardware was NOT re-armed automatically after first card
      expect(harness.bridge.startWifiWriteCalls, equals(1));

      // Tapping Write Another explicitly re-arms hardware for card #2
      await tester.tap(writeAnotherFinder);
      await tester.pump(const Duration(milliseconds: 350));
      expect(harness.bridge.startWifiWriteCalls, equals(2));
    },
  );

  testWidgets(
    'PIN Lock/Unlock switcher, Permanent Lock standby safety, and User Guide modal operate cleanly',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final harness = await createTestHarness();
      addTearDown(() {
        harness.nfcVm.dispose();
        harness.homeVm.dispose();
        harness.bridge.dispose();
      });

      await tester.pumpWidget(
        ReviewLinkGeneratorApp(
          preferencesService: harness.prefs,
          hardwareBridge: harness.bridge,
          homeViewModel: harness.homeVm,
          nfcViewModel: harness.nfcVm,
          enableAutoOnboarding: false,
          enableStartupUpdateCheck: false,
        ),
      );
      await tester.pumpAndSettle();

      // 1. Open PIN Lock/Unlock modal and toggle Lock <-> Unlock
      await tester.tap(find.byKey(const Key('btn_tool_pin_lock')));
      await tester.pumpAndSettle();
      expect(harness.nfcVm.pinMode, equals(PinMode.lock));

      // Verify submit and cancel buttons are side-by-side (same top Y)
      final pinSubmitFinder = find.byKey(const Key('btn_pin_submit'));
      final pinCancelFinder = find.byKey(const Key('btn_pin_cancel'));
      expect(pinSubmitFinder, findsOneWidget);
      expect(pinCancelFinder, findsOneWidget);
      final pinSubmitRect = tester.getRect(pinSubmitFinder);
      final pinCancelRect = tester.getRect(pinCancelFinder);
      expect((pinSubmitRect.top - pinCancelRect.top).abs(), lessThan(1.0));

      // Verify info button is inside input field and tapping it shows toast
      final pinInfoBtn = find.byKey(const Key('btn_pin_info'));
      expect(pinInfoBtn, findsOneWidget);
      await tester.tap(pinInfoBtn);
      await tester.pump();
      expect(find.text('4 digits recommended'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));

      await tester.tap(find.byKey(const Key('tab_pin_unlock')));
      await tester.pumpAndSettle();
      expect(harness.nfcVm.pinMode, equals(PinMode.unlock));

      // Close modal via Cancel
      await tester.tap(pinCancelFinder);
      await tester.pumpAndSettle();

      // 2. Open Permanent Lock confirmation and verify standby safety after locking 1 card
      await tester.tap(find.byKey(const Key('btn_tool_perm_lock')));
      await tester.pumpAndSettle();
      final permConfirmBtn = find.byKey(const Key('btn_perm_lock_confirm'));
      final permCancelBtn = find.byKey(const Key('btn_perm_lock_cancel'));
      expect(permConfirmBtn, findsOneWidget);
      expect(permCancelBtn, findsOneWidget);
      final pcRect = tester.getRect(permConfirmBtn);
      final pxRect = tester.getRect(permCancelBtn);
      expect((pcRect.top - pxRect.top).abs(), lessThan(1.0));

      await tester.tap(permConfirmBtn);
      await tester.pump(const Duration(milliseconds: 350));
      expect(harness.bridge.startPermLockCalls, equals(1));

      harness.nfcVm.handleHardwareEventForTest(
        const NfcHardwareEvent(type: NfcHardwareEventType.permLockSuccess),
      );
      await tester.pumpAndSettle();

      expect(harness.nfcVm.isPermLockStandby, isTrue);
      expect(harness.nfcVm.permLockBatchCount, equals(1));
      expect(harness.bridge.startPermLockCalls, equals(1));

      await tester.tap(find.byKey(const Key('btn_nfc_cancel')));
      await tester.pumpAndSettle();

      // 3. Open User Guide tour manually
      await tester.tap(find.byKey(const Key('btn_open_guide')));
      await tester.pumpAndSettle();
      expect(find.text('Skip Tour'), findsOneWidget);
      await tester.tap(find.text('Skip Tour'));
      await tester.pumpAndSettle();
    },
  );

  testWidgets(
    'User Guide opens automatically once on very first launch and records completion',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      // Fresh install simulation: no onboarding flag set
      SharedPreferences.setMockInitialValues(<String, Object>{});
      final prefs = await PreferencesService.create();
      final bridge = FakeHardwareBridgeService();
      final homeVm = HomeViewModel(
        preferencesService: prefs,
        hardwareBridge: bridge,
      );
      final nfcVm = NfcViewModel(hardwareBridge: bridge);

      addTearDown(() {
        nfcVm.dispose();
        homeVm.dispose();
        bridge.dispose();
      });

      expect(prefs.isOnboardingCompleted, isFalse);

      await tester.pumpWidget(
        ReviewLinkGeneratorApp(
          preferencesService: prefs,
          hardwareBridge: bridge,
          homeViewModel: homeVm,
          nfcViewModel: nfcVm,
          enableAutoOnboarding: true,
          enableStartupUpdateCheck: false,
        ),
      );

      // Trigger post frame callbacks and timer (400ms)
      await tester.pumpAndSettle(const Duration(milliseconds: 500));

      // Onboarding tour modal must have appeared automatically
      expect(find.text('Skip Tour'), findsOneWidget);
      expect(find.byKey(const Key('btn_close_onboarding')), findsOneWidget);

      final nextBtn = find.byKey(const Key('btn_onboarding_next'));
      final skipBtn = find.byKey(const Key('btn_onboarding_skip'));
      expect(nextBtn, findsOneWidget);
      expect(skipBtn, findsOneWidget);

      // Step 2
      await tester.tap(nextBtn);
      await tester.pumpAndSettle();
      expect(skipBtn, findsOneWidget);

      // Step 3 (Final step)
      await tester.tap(nextBtn);
      await tester.pumpAndSettle();
      expect(find.text('Get Started'), findsOneWidget);
      // Skip button must be removed on the final step
      expect(skipBtn, findsNothing);

      // Close it via close button
      await tester.tap(find.byKey(const Key('btn_close_onboarding')));
      await tester.pumpAndSettle();

      // Now onboarding must be completed
      expect(prefs.isOnboardingCompleted, isTrue);
    },
  );

  testWidgets(
    'Version Update Pill shows version, checks for updates, and opens modal when update is available',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final harness = await createTestHarness();
      addTearDown(() {
        harness.nfcVm.dispose();
        harness.homeVm.dispose();
        harness.bridge.dispose();
      });

      await tester.pumpWidget(
        ReviewLinkGeneratorApp(
          preferencesService: harness.prefs,
          hardwareBridge: harness.bridge,
          homeViewModel: harness.homeVm,
          nfcViewModel: harness.nfcVm,
          enableAutoOnboarding: false,
          enableStartupUpdateCheck: false,
        ),
      );
      await tester.pumpAndSettle();

      // Version pill is visible with current version v2.0.0
      final pillFinder = find.byKey(const Key('btn_check_update'));
      expect(pillFinder, findsOneWidget);
      expect(find.text('v2.0.0'), findsOneWidget);

      // Tap pill when no update available -> triggers manual check toast
      await tester.tap(pillFinder);
      await tester.pump(const Duration(milliseconds: 300));

      // First toast: checking for updates is visible
      expect(find.text('Checking for updates...'), findsOneWidget);

      // Wait 1200ms -> first toast hides and animates back up
      await tester.pump(const Duration(milliseconds: 1300));
      await tester.pump(const Duration(milliseconds: 400));

      // Second toast appears: app is up to date
      expect(find.text('App is up to date (2.0.0)'), findsOneWidget);
      await tester.pump(const Duration(seconds: 3));

      // Simulate update detected (starts repeating glow animation)
      harness.homeVm.availableUpdate = const AppReleaseInfo(
        tagVersion: 'v1.3.0',
        cleanVersion: '1.3.0',
        downloadUrl: 'https://example.com/app.apk',
        releasePageUrl: 'https://github.com/releases/v1.3.0',
        releaseNotes: 'Awesome new features',
        assetSizeBytes: 20000000,
      );
      await tester.pump(const Duration(milliseconds: 100));

      // Tap pill again -> update modal opens
      await tester.tap(pillFinder);
      await tester.pump(const Duration(milliseconds: 300));
      await tester.pump(const Duration(milliseconds: 300));

      expect(find.byType(UpdateModalDialog), findsOneWidget);
      expect(find.text('v1.3.0'), findsWidgets);
    },
  );

  testWidgets(
    'NFC Erase Tag confirmation modal and dual GitHub dock button (Project & Support) operate cleanly',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final harness = await createTestHarness(initialLang: 'ar');
      addTearDown(() {
        harness.nfcVm.dispose();
        harness.homeVm.dispose();
        harness.bridge.dispose();
      });

      await tester.pumpWidget(
        ReviewLinkGeneratorApp(
          preferencesService: harness.prefs,
          hardwareBridge: harness.bridge,
          homeViewModel: harness.homeVm,
          nfcViewModel: harness.nfcVm,
          enableAutoOnboarding: false,
          enableStartupUpdateCheck: false,
        ),
      );
      await tester.pumpAndSettle();

      // 1. Verify Card Tools Grid has the Erase button between PIN and Perm Lock
      final eraseTile = find.byKey(const Key('btn_tool_erase_card'));
      final pinTile = find.byKey(const Key('btn_tool_pin_lock'));
      final permTile = find.byKey(const Key('btn_tool_perm_lock'));

      expect(eraseTile, findsOneWidget);
      expect(pinTile, findsOneWidget);
      expect(permTile, findsOneWidget);

      final pinRect = tester.getRect(pinTile);
      final eraseRect = tester.getRect(eraseTile);
      final permRect = tester.getRect(permTile);

      // Verify they are on the same horizontal row (identical Y)
      expect((pinRect.top - eraseRect.top).abs(), lessThan(1.0));
      expect((eraseRect.top - permRect.top).abs(), lessThan(1.0));

      // 2. Verify dual GitHub dock button
      final projectBtn = find.byKey(const Key('btn_github_project'));
      final supportBtn = find.byKey(const Key('btn_github_support'));
      expect(projectBtn, findsOneWidget);
      expect(supportBtn, findsOneWidget);
      expect(
        find.descendant(of: projectBtn, matching: find.text('GitHub')),
        findsOneWidget,
      );

      // Tap support button -> opens sponsor/support page
      await tester.tap(supportBtn);
      await tester.pump(const Duration(milliseconds: 100));

      // 3. Open Erase NFC Tag modal
      await tester.tap(eraseTile);
      await tester.pumpAndSettle();

      final eraseConfirmBtn = find.byKey(const Key('btn_erase_confirm'));
      final eraseCancelBtn = find.byKey(const Key('btn_erase_cancel'));
      expect(eraseConfirmBtn, findsOneWidget);
      expect(eraseCancelBtn, findsOneWidget);
      final ecRect = tester.getRect(eraseConfirmBtn);
      final exRect = tester.getRect(eraseCancelBtn);
      expect((ecRect.top - exRect.top).abs(), lessThan(1.0));

      // Confirm erase
      await tester.tap(eraseConfirmBtn);
      await tester.pump(const Duration(milliseconds: 350));
      expect(harness.bridge.startEraseCalls, equals(1));

      // Simulate erase success event
      harness.nfcVm.handleHardwareEventForTest(
        const NfcHardwareEvent(type: NfcHardwareEventType.eraseSuccess),
      );
      await tester.pumpAndSettle();

      expect(harness.nfcVm.isEraseStandby, isTrue);
      expect(harness.nfcVm.eraseBatchCount, equals(1));

      // Verify Re-arm Erase Another button exists and is side-by-side with Done button
      final eraseAnother = find.byKey(const Key('btn_erase_another'));
      final eraseDone = find.byKey(const Key('btn_nfc_cancel'));
      expect(eraseAnother, findsOneWidget);
      expect(eraseDone, findsOneWidget);
      final eaRect = tester.getRect(eraseAnother);
      final edRect = tester.getRect(eraseDone);
      expect((eaRect.top - edRect.top).abs(), lessThan(1.0));

      // Tap erase another -> starts erase again
      await tester.tap(eraseAnother);
      await tester.pump(const Duration(milliseconds: 350));
      expect(harness.bridge.startEraseCalls, equals(2));

      // Close modal
      await tester.tap(find.text('إنهاء'));
      await tester.pumpAndSettle();

      // Clear toast timers
      await tester.pump(const Duration(seconds: 3));
    },
  );

  testWidgets(
    'PIN Lock/Unlock modal displays side-by-side action buttons in form, success, and error states',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final harness = await createTestHarness(initialLang: 'ar');
      addTearDown(() {
        harness.nfcVm.dispose();
        harness.homeVm.dispose();
        harness.bridge.dispose();
      });

      await tester.pumpWidget(
        ReviewLinkGeneratorApp(
          preferencesService: harness.prefs,
          hardwareBridge: harness.bridge,
          homeViewModel: harness.homeVm,
          nfcViewModel: harness.nfcVm,
          enableAutoOnboarding: false,
          enableStartupUpdateCheck: false,
        ),
      );
      await tester.pumpAndSettle();

      // 1. Open PIN Lock dialog & verify form buttons are side-by-side
      await tester.tap(find.byKey(const Key('btn_tool_pin_lock')));
      await tester.pumpAndSettle();

      final submitBtn = find.byKey(const Key('btn_pin_submit'));
      final cancelBtn = find.byKey(const Key('btn_pin_cancel'));
      expect(submitBtn, findsOneWidget);
      expect(cancelBtn, findsOneWidget);

      final submitRect = tester.getRect(submitBtn);
      final cancelRect = tester.getRect(cancelBtn);
      expect((submitRect.top - cancelRect.top).abs(), lessThan(1.0));

      // Enter PIN and start locking
      await tester.enterText(find.byKey(const Key('input_nfc_pin')), '1234');
      await tester.tap(submitBtn);
      await tester.pump(const Duration(milliseconds: 350));
      expect(harness.bridge.startPinLockCalls, equals(1));

      // 2. Simulate Success -> verify [Lock Another] + [Done] are side-by-side
      harness.nfcVm.handleHardwareEventForTest(
        const NfcHardwareEvent(
          type: NfcHardwareEventType.pwdSuccess,
          pwdAction: 'LOCKED',
        ),
      );
      await tester.pumpAndSettle();

      final anotherBtn = find.byKey(const Key('btn_pin_success_another'));
      final doneBtn = find.byKey(const Key('btn_nfc_cancel'));
      expect(anotherBtn, findsOneWidget);
      expect(doneBtn, findsOneWidget);

      final anotherRect = tester.getRect(anotherBtn);
      final doneRect = tester.getRect(doneBtn);
      expect((anotherRect.top - doneRect.top).abs(), lessThan(1.0));

      // 3. Simulate Error -> verify [Retry] + [Back] are side-by-side
      harness.nfcVm.handleHardwareEventForTest(
        const NfcHardwareEvent(
          type: NfcHardwareEventType.error,
          errorCode: 'WRONG_PWD',
        ),
      );
      await tester.pumpAndSettle();

      final retryBtn = find.byKey(const Key('btn_nfc_retry'));
      final backBtn = find.byKey(const Key('btn_nfc_cancel'));
      expect(retryBtn, findsOneWidget);
      expect(backBtn, findsOneWidget);

      final retryRect = tester.getRect(retryBtn);
      final backRect = tester.getRect(backBtn);
      expect((retryRect.top - backRect.top).abs(), lessThan(1.0));

      // Close modal via back/done button
      await tester.tap(backBtn);
      await tester.pumpAndSettle();
      await tester.pump(const Duration(seconds: 3));
    },
  );

  testWidgets(
    'Modal dialogs (QR modal, URL write success, general write error) render side-by-side compact action buttons',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final harness = await createTestHarness();
      addTearDown(() {
        harness.nfcVm.dispose();
        harness.homeVm.dispose();
        harness.bridge.dispose();
      });

      await tester.pumpWidget(
        ReviewLinkGeneratorApp(
          preferencesService: harness.prefs,
          hardwareBridge: harness.bridge,
          homeViewModel: harness.homeVm,
          nfcViewModel: harness.nfcVm,
          enableAutoOnboarding: false,
          enableStartupUpdateCheck: false,
        ),
      );
      await tester.pumpAndSettle();

      // Convert a URL so ResultCard appears
      const rawUrl =
          'https://www.google.com/maps/place/?q=place_id:ChIJN1t_tDeuEmsRUsoyG83frY4';
      await tester.enterText(find.byKey(const Key('input_direct_url')), rawUrl);
      await tester.tap(find.byKey(const Key('btn_convert_link')));
      await tester.pumpAndSettle();
      expect(find.byKey(const Key('result_card')), findsOneWidget);

      // 1. Open QR Modal and verify Download QR + Close buttons are side-by-side
      final qrBtn = find.byKey(const Key('btn_generate_qr'));
      await tester.ensureVisible(qrBtn);
      await tester.tap(qrBtn);
      await tester.pumpAndSettle();

      final qrDownloadBtn = find.byKey(const Key('btn_qr_download'));
      final qrCloseBtn = find.byKey(const Key('btn_qr_close'));
      expect(qrDownloadBtn, findsOneWidget);
      expect(qrCloseBtn, findsOneWidget);

      final qrDlRect = tester.getRect(qrDownloadBtn);
      final qrClRect = tester.getRect(qrCloseBtn);
      expect((qrDlRect.top - qrClRect.top).abs(), lessThan(1.0));

      await tester.tap(qrCloseBtn);
      await tester.pumpAndSettle();

      // 2. Open NFC Write Modal
      final writeNfcBtn = find.byKey(const Key('btn_write_nfc'));
      await tester.ensureVisible(writeNfcBtn);
      await tester.tap(writeNfcBtn);
      await tester.pump(const Duration(milliseconds: 350));

      // Simulate write success -> verify [Write Another] + [Done] are side-by-side
      harness.nfcVm.handleHardwareEventForTest(
        const NfcHardwareEvent(type: NfcHardwareEventType.writeSuccess),
      );
      await tester.pump(const Duration(milliseconds: 350));

      final writeAnotherBtn = find.byKey(const Key('btn_write_another'));
      final writeDoneBtn = find.byKey(const Key('btn_nfc_cancel'));
      expect(writeAnotherBtn, findsOneWidget);
      expect(writeDoneBtn, findsOneWidget);

      final waRect = tester.getRect(writeAnotherBtn);
      final wdRect = tester.getRect(writeDoneBtn);
      expect((waRect.top - wdRect.top).abs(), lessThan(1.0));

      // 3. Simulate error -> verify [Retry] + [Cancel] are side-by-side
      harness.nfcVm.handleHardwareEventForTest(
        const NfcHardwareEvent(
          type: NfcHardwareEventType.error,
          errorCode: 'WRITE_FAIL',
        ),
      );
      await tester.pump(const Duration(milliseconds: 350));

      final retryBtn = find.byKey(const Key('btn_nfc_retry'));
      final cancelBtn = find.byKey(const Key('btn_nfc_cancel'));
      expect(retryBtn, findsOneWidget);
      expect(cancelBtn, findsOneWidget);

      final Container retryContainer = tester.widget<Container>(
        find.descendant(of: retryBtn, matching: find.byType(Container)).first,
      );
      final BoxDecoration retryBox =
          retryContainer.decoration! as BoxDecoration;
      expect(retryBox.gradient, equals(AppColors.dangerPermGradient));

      final rRect = tester.getRect(retryBtn);
      final cRect = tester.getRect(cancelBtn);
      expect((rRect.top - cRect.top).abs(), lessThan(1.0));

      await tester.tap(cancelBtn);
      await tester.pump(const Duration(milliseconds: 350));
      await tester.pump(const Duration(seconds: 3));
    },
  );

  testWidgets(
    'Focus and keyboard management: tapping outside or opening/closing modals keeps text field unfocused',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final harness = await createTestHarness(initialLang: 'ar');
      addTearDown(() {
        harness.nfcVm.dispose();
        harness.homeVm.dispose();
        harness.bridge.dispose();
      });

      await tester.pumpWidget(
        ReviewLinkGeneratorApp(
          preferencesService: harness.prefs,
          hardwareBridge: harness.bridge,
          homeViewModel: harness.homeVm,
          nfcViewModel: harness.nfcVm,
          enableAutoOnboarding: false,
          enableStartupUpdateCheck: false,
        ),
      );
      await tester.pumpAndSettle();

      final inputFinder = find.byKey(const Key('input_direct_url'));
      expect(inputFinder, findsOneWidget);

      // 1. Tap input field -> gains focus
      await tester.tap(inputFinder);
      await tester.pumpAndSettle();
      final editableFinder = find.descendant(
        of: inputFinder,
        matching: find.byType(EditableText),
      );
      final EditableText editableWidget = tester.widget(editableFinder);
      expect(editableWidget.focusNode.hasFocus, isTrue);

      // 2. Tap another element on screen (e.g. Card Tools Grid or background)
      final readTile = find.byKey(const Key('btn_tool_read_card'));
      await tester.tap(readTile);
      await tester.pump(const Duration(milliseconds: 400));

      // Read modal is now open; verify text field has lost focus
      expect(editableWidget.focusNode.hasFocus, isFalse);

      // 3. Close the modal -> verify text field still does NOT regain focus
      final modalCancel = find.byKey(const Key('btn_nfc_cancel'));
      expect(modalCancel, findsOneWidget);
      await tester.tap(modalCancel);
      await tester.pumpAndSettle();

      expect(editableWidget.focusNode.hasFocus, isFalse);

      // 4. Tap input field again to focus it
      await tester.tap(inputFinder);
      await tester.pumpAndSettle();
      expect(editableWidget.focusNode.hasFocus, isTrue);

      // 5. Tap outside on the title text ('Quick NFC')
      await tester.tap(find.text('Quick NFC'));
      await tester.pumpAndSettle();
      expect(editableWidget.focusNode.hasFocus, isFalse);
    },
  );

  testWidgets(
    'Wi-Fi wizard close button closes modal, and Language Dropdown lists 10 languages with English fallback',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final harness = await createTestHarness(initialLang: 'ar');
      addTearDown(() {
        harness.nfcVm.dispose();
        harness.homeVm.dispose();
        harness.bridge.dispose();
      });

      await tester.pumpWidget(
        ReviewLinkGeneratorApp(
          preferencesService: harness.prefs,
          hardwareBridge: harness.bridge,
          homeViewModel: harness.homeVm,
          nfcViewModel: harness.nfcVm,
          enableAutoOnboarding: false,
          enableStartupUpdateCheck: false,
        ),
      );
      await tester.pumpAndSettle();

      // 1. Open Wi-Fi Card Wizard
      await tester.tap(find.byKey(const Key('btn_tool_wifi_card')));
      await tester.pumpAndSettle();

      // Verify close 'X' button is present and tap it to close modal
      final closeWifiBtn = find.byKey(const Key('btn_close_wifi_modal'));
      expect(closeWifiBtn, findsOneWidget);
      await tester.tap(closeWifiBtn);
      await tester.pumpAndSettle();

      // Verify Wi-Fi modal closed
      expect(find.byKey(const Key('btn_close_wifi_modal')), findsNothing);

      // 2. Open Settings
      await tester.tap(find.byKey(const Key('btn_open_settings')));
      await tester.pumpAndSettle();

      // Open language dropdown
      final dropdownBtn = find.byKey(const Key('btn_language_dropdown'));
      expect(dropdownBtn, findsOneWidget);
      await tester.tap(dropdownBtn);
      await tester.pumpAndSettle();

      // Verify all 10 languages are available in dropdown
      for (final code in ['ar', 'en', 'es', 'fr', 'de', 'zh', 'hi', 'pt', 'ru', 'ja']) {
        expect(find.byKey(Key('settings_lang_$code')), findsOneWidget);
      }

      // 3. Select Spanish ('es') -> full Spanish localization is active
      await tester.tap(find.byKey(const Key('settings_lang_es')));
      await tester.pumpAndSettle();

      expect(harness.homeVm.selectedLanguageCode, equals('es'));
      expect(harness.homeVm.locale.languageCode, equals('es'));
      expect(harness.homeVm.isArabic, isFalse);

      // Verify dropdown displays Español and no English UI badge is shown
      expect(find.text('Español'), findsWidgets);
      expect(find.text('English UI'), findsNothing);

      // 4. Navigate back to Home -> UI is in Spanish ('Enlace directo')
      await tester.tap(find.byKey(const Key('btn_settings_back')));
      await tester.pumpAndSettle();

      expect(find.text('Enlace directo'), findsOneWidget);
    },
  );

  testWidgets(
    'Settings Theme Control switches between System, Dark, and Light modes and updates AppColors & Theme',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final harness = await createTestHarness(initialLang: 'ar');
      addTearDown(() {
        harness.nfcVm.dispose();
        harness.homeVm.dispose();
        harness.bridge.dispose();
      });

      await tester.pumpWidget(
        ReviewLinkGeneratorApp(
          preferencesService: harness.prefs,
          hardwareBridge: harness.bridge,
          homeViewModel: harness.homeVm,
          nfcViewModel: harness.nfcVm,
          enableAutoOnboarding: false,
          enableStartupUpdateCheck: false,
        ),
      );
      await tester.pumpAndSettle();

      // Default theme mode is system
      expect(harness.homeVm.selectedThemeMode, equals('system'));
      expect(harness.homeVm.themeMode, equals(ThemeMode.system));

      // Open Settings
      await tester.tap(find.byKey(const Key('btn_open_settings')));
      await tester.pumpAndSettle();

      final systemBtn = find.byKey(const Key('btn_theme_system'));
      final darkBtn = find.byKey(const Key('btn_theme_dark'));
      final lightBtn = find.byKey(const Key('btn_theme_light'));

      expect(systemBtn, findsOneWidget);
      expect(darkBtn, findsOneWidget);
      expect(lightBtn, findsOneWidget);

      // Switch to Light mode
      await tester.tap(lightBtn);
      await tester.pumpAndSettle();
      expect(harness.homeVm.selectedThemeMode, equals('light'));
      expect(harness.homeVm.themeMode, equals(ThemeMode.light));
      expect(AppColors.isLight, isTrue);
      expect(AppColors.bg, equals(const Color(0xFFF6F5F2)));

      // Return to HomeScreen using the top-left Back button (btn_settings_back)
      // and verify HomeScreen widgets immediately reflect Light mode WITHOUT switching tabs
      await tester.tap(find.byKey(const Key('btn_settings_back')));
      await tester.pumpAndSettle();

      final Text titleLight = tester.widget<Text>(find.text('Quick NFC'));
      expect(titleLight.style?.color, equals(const Color(0xFF1C1917)));

      final EditableText inputEditableLight = tester.widget<EditableText>(
        find.descendant(
          of: find.byKey(const Key('input_direct_url')),
          matching: find.byType(EditableText),
        ),
      );
      expect(inputEditableLight.style.color, equals(const Color(0xFF1C1917)));

      // Open Settings again and switch to Dark mode, then tap btn_settings_back
      await tester.tap(find.byKey(const Key('btn_open_settings')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('btn_theme_dark')));
      await tester.pumpAndSettle();
      expect(harness.homeVm.selectedThemeMode, equals('dark'));
      expect(harness.homeVm.themeMode, equals(ThemeMode.dark));
      expect(AppColors.isLight, isFalse);
      expect(AppColors.bg, equals(const Color(0xFF0C0A09)));

      await tester.tap(find.byKey(const Key('btn_settings_back')));
      await tester.pumpAndSettle();

      final Text titleDark = tester.widget<Text>(find.text('Quick NFC'));
      expect(titleDark.style?.color, equals(const Color(0xFFFAFAF9)));

      final EditableText inputEditableDark = tester.widget<EditableText>(
        find.descendant(
          of: find.byKey(const Key('input_direct_url')),
          matching: find.byType(EditableText),
        ),
      );
      expect(inputEditableDark.style.color, equals(const Color(0xFFFAFAF9)));

      // Open Settings and switch back to System mode, then return to HomeScreen
      await tester.tap(find.byKey(const Key('btn_open_settings')));
      await tester.pumpAndSettle();
      await tester.tap(find.byKey(const Key('btn_theme_system')));
      await tester.pumpAndSettle();
      expect(harness.homeVm.selectedThemeMode, equals('system'));
      expect(harness.homeVm.themeMode, equals(ThemeMode.system));

      await tester.tap(find.byKey(const Key('btn_settings_back')));
      await tester.pumpAndSettle();

      // Simulate changing OS platform brightness while on HomeScreen in System mode
      tester.binding.platformDispatcher.platformBrightnessTestValue =
          Brightness.light;
      addTearDown(
        () => tester.binding.platformDispatcher.clearPlatformBrightnessTestValue(),
      );
      await tester.pumpAndSettle();

      expect(AppColors.isLight, isTrue);
      final Text titleSystemLight = tester.widget<Text>(find.text('Quick NFC'));
      expect(titleSystemLight.style?.color, equals(const Color(0xFF1C1917)));
      final EditableText inputSystemLight = tester.widget<EditableText>(
        find.descendant(
          of: find.byKey(const Key('input_direct_url')),
          matching: find.byType(EditableText),
        ),
      );
      expect(inputSystemLight.style.color, equals(const Color(0xFF1C1917)));

      tester.binding.platformDispatcher.platformBrightnessTestValue =
          Brightness.dark;
      await tester.pumpAndSettle();

      expect(AppColors.isLight, isFalse);
      final Text titleSystemDark = tester.widget<Text>(find.text('Quick NFC'));
      expect(titleSystemDark.style?.color, equals(const Color(0xFFFAFAF9)));
      final EditableText inputSystemDark = tester.widget<EditableText>(
        find.descendant(
          of: find.byKey(const Key('input_direct_url')),
          matching: find.byType(EditableText),
        ),
      );
      expect(inputSystemDark.style.color, equals(const Color(0xFFFAFAF9)));
    },
  );

  testWidgets(
    'Search mode displays trash icon clear button when field has text and clears cleanly',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final harness = await createTestHarness(initialLang: 'en');
      addTearDown(() {
        harness.nfcVm.dispose();
        harness.homeVm.dispose();
        harness.bridge.dispose();
      });

      await tester.pumpWidget(
        ReviewLinkGeneratorApp(
          preferencesService: harness.prefs,
          hardwareBridge: harness.bridge,
          homeViewModel: harness.homeVm,
          nfcViewModel: harness.nfcVm,
          enableAutoOnboarding: false,
          enableStartupUpdateCheck: false,
        ),
      );
      await tester.pumpAndSettle();

      // Switch to search mode tab
      await tester.tap(find.byKey(const Key('tab_mode_search')));
      await tester.pumpAndSettle();

      final searchInputFinder = find.byKey(const Key('input_business_search'));
      expect(searchInputFinder, findsOneWidget);
      expect(find.byKey(const Key('btn_clear_search')), findsNothing);

      // Enter search text -> trash can button appears
      await tester.enterText(searchInputFinder, 'Amman Cafe');
      await tester.pumpAndSettle();

      final clearSearchBtn = find.byKey(const Key('btn_clear_search'));
      expect(clearSearchBtn, findsOneWidget);

      // Tap clear button -> text is cleared
      await tester.tap(clearSearchBtn);
      await tester.pumpAndSettle();

      expect(harness.homeVm.searchController.text, isEmpty);
      expect(find.byKey(const Key('btn_clear_search')), findsNothing);

      // Allow toast timer to complete cleanly before teardown
      await tester.pump(const Duration(seconds: 3));
    },
  );

  testWidgets(
    'Direct Link mode does not auto-convert on input until Convert Link button is pressed',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final harness = await createTestHarness(initialLang: 'ar');
      addTearDown(() {
        harness.nfcVm.dispose();
        harness.homeVm.dispose();
        harness.bridge.dispose();
      });

      await tester.pumpWidget(
        ReviewLinkGeneratorApp(
          preferencesService: harness.prefs,
          hardwareBridge: harness.bridge,
          homeViewModel: harness.homeVm,
          nfcViewModel: harness.nfcVm,
          enableAutoOnboarding: false,
          enableStartupUpdateCheck: false,
        ),
      );
      await tester.pumpAndSettle();

      final inputFinder = find.byKey(const Key('input_direct_url'));
      expect(inputFinder, findsOneWidget);

      // Typing URL into text field must NOT immediately convert
      await tester.enterText(
        inputFinder,
        'https://maps.google.com/?cid=10255954625207137458',
      );
      await tester.pump(const Duration(milliseconds: 500));
      // Result card should NOT be active yet
      expect(harness.homeVm.currentResult.isResultActive, isFalse);

      // Tap convert button -> Now it converts
      await tester.tap(find.byKey(const Key('btn_convert_link')));
      await tester.pumpAndSettle();
      expect(harness.homeVm.currentResult.isResultActive, isTrue);

      // Verify shortened toast for place suggestion selection
      harness.homeVm.selectPlaceSuggestion(
        const PlaceSuggestion(
          placeId: 'ChIJN1t_tDeuEmsRUsoyG83frY4',
          mainText: 'Google Sydney',
          secondaryText: 'Darling Island Road, Pyrmont NSW, Australia',
        ),
        l10n: await AppLocalizations.delegate.load(const Locale('ar')),
      );
      await tester.pump();
      expect(find.text('تم توليد الرابط'), findsOneWidget);

      await tester.pump(const Duration(seconds: 3));
    },
  );

  testWidgets(
    'All 10 supported languages switch smoothly and display correct localized strings',
    (WidgetTester tester) async {
      await tester.binding.setSurfaceSize(const Size(430, 932));
      addTearDown(() => tester.binding.setSurfaceSize(null));

      final harness = await createTestHarness(initialLang: 'en');
      addTearDown(() {
        harness.nfcVm.dispose();
        harness.homeVm.dispose();
        harness.bridge.dispose();
      });

      await tester.pumpWidget(
        ReviewLinkGeneratorApp(
          preferencesService: harness.prefs,
          hardwareBridge: harness.bridge,
          homeViewModel: harness.homeVm,
          nfcViewModel: harness.nfcVm,
          enableAutoOnboarding: false,
          enableStartupUpdateCheck: false,
        ),
      );
      await tester.pumpAndSettle();

      final expectedTabs = <String, String>{
        'ar': 'وضع الرابط',
        'en': 'Direct Link',
        'es': 'Enlace directo',
        'fr': 'Lien direct',
        'de': 'Direktlink',
        'zh': '直达链接',
        'hi': 'सीधा लिंक',
        'pt': 'Link direto',
        'ru': 'Прямая ссылка',
        'ja': 'ダイレクトリンク',
      };

      for (final entry in expectedTabs.entries) {
        await harness.homeVm.switchLanguage(entry.key);
        await tester.pumpAndSettle();
        expect(harness.homeVm.selectedLanguageCode, equals(entry.key));
        expect(harness.homeVm.locale.languageCode, equals(entry.key));
        expect(find.text(entry.value), findsOneWidget);
        expect(find.text('GitHub'), findsOneWidget);
      }
    },
  );
}
