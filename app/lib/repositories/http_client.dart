import 'package:http/http.dart' as http;

import 'auth_config.dart';

class AuthException implements Exception {
  final String message;
  AuthException([this.message = 'Authentication failed.']);

  @override
  String toString() => 'AuthenticationException: $message';
}

class CustomHttpClient extends http.BaseClient {
  final http.Client _inner = http.Client();

  @override
  Future<http.StreamedResponse> send(http.BaseRequest request) async {
    final token = await AuthConfig().getToken();

    request.headers['Content-Type'] = 'application/json';
    if (token != null) request.headers['Authorization'] = 'Bearer $token';

    return _inner.send(request);
  }

  Future<http.Response> getWithCheck(Uri url) async {
    final response = await get(url);
    if (response.statusCode == 403) {
      throw AuthException();
    } else if (response.statusCode >= 400) {
      throw Exception('HTTP error: ${response.statusCode}');
    }
    return response;
  }
}
