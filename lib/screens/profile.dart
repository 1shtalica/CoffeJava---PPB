import 'package:e_nusantara/screens/orders.dart';
import 'package:e_nusantara/screens/setting.dart';
import 'package:e_nusantara/screens/sign_in.dart';
import 'package:flutter/material.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:e_nusantara/notifications/notification_controller.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/auth_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

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

  Future<void> _refreshScreen() async {
    await Future.delayed(Duration(seconds: 2)); // Simulasi refresh
    await _initializeProfile();
  }

  Future<void> _logout() async {
    final storage = FlutterSecureStorage();
    // Ambil token yang tersimpan dari localStorage
    String? token = await storage.read(key: 'refreshToken');
    print(token);
    final String? baseUrl = dotenv.env['BASE_URL'];
    // Endpoint API logout
    String url = "$baseUrl/logout";

    // Header dengan Authorization
    Map<String, String> headers = {
      "Authorization": "Bearer $token",
    };

    // Mengirim DELETE request
    try {
      final response = await http.delete(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        print("Logout berhasil: ${response.body}");
        // Setelah logout, hapus token dari storage
      } else {
        print("Gagal logout: ${response.statusCode}");
        print("Response: ${response.body}");
      }
    } catch (error) {
      print("Error: $error");
    } finally {
      await storage.delete(key: 'accessToken');
      await storage.delete(key: 'refreshToken');

      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const SignInPage(title: "sign in")));
    }
  }

  Future<void> _initializeProfile() async {
    try {
      final result = await _authService.decodeProfile(context);
      setState(() {
        profileImage = result['profileImage'] ?? ""; // Gambar profil
        name = result['name'] ?? "Loading..."; // Nama dengan fallback
        email = result['email'] ?? "Loading..."; // Email dengan fallback
        id = result['id'] ?? ""; // ID dengan fallback
      });
    } catch (e) {
      print("Error initializing profile: $e");
    }
  }

  Future<void> showSignOutDialog() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Confirm Sign Out"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () async {
                _logout();
              },
              child: const Text("Confirm"),
            ),
          ],
        );
      },
    );
  }

  final List<Map<String, String>> menuItems = [
    {
      'title': 'My orders',
      'subtitle': 'Already have 12 orders',
    },
    {
      'title': 'Settings',
      'subtitle': 'Notifications, password',
    },
    {
      'title': 'Sign Out',
      'subtitle': 'Sign out from your account',
    },
  ];

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
      body: RefreshIndicator(
        onRefresh: _refreshScreen,
        child: Column(
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
            const SizedBox(height: 10),
            ListTile(
              leading: CircleAvatar(
                radius: 30.0,
                backgroundImage: profileImage.isNotEmpty
                    ? NetworkImage(profileImage)
                    : AssetImage("assets/image/maria.png") as ImageProvider,
              ),
              title: Text(
                name,
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              subtitle: Text(email),
            ),
            const SizedBox(height: 10),
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
                          if (item['title'] == 'Sign Out') {
                            showSignOutDialog();
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => subScreen[index]),
                            );
                          }
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
      ),
    );
  }
}
