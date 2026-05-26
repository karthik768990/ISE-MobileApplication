import 'package:flutter/material.dart';
import '../../data/prescriptions.dart';
import '../../logging/study_logger.dart';
import '../../i18n/strings.dart';

class _Question {
  final String id;
  final String questionText;
  final String correctAnswer; // lowercase for comparison
  _Question(this.id, this.questionText, this.correctAnswer);
}

class ComprehensionScreen extends StatefulWidget {
  final StudyDrug drug;
  final int timeOnScreenMs;
  final bool audioPlayed;
  final String language;

  const ComprehensionScreen({
    super.key,
    required this.drug,
    required this.timeOnScreenMs,
    required this.audioPlayed,
    required this.language,
  });

  @override
  State<ComprehensionScreen> createState() => _ComprehensionScreenState();
}

class _ComprehensionScreenState extends State<ComprehensionScreen> {
  int _currentQ = 0;
  final TextEditingController _answerController = TextEditingController();

  List<_Question> get _questions => [
    _Question('q_name',    'What is the name of this medicine?', widget.drug.name.toLowerCase()),
    _Question('q_dose',    'How much of this medicine do you take?', widget.drug.dose.toLowerCase()),
    _Question('q_freq',    'How often do you take this medicine?', widget.drug.frequency.toLowerCase()),
    _Question('q_route',   'How do you take this medicine?', widget.drug.route.toLowerCase()),
    _Question('q_purpose', 'What is this medicine for?', ''),  // open-ended, scored manually
  ];

  void _submit() {
    final q = _questions[_currentQ];
    final answer = _answerController.text.trim();
    if (answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(widget.language == 'en' ? 'Please enter an answer' : 'దయచేసి సమాధానాన్ని నమోదు చేయండి')));
      return;
    }

    final correct = q.id == 'q_purpose'
        ? true // open-ended — manual scoring
        : answer.toLowerCase().contains(q.correctAnswer.split(' ').first);

    StudyLogger().logAnswer(
      drugId: widget.drug.drugId,
      questionId: q.id,
      answer: answer,
      correct: correct,
      timeOnScreenMs: widget.timeOnScreenMs,
      audioPlayed: widget.audioPlayed,
      language: widget.language,
    );

    _answerController.clear();
    if (_currentQ < _questions.length - 1) {
      setState(() { _currentQ++; });
    } else {
      // Completed, pop back to detail or list screen.
      // Wait, let's pop twice to go back to MedicationListScreen.
      Navigator.of(context).pop(); // Pops ComprehensionScreen
      Navigator.of(context).pop(); // Pops MedicationDetailScreen or PlainTextConditionScreen
    }
  }

  @override
  void dispose() {
    _answerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _questions[_currentQ];
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          getString('question_prompt', widget.language),
          style: const TextStyle(color: Color(0xFF1A1A2E), fontSize: 16, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF555555)),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            LinearProgressIndicator(
              value: (_currentQ + 1) / _questions.length,
              backgroundColor: const Color(0xFFE0E0E0),
              color: const Color(0xFF1D9E75),
              minHeight: 6,
              borderRadius: BorderRadius.circular(3),
            ),
            const SizedBox(height: 16),
            Text(
              '${widget.language == 'te' ? 'ప్రశ్న' : 'Question'} ${_currentQ + 1} of ${_questions.length}',
              style: const TextStyle(fontSize: 14, color: Color(0xFF888888), fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 24),
            Text(
              getString(q.id, widget.language),
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF1A1A2E)),
            ),
            const SizedBox(height: 24),
            TextField(
              controller: _answerController,
              decoration: InputDecoration(
                hintText: widget.language == 'en' ? 'Type your answer here...' : 'మీ సమాధానాన్ని ఇక్కడ టైప్ చేయండి...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: const BorderSide(color: Color(0xFF1D9E75), width: 2),
                ),
              ),
              maxLines: 3,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D9E75),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  getString('submit', widget.language),
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
