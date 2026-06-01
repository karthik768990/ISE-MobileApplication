// lib/components/patient_view/anatomy_viewer.dart
// Interactive physiology visualization upgrade.
// Extends base anatomy diagrams with animated custom mechanism storyboards (overlays).
// Enables fully illiterate users to comprehend body location, physiological effect, and benefit instantly.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/prescriptions.dart';
import '../../logging/performance_tracker.dart';

class AnatomyViewer extends StatefulWidget {
  final BodySystem bodySystem;
  final double height;
  final String? drugKey; // Optional: enables detailed animated mechanism overlays

  const AnatomyViewer({
    super.key,
    required this.bodySystem,
    this.height = 280,
    this.drugKey,
  });

  @override
  State<AnatomyViewer> createState() => _AnatomyViewerState();
}

class _AnatomyViewerState extends State<AnatomyViewer> with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    PatientModuleRegistry.isSvgInitialized = true;
    _controller = AnimationController(
      duration: const Duration(seconds: 2500),
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _assetPath {
    switch (widget.bodySystem) {
      case BodySystem.endocrine:      return 'assets/anatomy/endocrine.svg';
      case BodySystem.respiratory:    return 'assets/anatomy/respiratory.svg';
      case BodySystem.integumentary:  return 'assets/anatomy/integumentary.svg';
      case BodySystem.cardiovascular: return 'assets/anatomy/cardiovascular.svg';
      case BodySystem.systemic:       return 'assets/anatomy/systemic.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.height,
      alignment: Alignment.center,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Base Body Pulsing SVG
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              final double scale = 0.98 + (0.04 * math.sin(_animation.value * 2 * math.pi));
              return Transform.scale(
                scale: scale,
                child: SvgPicture.asset(
                  _assetPath,
                  height: widget.height,
                  semanticsLabel: 'Body diagram showing affected area',
                ),
              );
            },
          ),
          
          // Mechanism Pathway Animation Overlay
          if (widget.drugKey != null)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: _animation,
                builder: (context, child) {
                  return CustomPaint(
                    painter: _MechanismPainter(
                      drugKey: widget.drugKey!,
                      progress: _animation.value,
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }
}

class _MechanismPainter extends CustomPainter {
  final String drugKey;
  final double progress;

  _MechanismPainter({
    required this.drugKey,
    required this.progress,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final centerX = size.width / 2;
    final centerY = size.height / 2;

    switch (drugKey) {
      case 'metformin_01':
        _paintMetformin(canvas, centerX, centerY, size);
        break;
      case 'salbutamol_01':
        _paintSalbutamol(canvas, centerX, centerY, size);
        break;
      case 'betamethasone_01':
        _paintBetamethasone(canvas, centerX, centerY, size);
        break;
      case 'amlodipine_01':
        _paintAmlodipine(canvas, centerX, centerY, size);
        break;
      case 'prednisolone_01':
        _paintPrednisolone(canvas, centerX, centerY, size);
        break;
    }
  }

  void _paintMetformin(Canvas canvas, double cx, double cy, Size size) {
    final stomachX = cx - 10;
    final stomachY = cy - 20;
    final liverX = cx + 25;
    final liverY = cy - 5;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // 1. Stomach Highlight
    paint.color = const Color(0xFF1D9E75).withAlpha(200); // Increased alpha
    canvas.drawCircle(Offset(stomachX, stomachY), 16 + 4 * math.sin(progress * 2 * math.pi), paint);

    // 2. Liver Pulse
    final pulseScale = 12 + 6 * math.sin(progress * 4 * math.pi);
    paint.color = Colors.redAccent.withAlpha(220); // Increased alpha
    canvas.drawCircle(Offset(liverX, liverY), pulseScale, paint);

    // 3. Pathway Arrow (Stomach to Liver)
    final pathPaint = Paint()
      ..color = const Color(0xFF1D9E75)
      ..strokeWidth = 4 // Wider
      ..style = PaintingStyle.stroke;
    
    canvas.drawLine(Offset(stomachX, stomachY), Offset(liverX, liverY), pathPaint);

    // Moving signal dot
    final signalX = stomachX + (liverX - stomachX) * progress;
    final signalY = stomachY + (liverY - stomachY) * progress;
    paint.color = Colors.orangeAccent;
    canvas.drawCircle(Offset(signalX, signalY), 8, paint); // Larger dot

    // 4. Clinical Benefit: Sugar Down Indicator
    paint.color = Colors.green;
    paint.style = PaintingStyle.fill;
    final textPainter = TextPainter(
      text: const TextSpan(
        text: 'Sugar ↓',
        style: TextStyle(color: Colors.green, fontSize: 13, fontWeight: FontWeight.bold),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(liverX - 10, liverY + 14));
  }

  void _paintSalbutamol(Canvas canvas, double cx, double cy, Size size) {
    final throatX = cx;
    final throatY = cy - 65;
    final lungLeftX = cx - 20;
    final lungRightX = cx + 20;
    final lungsY = cy - 35;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // 1. Expanding Lungs Effect
    final expandScale = 22 + 4 * math.sin(progress * 2 * math.pi);
    paint.color = Colors.lightBlue.withAlpha(180); // Increased alpha
    canvas.drawCircle(Offset(lungLeftX, lungsY), expandScale, paint);
    canvas.drawCircle(Offset(lungRightX, lungsY), expandScale, paint);

    // 2. Inhaled Airflow stream (Particles descending down the throat into lungs)
    final flowProgress = (progress * 1.5) % 1.0;
    final currentY = throatY + (lungsY - throatY) * flowProgress;
    
    paint.color = Colors.blue;
    canvas.drawCircle(Offset(throatX - 5, currentY), 6, paint); // Larger
    canvas.drawCircle(Offset(throatX + 5, currentY), 6, paint);
  }

  void _paintBetamethasone(Canvas canvas, double cx, double cy, Size size) {
    // Local Skin area on arm
    final skinX = cx - 50;
    final skinY = cy + 45;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // 1. Shrinking Inflammation Rash
    final rashRadius = math.max(6.0, 18 * (1.0 - progress));
    paint.color = Colors.red.withAlpha((255 * (1.0 - progress)).round()); // Increased alpha to 255 max
    canvas.drawCircle(Offset(skinX, skinY), rashRadius, paint);

    // 2. Soothing teal halo expanding
    final tealPaint = Paint()
      ..color = const Color(0xFF1D9E75).withAlpha((180 * progress).round()) // Increased alpha to 180 max
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(skinX, skinY), 16 * progress, tealPaint);
  }

  void _paintAmlodipine(Canvas canvas, double cx, double cy, Size size) {
    // Vascular paths on the chest / cardiovascular area
    final heartX = cx;
    final heartY = cy - 25;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 4 + 2 * math.sin(progress * 2 * math.pi) // Widening vessel
      ..color = Colors.redAccent.withAlpha(220); // Increased alpha

    // 1. Widening Vessel paths
    canvas.drawCircle(Offset(heartX, heartY), 25, paint);
    canvas.drawCircle(Offset(heartX, heartY), 40, paint);

    // 2. Fast smooth blood flow arrows
    final flowPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.orangeAccent;
    final angle = progress * 2 * math.pi;
    final arrowX = heartX + 25 * math.cos(angle);
    final arrowY = heartY + 25 * math.sin(angle);
    canvas.drawCircle(Offset(arrowX, arrowY), 5, flowPaint);
  }

  void _paintPrednisolone(Canvas canvas, double cx, double cy, Size size) {
    // Full body systemic calm
    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // 1. Systemic glowing aura
    paint.color = Colors.purple.withAlpha((40 + 20 * math.sin(progress * 2 * math.pi)).round());
    canvas.drawCircle(Offset(cx, cy - 10), 55, paint);

    // 2. Decreasing swelling markers scattered on joints
    final joints = [
      Offset(cx - 30, cy + 25), // Hand left
      Offset(cx + 30, cy + 25), // Hand right
      Offset(cx - 20, cy + 90), // Knee left
      Offset(cx + 20, cy + 90), // Knee right
    ];

    for (final pos in joints) {
      final intensity = (150 * (1.0 - progress)).round();
      if (intensity > 20) {
        paint.color = Colors.redAccent.withAlpha(intensity);
        canvas.drawCircle(pos, 8 * (1.0 - progress), paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _MechanismPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.drugKey != drugKey;
  }
}
