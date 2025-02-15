import 'package:flutter/material.dart';

class Ratting extends StatelessWidget {
  final String username;
  final int rating;
  final String review;

  const Ratting(
      {super.key,
      required this.username,
      required this.rating,
      required this.review});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(left: 20, right: 20),
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(username,
                  style: const TextStyle(
                      fontSize: 14, height: 1.5, fontWeight: FontWeight.bold)),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Row(
                children: List.generate(5, (index) {
                  return Icon(
                    index < rating ? Icons.star : Icons.star_border,
                    color: index < rating ? Colors.amber : Colors.grey,
                  );
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 10),
              child: Text(review,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 1.5,
                  )),
            ),
            const Divider(color: Colors.black45),
          ],
        ),
      ),
    );
  }
}
