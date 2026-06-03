// lib/components/patient_view/anatomy_viewer.dart
// Interactive physiology visualization upgrade using data-driven SVG config.
// Replaced body.mp4 with dynamic layer rendering based on AnatomyAnimationConfig.

import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/prescriptions.dart';
import '../../data/anatomy_config.dart';

class AnatomyViewer extends StatefulWidget {
  final BodySystem bodySystem;
  final double height;
  final AnatomyAnimationConfig? config;
  final ValueNotifier<int>? activeStepNotifier;

  const AnatomyViewer({
    super.key,
    required this.bodySystem,
    this.height = 350, 
    this.config,
    this.activeStepNotifier,
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
    _controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: this,
    )..repeat();
    
    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: widget.height,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.black.withAlpha(10),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          // Base SVG Anatomy Model
          ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: SvgPicture.asset(
              'assets/anatomy/${widget.bodySystem.name}.svg',
              height: widget.height,
              fit: BoxFit.contain,
              placeholderBuilder: (context) => const Center(child: CircularProgressIndicator(color: Color(0xFF1D9E75))),
            ),
          ),
          
          // Mechanism Pathway Animation Overlay
          if (widget.config != null)
            Positioned.fill(
              child: AnimatedBuilder(
                animation: Listenable.merge([_animation, widget.activeStepNotifier]),
                builder: (context, child) {
                  return CustomPaint(
                    painter: _MechanismPainter(
                      config: widget.config!,
                      progress: _animation.value,
                      activeStep: widget.activeStepNotifier?.value ?? -1,
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
  final AnatomyAnimationConfig config;
  final double progress;
  final int activeStep;

  _MechanismPainter({
    required this.config,
    required this.progress,
    required this.activeStep,
  });

  @override
  void paint(Canvas canvas, Size size) {
    // If no active step yet, don't draw overlays
    if (activeStep < 0) return;

    // Collect active items to draw
    final activeIds = <String>{};
    for (int i = 0; i <= activeStep; i++) {
      if (config.narrationSyncPoints.containsKey(i)) {
        activeIds.addAll(config.narrationSyncPoints[i]!);
      }
    }

    // 1. Draw Paths first (so they are under organs)
    for (final path in config.animationPaths) {
      if (!activeIds.contains(path.id)) continue;
      _drawPath(canvas, size, path);
    }

    // 2. Draw Organs
    for (final organ in config.organTargets) {
      if (!activeIds.contains(organ.id)) continue;
      _drawOrgan(canvas, size, organ);
    }
    
    // 3. Draw Outcome if active
    if (activeIds.contains('outcome') && config.outcomeText.isNotEmpty) {
      // Find outcome position (usually bottom center of the active region, or default)
      final x = size.width / 2;
      final y = size.height * 0.8;
      _drawBenefit(canvas, config.outcomeText, x - 30, y, config.outcomeColor);
    }
  }

  void _drawOrgan(Canvas canvas, Size size, OrganTarget organ) {
    final x = organ.normalizedPosition.dx * size.width;
    final y = organ.normalizedPosition.dy * size.height;
    final paint = Paint()..isAntiAlias = true;

    // Base highlight
    paint.style = PaintingStyle.fill;
    
    if (organ.effectType == 'pulse') {
      final intensity = 0.5 + 0.5 * math.sin(progress * 2 * math.pi);
      paint.color = organ.highlightColor.withAlpha((200 * intensity).round());
      canvas.drawCircle(Offset(x, y), 25 + (5 * intensity), paint);
    } else {
      paint.color = organ.highlightColor.withAlpha(200);
      canvas.drawCircle(Offset(x, y), 25, paint);
    }
    
    _drawLabel(canvas, organ.name, x, y - 40);
  }

  void _drawPath(Canvas canvas, Size size, AnimationPath path) {
    final p1 = Offset(path.startNormalized.dx * size.width, path.startNormalized.dy * size.height);
    final p2 = Offset(path.endNormalized.dx * size.width, path.endNormalized.dy * size.height);
    
    _drawDashedPathway(canvas, p1, p2, path.color);

    // Particle
    if (path.style == 'particles') {
      final signalX = p1.dx + (p2.dx - p1.dx) * progress;
      final signalY = p1.dy + (p2.dy - p1.dy) * progress;
      canvas.drawCircle(Offset(signalX, signalY), 6, Paint()..color = Colors.white);
    }
  }

  void _drawDashedPathway(Canvas canvas, Offset p1, Offset p2, Color color) {
    final paint = Paint()
      ..color = color.withAlpha(150)
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke;
      
    final dx = p2.dx - p1.dx;
    final dy = p2.dy - p1.dy;
    final distance = math.sqrt(dx * dx + dy * dy);
    
    const dashWidth = 5.0;
    const dashSpace = 5.0;
    double startY = 0.0;
    
    canvas.save();
    canvas.translate(p1.dx, p1.dy);
    canvas.rotate(math.atan2(dy, dx));
    
    while (startY < distance) {
      canvas.drawLine(Offset(startY, 0), Offset(startY + dashWidth, 0), paint);
      startY += dashWidth + dashSpace;
    }
    canvas.restore();
  }

  void _drawLabel(Canvas canvas, String text, double x, double y) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.bold,
          shadows: [Shadow(color: Colors.black87, blurRadius: 4)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    
    final bgRect = RRect.fromRectAndRadius(
      Rect.fromLTWH(x - (textPainter.width / 2) - 4, y - 2, textPainter.width + 8, textPainter.height + 4),
      const Radius.circular(4),
    );
    canvas.drawRRect(bgRect, Paint()..color = Colors.black54);
    textPainter.paint(canvas, Offset(x - (textPainter.width / 2), y));
  }

  void _drawBenefit(Canvas canvas, String text, double x, double y, Color textColor) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: textColor,
          fontSize: 18,
          fontWeight: FontWeight.w900,
          shadows: const [Shadow(color: Colors.white, blurRadius: 6)],
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    
    textPainter.paint(canvas, Offset(x - (textPainter.width / 2) + 30, y));
  }

  @override
  bool shouldRepaint(covariant _MechanismPainter oldDelegate) {
    return oldDelegate.progress != progress || oldDelegate.activeStep != activeStep || oldDelegate.config != config;
  }
}
