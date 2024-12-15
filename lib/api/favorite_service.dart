import 'dart:async';
import 'dart:convert';
// import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import '../api/auth_service.dart';
import '../models/product_models.dart';

class favoriteService {
  final String? baseUrl = dotenv.env['BASE_URL'];
  final FlutterSecureStorage storage = FlutterSecureStorage();
  final AuthService _authService = AuthService();

  Future<String?> getValidToken() async {
    bool isTokenValid = await _authService.checkToken();

    if (isTokenValid) {
      return await storage.read(key: 'accessToken');
    } else {
      return null;
    }
  }

  Future<List<Product>> fetchFavorites() async {
    String? token = await getValidToken();

    if (token == null) {
      throw Exception('Token tidak valid');
    }

    final res = await http.get(Uri.parse('$baseUrl/favorites'), headers: {
      'Authorization': 'Bearer $token',
    });

    print("responsenya adalah ${res.body}");

    try {
      if (res.statusCode == 200) {
        if (res.body.isEmpty) {
          return [];
        }
        List<dynamic> jsonData = jsonDecode(res.body);
        return jsonData.map((json) => Product.fromJson(json)).toList();
      } else {
        print('Failed to load favorites, status code: ${res.statusCode}');
        throw Exception('Failed to load favorites');
      }
    } catch (err) {
      throw Exception('Failed to load favorites: $err');
    }
  }

  Future<bool> addFavorites(int productId) async {
    String? token = await getValidToken();

    if (token == null) {
      throw Exception('Token tidak valid');
    }
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

  Future<bool> deleteFavorites(int productId) async {
    String? token = await getValidToken();

    if (token == null) {
      throw Exception('Token tidak valid');
    }

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

  Future<bool> isCheckFavorite(int productId) async {
    String? token = await getValidToken();

    if (token == null) {
      throw Exception('Token tidak valid. Silakan login ulang.');
    }

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
