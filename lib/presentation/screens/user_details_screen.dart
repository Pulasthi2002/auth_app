import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../providers/user_provider.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glassmorphic_card.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/info_row.dart';

class UserDetailsScreen extends ConsumerWidget {
  const UserDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProvider);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    IconButton(
                      icon: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.transparentWhite20,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          color: AppColors.white,
                          size: 20,
                        ),
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                    const SizedBox(width: 12),
                    Text(
                      'User Details',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: AppColors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: user == null
                    ? Center(
                  child: Text(
                    'No user data available',
                    style: TextStyle(
                      color: AppColors.transparentWhite80,
                      fontSize: 16,
                    ),
                  ),
                )
                    : SingleChildScrollView(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      ProfileAvatar(imageUrl: user.profilePicture),
                      const SizedBox(height: 30),
                      GlassmorphicCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Complete Profile',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                color: AppColors.white,
                                letterSpacing: 0.5,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'All information about your account',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.transparentWhite70,
                              ),
                            ),
                            const SizedBox(height: 30),
                            InfoRow(
                              icon: Icons.fingerprint,
                              label: 'User ID',
                              value: user.id.toString(),
                            ),
                            const SizedBox(height: 20),
                            InfoRow(
                              icon: Icons.person_outline_rounded,
                              label: 'Full Name',
                              value: user.name,
                            ),
                            const SizedBox(height: 20),
                            InfoRow(
                              icon: Icons.email_outlined,
                              label: 'Email Address',
                              value: user.email,
                            ),
                            const SizedBox(height: 20),
                            InfoRow(
                              icon: Icons.calendar_today_outlined,
                              label: 'Account Created',
                              value: DateFormatter.formatDetailed(user.createdAt),
                            ),
                            const SizedBox(height: 20),
                            InfoRow(
                              icon: Icons.check_circle_outline,
                              label: 'Account Status',
                              value: 'Active',
                            ),
                            const SizedBox(height: 20),
                            InfoRow(
                              icon: Icons.verified_user_outlined,
                              label: 'Account Type',
                              value: 'Standard User',
                            ),
                            if (user.profilePicture != null && user.profilePicture!.isNotEmpty) ...[
                              const SizedBox(height: 20),
                              InfoRow(
                                icon: Icons.image_outlined,
                                label: 'Profile Picture',
                                value: 'Uploaded',
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(height: 40),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
