import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/products.dart'; // Pastikan ini sesuai dengan nama file model Anda

Future<List<Product>> fetchProducts() async {
  final String url =
      'https://api.escuelajs.co/api/v1/products?offset=0&limit=10';
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    // Mengubah JSON ke dalam List<Product>
    List<dynamic> data = json.decode(response.body);
    return data.map((productJson) => Product.fromJson(productJson)).toList();
  } else {
    throw Exception("Gagal mengambil data produk");
  }
}
