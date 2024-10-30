import 'package:flutter/material.dart';

class BagModels {
  final String name;
  final String color;
  final String size;
  int quantity;
  final double price;
  final String image;

  BagModels({
    required this.name,
    required this.color,
    required this.size,
    required this.quantity,
    required this.price,
    required this.image,
  });

  static List<BagModels> getItems() {
    List<BagModels> bagList = [];

    bagList.add(BagModels(
      name: "Pullover",
      color: "Black",
      size: "L",
      quantity: 1,
      price: 51,
      image: "assets/image/Women-01.jpg",
    ));

    bagList.add(BagModels(
      name: "T-Shirt",
      color: "Gray",
      size: "L",
      quantity: 6,
      price: 30,
      image: "assets/image/Men-01.jpg",
    ));

    bagList.add(BagModels(
      name: "Sport Dress",
      color: "Black",
      size: "M",
      quantity: 9,
      price: 43,
      image: "assets/image/Women-04.jpg",
    ));

    bagList.add(BagModels(
      name: "Sport Dress",
      color: "Black",
      size: "M",
      quantity: 9,
      price: 43,
      image: "assets/image/Women-04.jpg",
    ));

    return bagList;
  }

  void addQuantity() {
    quantity++;
  }

  void decreaseQuantity() {
    quantity--;
  }
}
