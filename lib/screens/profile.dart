import 'package:e_nusantara/screens/orders.dart';
import 'package:e_nusantara/screens/setting.dart';
import 'package:e_nusantara/screens/shipping.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:e_nusantara/notifications/notification_controller.dart';
import '../api/auth_service.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileWidget> {
  final AuthService _authService = AuthService();
  String name = "";
  String email = "";
  String profileImage = "";
  String id = "";

  @override
  void initState() {
    super.initState();
    _initializeProfile();

    // Set up Awesome Notifications listeners
    AwesomeNotifications().setListeners(
      onActionReceivedMethod: NotificationController.onActionReceivedMethod,
      onNotificationCreatedMethod:
          NotificationController.onNotificationCreatedMethod,
      onDismissActionReceivedMethod:
          NotificationController.onDismissActionReceivedMethod,
      onNotificationDisplayedMethod:
          NotificationController.onNotificationDisplayedMethod,
    );
  }

  void _initializeProfile() async {
    final result = await _authService.decodeProfile(context);
    setState(() {
      name = result['name'];
      email = result['email'];
      id = result['id'];
      // profileImage = result['profileImage'];
    });
  }

  final List<Map<String, String>> menuItems = [
    {
      'title': 'My orders',
      'subtitle': 'Already have 12 orders',
    },
    // {
    //   'title': 'Shipping addresses',
    //   'subtitle': '3 addresses',
    // },
    {
      'title': 'Settings',
      'subtitle': 'Notifications, password',
    },
  ];

  // final subScreen = [Orders(), ShippingAddress(), Settings()];
  final subScreen = [Orders(), Settings()];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.all(10),
            child: Text(
              "Profile",
              textAlign: TextAlign.start,
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFFDDA86B),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              backgroundImage: AssetImage("assets/image/maria.png"),
            ),
            title: Text(
              name,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(email),
          ),
          const SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: menuItems.length,
              itemBuilder: (context, index) {
                final item = menuItems[index];
                return Column(
                  children: [
                    ListTile(
                      title: Text(item['title']!),
                      subtitle: Text(item['subtitle']!),
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => subScreen[index]));
                      },
                    ),
                    const Divider(),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
