import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';
import 'Screens/sign_in.dart';
import './provider/SizeChartProvider.dart'; // Import Provider
import './provider/FavoriteProvider.dart';
import 'package:awesome_notifications/awesome_notifications.dart';

void main() async {
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
        channelGroupKey: "auth_channel_group",
        channelKey: "login_channel",
        channelName: "Login Notification",
        channelDescription: "Berhasil Login")
  ], channelGroups: [
    NotificationChannelGroup(
        channelGroupKey: "auth_channel_group", channelGroupName: "auth group")
  ]);
  bool isAllowedNotif = await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedNotif) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  await dotenv.load();
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
            create: (_) => SizeChartProvider()), // Registrasi
        // ChangeNotifierProvider(
        //   create: (_) => Favoriteprovider(),
        // ), // Favorite
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
        fontFamily: 'AbhayaLibre',
      ),
      home: const SignInPage(title: 'Flutter Demo Home Page'),
      debugShowCheckedModeBanner: false,
    );
  }
}
