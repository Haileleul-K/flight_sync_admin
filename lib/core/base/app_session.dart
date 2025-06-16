import 'package:shared_preferences/shared_preferences.dart';

//TO manage Logged in user's session
class AppSession {
  static const _tokenKey = 'access_token';

  /// Save access token
  static Future<void> setAccessToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_tokenKey, token);
  }

  /// Fetch access token
  static Future<String?> getAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_tokenKey);
  }

  static Future<void> saveUserCredential(
      {required String email, required String pwd}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('email', email);
    await prefs.setString('password', pwd);
  }

  static Future<Map<String, dynamic>?> getUserCredential() async {
    final prefs = await SharedPreferences.getInstance();
    String? email = prefs.getString('email');
    String? password = prefs.getString('password');
    if (email != null && password != null) {
      return {"email": "$email", "password": "$password"};
    }

    return null;
  }

  /// Remove access token (e.g., on logout)
  static Future<void> clearAccessToken() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_tokenKey);
  }


  static Future<void> removeUserCredential() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove("email");
    await prefs.remove("password");
  }
}
