import 'package:flutter/material.dart';
import '../../logging/study_logger.dart';
import 'medication_list_screen.dart';

class PatientEntryScreen extends StatefulWidget {
  final String initialCondition;
  const PatientEntryScreen({super.key, this.initialCondition = 'A'});

  @override
  State<PatientEntryScreen> createState() => _PatientEntryScreenState();
}

class _PatientEntryScreenState extends State<PatientEntryScreen> {
  final _codeController = TextEditingController();
  String _condition = 'A';

  @override
  void initState() {
    super.initState();
    _condition = widget.initialCondition;
  }

  void _launch() {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please enter a participant code')));
      return;
    }
    StudyLogger().startSession(code, _condition);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => MedicationListScreen(condition: _condition)));
  }

  Future<void> _export() async {
    final path = await StudyLogger().exportToCsv();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Exported to: $path')));
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Study Setup', style: TextStyle(color: Color(0xFF1A1A2E), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.download, color: Color(0xFF888888)),
            tooltip: 'Export study data',
            onPressed: _export)
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('Participant code',
              style: TextStyle(fontSize: 14, color: Color(0xFF888888), fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            TextField(
              controller: _codeController,
              decoration: InputDecoration(
                hintText: 'e.g. P01',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
              ),
            ),
            const SizedBox(height: 24),
            const Text('Study condition',
              style: TextStyle(fontSize: 14, color: Color(0xFF888888), fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            Row(children: [
              _conditionButton('A', 'Condition A\n(Enhanced)'),
              const SizedBox(width: 12),
              _conditionButton('B', 'Condition B\n(Plain text)'),
            ]),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _launch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D9E75),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: const Text('Launch', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _conditionButton(String value, String label) {
    final selected = _condition == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _condition = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: selected ? const Color(0xFFE1F5EE) : const Color(0xFFF5F5F5),
            border: Border.all(
              color: selected ? const Color(0xFF1D9E75) : const Color(0xFFCCCCCC),
              width: selected ? 2 : 1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              fontWeight: selected ? FontWeight.bold : FontWeight.normal,
              color: selected ? const Color(0xFF085041) : const Color(0xFF555555))),
        ),
      ),
    );
  }
}
