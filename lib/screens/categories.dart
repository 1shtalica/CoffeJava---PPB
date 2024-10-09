import 'package:e_nusantara/screens/home.dart';
import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String selectedCategory = "Women";

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
                MaterialPageRoute(
                    builder: (context) => HomeWidget() // Hapus 'const'
                    ),
              );
            },
          ),
          title: Text(
            "Categories",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
          ),
          centerTitle: true),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              InkWell(
                onTap: () {
                  setState(() {
                    selectedCategory = "Women";
                  });
                },
                child: Container(
                  width: 50,
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "Women",
                    style: TextStyle(
                        fontWeight: selectedCategory == "Women"
                            ? FontWeight.bold
                            : FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: selectedCategory == "Women"
                          ? Border(
                              bottom: BorderSide(width: 2, color: Colors.black))
                          : null),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedCategory = "Men";
                  });
                },
                child: Container(
                  width: 50,
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "Men",
                    style: TextStyle(
                        fontWeight: selectedCategory == "Men"
                            ? FontWeight.bold
                            : FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: selectedCategory == "Men"
                          ? Border(
                              bottom: BorderSide(width: 2, color: Colors.black))
                          : null),
                ),
              ),
              InkWell(
                onTap: () {
                  setState(() {
                    selectedCategory = "Kids";
                  });
                },
                child: Container(
                  width: 50,
                  margin: EdgeInsets.all(10),
                  child: Text(
                    "Kids",
                    style: TextStyle(
                        fontWeight: selectedCategory == "Kids"
                            ? FontWeight.bold
                            : FontWeight.normal),
                    textAlign: TextAlign.center,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.transparent,
                      border: selectedCategory == "Kids"
                          ? Border(
                              bottom: BorderSide(width: 2, color: Colors.black))
                          : null),
                ),
              )
            ],
          ),
          Container(
            child: const Column(
              children: [
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
            width: 200,
            height: 100,
            padding: EdgeInsets.all(10),
            margin: EdgeInsets.fromLTRB(10, 10, 10, 20),
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), color: Colors.red),
          ),
          GestureDetector(
            child: Container(
              width: 200,
              height: 100,
              padding: EdgeInsets.all(10),
              margin: EdgeInsets.all(10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black, blurRadius: 50, spreadRadius: -10)
                  ],
                  borderRadius: BorderRadius.circular(10)),
            ),
          )
        ],
      ),
    ));
  }
}
