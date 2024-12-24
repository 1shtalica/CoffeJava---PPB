import 'package:e_nusantara/screens/product_details.dart';
import 'package:flutter/material.dart';
import 'package:filter_list/filter_list.dart';
import 'package:intl/intl.dart';
import 'package:buttons_tabbar/buttons_tabbar.dart';

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
    const Icon(Icons.grid_view_rounded),
    const Icon(Icons.view_agenda)
  ];

  final List<bool> _selectedView = <bool>[true, false];

  List<Product> productList = [
    Product(
      nameProduct: "Basic T-Shirt Exclusive Summer 2024 Festival -TwentyOne",
      category: "Men's Clothing",
      subCategory: "T-Shirt",
      location: "New York",
      image: "assets/image/Men_T-Shirt_01.jpg",
      brand: ["Brand A"],
      color: ["Black", "White"],
      price: 200000,
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
      price: 150000,
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
      price: 250000,
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
      price: 300000,
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
      price: 175000,
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
      price: 320000,
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
      price: 120000,
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
    User(name: "Kevin ", avatar: ""),
    User(name: "Adib ", avatar: ""),
    User(name: "Adrian ", avatar: ""),
    User(name: "Farhan ", avatar: ""),
    User(name: "Asep ", avatar: ""),
    User(name: "Budi ", avatar: ""),
  ];

  List<Category> categoryList = [
    Category(
      nameCategory: "Women's T-Shirt",
      categoryImg: 'assets/image/Women-01.jpg',
      subList: [
        SubCategory(
            nameSubCategory: "Basic T-Shirt",
            subCategoryImg: 'assets/image/Women-01.jpg'),
        SubCategory(
            nameSubCategory: "Graphic T-Shirt",
            subCategoryImg: 'assets/image/Women-01.jpg'),
        SubCategory(
            nameSubCategory: "V-Neck T-Shirt",
            subCategoryImg: 'assets/image/Women-01.jpg'),
        SubCategory(
            nameSubCategory: "Oversized T-Shirt",
            subCategoryImg: 'assets/image/Women-01.jpg'),
      ],
    ),
    Category(
      nameCategory: "Women's Blus",
      categoryImg: 'assets/image/Women-02.jpg',
      subList: [
        SubCategory(
            nameSubCategory: "Casual Blus",
            subCategoryImg: 'assets/image/Women-02.jpg'),
        SubCategory(
            nameSubCategory: "Formal Blus",
            subCategoryImg: 'assets/image/Women-02.jpg'),
        SubCategory(
            nameSubCategory: "Sleeveless Blus",
            subCategoryImg: 'assets/image/Women-02.jpg'),
        SubCategory(
            nameSubCategory: "Ruffled Blus",
            subCategoryImg: 'assets/image/Women-02.jpg'),
      ],
    ),
    Category(
      nameCategory: "Women's Dress",
      categoryImg: 'assets/image/Women-03.jpg',
      subList: [
        SubCategory(
            nameSubCategory: "Maxi Dress",
            subCategoryImg: 'assets/image/Women-03.jpg'),
        SubCategory(
            nameSubCategory: "Midi Dress",
            subCategoryImg: 'assets/image/Women-03.jpg'),
        SubCategory(
            nameSubCategory: "A-Line Dress",
            subCategoryImg: 'assets/image/Women-03.jpg'),
        SubCategory(
            nameSubCategory: "Bodycon Dress",
            subCategoryImg: 'assets/image/Women-03.jpg'),
      ],
    ),
    Category(
      nameCategory: "Women's Skirt",
      categoryImg: 'assets/image/Women-04.jpg',
      subList: [
        SubCategory(
            nameSubCategory: "Mini Skirt",
            subCategoryImg: 'assets/image/Women-04.jpg'),
        SubCategory(
            nameSubCategory: "Pencil Skirt",
            subCategoryImg: 'assets/image/Women-04.jpg'),
        SubCategory(
            nameSubCategory: "Pleated Skirt",
            subCategoryImg: 'assets/image/Women-04.jpg'),
        SubCategory(
            nameSubCategory: "Wrap Skirt",
            subCategoryImg: 'assets/image/Women-04.jpg'),
      ],
    ),
    Category(
      nameCategory: "Women's Bag",
      categoryImg: 'assets/image/Women-05.jpg',
      subList: [
        SubCategory(
            nameSubCategory: "Handbag",
            subCategoryImg: 'assets/image/Women-05.jpg'),
        SubCategory(
            nameSubCategory: "Tote Bag",
            subCategoryImg: 'assets/image/Women-05.jpg'),
        SubCategory(
            nameSubCategory: "Crossbody Bag",
            subCategoryImg: 'assets/image/Women-05.jpg'),
        SubCategory(
            nameSubCategory: "Clutch Bag",
            subCategoryImg: 'assets/image/Women-05.jpg'),
      ],
    ),
    Category(
      nameCategory: "Women's Shoe",
      categoryImg: 'assets/image/Women-06.jpg',
      subList: [
        SubCategory(
            nameSubCategory: "Sneakers",
            subCategoryImg: 'assets/image/Women_Shoe_01.jpg'),
        SubCategory(
            nameSubCategory: "Flats",
            subCategoryImg: 'assets/image/Women_Shoe_02.jpg'),
        SubCategory(
            nameSubCategory: "Heels",
            subCategoryImg: 'assets/image/Women_Shoe_03.jpg'),
        SubCategory(
            nameSubCategory: "Boots",
            subCategoryImg: 'assets/image/Women_Shoe_04.jpg'),
      ],
    ),
    Category(
      nameCategory: "Men's T-Shirt",
      categoryImg: 'assets/image/Men-01.jpg',
      subList: [
        SubCategory(
            nameSubCategory: "Basic T-Shirt",
            subCategoryImg: 'assets/image/Men_T-Shirt_01.jpg'),
        SubCategory(
            nameSubCategory: "Graphic T-Shirt",
            subCategoryImg: 'assets/image/Men_T-Shirt_02.jpg'),
        SubCategory(
            nameSubCategory: "V-Neck T-Shirt",
            subCategoryImg: 'assets/image/Men_T-Shirt_03.jpg'),
        SubCategory(
            nameSubCategory: "Polo T-Shirt",
            subCategoryImg: 'assets/image/Men_T-Shirt_04.jpg'),
      ],
    ),
    Category(
      nameCategory: "Men's Shirt",
      categoryImg: 'assets/image/Men-02.jpg',
      subList: [
        SubCategory(
            nameSubCategory: "Formal Shirt",
            subCategoryImg: 'assets/image/Men_Shirt_01.jpg'),
        SubCategory(
            nameSubCategory: "Casual Shirt",
            subCategoryImg: 'assets/image/Men_Shirt_02.jpg'),
        SubCategory(
            nameSubCategory: "Denim Shirt",
            subCategoryImg: 'assets/image/Men_Shirt_03.jpg'),
        SubCategory(
            nameSubCategory: "Flannel Shirt",
            subCategoryImg: 'assets/image/Men_Shirt_04.jpg'),
      ],
    ),
    Category(
      nameCategory: "Men's Trousers",
      categoryImg: 'assets/image/Men-03.jpg',
      subList: [
        SubCategory(
            nameSubCategory: "Cargo Trousers",
            subCategoryImg: 'assets/image/Men_Trousers_01.jpg'),
        SubCategory(
            nameSubCategory: "Chinos",
            subCategoryImg: 'assets/image/Men_Trousers_02.jpg'),
        SubCategory(
            nameSubCategory: "Slim Fit Trousers",
            subCategoryImg: 'assets/image/Men_Trousers_03.jpg'),
        SubCategory(
            nameSubCategory: "Joggers",
            subCategoryImg: 'assets/image/Men_Trousers_04.jpg'),
      ],
    ),
    Category(
      nameCategory: "Men's Jacket",
      categoryImg: 'assets/image/Men-04.jpg',
      subList: [
        SubCategory(
            nameSubCategory: "Bomber Jacket",
            subCategoryImg: 'assets/image/Men_Jacket_01.jpg'),
        SubCategory(
            nameSubCategory: "Denim Jacket",
            subCategoryImg: 'assets/image/Men_Jacket_02.jpg'),
        SubCategory(
            nameSubCategory: "Leather Jacket",
            subCategoryImg: 'assets/image/Men_Jacket_03.jpg'),
        SubCategory(
            nameSubCategory: "Blazer",
            subCategoryImg: 'assets/image/Men_Jacket_04.jpg'),
      ],
    ),
    Category(
      nameCategory: "Men's Hoodie",
      categoryImg: 'assets/image/Men-05.jpg',
      subList: [
        SubCategory(
            nameSubCategory: "Pullover Hoodie",
            subCategoryImg: 'assets/image/Men_Hoodie_01.jpg'),
        SubCategory(
            nameSubCategory: "Zipper Hoodie",
            subCategoryImg: 'assets/image/Men_Hoodie_02.jpg'),
        SubCategory(
            nameSubCategory: "Graphic Hoodie",
            subCategoryImg: 'assets/image/Men_Hoodie_03.jpg'),
        SubCategory(
            nameSubCategory: "Lightweight Hoodie",
            subCategoryImg: 'assets/image/Men_Hoodie_04.jpg'),
      ],
    ),
    Category(
      nameCategory: "Men's Shoe",
      categoryImg: 'assets/image/Men-06.jpg',
      subList: [
        SubCategory(
            nameSubCategory: "Sneakers",
            subCategoryImg: 'assets/image/Men_Shoe_01.jpg'),
        SubCategory(
            nameSubCategory: "Loafers",
            subCategoryImg: 'assets/image/Men_Shoe_02.jpg'),
        SubCategory(
            nameSubCategory: "Boots",
            subCategoryImg: 'assets/image/Men_Shoe_03.jpg'),
        SubCategory(
            nameSubCategory: "Sandals",
            subCategoryImg: 'assets/image/Men_Shoe_04.jpg'),
      ],
    ),
    Category(
      nameCategory: "Kid's T-Shirt",
      categoryImg: 'assets/image/Kids-01.jpg',
      subList: [
        SubCategory(
            nameSubCategory: "Graphic T-Shirt",
            subCategoryImg: 'assets/image/Kids_T-Shirt_01.jpg'),
        SubCategory(
            nameSubCategory: "Basic T-Shirt",
            subCategoryImg: 'assets/image/Kids_T-Shirt_02.jpg'),
        SubCategory(
            nameSubCategory: "Funny T-Shirt",
            subCategoryImg: 'assets/image/Kids_T-Shirt_03.jpg'),
        SubCategory(
            nameSubCategory: "Cartoon T-Shirt",
            subCategoryImg: 'assets/image/Kids_T-Shirt_04.jpg'),
      ],
    ),
    Category(
      nameCategory: "Kid's Dress",
      categoryImg: 'assets/image/Kids-02.jpg',
      subList: [
        SubCategory(
            nameSubCategory: "Party Dress",
            subCategoryImg: 'assets/image/Kids_Dress_01.jpg'),
        SubCategory(
            nameSubCategory: "Casual Dress",
            subCategoryImg: 'assets/image/Kids_Dress_02.jpg'),
        SubCategory(
            nameSubCategory: "Summer Dress",
            subCategoryImg: 'assets/image/Kids_Dress_03.jpg'),
        SubCategory(
            nameSubCategory: "Winter Dress",
            subCategoryImg: 'assets/image/Kids_Dress_04.jpg'),
      ],
    ),
    Category(
      nameCategory: "Kid's Trousers",
      categoryImg: 'assets/image/Kids-03.jpg',
      subList: [
        SubCategory(
            nameSubCategory: "Jeans",
            subCategoryImg: 'assets/image/Kids_Trousers_01.jpg'),
        SubCategory(
            nameSubCategory: "Shorts",
            subCategoryImg: 'assets/image/Kids_Trousers_02.jpg'),
        SubCategory(
            nameSubCategory: "Chinos",
            subCategoryImg: 'assets/image/Kids_Trousers_03.jpg'),
        SubCategory(
            nameSubCategory: "Cargo Pants",
            subCategoryImg: 'assets/image/Kids_Trousers_04.jpg'),
      ],
    ),
    Category(
      nameCategory: "Kid's Hat",
      categoryImg: 'assets/image/Kids-04.jpg',
      subList: [
        SubCategory(
            nameSubCategory: "Baseball Cap",
            subCategoryImg: 'assets/image/Kids_Hat_01.jpg'),
        SubCategory(
            nameSubCategory: "Sun Hat",
            subCategoryImg: 'assets/image/Kids_Hat_02.jpg'),
        SubCategory(
            nameSubCategory: "Beanie",
            subCategoryImg: 'assets/image/Kids_Hat_03.jpg'),
        SubCategory(
            nameSubCategory: "Bucket Hat",
            subCategoryImg: 'assets/image/Kids_Hat_04.jpg'),
      ],
    ),
    Category(
      nameCategory: "Kid's Bag",
      categoryImg: 'assets/image/Kids-05.jpg',
      subList: [
        SubCategory(
            nameSubCategory: "Backpack",
            subCategoryImg: 'assets/image/Kids_Bag_01.jpg'),
        SubCategory(
            nameSubCategory: "Tote Bag",
            subCategoryImg: 'assets/image/Kids_Bag_02.jpg'),
        SubCategory(
            nameSubCategory: "Lunch Bag",
            subCategoryImg: 'assets/image/Kids_Bag_03.jpg'),
        SubCategory(
            nameSubCategory: "Drawstring Bag",
            subCategoryImg: 'assets/image/Kids_Bag_04.jpg'),
      ],
    ),
    Category(
      nameCategory: "Kid's Shoe",
      categoryImg: 'assets/image/Kids-06.jpg',
      subList: [
        SubCategory(
            nameSubCategory: "Sneakers",
            subCategoryImg: 'assets/image/Kids-06.jpg'),
        SubCategory(
            nameSubCategory: "Sandals",
            subCategoryImg: 'assets/image/Kids-06.jpg'),
        SubCategory(
            nameSubCategory: "Boots",
            subCategoryImg: 'assets/image/Kids-06.jpg'),
        SubCategory(
            nameSubCategory: "Slippers",
            subCategoryImg: 'assets/image/Kids-06.jpg'),
      ],
    ),
  ];

  final Map<String, List<Map<String, String>>> products = {
    "Men's T-Shirt": [
      {'image': 'assets/image/Men_T-Shirt_01.jpg', 'name': "Basic T-Shirt"},
      {'image': 'assets/image/Men_T-Shirt_02.jpg', 'name': "Graphic T-Shirt"},
      {'image': 'assets/image/Men_T-Shirt_03.jpg', 'name': "Plain T-Shirt"},
    ],
    "Men's Shirt": [
      {'image': 'assets/image/Men_Shirt_01.jpg', 'name': "Formal Shirt"},
      {'image': 'assets/image/Men_Shirt_02.jpg', 'name': "Casual Shirt"},
    ],
    "Men's Trousers": [
      {'image': 'assets/image/Men_Trousers_01.jpg', 'name': "Cargo"},
      {'image': 'assets/image/Men_Trousers_02.jpg', 'name': "Chinos"},
    ],
  };

  List<User> selectedUserList = [];
  List<Product> selectedProduct = [];

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

  void openFilterLocation() async {
    await FilterListDialog.display<Product>(
      context,
      listData: productList,
      selectedListData: selectedProduct,
      choiceChipLabel: (Product) => Product!.location,
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (product, query) {
        return product.location!.toLowerCase().contains(query.toLowerCase());
      },
      enableOnlySingleSelection: true,
      onApplyButtonClick: (list) {
        setState(() {
          selectedProduct = List.from(list!);
        });
        Navigator.pop(context);
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primaryColor: Colors.white,
        scaffoldBackgroundColor: Colors.white,
        colorScheme: ColorScheme.fromSwatch().copyWith(
          surface: Colors.white,
          primary: Color(0xFFDDA86B),
        ),
      ),
      home: Scaffold(
        body: Column(
          children: [
            Container(
              width: double.infinity,
              height: 120,
              padding: const EdgeInsets.all(10),
              decoration: const BoxDecoration(color: Color(0xFFDDA86B)),
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
                    onTap: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.white,
                          isScrollControlled: true,
                          shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(20),
                                  topRight: Radius.circular(20))),
                          context: context,
                          builder: (BuildContext context) {
                            return DraggableScrollableSheet(
                              initialChildSize: 0.6,
                              maxChildSize: 0.95,
                              minChildSize: 0.3,
                              expand: false,
                              builder: (context, ScrollController) {
                                return Column(
                                  children: [
                                    SizedBox(
                                      height: 100,
                                      child: Center(
                                          child: Column(
                                        children: [
                                          topButtonIndicator(),
                                          const Text(
                                            'Category',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 20),
                                          )
                                        ],
                                      )),
                                    ),
                                    Expanded(
                                        child: ListView.builder(
                                            shrinkWrap: true,
                                            itemCount: categoryList.length,
                                            scrollDirection: Axis.horizontal,
                                            itemBuilder: (context, index) {
                                              Category category =
                                                  categoryList[index];
                                              return _buildCategoryCard(
                                                  category);
                                            })),
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: SizedBox(
                                        height: 50,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFFD08835),
                                            minimumSize:
                                                const Size.fromHeight(50),
                                          ),
                                          child: const Text('Terapkan Filter'),
                                        ),
                                      ),
                                    )
                                  ],
                                );
                              },
                            );
                            // return Container(
                            //     height: 500,
                            //     child: LimitedBox(
                            //       maxHeight: userList.length < 5
                            //           ? userList.length * 70.0
                            //           : 350.0,
                            //       child: ListView.builder(
                            //         shrinkWrap: true,
                            //         itemCount: userList.length,
                            //         itemBuilder: (context, index) {
                            //           return Center(
                            //             child: Text(
                            //                 userList[index].name ?? 'unknown'),
                            //           );
                            //         },
                            //       ),
                            //     ));
                          });
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: const Color(0xFFDDA86B),
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
                      openFilterLocation();
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: const Color(0xFFDDA86B),
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
                    onTap: () {
                      openFilterDialog();
                    },
                    child: Container(
                      width: 100,
                      height: 50,
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: const Color(0xFFDDA86B),
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
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: const Color(0xFFDDA86B),
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
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: const Color(0xFFDDA86B),
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
                      margin: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: const Color(0xFFDDA86B),
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
            // selectedUserList == null || selectedUserList!.isEmpty
            //     ? LimitedBox(
            //         maxHeight:
            //             userList.length < 5 ? userList.length * 70.0 : 350.0,
            //         child: ListView.builder(
            //           shrinkWrap: true,
            //           itemCount: userList.length,
            //           itemBuilder: (context, index) {
            //             return Center(
            //               child: Text(userList[index].name ?? 'unknown'),
            //             );
            //           },
            //         ),
            //       )
            //     : LimitedBox(
            //         maxHeight: selectedUserList.length * 70.0,
            //         child: ListView.builder(
            //           shrinkWrap: true,
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
                itemCount: selectedProduct.isEmpty
                    ? productList.length
                    : selectedProduct.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: MediaQuery.of(context).orientation ==
                            Orientation.portrait
                        ? 2
                        : 2,
                    crossAxisSpacing: 10.0,
                    mainAxisSpacing: 10.0,
                    childAspectRatio: 0.8),
                itemBuilder: (context, index) {
                  Product product = selectedProduct.isEmpty
                      ? productList[index]
                      : selectedProduct[index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => product_details(
                                    image: productList[index].image!,
                                    title: productList[index].nameProduct!,
                                    productId: 34,
                                  )));
                    },
                    child: _buildProductCard(product),
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
      margin: const EdgeInsets.fromLTRB(15, 0, 15, 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: Colors.white,
        boxShadow: const [
          BoxShadow(
              color: Colors.black38,
              blurRadius: 8,
              spreadRadius: 2,
              offset: Offset(4, 4))
        ],
      ),
      child: Column(
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.only(
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
          Expanded(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 10, 0, 0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 4),
                    child: Text(
                      myProduct.nameProduct ?? 'unknown',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ),
                  Text(
                    NumberFormat.simpleCurrency(
                      locale: 'id_ID',
                      name: 'Rp',
                    ).format(myProduct.price).toString(),
                    // style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Row(
                    children: [
                      const Icon(
                        Icons.star,
                        color: Color.fromARGB(255, 255, 182, 35),
                      ),
                      Text(
                        myProduct.rating.toString(),
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ),
  );
}

Container topButtonIndicator() {
  return Container(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          child: Wrap(
            children: [
              Container(
                width: 100,
                margin: const EdgeInsets.only(top: 10, bottom: 10),
                height: 5,
                decoration: const BoxDecoration(
                    color: Colors.black54,
                    shape: BoxShape.rectangle,
                    borderRadius: BorderRadius.all(Radius.circular(8))),
              )
            ],
          ),
        )
      ],
    ),
  );
}

Widget _buildCategoryCard(Category myCategory) {
  return Container(
    width: 150,
    margin: const EdgeInsets.all(15),
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
          borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(10), topRight: Radius.circular(10)),
          child: myCategory.categoryImg != null
              ? Image.asset(
                  myCategory.categoryImg!,
                  fit: BoxFit.cover,
                  height: 100,
                  width: 150,
                )
              : const SizedBox.shrink(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            myCategory.nameCategory ?? 'Unknown',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
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

class Category {
  String? nameCategory;
  String? categoryImg;
  List<SubCategory> subList;

  Category({this.nameCategory, this.categoryImg, required this.subList});
}

class SubCategory {
  String? nameSubCategory;
  String? subCategoryImg;
  SubCategory({this.nameSubCategory, this.subCategoryImg});
}

class TypeProduct {
  String? nameType;
  List<Category>? categories;

  TypeProduct({this.nameType, required this.categories});
}
