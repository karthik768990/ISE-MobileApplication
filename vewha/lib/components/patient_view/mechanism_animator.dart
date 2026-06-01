// lib/components/patient_view/mechanism_animator.dart
// Visual-first interactive drug mechanism storyboard animator.
// Renders active animated nodes, connecting flow indicators, and custom path tracers.
// Helps fully illiterate patients understand how their medicine works in the body.

import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class StoryboardNode {
  final IconData icon;
  final String labelEn;
  final String labelTe;
  final String labelHi;

  const StoryboardNode({
    required this.icon,
    required this.labelEn,
    required this.labelTe,
    required this.labelHi,
  });
}

class MechanismAnimator extends StatefulWidget {
  final String drugKey;
  final List<String> steps;
  final Color accentColor;
  final String language; // 'en', 'te', 'hi'
  final ValueNotifier<int>? activeStepNotifier;

  const MechanismAnimator({
    super.key,
    required this.drugKey,
    required this.steps,
    required this.language,
    this.accentColor = const Color(0xFF1D9E75),
    this.activeStepNotifier,
  });

  @override
  State<MechanismAnimator> createState() => _MechanismAnimatorState();
}

class _MechanismAnimatorState extends State<MechanismAnimator> with SingleTickerProviderStateMixin {
  int _visibleCount = 0;
  Timer? _timer;
  bool _completed = false;
  late AnimationController _pulseController;

