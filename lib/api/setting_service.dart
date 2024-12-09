import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ResetPasswordService {
  final String? baseUrl = dotenv.env['BASE_URL'];

  Future<bool> resetPassword(
      String userId, String oldPassword, String newPassword) async {
    final url = Uri.parse('$baseUrl/$userId/change-password');

    try {
      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'currentPassword': oldPassword,
          'newPassword': newPassword,
          'confirmNewPassword': newPassword,
        }),
      );

      if (response.statusCode == 200) {
        print("Password reset successful");
        return true;
      } else {
        final data = jsonDecode(response.body);
        print("Password reset failed: ${data['message']}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}
