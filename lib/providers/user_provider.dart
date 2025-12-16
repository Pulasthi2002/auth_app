import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user_model.dart';

// StateNotifier to manage user state
class UserNotifier extends StateNotifier<UserModel?> {
  UserNotifier() : super(null);

  void setUser(UserModel user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }
}

// Provider that other widgets can access
final userProvider = StateNotifierProvider<UserNotifier, UserModel?>((ref) {
  return UserNotifier();
});
