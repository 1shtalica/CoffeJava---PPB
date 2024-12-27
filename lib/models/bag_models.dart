import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BagModels {
  final int id;
  final String name;
  final String color;
  final String size;
  int quantity;
  final int price;
  final String image;

  BagModels({
    required this.id,
    required this.name,
    required this.color,
    required this.size,
    required this.quantity,
    required this.price,
    required this.image,
  });
  final String? baseUrl = dotenv.env['BASE_URL'];

  factory BagModels.fromJson(Map<String, dynamic> json) {
    return BagModels(
      id: json['cart_item_id'],
      name: json['product']['pName'],
      color: json['product']['color'] ?? "None",
      size: json['size'],
      quantity: json['quantity'],
      price: (json['total_price'] as num).toInt(),
      image: "assets/image/Women-01.jpg",
    );
  }

  Future<void> updateQuantity(int newqty) async {
    final url = Uri.parse("$baseUrl/checkout/update");
    try {
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception('Access token is missing');
      }

      final response = await http.put(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'itemId': id,
          'qty': newqty,
        }),
      );

      if (response.statusCode == 200) {
        quantity = newqty;
      } else {
        print('Failed to update quantity on server: ${response.body}');
      }
    } catch (e) {
      print('Error updating quantity: $e');
    }
  }

  void addQuantity() async {
    await updateQuantity(quantity + 1);
  }

  void decreaseQuantity() async {
    await updateQuantity(quantity - 1);
  }

  Future<void> deleteItem(List<BagModels> bagList) async {
    final url = Uri.parse("$baseUrl/checkout/delete/$id");
    try {
      final storage = FlutterSecureStorage();
      String? accessToken = await storage.read(key: 'accessToken');
      if (accessToken == null) {
        throw Exception('Access token is missing');
      }

      final response = await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode({
          'itemId': id,
        }),
      );

      if (response.statusCode == 200) {
        //remove local if successfull in server
        bagList.removeWhere((item) => item.id == this.id);
      } else {
        print('Failed to delete item from server ${response.body}');
      }
    } catch (e) {
      print('Error deleting item $e');
    }
  }
}
