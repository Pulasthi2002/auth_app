import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/models/user_model.dart';
import '../../data/repositories/auth_repository.dart';
import '../../data/repositories/image_repository.dart';

class UserNotifier extends Notifier<UserModel?> {
  @override
  UserModel? build() => null;

  void setUser(UserModel user) {
    state = user;
  }

  void clearUser() {
    state = null;
  }
}

final userProvider = NotifierProvider<UserNotifier, UserModel?>(
      () => UserNotifier(),
);

final authRepositoryProvider = Provider<AuthRepository>(
      (ref) => AuthRepository(),
);

final imageRepositoryProvider = Provider<ImageRepository>(
      (ref) => ImageRepository(),
);
