import 'package:e_nusantara/models/pagination_models.dart';
import 'package:e_nusantara/screens/bag.dart';
import 'package:e_nusantara/screens/categories.dart';
import 'package:e_nusantara/screens/favoriteScreen.dart';
import 'package:e_nusantara/screens/orders.dart';
import 'package:e_nusantara/screens/profile.dart';
import 'package:e_nusantara/screens/shop.dart';
import 'package:e_nusantara/screens/MyShopPage.dart';
import 'package:e_nusantara/widget/cardList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../api/product_service.dart';
import '../models/product_models.dart' as fixProduct;

class HomeWidget extends StatefulWidget {
  const HomeWidget({super.key});

  @override
  State<HomeWidget> createState() => _HomeWidget();
}

class _HomeWidget extends State<HomeWidget> {
  int selectedIndex = 0;
  bool isLoading = true;
  List<fixProduct.Product> products = [];
  late Pagination pagination;

  void onItem(int index) {
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _initializeProducts();
    if (isLoading == false) {
      print(pagination.currentPage);
    }
  }

  Future<void> _initializeProducts() async {
    final ProductService productService = ProductService();
    try {
      isLoading = true;
      final result =
          await productService.fetchAllProducts(limit: 25); // Set limit 25

      setState(() {
        products = result['products']; // Menyimpan produk ke state
        pagination =
            result['pagination']; // Menyimpan informasi pagination ke state

        isLoading = false; // Menandakan bahwa loading selesai
      });
    } catch (e) {
      setState(() {
        isLoading = false; // Menghentikan loading jika terjadi error
      });
      print("Error loading products: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    final List<Widget> widgetOptions = [
      isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : SingleChildScrollView(
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
                              onPressed: () async {
                                final storage = FlutterSecureStorage();
                                String? token =
                                    await storage.read(key: 'refreshToken');
                                print(token);
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => const ShopWidget()),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFDDA86B),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 60, vertical: 10),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: const Text('Check'),
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
                        itemCount: products.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.only(
                                left: 10, right: 10, bottom: 10),
                            child: CardList(
                              image: products[index].images?[0] ?? '',
                              index: index,
                              title: products[index].pName ?? 'No Title',
                              product_id: products[index].productId ?? 0,
                              price: products[index].price.toInt() ?? 0,
                              totalReview: products[index].ratings!.length,
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
      const ProfileWidget(),
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
