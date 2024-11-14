// register_service.dart
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class RegisterService {
  final String? baseUrl = dotenv.env['BASE_URL'];

  Future<bool> register(String name, String email, String password,
      String confirmPassword, String gender, String birthDate) async {
    final url = Uri.parse('$baseUrl/register');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'nama': name,
          'email': email,
          'password': password,
          'confirmPassword': confirmPassword,
          'gender': gender,
          'tanggalLahir': birthDate,
        }),
      );

      if (response.statusCode == 201) {
        print("Registration successful");
        return true;
      } else {
        final data = jsonDecode(response.body);
        print("Registration failed: ${data['message']}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}
