// ignore_for_file: depend_on_referenced_packages, unnecessary_import
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';

import 'package:Vewha/data/prescriptions.dart';
import 'package:Vewha/logging/performance_tracker.dart';
import 'package:Vewha/Screens/patient_view/patient_entry_screen.dart';
import 'package:Vewha/Screens/patient_view/medication_detail_screen.dart';
import 'package:Vewha/Screens/patient_view/plain_text_condition_screen.dart';

class MockPathProviderPlatform extends PathProviderPlatform
    with MockPlatformInterfaceMixin {
  @override
  Future<String?> getApplicationDocumentsPath() async {
    return '.';
  }
}

void main() {
  setUpAll(() {
    PathProviderPlatform.instance = MockPathProviderPlatform();
  });

  void setupMockChannels(WidgetTester tester) {
    tester.binding.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('flutter_tts'),
      (MethodCall methodCall) async {
        return 1;
      },
    );

    tester.binding.defaultBinaryMessenger.setMockMessageHandler(
      'flutter/assets',
      (ByteData? message) async {
        if (message == null) return null;
        final String key = utf8.decode(message.buffer.asUint8List(message.offsetInBytes, message.lengthInBytes));
        if (key.startsWith('assets/anatomy/')) {
          final String svg = '<svg viewBox="0 0 200 400"><rect width="200" height="400" fill="gray"/></svg>';
          final Uint8List bytes = Uint8List.fromList(utf8.encode(svg));
          return ByteData.view(bytes.buffer);
        }
        return null;
      },
    );
  }

  group('UX Accessibility & Conditional Module Loading Tests', () {
    testWidgets('Bilingual Language Switcher translates setup screen', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: PatientEntryScreen(),
      ));

      // Initially in English
      expect(find.text('Study Setup'), findsOneWidget);
      expect(find.text('Launch Study'), findsOneWidget);

      // Tap Telugu switcher button
      await tester.tap(find.text('తెలుగు'));
      await tester.pump();

      // Verify Telugu UI completeness
      expect(find.text('స్టడీ సెటప్'), findsOneWidget);
      expect(find.text('స్టడీ ప్రారంభించు'), findsOneWidget);
      expect(find.text('చిత్రాలు + వాయిస్'), findsOneWidget);
    });

    testWidgets('Accessibility preview cards for Condition A vs B render with visual icons', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(
        home: PatientEntryScreen(),
      ));

      // Verifies custom layout icons are visible for low-literacy users
      expect(find.byIcon(Icons.image), findsOneWidget);
      expect(find.byIcon(Icons.volume_up), findsOneWidget);
      expect(find.byIcon(Icons.description), findsOneWidget);
      expect(find.byIcon(Icons.table_chart), findsOneWidget);
    });

    testWidgets('STRICT CONDITIONAL LOADING: Condition B must NOT initialize TTS or SVG rendering', (WidgetTester tester) async {
      setupMockChannels(tester);
      PatientModuleRegistry.reset();

      // Confirm both tracking flags are strictly false initially
      expect(PatientModuleRegistry.isTtsInitialized, isFalse);
      expect(PatientModuleRegistry.isSvgInitialized, isFalse);

      final drug = studyDrugs[0]; // Metformin

      // Build PlainTextConditionScreen (Condition B)
      await tester.pumpWidget(MaterialApp(
        home: PlainTextConditionScreen(drug: drug),
      ));

      // Assert that enhanced modules were NEVER initialized
      expect(PatientModuleRegistry.isTtsInitialized, isFalse);
      expect(PatientModuleRegistry.isSvgInitialized, isFalse);
    });

    testWidgets('STRICT CONDITIONAL LOADING: Condition A initializes TTS and SVG rendering correctly', (WidgetTester tester) async {
      setupMockChannels(tester);
      PatientModuleRegistry.reset();

      // Confirm flags are false
      expect(PatientModuleRegistry.isTtsInitialized, isFalse);
      expect(PatientModuleRegistry.isSvgInitialized, isFalse);

      final drug = studyDrugs[0]; // Metformin

      // Build MedicationDetailScreen (Condition A)
      await tester.pumpWidget(MaterialApp(
        home: MedicationDetailScreen(drug: drug),
      ));

      // Assert that both modules have initialized programmatically
      expect(PatientModuleRegistry.isTtsInitialized, isTrue);
      expect(PatientModuleRegistry.isSvgInitialized, isTrue);
    });
  });
}
