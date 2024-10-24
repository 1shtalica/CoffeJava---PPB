import 'package:e_nusantara/screens/bag.dart';
import 'package:e_nusantara/screens/categories.dart';
import 'package:e_nusantara/screens/favoriteScreen.dart';
import 'package:e_nusantara/screens/profile.dart';
import 'package:e_nusantara/screens/shop.dart';
import 'package:e_nusantara/widget/cardList.dart';
import 'package:flutter/material.dart';
import 'product_details.dart';

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidget();
}

class _HomeWidget extends State<HomeWidget> {
  int selectedIndex = 0;

  void onItem(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = [
      SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                Image.asset(
                  'assets/image/background.jpg',
                  width: double.infinity,
                  height: 450,
                  fit: BoxFit.cover,
                  alignment: Alignment.centerRight,
                ),
                Positioned(
                  top: 300,
                  left: 20,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      const Text(
                        'Fashion',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Text(
                        'Batik',
                        style: TextStyle(
                          color: Color(0xFFD08835),
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CategoriesPage()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFDDA86B),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 60, vertical: 10),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: Text('Check'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'New',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "You've never seen it before!",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            ),
            SizedBox(
              height: 200,
              child: SizedBox(
                width: double.infinity,
                height: 200,
                child: ListView.builder(
                  itemCount: 10,
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: EdgeInsets.only(left: 10, right: 10, bottom: 10),
                      child: CardList(
                        image: 'assets/image/${index + 1}.png',
                        index: index,
                      ),
                    );
                  },
                ),
              ),
            )
          ],
        ),
      ),
      const ShopWidget(),
      const BagWidget(),
      const FavoriteScreen(),
      const ProfileWidget()
      // Tambahkan screen lainnya jika diperlukan
    ];

    return Scaffold(
      body: widgetOptions[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: selectedIndex,
        onTap: onItem,
        iconSize: 30,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(
              Icons.home,
              color: Color(0xFFD08835),
            ),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shop,
              color: Color(0xFFD08835),
            ),
            label: 'Shop',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.shopping_bag,
              color: Color(0xFFD08835),
            ),
            label: 'Bag',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.favorite,
              color: Color(0xFFD08835),
            ),
            label: 'Favorites',
          ),
          BottomNavigationBarItem(
            icon: Icon(
              Icons.person,
              color: Color(0xFFD08835),
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
