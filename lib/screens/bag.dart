import 'package:e_nusantara/api/checkLogin.dart';
import 'package:e_nusantara/models/bag_models.dart';
import 'package:e_nusantara/models/promo_models.dart';
import 'package:e_nusantara/screens/checkout.dart';
import 'package:e_nusantara/screens/shipping_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup_menu_button/custom_popup_menu_button.dart';
import 'package:flutter_popup_menu_button/menu_direction.dart';
import 'package:flutter_popup_menu_button/menu_icon.dart';
import 'package:flutter_popup_menu_button/menu_item.dart';
import 'package:flutter_popup_menu_button/popup_menu_button.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class BagWidget extends StatefulWidget {
  const BagWidget({super.key});

  @override
  State<BagWidget> createState() => _BagScreen();
}

class _BagScreen extends State<BagWidget> {
  final String? baseUrl = dotenv.env['BASE_URL'];
  List<BagModels> bagList = [];
  final Checklogin _checklogin = new Checklogin();

  Future<List<BagModels>> fetchCartData() async {
    final FlutterSecureStorage storage = FlutterSecureStorage();

    String? accessToken = await storage.read(key: 'accessToken');

    if (accessToken == null) {
      throw Exception('No access token found');
    }

    final response = await http.get(
      Uri.parse('$baseUrl/checkout'),
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      final List<dynamic> cartItems = data['cart_items'];
      return cartItems.map((item) => BagModels.fromJson(item)).toList();
    } else {
      throw Exception('Failed to load cart data');
    }
  }

  @override
  void initState() {
    super.initState();
    loadCartData();
  }

  Future<void> loadCartData() async {
    _checklogin.checkAndNavigate(context);
    try {
      final fetchBagList = await fetchCartData();
      if (this.mounted) {
        setState(() {
          bagList = fetchBagList;
        });
      }
    } catch (e) {
      print('Error fetching cart data $e');
    }
  }

