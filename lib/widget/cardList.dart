import 'dart:math';
import 'package:intl/intl.dart';
import 'package:e_nusantara/screens/product_details.dart';
import 'package:flutter/material.dart';

class CardList extends StatelessWidget {
  const CardList(
      {super.key,
      required this.image,
      required this.index,
      required this.title});
  final String image;
  final int index;
  final String title;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => product_details(
              image: 'assets/image/${index + 1}.png',
              title: title,
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
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                width: 120,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: AssetImage(image),
                  ),
                ),
              ),
            ),
            Text(
              title,
              style: const TextStyle(),
            ),
            Text(
              NumberFormat.simpleCurrency(
                locale: 'id_ID',
                name: 'Rp',
              ).format((Random().nextInt(100) + 50) * 1000).toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text("${Random().nextInt(1000)} Review •"),
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
