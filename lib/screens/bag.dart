import 'package:flutter/material.dart';

class BagWidget extends StatefulWidget {
  const BagWidget({super.key});

  @override
  State<BagWidget> createState() => _BagScreen();
}

class _BagScreen extends State<BagWidget> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('ini halaman bag'),
    );
  }
}
