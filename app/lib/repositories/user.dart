import 'dart:async';
import 'dart:convert';

import '../models/user.dart';

import 'auth_config.dart';
import 'http_client.dart';
import 'local_config.dart';

abstract class UserApiRepository {
  Future<String?> signup({required String email, required String password});
  Future<String?> login({required String email, required String password});
  Future<User?> getAuthUser();
}

class UserRepository extends UserApiRepository {
  UserRepository();

  static final client = CustomHttpClient();
  static const baseURL = '$apiHost/api/auth';

  @override
  Future<String?> signup({
    required String email,
    required String password,
  }) async {
    final response = await client.post(
      Uri.parse('$baseURL/signup'),
      body: json.encode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      await AuthConfig().setToken(response.body);
      return response.body;
    }
    return null;
  }

  @override
  Future<String?> login({
    required String email,
    required String password,
  }) async {
    final response = await client.post(
      Uri.parse('$baseURL/login'),
      body: json.encode({'email': email, 'password': password}),
    );
    if (response.statusCode == 200) {
      await AuthConfig().setToken(response.body);
      return response.body;
    }
    return null;
  }

  @override
  Future<User?> getAuthUser() async {
    final response = await client.get(Uri.parse('$baseURL/user'));
    if (response.statusCode == 200) {
      return User.fromJson(jsonDecode(response.body));
    }
    await AuthConfig().revokeToken();
    return null;
  }
}
