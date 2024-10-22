import 'package:e_nusantara/screens/home.dart';
import 'package:flutter/material.dart';
import 'package:e_nusantara/screens/product_list.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String selectedCategory = "Women";
  String? selectedSubCategory;
  final List<Map<String, dynamic>> category = [
    {
      'type': "Women",
      'subType': [
        "Women's T-Shirt",
        "Women's Blus",
        "Women's Dress",
        "Women's Skirt",
        "Women's Bag",
        "Women's Shoe"
      ]
    },
    {
      'type': 'Men',
      'subType': [
        "Men's T-Shirt",
        "Men's Shirt",
        "Men's Trousers",
        "Men's Jacket",
        "Men's Hoodie",
        "Men's Shoe"
      ]
    },
    {
      'type': 'Kids',
      'subType': [
        "Kid's T-Shirt",
        "Kid's Dress",
        "Kid's Trousers",
        "Kid's Hat",
        "Kid's Bag",
        "Kid's Shoe"
      ]
    },
    {
      'type': 'Electronics',
      'subType': [
        "TV",
        "Camera",
        "Laptop",
        "Handphone"
      ] // This category doesn't seem to have corresponding items in the `items` list, so it's left empty.
    },
  ];

  // Ini list buat gambar ama produknya, kalo mau nambah kategori, langkah2nya:
  //1. tmbhn di list dibawah path gambar ama deskripsinya
  //2. atur kembali index di listview builder
  final List<Map<String, String>> items = [
    {'image': 'assets/image/Women-01.jpg', 'description': "Women's T-Shirt"},
    {'image': 'assets/image/Women-02.jpg', 'description': "Women's Blus"},
    {'image': 'assets/image/Women-03.jpg', 'description': "Women's Dress"},
    {'image': 'assets/image/Women-04.jpg', 'description': "Women's Skirt"},
    {'image': 'assets/image/Women-05.jpg', 'description': "Women's Bag"},
    {'image': 'assets/image/Women-06.jpg', 'description': "Women's Shoe"},
    {'image': 'assets/image/Men-01.jpg', 'description': "Men's T-Shirt"},
    {'image': 'assets/image/Men-02.jpg', 'description': "Men's Shirt"},
    {'image': 'assets/image/Men-03.jpg', 'description': "Men's Trousers"},
    {'image': 'assets/image/Men-04.jpg', 'description': "Men's Jacket"},
    {'image': 'assets/image/Men-05.jpg', 'description': "Men's Hoodie"},
    {'image': 'assets/image/Men-06.jpg', 'description': "Men's Shoe"},
    {'image': 'assets/image/Kids-01.jpg', 'description': "Kid's T-Shirt"},
    {'image': 'assets/image/Kids-02.jpg', 'description': "Kid's Dress"},
    {'image': 'assets/image/Kids-03.jpg', 'description': "Kid's Trousers"},
    {'image': 'assets/image/Kids-04.jpg', 'description': "Kid's Hat"},
    {'image': 'assets/image/Kids-05.jpg', 'description': "Kid's Bag"},
    {'image': 'assets/image/Kids-06.jpg', 'description': "Kid's Shoe"},
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
          elevation: 0,
          backgroundColor: Colors.transparent,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => HomeWidget()),
              );
            },
          ),
          title: const Text(
            "Categories",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          centerTitle: true),
      body: ListView(
        children: [
          Row(
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    selectedCategory = "Women";
                    selectedSubCategory = null;
                  });
                },
                child: Container(
                  width: 135,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: selectedCategory == "Women"
                          ? const Border(
                              bottom: BorderSide(width: 2, color: Colors.black))
                          : null),
                  child: Text(
                    "Women",
                    style: TextStyle(
                        fontWeight: selectedCategory == "Women"
                            ? FontWeight.bold
                            : FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedCategory = "Men";
                    selectedSubCategory = null;
                  });
                },
                child: Container(
                  width: 135,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: selectedCategory == "Men"
                          ? const Border(
                              bottom: BorderSide(width: 2, color: Colors.black))
                          : null),
                  child: Text(
                    "Men",
                    style: TextStyle(
                        fontWeight: selectedCategory == "Men"
                            ? FontWeight.bold
                            : FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedCategory = "Kids";
                    selectedSubCategory = null;
                  });
                },
                child: Container(
                  width: 135,
                  margin:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: selectedCategory == "Kids"
                          ? const Border(
                              bottom: BorderSide(width: 2, color: Colors.black))
                          : null),
                  child: Text(
                    "Kids",
                    style: TextStyle(
                        fontWeight: selectedCategory == "Kids"
                            ? FontWeight.bold
                            : FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                ),
              )
            ],
          ),
          //Dibawah tampilan yang menyesuaikan tipe kategori dan sub kategori yang dipilih
          InkWell(
            onTap: () {
              setState(() {
                selectedCategory = "Kids";
                selectedSubCategory = null;
              });
            },
            child: Container(
              width: 200,
              height: 100,
              padding: const EdgeInsets.all(10),
              margin: const EdgeInsets.fromLTRB(10, 10, 10, 20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: const Color(0xFFDDA86B)),
              child: const Column(
                children: <Widget>[
                  Text(
                    "Flash Sale",
                    style: TextStyle(
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                        color: Colors.white),
                  ),
                  Text(
                    "Up to 50% off",
                    style: TextStyle(
                        fontWeight: FontWeight.w600, color: Colors.white),
                  )
                ],
              ),
            ),
          ),
          //List View Builder buat kategori
          SizedBox(
            height: 200,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: items.length,
              itemBuilder: (context, index) {
                if (selectedCategory == "Women" && index < 6) {
                  return InkWell(
                      onTap: () {
                        setState(() {
                          selectedSubCategory = items[index]['description'];
                        });
                      },
                      child: _buildItemCard(items[index]));
                } else if (selectedCategory == "Men" &&
                    index >= 6 &&
                    index < 12) {
                  return InkWell(
                      onTap: () {
                        setState(() {
                          selectedSubCategory = items[index]['description'];
                        });
                      },
                      child: _buildItemCard(items[index]));
                } else if (selectedCategory == "Kids" && index >= 12) {
                  return InkWell(
                      onTap: () {
                        setState(() {
                          selectedSubCategory = items[index]['description'];
                        });
                      },
                      child: _buildItemCard(items[index]));
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          if (selectedSubCategory != null &&
              products.containsKey(selectedSubCategory))
            Column(children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 10),
                child: Text(
                  "$selectedSubCategory Products",
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ),
              Column(
                children: products[selectedSubCategory]!
                    .map((product) => InkWell(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProductList(
                                        selectedProductCategory:
                                            product['name'] ?? 'unknown',
                                      )),
                            );
                          },
                          child: Container(
                            margin: const EdgeInsets.all(10),
                            padding: const EdgeInsets.all(10),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.white,
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 6,
                                  spreadRadius: 2,
                                )
                              ],
                            ),
                            child: Row(
                              children: [
                                Image.asset(
                                  product['image']!,
                                  height: 50,
                                  width: 50,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  product['name']!,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                )
                              ],
                            ),
                          ),
                        ))
                    .toList(),
              )
            ])
          else
            const SizedBox.shrink(),
        ],
      ),
    ));
  }
}

Widget _buildItemCard(Map<String, String> item) {
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
          child: item['image'] != null
              ? Image.asset(
                  item['image']!,
                  fit: BoxFit.cover,
                  height: 100,
                  width: 150,
                )
              : const SizedBox.shrink(),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Text(
            item['description'] ?? 'Unknown',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    ),
  );
}
