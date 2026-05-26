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
  String _lang = 'en';

  @override
  void initState() {
    super.initState();
    _condition = widget.initialCondition;
  }

  void _launch() {
    final code = _codeController.text.trim();
    if (code.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _lang == 'en'
                ? 'Please enter a participant code'
                : 'దయచేసి పాల్గొనేవారి కోడ్‌ను నమోదు చేయండి',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    StudyLogger().startSession(code, _condition);
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => MedicationListScreen(
        condition: _condition,
        language: _lang,
      ),
    ));
  }

  Future<void> _export() async {
    final path = await StudyLogger().exportToCsv();
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _lang == 'en' ? 'Exported to: $path' : 'ఎగుమతి చేయబడింది: $path',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF1D9E75),
        ),
      );
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEn = _lang == 'en';
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isEn ? 'Study Setup' : 'స్టడీ సెటప్',
          style: const TextStyle(color: Color(0xFF1A1A2E), fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Language switcher in App Bar for total consistency
          TextButton(
            onPressed: () => setState(() => _lang = _lang == 'en' ? 'te' : 'en'),
            child: Text(
              isEn ? 'తెలుగు' : 'English',
              style: const TextStyle(color: Color(0xFF1D9E75), fontWeight: FontWeight.bold, fontSize: 16),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.download, color: Color(0xFF888888)),
            tooltip: isEn ? 'Export study data' : 'స్టడీ డేటా ఎగుమతి',
            onPressed: _export,
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEn ? 'Participant code' : 'పాల్గొనేవారి కోడ్',
                style: const TextStyle(fontSize: 16, color: Color(0xFF555555), fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _codeController,
                style: const TextStyle(fontSize: 18),
                decoration: InputDecoration(
                  hintText: isEn ? 'e.g. P01' : 'ఉదా: P01',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 18, vertical: 16),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(color: Color(0xFF1D9E75), width: 2),
                  ),
                ),
              ),
              const SizedBox(height: 32),
              Text(
                isEn ? 'Select study instructions style' : 'సూచనల శైలిని ఎంచుకోండి',
                style: const TextStyle(fontSize: 16, color: Color(0xFF555555), fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 14),
              Row(
                children: [
                  _conditionButton(
                    'A',
                    isEn ? 'Pictures + Voice' : 'చిత్రాలు + వాయిస్',
                    isEn
                        ? 'Uses body drawings, plain words, & speaks out loud.'
                        : 'శరీర పటాలు, సరళమైన భాష మరియు వాయిస్ సహాయాన్ని ఉపయోగిస్తుంది.',
                    Icons.image,
                    Icons.volume_up,
                    const Color(0xFF1D9E75),
                    const Color(0xFFE8F8F5),
                  ),
                  const SizedBox(width: 16),
                  _conditionButton(
                    'B',
                    isEn ? 'Basic Text Table' : 'సాధారణ టెక్స్ట్ పట్టిక',
                    isEn
                        ? 'Uses a simple clinical text table only.'
                        : 'కేవలం సాధారణ క్లినికల్ టెక్స్ట్ పట్టికను మాత్రమే ఉపయోగిస్తుంది.',
                    Icons.description,
                    Icons.table_chart,
                    const Color(0xFF455A64),
                    const Color(0xFFECEFF1),
                  ),
                ],
              ),
              const SizedBox(height: 80),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _launch,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF1D9E75),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                    elevation: 2,
                  ),
                  child: Text(
                    isEn ? 'Launch Study' : 'స్టడీ ప్రారంభించు',
                    style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _conditionButton(
    String value,
    String title,
    String subtitle,
    IconData icon1,
    IconData icon2,
    Color activeColor,
    Color activeBg,
  ) {
    final selected = _condition == value;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _condition = value),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          height: 220, // Tall, accessible visual button
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: selected ? activeBg : const Color(0xFFF9F9F9),
            border: Border.all(
              color: selected ? activeColor : const Color(0xFFDDDDDD),
              width: selected ? 3.0 : 1.5,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: activeColor.withOpacity(0.15),
                      blurRadius: 8,
                      offset: const Offset(0, 4),
                    )
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Double Icons row for unmistakable visual cue
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(icon1, size: 36, color: selected ? activeColor : const Color(0xFF888888)),
                  const SizedBox(width: 8),
                  Icon(icon2, size: 36, color: selected ? activeColor : const Color(0xFF888888)),
                ],
              ),
              const SizedBox(height: 16),
              // Accent Title
              Text(
                title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: selected ? activeColor : const Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 8),
              // Accessible small description
              Text(
                subtitle,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 12,
                  height: 1.4,
                  fontWeight: FontWeight.w500,
                  color: selected ? activeColor.withOpacity(0.85) : const Color(0xFF666666),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
