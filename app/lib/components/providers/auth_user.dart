import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../models/user.dart';
import '../../repositories/auth_config.dart';
import '../../repositories/user.dart';

part 'auth_user.g.dart';

@Riverpod(keepAlive: true)
class AuthUser extends _$AuthUser {
  @override
  User? build() => null;

  Future<void> fetchUser() async {
    final token = await AuthConfig().getToken();
    if (token != null) {
      state = await UserRepository().getAuthUser();
    }
  }
}
