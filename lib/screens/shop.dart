import 'package:flutter/material.dart';

class ShopWidget extends StatefulWidget {
  const ShopWidget({super.key});

  @override
  State<ShopWidget> createState() => _ShopScreen();
}

class _ShopScreen extends State<ShopWidget> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('ini halaman shop'),
    );
  }
}
