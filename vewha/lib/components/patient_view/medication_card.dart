import 'package:flutter/material.dart';
import '../../data/prescriptions.dart';

class MedicationCard extends StatelessWidget {
  final StudyDrug drug;
  final String language;

  const MedicationCard({
    super.key,
    required this.drug,
    this.language = 'en',
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: const BorderSide(color: Color(0xFFE0E0E0)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(language == 'te' ? drug.nameTe : drug.name,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E))),
            const SizedBox(height: 12),
            _row(language == 'te' ? 'మోతాదు' : 'Dose', language == 'te' ? drug.doseTe : drug.dose),
            _row(language == 'te' ? 'ఎలా వాడాలి' : 'Route', language == 'te' ? drug.routeTe : drug.route),
            _row(language == 'te' ? 'ఎంత తరచుగా' : 'How often', language == 'te' ? drug.frequencyTe : drug.frequency),
            _row(language == 'te' ? 'దేనికి వాడతారు' : 'Purpose', language == 'te' ? drug.purposeTe : drug.purpose),
          ],
        ),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(width: 90,
            child: Text(label,
              style: const TextStyle(fontSize: 13, color: Color(0xFF888888), fontWeight: FontWeight.w500))),
          Expanded(
            child: Text(value,
              style: const TextStyle(fontSize: 14, color: Color(0xFF333333)))),
        ],
      ),
    );
  }
}
