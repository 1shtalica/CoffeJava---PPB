import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

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

  Future<bool> updateUserProfile({
    required String userId,
    required String token,
    String? nama,
    String? email,
    String? gender,
    String? tanggalLahir,
  }) async {
    final url = Uri.parse('$baseUrl/editUser/$userId');

    try {
      final Map<String, dynamic> updateData = {
        'nama': nama,
        'email': email,
        'gender': gender,
        'tanggalLahir': tanggalLahir,
      };

      updateData.removeWhere((key, value) => value == null);

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode(updateData),
      );

      if (response.statusCode == 200) {
        print('Profile updated successfully: ${response.body}');
        return true;
      } else {
        final data = jsonDecode(response.body);
        print('Failed to update profile: ${data['msg']}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }

  Future<bool> updateProfileImage({
    required String userId,
    required String token,
    required File imageFile,
  }) async {
    final url = Uri.parse('$baseUrl/editProfile/$userId');
    final request = http.MultipartRequest('POST', url);
    final storage = FlutterSecureStorage();

    try {
      request.headers['Authorization'] = 'Bearer $token';

      request.files.add(
        await http.MultipartFile.fromPath(
          'image',
          imageFile.path,
        ),
      );

      final response = await request.send();

      if (response.statusCode == 200) {
        final responseBody = await response.stream.bytesToString();
        final responseJson = jsonDecode(responseBody);

        if (responseJson.containsKey('accessToken') &&
            responseJson.containsKey('refreshToken')) {
          await storage.write(
            key: 'accessToken',
            value: responseJson['accessToken'],
          );
          await storage.write(
            key: 'refreshToken',
            value: responseJson['refreshToken'],
          );
          print('Tokens updated successfully');
        }
        print('Image updated successfully: $responseBody');
        return true;
      } else {
        print('Failed to update image: ${response.statusCode}');
        return false;
      }
    } catch (e) {
      print('Error: $e');
      return false;
    }
  }
}
