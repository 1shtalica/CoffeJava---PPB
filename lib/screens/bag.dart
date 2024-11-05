import 'package:e_nusantara/models/bag_models.dart';
import 'package:e_nusantara/models/promo_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_popup_menu_button/custom_popup_menu_button.dart';
import 'package:flutter_popup_menu_button/menu_direction.dart';
import 'package:flutter_popup_menu_button/menu_icon.dart';
import 'package:flutter_popup_menu_button/menu_item.dart';
import 'package:flutter_popup_menu_button/popup_menu_button.dart';

class BagWidget extends StatefulWidget {
  const BagWidget({super.key});

  @override
  State<BagWidget> createState() => _BagScreen();
}

class _BagScreen extends State<BagWidget> {
  List<BagModels> bagList = BagModels.getItems();

  void updateQuantity(int index, bool isAdd) {
    setState(() {
      if (isAdd) {
        bagList[index].quantity++;
      } else if (bagList[index].quantity > 0) {
        bagList[index].quantity--;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    List<PromoModels> promoList = PromoModels.getItems();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xffF9F9F9),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.search, color: Colors.black, size: 30),
            onPressed: () {},
          ),
        ],
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
                  EnterPromoCodeContainer(promoList),

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
      child: ListView.separated(
        separatorBuilder: (context, index) => const SizedBox(height: 25),
        itemCount: bagList.length,
        itemBuilder: (context, index) {
          return Container(
            margin: const EdgeInsets.only(left: 20, right: 20),
            height: 130,
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
                        child: Image.asset(
                          bagList[index].image,
                          fit: BoxFit.cover,
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
                          Text(bagList[index].name,
                              style: const TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.black)),
                          const SizedBox(
                            height: 3,
                            width: 200,
                          ),
                          Row(
                            children: [
                              const Text(
                                "Color: ",
                                style: TextStyle(color: Color(0xff9B9B9B)),
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
                                style: TextStyle(color: Color(0xff9B9B9B)),
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
                                    borderRadius: BorderRadius.circular(900),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.2),
                                        spreadRadius: 2,
                                        blurRadius: 5,
                                        offset: const Offset(0, 2),
                                      ),
                                    ]),
                                child: Center(
                                  child: IconButton(
                                    icon: const Icon(
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
                              const SizedBox(width: 20),
                              Text(bagList[index].quantity.toString(),
                                  style: const TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w700)),
                              const SizedBox(width: 20),

                              Container(
                                height: 40,
                                width: 40,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(900),
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
                              Expanded(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      ('${bagList[index].price * bagList[index].quantity}'),
                                      style: const TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800),
                                    ),
                                    const Text(
                                      '\$',
                                      style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w800),
                                    )
                                  ],
                                ),
                              ),
                              //3 dots thingy
                              const SizedBox(width: 10),
                            ],
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
                        child: Container(
                          decoration: const BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Color(0xff9B9B9B),
                                width: 1.0,
                              ),
                            ),
                          ),
                          child: ListTile(
                            title: const Text(
                              "Add to favorites",
                              textAlign: TextAlign.center,
                            ),
                            titleAlignment: ListTileTitleAlignment.center,
                            onTap: () {},
                          ),
                        ),
                      ),
                      FlutterPopupMenuItem(
                        closeOnItemClick: true,
                        child: ListTile(
                          title: const Text(
                            "Delete from the list",
                            textAlign: TextAlign.center,
                          ),
                          titleAlignment: ListTileTitleAlignment.center,
                          onTap: () {},
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

  Container EnterPromoCodeContainer(List<PromoModels> promoList) {
    return Container(
      height: 40,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(90),
        color: const Color(0xffFFFFFF),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: TextField(
        onTap: () {
          //Modal bottom sheet
          showModalBottomSheet<void>(
            context: context,
            builder: (BuildContext context) {
              return Container(
                child: Column(
                  children: [
                    Container(
                      margin: const EdgeInsets.only(top: 60),
                      height: 40,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(90),
                        color: const Color(0xffFFFFFF),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.2),
                            spreadRadius: 2,
                            blurRadius: 5,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),

                      //textfield
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: TextField(
                          //TODO: filter promo codes based on text
                          onTap: () {},
                          decoration: InputDecoration(
                            fillColor: const Color(0xffFFFFFF),
                            filled: true,
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                              borderSide: BorderSide.none,
                            ),
                            //TODO: tappable icon?
                            suffixIcon: const Icon(
                                Icons.arrow_circle_right_rounded,
                                size: 40),
                            hintText: 'Enter your promo code',
                            hintStyle: const TextStyle(
                              fontFamily: 'AbhayaLibre',
                              color: Color(0xff9B9B9B),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                    //promo text
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Container(
                          margin: const EdgeInsets.only(
                              top: 20, bottom: 20, left: 20),
                          child: const Text(
                            'Your Promo Codes',
                            style: TextStyle(
                              color: Color(0xff222222),
                              fontSize: 20,
                              fontFamily: 'AbhayaLibre',
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ],
                    ),

                    //promo list
                    Expanded(
                      child: Container(
                        child: ListView.separated(
                          separatorBuilder: (context, index) =>
                              const SizedBox(height: 25),
                          itemCount: promoList.length,
                          itemBuilder: (context, index) {
                            return Container(
                                margin:
                                    const EdgeInsets.only(left: 20, right: 20),
                                height: 100,
                                decoration: BoxDecoration(
                                  color: Colors.white,
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
                                    //main Row
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        //image
                                        SizedBox(
                                          width: 100,
                                          child: ClipRRect(
                                            borderRadius:
                                                const BorderRadius.only(
                                              topLeft: Radius.circular(8),
                                              bottomLeft: Radius.circular(8),
                                            ),
                                            child: Image.asset(
                                              promoList[index].image,
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),

                                        //details
                                        SizedBox(
                                          width: 150,
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 10),
                                                  child: Text(
                                                    promoList[index].name,
                                                    style: const TextStyle(
                                                      color: Color(0xff222222),
                                                      fontSize: 15,
                                                      fontFamily: 'AbhayaLibre',
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  )),
                                              const SizedBox(height: 5),
                                              Container(
                                                  margin: const EdgeInsets.only(
                                                      left: 10),
                                                  child: Text(
                                                    promoList[index].code,
                                                    style: const TextStyle(
                                                      color: Color(0xff222222),
                                                      fontSize: 12,
                                                      fontFamily: 'AbhayaLibre',
                                                      fontWeight:
                                                          FontWeight.w800,
                                                    ),
                                                  )),
                                            ],
                                          ),
                                        ),

                                        //apply button and remaining(with positioned)
                                        Expanded(
                                          child: Container(
                                            child: Column(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.end,
                                                children: [
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 20,
                                                            bottom: 10),
                                                    child: Text(
                                                      '${promoList[index].DaysLeft()} days remaining',
                                                      style: const TextStyle(
                                                        color:
                                                            Color(0xff9B9B9B),
                                                        fontSize: 12,
                                                        fontFamily:
                                                            'AbhayaLibre',
                                                        fontWeight:
                                                            FontWeight.w800,
                                                      ),
                                                    ),
                                                  ),
                                                  //TODO: change to elevatedbutton to set code
                                                  Container(
                                                    margin:
                                                        const EdgeInsets.only(
                                                            right: 20,
                                                            bottom: 5),
                                                    width: 100,
                                                    height: 40,
                                                    decoration: BoxDecoration(
                                                      color: Colors.red,
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              25),
                                                    ),
                                                    child: const Center(
                                                      child: Text(
                                                        'Apply',
                                                        style: TextStyle(
                                                          color: Colors.white,
                                                          fontSize: 12,
                                                          fontFamily:
                                                              'AbhayaLibre',
                                                          fontWeight:
                                                              FontWeight.w500,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ]),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
        decoration: InputDecoration(
          fillColor: const Color(0xffFFFFFF),
          filled: true,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide.none,
          ),
          suffixIcon: const Icon(Icons.arrow_circle_right_rounded, size: 40),
          hintText: 'Enter your promo code',
          hintStyle: const TextStyle(
            fontFamily: 'AbhayaLibre',
            color: Color(0xff9B9B9B),
            fontSize: 14,
            fontWeight: FontWeight.w400,
          ),
        ),
      ),
    );
  }

  Container TotalamountContainer(List<BagModels> bagList) {
    //total amount
    double total = 0;
    for (int i = 0; i < bagList.length; i++) {
      total = bagList[i].price * bagList[i].quantity + total;
    }

    return Container(
      height: 20,
      margin: const EdgeInsets.only(top: 20, left: 30, right: 30),
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
            '${total.toString()}\$',
            style: const TextStyle(
              fontWeight: FontWeight.w800,
              fontSize: 20,
            ),
          ),
        ],
      ),
    );
  }

  Container CheckoutButton() {
    //TODO: change to elevatedbutton when making new screen
    return Container(
      height: 60,
      margin: const EdgeInsets.only(left: 20, right: 20, top: 30),
      decoration: BoxDecoration(
        color: const Color(0xffDDA86B),
        borderRadius: BorderRadius.circular(40),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            spreadRadius: 2,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: const Center(
        child: Text(
          'CHECK OUT',
          style: TextStyle(
              fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
        ),
      ),
    );
  }

  Container MybagText() {
    return Container(
      margin: const EdgeInsets.only(top: 30),
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
