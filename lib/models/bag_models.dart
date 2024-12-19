import 'dart:convert';
import 'package:http/http.dart' as http;

class BagModels {
  final String name;
  final String color;
  final String size;
  int quantity;
  final int price;
  final String image;

  BagModels({
    required this.name,
    required this.color,
    required this.size,
    required this.quantity,
    required this.price,
    required this.image,
  });

  factory BagModels.fromJson(Map<String, dynamic> json) {
    return BagModels(
      name: json['product']['pName'],
      color: json['product']['color'] ?? "None",
      size: json['size'],
      quantity: json['quantity'],
      price: (json['total_price'] as num).toInt(),
      image: "assets/image/Women-01.jpg",
    );
  }

  void addQuantity() {
    quantity++;
  }

  void decreaseQuantity() {
    quantity--;
  }

  void deleteItem(List<BagModels> bagList) {
    bagList.remove(this);
  }
}
