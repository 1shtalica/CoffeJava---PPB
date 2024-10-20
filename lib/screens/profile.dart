import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileWidget> {
  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Text('ini halaman profile'),
    );
  }
}
