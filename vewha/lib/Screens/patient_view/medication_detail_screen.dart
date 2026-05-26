import 'package:flutter/material.dart';
import '../../data/prescriptions.dart';
import '../../data/plain_language_map.dart';
import '../../components/patient_view/anatomy_viewer.dart';
import '../../components/patient_view/audio_narration.dart';
import '../../components/patient_view/medication_card.dart';
import 'comprehension_screen.dart';

class MedicationDetailScreen extends StatefulWidget {
  final StudyDrug drug;
  const MedicationDetailScreen({super.key, required this.drug});

  @override
  State<MedicationDetailScreen> createState() => _MedicationDetailScreenState();
}

class _MedicationDetailScreenState extends State<MedicationDetailScreen> {
  String _lang = 'en';
  bool _audioPlayed = false;
  final DateTime _screenOpenTime = DateTime.now();

  PlainLangEntry get _entry =>
    plainLanguageMap[widget.drug.plainLanguageKey]?[_lang] ??
    plainLanguageMap[widget.drug.plainLanguageKey]!['en']!;

  String get _ttsLang => _lang == 'te' ? 'te-IN' : 'en-IN';

  void _openComprehension() {
    final elapsed = DateTime.now().difference(_screenOpenTime).inMilliseconds;
    Navigator.of(context).push(MaterialPageRoute(
      builder: (_) => ComprehensionScreen(
        drug: widget.drug,
        timeOnScreenMs: elapsed,
        audioPlayed: _audioPlayed,
        language: _lang,
      )));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(widget.drug.name,
          style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 16, fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF555555)),
          onPressed: () => Navigator.of(context).pop()),
        actions: [
          TextButton(
            onPressed: () => setState(() => _lang = _lang == 'en' ? 'te' : 'en'),
            child: Text(_lang == 'en' ? 'తెలుగు' : 'English',
              style: const TextStyle(color: Color(0xFF1D9E75), fontWeight: FontWeight.bold, fontSize: 16)),
          )
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Anatomy viewer
            Center(child: AnatomyViewer(bodySystem: widget.drug.bodySystem, height: 220)),
            const SizedBox(height: 8),
            Center(
              child: Text(_lang == 'te' ? 'ఇది మీ శరీరంలో ఎక్కడ పని చేస్తుంది' : 'Where this medicine works in your body',
                style: const TextStyle(fontSize: 12, color: Color(0xFF888888), fontWeight: FontWeight.w500))),
            const SizedBox(height: 24),
            // Plain language what it's for
            _section(_lang == 'te' ? 'ఈ మందు దేనికి వాడతారు' : 'What this medicine is for', _entry.whatItIsFor),
            const SizedBox(height: 16),
            _section(_lang == 'te' ? 'ఎలా వాడాలి' : 'How to take it', _entry.howToTake),
            const SizedBox(height: 20),
            // Audio button
            AudioNarration(
              text: _entry.audioText,
              languageCode: _ttsLang,
              onPlayStateChanged: (playing) {
                if (playing) setState(() => _audioPlayed = true);
              },
            ),
            const SizedBox(height: 24),
            // Clinical summary card
            Text(_lang == 'te' ? 'క్లినికల్ వివరాలు' : 'Clinical details',
              style: const TextStyle(fontSize: 13, color: Color(0xFF888888), fontWeight: FontWeight.w500)),
            const SizedBox(height: 8),
            MedicationCard(drug: widget.drug, language: _lang),
            const SizedBox(height: 28),
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
                child: Text(_lang == 'te' ? 'ప్రశ్నలకు సమాధానం ఇవ్వండి' : 'Answer questions about this medicine',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _section(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold,
            color: Color(0xFF1D9E75))),
        const SizedBox(height: 6),
        Text(content, style: const TextStyle(fontSize: 16, color: Color(0xFF333333),
            height: 1.6)),
      ],
    );
  }
}
