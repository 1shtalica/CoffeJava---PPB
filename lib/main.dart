import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'Screens/sign_in.dart';
import './provider/SizeChartProvider.dart'; // Import Provider

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => SizeChartProvider()), // Registrasi
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'E-Nusantara',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFDDA86B)),
        useMaterial3: false,
      ),
      home: const SignInPage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}
