import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';

class ProfileAvatar extends StatelessWidget {
  final String? imageUrl;
  final double size;

  const ProfileAvatar({
    super.key,
    this.imageUrl,
    this.size = 140,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(5),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [
            AppColors.white,
            AppColors.transparentWhite30,
          ],
        ),
      ),
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppColors.transparentWhite30,
              AppColors.transparentWhite10,
            ],
          ),
        ),
        child: ClipOval(
          child: imageUrl != null && imageUrl!.isNotEmpty
              ? Image.network(
            imageUrl!,
            fit: BoxFit.cover,
            width: size,
            height: size,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Center(
                child: CircularProgressIndicator(
                  value: loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                      loadingProgress.expectedTotalBytes!
                      : null,
                  color: AppColors.white,
                  strokeWidth: 2,
                ),
              );
            },
            errorBuilder: (context, error, stackTrace) {
              return Icon(
                Icons.person_rounded,
                size: size * 0.5,
                color: AppColors.white,
              );
            },
          )
              : Icon(
            Icons.person_rounded,
            size: size * 0.5,
            color: AppColors.white,
          ),
        ),
      ),
    );
  }
}
