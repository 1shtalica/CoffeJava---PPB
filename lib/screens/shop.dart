import 'package:e_nusantara/screens/product_details.dart';
import 'package:flutter/material.dart';
import 'package:filter_list/filter_list.dart';
import 'package:e_nusantara/screens/product_details.dart';

class ShopWidget extends StatefulWidget {
  const ShopWidget({super.key});

  @override
  State<ShopWidget> createState() => _ShopScreen();
}

class _ShopScreen extends State<ShopWidget> {
  //daftar variabel
  String search = "";

  //controller
  final searchController = TextEditingController();

  //List
  List<Widget> views = <Widget>[
    Icon(Icons.grid_view_rounded),
    Icon(Icons.view_agenda)
  ];

  final List<bool> _selectedView = <bool>[true, false];

  List<Product> productList = [
    Product(
      nameProduct: "Basic T-Shirt",
      category: "Men's Clothing",
      subCategory: "T-Shirt",
      location: "New York",
      image: "assets/image/Men_T-Shirt_01.jpg",
      brand: ["Brand A"],
      color: ["Black", "White"],
      price: 19.99,
      rating: 4.5,
      size: ["S", "M", "L", "XL"],
    ),
    Product(
      nameProduct: "Graphic T-Shirt",
      category: "Men's Clothing",
      subCategory: "T-Shirt",
      location: "Los Angeles",
      image: "assets/image/Men_T-Shirt_02.jpg",
      brand: ["Brand B"],
      color: ["Red", "Blue"],
      price: 24.99,
      rating: 4.2,
      size: ["M", "L", "XL"],
    ),
    Product(
      nameProduct: "Plain T-Shirt",
      category: "Men's Clothing",
      subCategory: "T-Shirt",
      location: "Chicago",
      image: "assets/image/Men_T-Shirt_03.jpg",
      brand: ["Brand C"],
      color: ["Gray", "White"],
      price: 17.99,
      rating: 4.0,
      size: ["S", "M", "L"],
    ),
    Product(
      nameProduct: "Formal Shirt",
      category: "Men's Clothing",
      subCategory: "Shirt",
      location: "Houston",
      image: "assets/image/Men_Shirt_01.jpg",
      brand: ["Brand D"],
      color: ["White", "Blue"],
      price: 29.99,
      rating: 4.7,
      size: ["M", "L", "XL", "XXL"],
    ),
    Product(
      nameProduct: "Casual Shirt",
      category: "Men's Clothing",
      subCategory: "Shirt",
      location: "Miami",
      image: "assets/image/Men_Shirt_02.jpg",
      brand: ["Brand E"],
      color: ["Green", "Brown"],
      price: 22.99,
      rating: 4.1,
      size: ["S", "M", "L"],
    ),
    Product(
      nameProduct: "Cargo Trousers",
      category: "Men's Clothing",
      subCategory: "Trousers",
      location: "San Francisco",
      image: "assets/image/Men_Trousers_01.jpg",
      brand: ["Brand F"],
      color: ["Khaki", "Olive"],
      price: 34.99,
      rating: 4.6,
      size: ["M", "L", "XL"],
    ),
    Product(
      nameProduct: "Chinos",
      category: "Men's Clothing",
      subCategory: "Trousers",
      location: "Boston",
      image: "assets/image/Men_Trousers_02.jpg",
      brand: ["Brand G"],
      color: ["Navy", "Beige"],
      price: 31.99,
      rating: 4.3,
      size: ["M", "L", "XL", "XXL"],
    ),
  ];

  List<User> userList = [
    User(name: "Jon", avatar: ""),
    User(name: "Lindsey ", avatar: ""),
    User(name: "Valarie ", avatar: ""),
    User(name: "Elyse ", avatar: ""),
    User(name: "Ethel ", avatar: ""),
    User(name: "Emelyan ", avatar: ""),
    User(name: "Catherine ", avatar: ""),
    User(name: "Stepanida  ", avatar: ""),
    User(name: "Carolina ", avatar: ""),
    User(name: "Nail  ", avatar: ""),
    User(name: "Kamil ", avatar: ""),
    User(name: "Mariana ", avatar: ""),
    User(name: "Katerina ", avatar: ""),
  ];

  List<User> selectedUserList = [];

