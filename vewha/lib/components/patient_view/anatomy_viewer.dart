import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import '../../data/prescriptions.dart';

class AnatomyViewer extends StatelessWidget {
  final BodySystem bodySystem;
  final double height;

  const AnatomyViewer({
    super.key,
    required this.bodySystem,
    this.height = 280,
  });

  String get _assetPath {
    switch (bodySystem) {
      case BodySystem.endocrine:      return 'assets/anatomy/endocrine.svg';
      case BodySystem.respiratory:    return 'assets/anatomy/respiratory.svg';
      case BodySystem.integumentary:  return 'assets/anatomy/integumentary.svg';
      case BodySystem.cardiovascular: return 'assets/anatomy/cardiovascular.svg';
      case BodySystem.systemic:       return 'assets/anatomy/systemic.svg';
    }
  }

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      _assetPath,
      height: height,
      semanticsLabel: 'Body diagram showing affected area',
    );
  }
}
