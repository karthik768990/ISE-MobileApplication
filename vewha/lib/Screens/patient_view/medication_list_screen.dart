import 'package:flutter/material.dart';
import '../../data/prescriptions.dart';
import '../../components/patient_view/progress_stepper.dart';
import 'medication_detail_screen.dart';
import 'plain_text_condition_screen.dart';

class MedicationListScreen extends StatefulWidget {
  final String condition; // 'A' or 'B'
  const MedicationListScreen({super.key, required this.condition});

  @override
  State<MedicationListScreen> createState() => _MedicationListScreenState();
}

class _MedicationListScreenState extends State<MedicationListScreen> {
  int _current = 0;

  void _go(int index) {
    if (index < 0 || index >= studyDrugs.length) return;
    setState(() => _current = index);
  }

  void _openDetail() {
    final drug = studyDrugs[_current];
    if (widget.condition == 'A') {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => MedicationDetailScreen(drug: drug)));
    } else {
      Navigator.of(context).push(MaterialPageRoute(
        builder: (_) => PlainTextConditionScreen(drug: drug)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final drug = studyDrugs[_current];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Medication ${_current + 1} of ${studyDrugs.length}',
          style: const TextStyle(color: Color(0xFF1A1A2E), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF555555)),
          onPressed: () => Navigator.of(context).pop()),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            ProgressStepper(
              currentIndex: _current,
              total: studyDrugs.length,
              onTap: _go),
            const SizedBox(height: 24),
            Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: const BorderSide(color: Color(0xFFE0E0E0))),
              child: InkWell(
                onTap: _openDetail,
                borderRadius: BorderRadius.circular(12),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(drug.name,
                        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,
                            color: Color(0xFF1A1A2E))),
                      const SizedBox(height: 8),
                      Text(drug.purpose,
                        style: const TextStyle(fontSize: 14, color: Color(0xFF555555))),
                      const SizedBox(height: 16),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text('Tap to view details',
                            style: TextStyle(fontSize: 13, color: Color(0xFF1D9E75), fontWeight: FontWeight.bold)),
                          SizedBox(width: 4),
                          Icon(Icons.arrow_forward, size: 16, color: Color(0xFF1D9E75)),
                        ],
                      )
                    ],
                  ),
                ),
              ),
            ),
            const Spacer(),
            Row(children: [
              if (_current > 0)
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => _go(_current - 1),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      side: const BorderSide(color: Color(0xFF1D9E75)),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Previous', style: TextStyle(color: Color(0xFF1D9E75), fontWeight: FontWeight.bold)),
                  ),
                ),
              if (_current > 0) const SizedBox(width: 12),
              if (_current < studyDrugs.length - 1)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => _go(_current + 1),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF1D9E75),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Next', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
              if (_current == studyDrugs.length - 1)
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF534AB7),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                    ),
                    child: const Text('Done', style: TextStyle(fontWeight: FontWeight.bold)),
                  ),
                ),
            ]),
          ],
        ),
      ),
    );
  }
}
