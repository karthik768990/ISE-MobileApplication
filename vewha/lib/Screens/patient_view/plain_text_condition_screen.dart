// Condition B control screen — plain clinical table, no visuals, no audio.
import 'package:flutter/material.dart';
import '../../data/prescriptions.dart';
import 'comprehension_screen.dart';

class PlainTextConditionScreen extends StatefulWidget {
  final StudyDrug drug;
  final String initialLanguage;

  const PlainTextConditionScreen({
    super.key,
    required this.drug,
    this.initialLanguage = 'en',
  });

  @override
  State<PlainTextConditionScreen> createState() => _PlainTextConditionScreenState();
}

class _PlainTextConditionScreenState extends State<PlainTextConditionScreen> {
  late final DateTime _screenOpenTime;
  String _lang = 'en';

  @override
  void initState() {
    super.initState();
    _lang = widget.initialLanguage;
    _screenOpenTime = DateTime.now();
  }

  void _openComprehension() {
    final elapsed = DateTime.now().difference(_screenOpenTime).inMilliseconds;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ComprehensionScreen(
        drug: widget.drug,
        timeOnScreenMs: elapsed,
        audioPlayed: false,
        language: _lang,
      ),
    ));
  }

  @override
  Widget build(BuildContext context) {
    final d = widget.drug;
    final isTe = _lang == 'te';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isTe ? 'ప్రిస్క్రిప్షన్' : 'Prescription',
          style: const TextStyle(color: Color(0xFF1A1A2E), fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF555555)),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          // AppBar Language Switcher for perfect Condition B bilingual consistency
          TextButton(
            onPressed: () => setState(() => _lang = _lang == 'en' ? 'te' : 'en'),
            child: Text(
              _lang == 'en' ? 'తెలుగు' : 'English',
              style: const TextStyle(color: Color(0xFF1D9E75), fontWeight: FontWeight.bold, fontSize: 16),
            ),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Table(
              border: TableBorder.all(color: const Color(0xFFE0E0E0), width: 1.5, borderRadius: BorderRadius.circular(8)),
              columnWidths: const {0: FixedColumnWidth(110), 1: FlexColumnWidth()},
              children: [
                _headerRow(isTe ? 'ఫీల్డ్' : 'Field', isTe ? 'వివరాలు' : 'Details'),
                _dataRow(isTe ? 'మందు' : 'Medicine', isTe ? d.nameTe : d.name),
                _dataRow(isTe ? 'మోతాదు' : 'Dose', isTe ? d.doseTe : d.dose),
                _dataRow(isTe ? 'ఎలా వాడాలి' : 'Route', isTe ? d.routeTe : d.route),
                _dataRow(isTe ? 'ఎంత తరచుగా' : 'Frequency', isTe ? d.frequencyTe : d.frequency),
                _dataRow(isTe ? 'దేనికి వాడతారు' : 'Purpose', isTe ? d.purposeTe : d.purpose),
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
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                child: Text(
                  isTe ? 'ప్రశ్నలకు సమాధానం ఇవ్వండి' : 'Answer questions',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TableRow _headerRow(String fieldLabel, String detailsLabel) => TableRow(
        decoration: const BoxDecoration(color: Color(0xFF1A1A2E)),
        children: [fieldLabel, detailsLabel]
            .map((h) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
                  child: Text(
                    h,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ))
            .toList(),
      );

  TableRow _dataRow(String label, String value) => TableRow(children: [
        Padding(
          padding: const EdgeInsets.all(14),
          child: Text(
            label,
            style: const TextStyle(fontSize: 14, color: Color(0xFF555555), fontWeight: FontWeight.bold),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(14),
          child: Text(
            value,
            style: const TextStyle(fontSize: 14, color: Color(0xFF333333), height: 1.4),
          ),
        ),
      ]);
}
