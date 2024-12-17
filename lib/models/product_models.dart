import 'dart:convert';
import 'dart:ffi';
import 'package:http/http.dart' as http;

class Product {
  final int? productId;
  final String? pName;
  final bool? sale;
  final double? dicount;
  final String? brand;
  final String? decs;
  final double price;
  final List<Review>? ratings;
  final List<Category>? categories;
  final List<SubCategory>? subCategories;
  final List<SpecificSubCategory>? specificSubCategories;
  final List<String>? images;
  final List<Stock>? stock;

  Product(
      {required this.productId,
      required this.pName,
      required this.categories,
      required this.subCategories,
      required this.specificSubCategories,
      required this.images,
      required this.stock,
      required this.dicount,
      required this.ratings,
      required this.sale,
      required this.brand,
      required this.decs,
      required this.price});

  factory Product.fromJson(Map<String, dynamic> json) {
    print(json);
    return Product(
      productId: json['product_id'],
      pName: json['pName'],
      ratings: (json['rattings'] as List?)?.map((i) => Review.fromJson(i)).toList(),

      categories: (json['categories'] as List)
          .map((i) => Category.fromJson(i))
          .toList(),
      subCategories: (json['subCategories'] as List)
          .map((i) => SubCategory.fromJson(i))
          .toList(),
      specificSubCategories: (json['specificSubCategories'] as List)
          .map((i) => SpecificSubCategory.fromJson(i))
          .toList(),
      images: List<String>.from(json['images']),
      stock: (json['stock'] as List).map((i) => Stock.fromJson(i)).toList(),
      dicount: (json['discount'] as num).toDouble(),
      sale: json['sale'],
      price: (json['price'] as num).toDouble(),
      brand: json['brand'],
      decs: json['decs'],
    );
  }
}

class Review {
  final int rating_id;
  final int value;
  final String review;
  final String name;

  Review(
      {required this.rating_id,
      required this.review,
      required this.value,
      required this.name});
  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
        rating_id: json['rating_id']??"",
        review: json['review']??"",
        value: json['value']??"",
        name: json['name']??"");
  }
}

class Category {
  final int categoryId;
  final String categoryName;

  Category({
    required this.categoryId,
    required this.categoryName,
  });

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(
      categoryId: json['category_id'],
      categoryName: json['category_name'],
    );
  }
}

class SubCategory {
  final int subCategoryId;
  final String subCategoryName;

  SubCategory({
    required this.subCategoryId,
    required this.subCategoryName,
  });

  factory SubCategory.fromJson(Map<String, dynamic> json) {
    return SubCategory(
      subCategoryId: json['sub_category_id'],
      subCategoryName: json['sub_category_name'],
    );
  }
}

class SpecificSubCategory {
  final int specificSubCategoryId;
  final String specificSubCategoryName;

  SpecificSubCategory({
    required this.specificSubCategoryId,
    required this.specificSubCategoryName,
  });

  factory SpecificSubCategory.fromJson(Map<String, dynamic> json) {
    return SpecificSubCategory(
      specificSubCategoryId: json['specific_sub_category_id'],
      specificSubCategoryName: json['specific_sub_category_name'],
    );
  }
}

class Stock {
  final int stockId;
  final String size;
  final int quantity;

  Stock({
    required this.stockId,
    required this.size,
    required this.quantity,
  });

  factory Stock.fromJson(Map<String, dynamic> json) {
    return Stock(
      stockId: json['stock_id'],
      size: json['size'],
      quantity: json['quantity'],
    );
  }
}

Future<Product> fetchProduct(String url) async {
  final response = await http.get(Uri.parse(url));

  if (response.statusCode == 200) {
    final jsonResponse = jsonDecode(response.body);
    return Product.fromJson(jsonResponse['data']);
  } else {
    throw Exception('Failed to load product');
  }
}
