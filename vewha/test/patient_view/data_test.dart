import 'package:flutter_test/flutter_test.dart';
import 'package:Vewha/data/prescriptions.dart';
import 'package:Vewha/data/plain_language_map.dart';
import 'package:Vewha/i18n/strings.dart';

void main() {
  group('Prescription Data & Localization Validation', () {
    test('Validate all 5 medications exist and are unique', () {
      expect(studyDrugs.length, equals(5));

      final Set<String> drugIds = {};
      for (final drug in studyDrugs) {
        expect(drug.drugId.isNotEmpty, isTrue);
        expect(drug.name.isNotEmpty, isTrue);
        expect(drug.dose.isNotEmpty, isTrue);
        expect(drug.route.isNotEmpty, isTrue);
        expect(drug.frequency.isNotEmpty, isTrue);
        expect(drug.purpose.isNotEmpty, isTrue);
        expect(drug.plainLanguageKey.isNotEmpty, isTrue);

        // Verify ID uniqueness
        expect(drugIds.contains(drug.drugId), isFalse, reason: 'Duplicate drug ID detected: ${drug.drugId}');
        drugIds.add(drug.drugId);
      }
    });

    test('Validate Prednisolone systemic anatomy mapping', () {
      final prednisolone = studyDrugs.firstWhere((d) => d.drugId == 'prednisolone_01');
      expect(prednisolone.bodySystem, equals(BodySystem.systemic));
      expect(prednisolone.isNonObvious, isTrue);
    });

    test('Validate complete English and Telugu translations for all study drugs', () {
      for (final drug in studyDrugs) {
        final key = drug.plainLanguageKey;
        expect(plainLanguageMap.containsKey(key), isTrue, reason: 'Missing translation map for plainLanguageKey: $key');

        final entry = plainLanguageMap[key]!;
        
        // English validation
        expect(entry.containsKey('en'), isTrue, reason: 'Missing English translations for $key');
        final en = entry['en']!;
        expect(en.whatItIsFor.isNotEmpty, isTrue);
        expect(en.howToTake.isNotEmpty, isTrue);
        expect(en.audioText.isNotEmpty, isTrue);

        // Telugu validation
        expect(entry.containsKey('te'), isTrue, reason: 'Missing Telugu translations for $key');
        final te = entry['te']!;
        expect(te.whatItIsFor.isNotEmpty, isTrue);
        expect(te.howToTake.isNotEmpty, isTrue);
        expect(te.audioText.isNotEmpty, isTrue);
      }
    });

    test('Validate general UI translation dictionary values', () {
      expect(uiStrings.containsKey('en'), isTrue);
      expect(uiStrings.containsKey('te'), isTrue);

      final enStrings = uiStrings['en']!;
      final teStrings = uiStrings['te']!;

      expect(enStrings.length, equals(teStrings.length));

      for (final key in enStrings.keys) {
        expect(teStrings.containsKey(key), isTrue, reason: 'General UI translation missing Telugu key: $key');
        expect(enStrings[key]!.isNotEmpty, isTrue);
        expect(teStrings[key]!.isNotEmpty, isTrue);
      }
    });
  });
}
