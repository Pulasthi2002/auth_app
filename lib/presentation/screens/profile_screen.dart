import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui';
import '../../core/constants/app_colors.dart';
import '../../core/utils/date_formatter.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../providers/user_provider.dart';
import '../widgets/gradient_background.dart';
import '../widgets/glassmorphic_card.dart';
import '../widgets/profile_avatar.dart';
import '../widgets/info_row.dart';
import '../widgets/custom_button.dart';
import 'login_screen.dart';
import 'user_details_screen.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> with SingleTickerProviderStateMixin {
  Map<String, dynamic>? _userData;
  bool _isLoading = true;
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _loadProfile();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');

    if (token != null) {
      final authRepo = ref.read(authRepositoryProvider);
      final result = await authRepo.getProfile(token);

      if (mounted) {
        if (result['success']) {
          setState(() {
            _userData = result['data']['user'];
            _isLoading = false;
          });

          final user = UserModel.fromJson(result['data']['user']);
          ref.read(userProvider.notifier).setUser(user);
        } else {
          _logout();
        }
      }
    } else {
      _logout();
    }
  }

  void _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    ref.read(userProvider.notifier).clearUser();

    if (mounted) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const LoginScreen()),
      );
    }
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (context) => BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          title: const Text('Logout'),
          content: const Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel', style: TextStyle(color: AppColors.grey)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
                _logout();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.darkPurple,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
              child: Text('Logout', style: TextStyle(color: AppColors.grey)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: _isLoading
            ? Center(
          child: CircularProgressIndicator(
            color: AppColors.white,
            strokeWidth: 3,
          ),
        )
            : SafeArea(
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Profile',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.bold,
                            color: AppColors.white,
                          ),
                        ),
                        IconButton(
                          icon: Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: AppColors.transparentWhite20,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(Icons.logout_rounded, color: AppColors.white),
                          ),
                          onPressed: _showLogoutDialog,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                  ProfileAvatar(imageUrl: _userData?['profile_picture']),
                  const SizedBox(height: 20),
                  Text(
                    _userData?['name'] ?? 'User',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _userData?['email'] ?? '',
                    style: TextStyle(
                      fontSize: 16,
                      color: AppColors.transparentWhite80,
                      fontWeight: FontWeight.w300,
                    ),
                  ),
                  const SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: GlassmorphicCard(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Account Information',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          InfoRow(
                            icon: Icons.badge_outlined,
                            label: 'User ID',
                            value: _userData?['id']?.toString() ?? 'N/A',
                          ),
                          const SizedBox(height: 20),
                          InfoRow(
                            icon: Icons.person_outline_rounded,
                            label: 'Full Name',
                            value: _userData?['name'] ?? 'N/A',
                          ),
                          const SizedBox(height: 20),
                          InfoRow(
                            icon: Icons.email_outlined,
                            label: 'Email Address',
                            value: _userData?['email'] ?? 'N/A',
                          ),
                          const SizedBox(height: 20),
                          InfoRow(
                            icon: Icons.calendar_today_outlined,
                            label: 'Member Since',
                            value: DateFormatter.format(_userData?['created_at']),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24.0),
                    child: CustomButton(
                      text: 'View Detailed Information',
                      icon: Icons.info_outline_rounded,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const UserDetailsScreen(),
                          ),
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
