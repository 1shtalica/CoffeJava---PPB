import 'package:e_nusantara/screens/orders.dart';
import 'package:flutter/material.dart';

class ProfileWidget extends StatefulWidget {
  const ProfileWidget({super.key});

  @override
  State<ProfileWidget> createState() => _ProfileScreen();
}

class _ProfileScreen extends State<ProfileWidget> {
  final List<Map<String, String>> menuItems = [
    {
      'title': 'My orders',
      'subtitle': 'Already have 12 orders',
    },
    {
      'title': 'Shipping addresses',
      'subtitle': '3 addresses',
    },
    {
      'title': 'Payment methods',
      'subtitle': 'Visa **34',
    },
    {
      'title': 'Promocodes',
      'subtitle': 'You have special promocodes',
    },
    {
      'title': 'My reviews',
      'subtitle': 'Reviews for 4 items',
    },
    {
      'title': 'Settings',
      'subtitle': 'Notifications, password',
    },
  ];
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
          const ListTile(
            leading: CircleAvatar(
              radius: 30.0,
              backgroundImage: AssetImage("assets/image/rindang_profile.jpg"),
            ),
            title: Text(
              'Rindang Bani Isyan',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text('rindangKarawang@karawang.co.id'),
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
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Orders()));
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
