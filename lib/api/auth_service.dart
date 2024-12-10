import 'dart:convert';
import 'package:e_nusantara/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class AuthService {
  final String? baseUrl = dotenv.env['BASE_URL'];

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = Uri.parse('$baseUrl/login');

    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'email': email,
          'password': password,
        }),
      );

      if (response.statusCode == 200) {
        // Decode the response
        final data = jsonDecode(response.body);
        final accessToken = data['accessToken'];
        final refreshToken = data['refreshToken'];

        // Return access token
        return {'accessToken': accessToken, 'refreshToken': refreshToken};
      } else if (response.statusCode == 404) {
        final data = jsonDecode(response.body);
        print(data['msg']);
        throw Exception('User not found');
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        print(data['msg']);
        throw Exception('Wrong password');
      } else {
        final data = jsonDecode(response.body);
        print(data['msg']);
        throw Exception('Failed to login');
      }
    } catch (e) {
      print('Error wqe: $e');
      return {'error': e.toString().replaceFirst('Exception: ', '')};
    }
  }

  bool isTokenExpired(int expirationTime) {
    DateTime expirationDate =
        DateTime.fromMillisecondsSinceEpoch(expirationTime * 1000);
    return expirationDate.isBefore(DateTime.now());
  }

  Future<bool> isReffreshTokenExpired(BuildContext context) async {
    final FlutterSecureStorage storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'refreshToken');

    if (token == null) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const SignInPage(title: 'Sign In')),
      );
      return true;
    }

    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String? name = decodedToken['name'];
    int? expirationTime = decodedToken['exp'];
    DateTime expirationDate =
        DateTime.fromMillisecondsSinceEpoch(expirationTime! * 1000);

    bool isExpired = expirationDate.isBefore(DateTime.now());

    return isExpired;
  }

  Future<bool> isAccessTokenExpired(BuildContext context) async {
    final FlutterSecureStorage storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'accessToken');

    if (token == null) {
      // If token is null, navigate to the sign-in page
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
            builder: (context) => const SignInPage(title: 'Sign In')),
      );
      return true; // Token is null, considered expired
    }

    // If token is available, decode it
    Map<String, dynamic> decodedToken = JwtDecoder.decode(token);
    String? name = decodedToken['name'];
    int? expirationTime = decodedToken['exp'];
    DateTime expirationDate =
        DateTime.fromMillisecondsSinceEpoch(expirationTime! * 1000);

    bool isExpired = expirationDate.isBefore(DateTime.now());

    // Debugging: Log decoded token and expiration date

    return isExpired;
  }

  Future<Map<String, dynamic>> decodeProfile(BuildContext context) async {
    final FlutterSecureStorage storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'accessToken');
    if (token != null) {
      Map<String, dynamic> decodedToken = JwtDecoder.decode(token);

      String? id = decodedToken['id'];
      String? name = decodedToken['name'];
      String? email = decodedToken['email'];
      String? profileImage = decodedToken['profileImage'];
      // String? profileImage = decodedToken['profileImage'];
      //   const profileImage = User.profileImage;
      // const tanggalLahir = User.tanggalLahir;

      return {
        "id": id,
        "name": name,
        "email": email,
        "profileImage": profileImage
      };
    }
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => const SignInPage(title: 'Sign In')),
    );
    return {};
  }

  Future<bool> logout() async {
    final url = Uri.parse('$baseUrl/logout');

    try {
      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        print("Logout berhasil");
        return true;
      } else {
        final data = jsonDecode(response.body);
        print("Gagal logout: ${data['message']}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }
}