  //function
  void openFilterDialog() async {
    await FilterListDialog.display<User>(
      context,
      listData: userList,
      selectedListData: selectedUserList,
      choiceChipLabel: (user) => user!.name,
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (user, query) {
        return user.name!.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        setState(() {
          selectedUserList = List.from(list!);
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 120,
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(color: Color(0xFFDDA86B)),
              child: Column(
                children: [
                  const Text(
                    'Shop',
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 20,
                        fontWeight: FontWeight.bold),
                  ),
                  SearchAnchor(
                    builder: (context, controller) {
                      return SearchBar(
                        controller: controller,
                        padding: const WidgetStatePropertyAll(
                            EdgeInsets.symmetric(horizontal: 10)),
                        onTap: () {
                          controller.openView();
                        },
                        onChanged: (_) {
                          controller.openView();
                        },
                        leading: const Icon(Icons.search),
                      );
                    },
                    suggestionsBuilder: (context, controller) {
                      return List<ListTile>.generate(5, (int index) {
                        final String item = 'item $index';
                        return ListTile(
                          title: Text(item),
                          onTap: () {
                            setState(() {
                              controller.closeView(item);
                            });
                          },
                        );
                      });
                    },
                  )
                ],
              ),
            ),
            SizedBox(
              height: 60,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {},
                    child: Container(
                      width: 100,
                      height: 50,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xFFDDA86B),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          'Category',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {
                      openFilterDialog();
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xFFDDA86B),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          'Location',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {},
                    child: Container(
                      width: 100,
                      height: 50,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xFFDDA86B),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          'Size',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {},
                    child: Container(
                      width: 100,
                      height: 50,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xFFDDA86B),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          'Color',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {},
                    child: Container(
                      width: 100,
                      height: 50,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xFFDDA86B),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          'Price',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                  InkWell(
                    borderRadius: BorderRadius.circular(20),
                    onTap: () {},
                    child: Container(
                      width: 100,
                      height: 50,
                      margin: EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Color(0xFFDDA86B),
                          borderRadius: BorderRadius.circular(20)),
                      child: const Center(
                        child: Text(
                          'Brand',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            // selectedUserList == null || selectedUserList!.length == 0
            //     ? Expanded(
            //         child: ListView.builder(
            //           itemCount: userList.length,
            //           itemBuilder: (context, index) {
            //             return Center(
            //               child: Text(userList[index].name ?? 'unknown'),
            //             );
            //           },
            //         ),
            //       )
            //     : Expanded(
            //         child: ListView.builder(
            //           itemCount: selectedUserList.length,
            //           itemBuilder: (context, index) {
            //             return Center(
            //               child:
            //                   Text(selectedUserList[index].name ?? 'unknown'),
            //             );
            //           },
            //         ),
            //       ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {},
                      child: const Row(
                        children: [
                          Icon(
                            Icons.delivery_dining,
                            color: Color(0xFFDDA86B),
                          ),
                          Text(
                            "Delivery To...",
                            style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFFDDA86B)),
                          ),
                        ],
                      )),
                  ToggleButtons(
                    direction: Axis.horizontal,
                    onPressed: (int indexView) {
                      setState(() {
                        for (int i = 0; i < views.length; i++) {
                          _selectedView[i] = i == indexView;
                        }
                      });
                    },
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                    selectedBorderColor:
                        const Color.fromRGBO(255, 208, 136, 0.7),
                    selectedColor: Colors.white,
                    fillColor: const Color.fromRGBO(255, 208, 136, 1),
                    color: const Color.fromRGBO(255, 208, 136, 1),
                    constraints: const BoxConstraints(
                      minHeight: 30.0,
                      minWidth: 60.0,
                    ),
                    isSelected: _selectedView,
                    children: views,
                  )
                ],
              ),
            ),
            Expanded(
              //   child: ListView.builder(
              // itemCount: productList.length,
              // itemBuilder: (context, index) {
              //   return _buildProductCard(productList[index]);
              // },)

              child: GridView.builder(
                itemCount: productList.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount:
                      MediaQuery.of(context).orientation == Orientation.portrait
                          ? 2
                          : 2,
                  crossAxisSpacing: 10.0,
                  mainAxisSpacing: 10.0,
                ),
                itemBuilder: (context, index) {
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => product_details(
                                    image: productList[index].image!,
                                  )));
                    },
                    child: _buildProductCard(productList[index]),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

Widget _buildProductCard(Product myProduct) {
  return InkWell(
    child: Container(
      width: 200,
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
              color: Colors.black38,
              blurRadius: 7,
              spreadRadius: 2,
              offset: Offset(4, 4))
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.only(
                topLeft: Radius.circular(10), topRight: Radius.circular(10)),
            child: myProduct.image != null
                ? Image.asset(
                    myProduct.image!,
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: 100,
                  )
                : const SizedBox.shrink(),
          ),
          Padding(
            padding: EdgeInsets.only(top: 10),
            child: Column(
              children: [
                Text(
                  myProduct.nameProduct ?? 'unknown',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  "\$${myProduct.price.toStringAsFixed(2)}", // Menampilkan harga
                  style: const TextStyle(color: Colors.grey),
                ),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

class User {
  final String? name;
  final String? avatar;
  User({this.name, this.avatar});
}

class Product {
  String? nameProduct;
  String? category;
  String? subCategory;
  String? location;
  String? image;
  List<String>? brand;
  List<String>? color;
  List<String>? size;
  double price;
  double rating;
  Product({
    required this.nameProduct,
    required this.category,
    required this.subCategory,
    required this.location,
    required this.image,
    required this.brand,
    required this.color,
    required this.price,
    required this.rating,
    this.size,
  });
}
