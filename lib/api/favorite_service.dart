import 'dart:async';
import 'dart:convert';
// import 'package:flutter/material.dart';
import 'package:e_nusantara/api/checkLogin.dart';
import 'package:e_nusantara/screens/product_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:jwt_decoder/jwt_decoder.dart';
import '../api/auth_service.dart';
import '../models/product_models.dart';

class favoriteService {
  final String? baseUrl = dotenv.env['BASE_URL'];
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final AuthService _authService = AuthService();

  Future<List<dynamic>> fetchFavorites(BuildContext context) async {
    final Checklogin _checklogin = new Checklogin();
    final refreshToken = await storage.read(key: 'refreshToken');
    String? token = await storage.read(key: 'accessToken');
    bool isExpired = JwtDecoder.isExpired(token!);
    print("apakah sudah: ${isExpired}");
    if (isExpired) {
      print("sudah expired");
      await _checklogin.checkAndNavigate(context);
    }

    final url = Uri.parse('${baseUrl}/token');
    final headers = {
      'Authorization': 'Bearer $refreshToken',
      'Content-Type': 'application/json',
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final newToken = responseBody['accessToken'];
      storage.write(key: "accessToken", value: newToken);
      print("get new token");
    }
    token = await storage.read(key: 'accessToken');
    try {
      final res = await http.get(Uri.parse('$baseUrl/favorites'), headers: {
        'Authorization': 'Bearer $token',
      });

      print("responsenya adalah ${res.body}");

      if (res.statusCode == 200) {
        if (res.body.isEmpty) {
          return [];
        }

        final List<dynamic> decodedData = jsonDecode(res.body);
        return decodedData;
      } else {
        throw Exception('Failed to load favorites');
      }
    } catch (e) {
      print('Error fetching favorites: $e');
      throw Exception('Failed to load favorites: $e');
    }
  }

  Future<void> getnewToken() async {
    final refreshToken = await storage.read(key: 'refreshToken');
    final url = Uri.parse('${baseUrl}/token');
    final headers = {
      'Authorization': 'Bearer $refreshToken',
      'Content-Type': 'application/json',
    };
    final response = await http.get(url, headers: headers);
    if (response.statusCode == 200) {
      final Map<String, dynamic> responseBody = json.decode(response.body);
      final newToken = responseBody['accessToken'];
      storage.write(key: "accessToken", value: newToken);
      print("get new token");
    }
  }

  Future<bool> addFavorites(int productId, BuildContext context) async {
    final FlutterSecureStorage storage = FlutterSecureStorage();
    String? token = await storage.read(key: 'accessToken');
    print(token);
    getnewToken();
    try {
      final res = await http.post(
        Uri.parse('$baseUrl/favorites'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'productId': productId}),
      );

      if (res.statusCode == 201) {
        return true;
      } else {
        print('Failed to add favorite, status code: ${res.statusCode}');
        print('Response body: ${res.body}');
        throw Exception('Failed to add Favorite');
      }
    } catch (err) {
      print('Error: $err');
      return false;
    }
  }

  Future<bool> deleteFavorites(int productId, BuildContext context) async {
    String? token = await storage.read(key: 'accessToken');
    getnewToken();
    try {
      final res = await http.delete(
        Uri.parse('$baseUrl/favorites'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({'productId': productId}),
      );

      if (res.statusCode == 200) {
        return true;
      } else {
        print('Gagal menambah favorit, kode status: ${res.statusCode}');
        print('Respon body: ${res.body}');
        return false;
      }
    } catch (err) {
      throw Exception('Failed to delete Favorite: $err');
    }
  }

  Future<bool> isCheckFavorite(int productId, BuildContext context) async {
    String? token = await storage.read(key: 'accessToken');

    getnewToken();
    final url = Uri.parse('$baseUrl/favorites');
    final headers = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json',
    };

    try {
      final res = await http.get(url, headers: headers);

      if (res.statusCode == 200) {
        List<dynamic> favorites = json.decode(res.body);
        return favorites.any((favorite) => favorite['product_id'] == productId);
      } else {
        return false;
      }
    } catch (err) {
      print('Error Not Found: $err');
      return false;
    }
  }
}
