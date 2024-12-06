import 'dart:convert';
import 'package:e_nusantara/models/pagination_models.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import '../models/product_models.dart';

class ProductService {
  final String? baseUrl = dotenv.env['BASE_URL'];
  Future<Product> fetchProductbyId(int productId) async {
    final url = '$baseUrl/product/$productId'; 
    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
  
   
      
     
      return Product.fromJson(jsonResponse['data']);
    } else {
      throw Exception('Failed to load product');
    }

    
  }

  Future<Map<String, dynamic>> fetchAllProducts(
      {int? page,
      int? limit,
      String? search,
      int? categoryId,
      int? subcategoryId,
      int? specificSubcategoryId}) async {
    page ??= 1;
    limit ??= 20;
    final queryParams = {
      'page': page.toString(),
      'limit': limit.toString(),
      if (search != null) 'search': search,
      if (categoryId != null) 'categoryId': categoryId.toString(),
      if (subcategoryId != null) 'subcategoryId': subcategoryId.toString(),
      if (specificSubcategoryId != null)
        'specificSubcategoryId': specificSubcategoryId.toString(),
    };

    final url = Uri.parse('$baseUrl/products')
        .replace(queryParameters: queryParams)
        .toString();

    final response = await http.get(Uri.parse(url));
    try {
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);
        final productsJson = jsonResponse['data'] as List;
        final pagination = Pagination.fromJson(jsonResponse['pagination']);
      
        final products =
            productsJson.map((json) => Product.fromJson(json)).toList();

        return {'products': products, 'pagination': pagination};
      } else {
        throw "er";
      }
    } catch (e) {
      print(e);
      throw Exception('Failed to load products');
    }
  }
}