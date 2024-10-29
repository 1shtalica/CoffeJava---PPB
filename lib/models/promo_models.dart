import 'package:flutter/material.dart';

class PromoModels {
  final String name;
  final String code;
  final DateTime deadline;
  final String image;

  PromoModels({
    required this.name,
    required this.code,
    required this.deadline,
    required this.image,
  });

  static List<PromoModels> getItems() {
    List<PromoModels> promos = [];

    promos.add(
      PromoModels(
        name: "Personal Offer",
        code: "mypromocode2020",
        deadline: DateTime(2024, 11, 19),
        image: 'assets/image/10off.png',
      ),
    );

    promos.add(
      PromoModels(
        name: "Summer Sale",
        code: "summer2020",
        deadline: DateTime(2025, 12, 31),
        image: 'assets/image/15off.png',
      ),
    );

    promos.add(
      PromoModels(
        name: "Personal Offer",
        code: "mypromocode2020",
        deadline: DateTime(2023, 1, 12),
        image: 'assets/image/22off.png',
      ),
    );

    promos.add(
      PromoModels(
        name: "Personal Offer",
        code: "mypromocode2020",
        deadline: DateTime(2024, 11, 19),
        image: 'assets/image/10off.png',
      ),
    );

    return promos;
  }

  int DaysLeft() {
    final remainingDays = deadline.difference(DateTime.now()).inDays;

    if (remainingDays > 0) {
      return remainingDays;
    } else {
      return 0;
    }
  }
}
