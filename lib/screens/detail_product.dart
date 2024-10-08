import 'package:flutter/material.dart';
import '../models/products.dart';

class ProductDetailPage extends StatelessWidget {
  final Product product;

  const ProductDetailPage({Key? key, required this.product}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea( 
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
             
              Text(
                product.title, 
                style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFFDDA86B), 
                ),
              ),
              SizedBox(height: 20), 
              Image.network(product.images.isNotEmpty ? product.images[0] : ''),
              SizedBox(height: 10),
              Text(
                'Harga: \$${product.price}',
                style: TextStyle(fontSize: 20, color: Colors.grey),
              ),
              SizedBox(height: 10),
              Text(
                product.description,
                style: TextStyle(fontSize: 16),
                textAlign: TextAlign.justify,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFFDDA86B),
                  padding: const EdgeInsets.symmetric(horizontal: 60, vertical: 10),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text('Beli'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
