import 'package:flutter/material.dart';
import '../../data/prescriptions.dart';
import '../../logging/study_logger.dart';

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

  BilingualQuestion get _currentQuestion => widget.drug.questions[_currentQ];

  void _submit() {
    final q = _currentQuestion;
    final answer = _answerController.text.trim().toLowerCase();
    final isTe = widget.language == 'te';

    if (answer.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            isTe ? 'దయచేసి సమాధానాన్ని నమోదు చేయండి' : 'Please enter an answer',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          backgroundColor: Colors.orangeAccent,
        ),
      );
      return;
    }

    // Flexible grading matching any of the expected keywords in English or Telugu
    bool correct = false;
    if (q.id == 'q_verify') {
      correct = answer == 'yes' ||
          answer == 'y' ||
          answer.contains('అవును') ||
          answer.contains('సరే') ||
          answer.contains('అర్థమైంది');
    } else {
      final keywordsEn = q.expectedEn.split(',').map((s) => s.trim().toLowerCase()).toList();
      final keywordsTe = q.expectedTe.split(',').map((s) => s.trim().toLowerCase()).toList();

      final matchesEn = keywordsEn.any((kw) => kw.isNotEmpty && answer.contains(kw));
      final matchesTe = keywordsTe.any((kw) => kw.isNotEmpty && answer.contains(kw));
      correct = matchesEn || matchesTe;
    }

    StudyLogger().logAnswer(
      drugId: widget.drug.drugId,
      questionId: q.id,
      answer: _answerController.text.trim(),
      correct: correct,
      timeOnScreenMs: widget.timeOnScreenMs,
      audioPlayed: widget.audioPlayed,
      language: widget.language,
    );

    _answerController.clear();
    if (_currentQ < widget.drug.questions.length - 1) {
      setState(() {
        _currentQ++;
      });
    } else {
      // Completed, pop back to MedicationListScreen.
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
    final q = _currentQuestion;
    final isTe = widget.language == 'te';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          isTe ? 'ప్రశ్నలకు సమాధానం ఇవ్వండి' : 'Study Evaluation Quiz',
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
              value: (_currentQ + 1) / widget.drug.questions.length,
              backgroundColor: const Color(0xFFE0E0E0),
              color: const Color(0xFF1D9E75),
              minHeight: 8,
              borderRadius: BorderRadius.circular(4),
            ),
            const SizedBox(height: 18),
            Text(
              isTe
                  ? 'ప్రశ్న ${_currentQ + 1} / ${widget.drug.questions.length}'
                  : 'Question ${_currentQ + 1} of ${widget.drug.questions.length}',
              style: const TextStyle(fontSize: 14, color: Color(0xFF888888), fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 28),
            Text(
              isTe ? q.questionTe : q.questionEn,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                height: 1.4,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 28),
            TextField(
              controller: _answerController,
              style: const TextStyle(fontSize: 18),
              decoration: InputDecoration(
                hintText: isTe ? 'మీ సమాధానాన్ని ఇక్కడ టైప్ చేయండి...' : 'Type your answer here...',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: const BorderSide(color: Color(0xFF1D9E75), width: 2),
                ),
              ),
              maxLines: 4,
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _submit,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1D9E75),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 18),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: Text(
                  isTe ? 'సమాధానం సమర్పించండి' : 'Submit Answer',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