  static const Map<String, List<StoryboardNode>> _storyboards = {
    'metformin_01': [
      StoryboardNode(icon: Icons.medication_outlined, labelEn: 'Tablet', labelTe: 'టాబ్లెట్', labelHi: 'गोली'),
      StoryboardNode(icon: Icons.layers_outlined, labelEn: 'Stomach', labelTe: 'కడుపు', labelHi: 'पेट'),
      StoryboardNode(icon: Icons.bloodtype_outlined, labelEn: 'Liver', labelTe: 'కాలేయం', labelHi: 'जिगर'),
      StoryboardNode(icon: Icons.trending_down_outlined, labelEn: 'Less Sugar', labelTe: 'తక్కువ చక్కెర', labelHi: 'कम शर्करा'),
    ],
    'salbutamol_01': [
      StoryboardNode(icon: Icons.air, labelEn: 'Inhaler', labelTe: 'ఇన్హేలర్', labelHi: 'इनहेलर'),
      StoryboardNode(icon: Icons.bubble_chart_outlined, labelEn: 'Lungs', labelTe: 'ఊపిరితిత్తులు', labelHi: 'फेफड़े'),
      StoryboardNode(icon: Icons.fit_screen_outlined, labelEn: 'Expand', labelTe: 'వెడల్పు', labelHi: 'फैलाव'),
      StoryboardNode(icon: Icons.sentiment_very_satisfied_outlined, labelEn: 'Easy Breath', labelTe: 'సులభ శ్వాస', labelHi: 'सहज सांस'),
    ],
    'betamethasone_01': [
      StoryboardNode(icon: Icons.clean_hands_outlined, labelEn: 'Cream', labelTe: 'క్రీమ్', labelHi: 'क्रीम'),
      StoryboardNode(icon: Icons.back_hand_outlined, labelEn: 'Skin', labelTe: 'చర్మం', labelHi: 'त्वचा'),
      StoryboardNode(icon: Icons.spa_outlined, labelEn: 'Calm', labelTe: 'ఉపశమనం', labelHi: 'राहत'),
      StoryboardNode(icon: Icons.done_all_outlined, labelEn: 'Relief', labelTe: 'నివారణ', labelHi: 'आराम'),
    ],
    'amlodipine_01': [
      StoryboardNode(icon: Icons.medication_outlined, labelEn: 'Tablet', labelTe: 'టాబ్లెట్', labelHi: 'गोली'),
      StoryboardNode(icon: Icons.timeline_outlined, labelEn: 'Vessel', labelTe: 'రక్తనాళం', labelHi: 'रक्त वाहिका'),
      StoryboardNode(icon: Icons.zoom_out_map_outlined, labelEn: 'Widen', labelTe: 'సడలింపు', labelHi: 'शिथिलता'),
      StoryboardNode(icon: Icons.favorite_outline, labelEn: 'Stable BP', labelTe: 'స్థిర బీపీ', labelHi: 'स्थिर बीपी'),
    ],
    'prednisolone_01': [
      StoryboardNode(icon: Icons.medication_outlined, labelEn: 'Tablet', labelTe: 'టాబ్లెట్', labelHi: 'गोली'),
      StoryboardNode(icon: Icons.waves_outlined, labelEn: 'Bloodstream', labelTe: 'రక్తం', labelHi: 'रक्तप्रवाह'),
      StoryboardNode(icon: Icons.shield_outlined, labelEn: 'Calm Immune', labelTe: 'రోగనిరోధక', labelHi: 'प्रतिरक्षा शांत'),
      StoryboardNode(icon: Icons.health_and_safety_outlined, labelEn: 'Swelling Down', labelTe: 'వాపు తగ్గుతుంది', labelHi: 'सूजन कम'),
    ],
  };

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);

    if (widget.activeStepNotifier != null) {
      widget.activeStepNotifier!.addListener(_onStepNotifierChanged);
      _onStepNotifierChanged();
    } else {
      _startAnimation();
    }
  }

  void _onStepNotifierChanged() {
    final step = widget.activeStepNotifier!.value;
    if (step < 0) {
      setState(() {
        _visibleCount = 0;
        _completed = false;
      });
    } else {
      setState(() {
        _visibleCount = step + 1; // 0-based step, 1-based visible count
        if (_visibleCount >= widget.steps.length) {
          _completed = true;
        } else {
          _completed = false;
        }
      });
    }
  }

  void _startAnimation() {
    _visibleCount = 0;
    _completed = false;
    _timer?.cancel();
    setState(() => _visibleCount = 1);
    _timer = Timer.periodic(const Duration(milliseconds: 1800), (t) {
      if (!mounted) { t.cancel(); return; }
      if (_visibleCount < widget.steps.length) {
        setState(() => _visibleCount++);
      } else {
        t.cancel();
        if (mounted) setState(() => _completed = true);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    _pulseController.dispose();
    widget.activeStepNotifier?.removeListener(_onStepNotifierChanged);
    super.dispose();
  }

  String _t(StoryboardNode node) {
    if (widget.language == 'te') return node.labelTe;
    if (widget.language == 'hi') return node.labelHi;
    return node.labelEn;
  }

  @override
  Widget build(BuildContext context) {
    final nodes = _storyboards[widget.drugKey] ?? [];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section header
        Row(
          children: [
            Icon(Icons.biotech_outlined, size: 18, color: widget.accentColor),
            const SizedBox(width: 6),
            Text(
              widget.language == 'te'
                  ? 'మందు పని చేసే విధానం'
                  : widget.language == 'hi'
                      ? 'दवा काम करने का तरीका'
                      : 'How this medicine works',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: widget.accentColor,
              ),
            ),
            const Spacer(),
            if (_completed)
              GestureDetector(
                onTap: _startAnimation,
                child: Row(
                  children: [
                    Icon(Icons.replay, size: 16, color: widget.accentColor),
                    const SizedBox(width: 4),
                    Text(
                      widget.language == 'te' ? 'మళ్లీ చూడండి' : widget.language == 'hi' ? 'फिर से देखें' : 'Replay',
                      style: TextStyle(
                        fontSize: 13,
                        color: widget.accentColor,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
        const SizedBox(height: 20),

        // Lottie Animation (Reused Visuals)
        Center(
          child: SizedBox(
            height: 120,
            child: Lottie.asset(
              'assets/animations/mechanism_${widget.drugKey.split('_').first}.json',
              repeat: true,
              errorBuilder: (context, error, stackTrace) => const SizedBox(), // Fallback if missing
            ),
          ),
        ),
        const SizedBox(height: 16),

        // Visual Storyboard Node Row
        if (nodes.isNotEmpty)
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF9FBF9),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE8EFEA)),
            ),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(nodes.length, (index) {
                    final node = nodes[index];
                    final isActive = index < _visibleCount;
                    final isCurrent = index == _visibleCount - 1 && !_completed;

                    return Expanded(
                      child: Row(
                        children: [
                          // Storyboard Node
                          Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              AnimatedBuilder(
                                animation: _pulseController,
                                builder: (context, child) {
                                  final double scale = isCurrent
                                      ? 1.0 + (_pulseController.value * 0.12)
                                      : 1.0;
                                  return Transform.scale(
                                    scale: scale,
                                    child: AnimatedContainer(
                                      duration: const Duration(milliseconds: 400),
                                      width: 46,
                                      height: 46,
                                      decoration: BoxDecoration(
                                        color: isActive ? widget.accentColor : const Color(0xFFE0E0E0),
                                        shape: BoxShape.circle,
                                        boxShadow: isCurrent
                                            ? [
                                                BoxShadow(
                                                  color: widget.accentColor.withAlpha((0.4 * 255).round()),
                                                  blurRadius: 10,
                                                  spreadRadius: 2,
                                                )
                                              ]
                                            : null,
                                      ),
                                      child: Icon(
                                        node.icon,
                                        color: Colors.white,
                                        size: 24,
                                      ),
                                    ),
                                  );
                                },
                              ),
                              const SizedBox(height: 8),
                              SizedBox(
                                width: 68,
                                child: Text(
                                  _t(node),
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
                                    color: isActive ? const Color(0xFF0F4C3A) : const Color(0xFF888888),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          // Connector Line
                          if (index < nodes.length - 1)
                            Expanded(
                              child: Padding(
                                padding: const EdgeInsets.only(bottom: 22),
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    Container(
                                      height: 4,
                                      decoration: BoxDecoration(
                                        color: index < _visibleCount - 1
                                            ? widget.accentColor
                                            : const Color(0xFFE0E0E0),
                                        borderRadius: BorderRadius.circular(2),
                                      ),
                                    ),
                                    if (index == _visibleCount - 1 && !_completed)
                                      AnimatedBuilder(
                                        animation: _pulseController,
                                        builder: (context, child) {
                                          return Align(
                                            alignment: Alignment(-1.0 + (_pulseController.value * 2.0), 0),
                                            child: Container(
                                              width: 8,
                                              height: 8,
                                              decoration: const BoxDecoration(
                                                color: Colors.orangeAccent,
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                  ],
                                ),
                              ),
                            ),
                        ],
                      ),
                    );
                  }),
                ),
              ],
            ),
          ),
        const SizedBox(height: 18),

        // Text Step sequence
        ...List.generate(widget.steps.length, (i) {
          final isVisible = i < _visibleCount;
          return AnimatedOpacity(
            duration: const Duration(milliseconds: 500),
            opacity: isVisible ? 1.0 : 0.0,
            child: AnimatedSlide(
              duration: const Duration(milliseconds: 400),
              offset: isVisible ? Offset.zero : const Offset(0, 0.15),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 26,
                      height: 26,
                      margin: const EdgeInsets.only(right: 10, top: 1),
                      decoration: BoxDecoration(
                        color: widget.accentColor,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: Text(
                          '${i + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: Text(
                        widget.steps[i],
                        style: const TextStyle(
                          fontSize: 16,
                          color: Color(0xFF333333),
                          height: 1.5,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),

        if (!_completed) ...[
          const SizedBox(height: 4),
          Row(
            children: List.generate(widget.steps.length, (i) {
              return AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                margin: const EdgeInsets.only(right: 6),
                width: i < _visibleCount ? 20 : 8,
                height: 6,
                decoration: BoxDecoration(
                  color: i < _visibleCount
                      ? widget.accentColor
                      : const Color(0xFFDDDDDD),
                  borderRadius: BorderRadius.circular(3),
                ),
              );
            }),
          ),
        ],
      ],
    );
  }
}
