import 'package:flutter/material.dart';
import 'dart:ui';
import '../../core/constants/app_colors.dart';

class GlassmorphicCard extends StatelessWidget {
  final Widget child;
  final EdgeInsets? padding;

  const GlassmorphicCard({
    super.key,
    required this.child,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(30),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: padding ?? const EdgeInsets.all(24.0),
          decoration: BoxDecoration(
            color: AppColors.transparentWhite20,
            borderRadius: BorderRadius.circular(30),
            border: Border.all(
              color: AppColors.transparentWhite30,
              width: 1.5,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