  void updateQuantity(int index, bool isAdd) {
    _checklogin.checkAndNavigate(context);
    if (isAdd) {
      setState(() {
        bagList[index].addQuantity();
        bagList[index].quantity++;
      });
    } else {
      if (bagList[index].quantity > 1) {
        setState(() {
          bagList[index].decreaseQuantity();
          bagList[index].quantity--;
          if (bagList[index].quantity == 0) {
            bagList[index].deleteItem(bagList);
            if (bagList.isEmpty) {
              print('Bag is empty');
            }
          }
        });
      } else {
        print('Quantity cannot go below 1');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    // List<PromoModels> promoList = PromoModels.getItems();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF9F9F9),
        elevation: 0,
      ),

      //main column
      body: SafeArea(
        child: Column(
          children: [
            MybagText(),
            Expanded(
              child: ListView(
                children: [
                  // List of items
                  ListofItems(bagList),

                  // Enter promo code container
                  // EnterPromoCodeContainer(promoList),

                  // Total amount
                  TotalamountContainer(bagList),

                  // Check out button
                  CheckoutButton(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container ListofItems(List<BagModels> bagList) {
    return Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      height: 400,
      width: double.infinity,
      child: bagList.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Text(
                    "You don’t have any items!",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Please add new items first",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            )
          : ListView.separated(
              separatorBuilder: (context, index) => const SizedBox(height: 25),
              itemCount: bagList.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.only(left: 20, right: 20),
                  height: 150,
                  decoration: BoxDecoration(
                    color: const Color(0xffFFFFFF),
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          //image
                          SizedBox(
                            width: 150,
                            child: ClipRRect(
                              borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(8),
                                  bottomLeft: Radius.circular(8)),
                              child: Image.network(
                                bagList[index].image,
                                fit: BoxFit.fill,
                                errorBuilder: (context, error, stackTrace) =>
                                    Icon(Icons.error),
                              ),
                            ),
                          ),
                          const SizedBox(width: 5),
                          //details
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const SizedBox(height: 8),
                                Text(
                                  bagList[index].name,
                                  style: const TextStyle(
                                      fontSize: 19,
                                      fontWeight: FontWeight.w800,
                                      color: Colors.black),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                                const SizedBox(
                                  height: 3,
                                  width: 200,
                                ),
                                Row(
                                  children: [
                                    const Text(
                                      "Color: ",
                                      style:
                                          TextStyle(color: Color(0xff9B9B9B)),
                                    ),
                                    Text(
                                      bagList[index].color,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                    const SizedBox(width: 20),
                                    const Text(
                                      "Size: ",
                                      style:
                                          TextStyle(color: Color(0xff9B9B9B)),
                                    ),
                                    Text(
                                      bagList[index].size,
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: Colors.black),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                //quantity
                                Row(
                                  children: [
                                    //plus and minus button
                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(900),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              spreadRadius: 2,
                                              blurRadius: 5,
                                              offset: const Offset(0, 2),
                                            ),
                                          ]),
                                      child: Center(
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.remove,
                                            color: Color(0xff9B9B9B),
                                          ),
                                          onPressed: () {
                                            //TODO: maybe use inkwell for an effect
                                            updateQuantity(index, false);
                                          },
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 20),
                                    //quantity text
                                    SizedBox(
                                      width: 20,
                                      child: Text(
                                          bagList[index].quantity.toString(),
                                          textAlign: TextAlign.center,
                                          style: TextStyle(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w700)),
                                    ),
                                    SizedBox(width: 20),

                                    Container(
                                      height: 40,
                                      width: 40,
                                      decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius:
                                            BorderRadius.circular(900),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 2,
                                            blurRadius: 5,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Center(
                                        child: IconButton(
                                            icon: const Icon(
                                              Icons.add,
                                              color: Color(0xff9B9B9B),
                                            ),
                                            onPressed: () {
                                              //TODO: maybe use inkwell for an effect
                                              updateQuantity(index, true);
                                            }),
                                      ),
                                    ),
                                    //total item price
                                    //3 dots thingy
                                    const SizedBox(width: 10),
                                  ],
                                ),
                                Padding(
                                  padding: EdgeInsets.only(
                                      top: 10, left: 10, right: 10, bottom: 8),
                                  child: Align(
                                    alignment: Alignment.bottomLeft,
                                    child: Text(
                                      'Price:             Rp${bagList[index].price * bagList[index].quantity}',
                                      style: TextStyle(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w800),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Positioned(
                        top: 9,
                        right: 0,
                        child: FlutterPopupMenuButton(
                          direction: MenuDirection.left,
                          decoration: const BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          popupMenuSize: const Size(200, 100),
                          child: FlutterPopupMenuIcon(
                            key: GlobalKey(),
                            child: const Icon(Icons.more_vert),
                          ),
                          children: [
                            FlutterPopupMenuItem(
                              closeOnItemClick: true,
                              child: ListTile(
                                title: Text(
                                  "Delete from the list",
                                  textAlign: TextAlign.center,
                                ),
                                titleAlignment: ListTileTitleAlignment.center,
                                onTap: () {
                                  setState(() {
                                    bagList[index].deleteItem(bagList);
                                    bagList.removeAt(index);
                                  });
                                  Navigator.of(context).pop();
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }

  int total = 0;
  Container TotalamountContainer(List<BagModels> bagList) {
    //total amount
    total = bagList.fold(
      0,
      (sum, item) => sum + (item.price * item.quantity),
    );

    return Container(
      height: 20,
      margin: const EdgeInsets.only(top: 20, left: 30, right: 30, bottom: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          const Text(
            'Total amount:',
            style: TextStyle(
              fontFamily: 'AbhayaLibre',
              color: Color(0xff9B9B9B),
              fontSize: 16,
              fontWeight: FontWeight.w400,
            ),
          ),

          //price adds according to bag
          Text(
            'Rp${total.toString()}',
            style: TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  ElevatedButton CheckoutButton() {
    return ElevatedButton(
      onPressed: bagList.isEmpty
          ? null
          : () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => ShippingDetailsScreen(total: total),
                ),
              );
            },
      style: ElevatedButton.styleFrom(
        backgroundColor:
            bagList.isEmpty ? Colors.grey : const Color(0xffDDA86B),
        foregroundColor: Colors.white,
        elevation: 5,
        shadowColor: Colors.grey.withOpacity(0.2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(40),
        ),
        minimumSize: Size(double.infinity, 60),
      ),
      child: const Text(
        'CHECK OUT',
        style: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Container MybagText() {
    return Container(
      margin: const EdgeInsets.only(top: 30, left: 10),
      child: const Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            'My Bag',
            style: TextStyle(
              color: Color(0xff222222),
              fontSize: 34,
              fontFamily: 'AbhayaLibre',
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
