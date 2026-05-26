// Condition B control screen — plain clinical table, no visuals, no audio.
import 'package:flutter/material.dart';
import '../../data/prescriptions.dart';
import 'comprehension_screen.dart';

class PlainTextConditionScreen extends StatefulWidget {
  final StudyDrug drug;
  const PlainTextConditionScreen({super.key, required this.drug});

  @override
  State<PlainTextConditionScreen> createState() => _PlainTextConditionScreenState();
}

class _PlainTextConditionScreenState extends State<PlainTextConditionScreen> {
  final DateTime _screenOpenTime = DateTime.now();

  void _openComprehension() {
    final elapsed = DateTime.now().difference(_screenOpenTime).inMilliseconds;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ComprehensionScreen(
        drug: widget.drug,
        timeOnScreenMs: elapsed,
        audioPlayed: false,
        language: 'en',
      )));
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.drug;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Prescription', style: TextStyle(color: Color(0xFF1A1A2E), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF555555)),
          onPressed: () => Navigator.of(context).pop()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Table(
              border: TableBorder.all(color: const Color(0xFFE0E0E0), borderRadius: BorderRadius.circular(4)),
              columnWidths: const {0: FixedColumnWidth(110), 1: FlexColumnWidth()},
              children: [
                _headerRow(),
                _dataRow('Medicine', d.name),
                _dataRow('Dose', d.dose),
                _dataRow('Route', d.route),
                _dataRow('Frequency', d.frequency),
                _dataRow('Purpose', d.purpose),
              ],
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _openComprehension,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF534AB7),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Answer questions', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _headerRow() => TableRow(
    decoration: const BoxDecoration(color: Color(0xFF1A1A2E)),
    children: ['Field', 'Details'].map((h) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      child: Text(h, style: const TextStyle(color: Colors.white,
          fontWeight: FontWeight.bold, fontSize: 13)))).toList());

  TableRow _dataRow(String label, String value) => TableRow(
    children: [
      Padding(padding: const EdgeInsets.all(12),
        child: Text(label, style: const TextStyle(fontSize: 13,
            color: Color(0xFF555555), fontWeight: FontWeight.w600))),
      Padding(padding: const EdgeInsets.all(12),
        child: Text(value, style: const TextStyle(fontSize: 13, color: Color(0xFF333333)))),
    ]);
}
