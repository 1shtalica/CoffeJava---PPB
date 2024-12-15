import 'dart:math';
import 'package:intl/intl.dart';
import 'package:e_nusantara/screens/product_details.dart';
import 'package:flutter/material.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    super.key,
    required this.image,
    required this.title,
    required this.productId,
    required this.price,
    required this.totalReview,
  });

  final String image;
  final String title;
  final int productId;
  final int price;
  final int totalReview;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => product_details(
              image: image,
              title: title,
              productId: productId,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(3, 4),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                width: double.infinity,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(image),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.transparent,
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                title,
                style: const TextStyle(fontSize: 12),
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(
                NumberFormat.simpleCurrency(
                  locale: 'id_ID',
                  name: 'Rp',
                ).format(price * 1000),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                children: [
                  Text("$totalReview Review •"),
                  const Icon(
                    Icons.star,
                    color: Colors.amber,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
