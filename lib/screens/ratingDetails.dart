import 'package:e_nusantara/screens/sign_in.dart';
import 'package:e_nusantara/widget/ratting.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RatingDetails extends StatelessWidget {
  @override
  const RatingDetails({super.key, required this.ratings});
  final List<Map<String, dynamic>> ratings;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        automaticallyImplyLeading: false,
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        title: Container(
          alignment: Alignment.center,
          child: const Text(
            'Ratting',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () async {
              final storage1 = FlutterSecureStorage();
              String? token = await storage1.read(key: 'refreshToken');
              print(await storage1.read(key: 'refreshToken'));
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const SignInPage(title: "sign in")));
            },
          ),
        ],
      ),
      body: Center(
          child: CustomScrollView(
        slivers: [
          SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                return Ratting(
                  username: ratings[index]["username"],
                  rating: ratings[index]["rating"],
                  review: ratings[index]["review"],
                );
              },
              childCount: ratings.length,
            ),
          ),
        ],
      )),
    );
  }
}
