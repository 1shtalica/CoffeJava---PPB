import 'package:flutter/material.dart';
import 'package:e_nusantara/screens/categories.dart';

const List<Widget> views = <Widget>[
  Icon(Icons.grid_view_rounded),
  Icon(Icons.view_agenda)
];

class ProductList extends StatefulWidget {
  final String selectedProductCategory;
  const ProductList({super.key, required this.selectedProductCategory});

  @override
  State<ProductList> createState() => _ProductListState();
}

class _ProductListState extends State<ProductList> {
  final List<bool> _selectedView = <bool>[true, false];
  bool vertical = false;

  final List<Map<String, dynamic>> products = [
    {
      'name': 't-shirt 01',
      'price': 120.000,
      'category': 'Graphic T-Shirt',
      'shop': 'Makappa',
      'Location': 'Bekasi',
      'Rating': 5.0
    },
    {
      'name': 't-shirt 02',
      'price': 150.000,
      'category': 'Graphic T-Shirt',
      'shop': 'BattleRoyal',
      'Location': 'Bogor',
      'Rating': 4.2
    },
    {
      'name': 't-shirt 03',
      'price': 100.000,
      'category': 'Graphic T-Shirt',
      'shop': 'Makappa',
      'Location': 'Bekasi',
      'Rating': 4.5
    },
    {
      'name': 't-shirt 04',
      'price': 115.000,
      'category': 'Graphic T-Shirt',
      'shop': 'BattleRoyal',
      'Location': 'Bogor',
      'Rating': 4.0
    },
    {
      'name': 't-shirt 05',
      'price': 145.000,
      'category': 'Graphic T-Shirt',
      'shop': 'Mara',
      'Location': 'Jakarta',
      'Rating': 4.2
    },
    {
      'name': 't-shirt 06',
      'price': 445.000,
      'category': 'Graphic T-Shirt',
      'shop': 'ZZZ',
      'Location': 'Bekasi',
      'Rating': 3.4
    },
    {
      'name': 't-shirt 07',
      'price': 75.000,
      'category': 'Graphic T-Shirt',
      'shop': 'Mara',
      'Location': 'Jakarta',
      'Rating': 4.7
    },
    {
      'name': 't-shirt 08',
      'price': 250.000,
      'category': 'Graphic T-Shirt',
      'shop': 'Coach',
      'Location': 'Tangerang',
      'Rating': 5.0
    },
    {
      'name': 't-shirt 09',
      'price': 180.000,
      'category': 'Graphic T-Shirt',
      'shop': 'BattleRoyal',
      'Location': 'Bogor',
      'Rating': 4.8
    },
  ];

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
                      builder: (context) => const CategoriesPage()),
                );
              },
            ),
            title: Text(
              "${widget.selectedProductCategory} Products",
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
            ),
            centerTitle: true),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ElevatedButton.icon(
                  icon: const Icon(
                    Icons.filter_list,
                    color: Colors.white,
                    size: 20,
                  ),
                  label: const Text(
                    'Filter',
                    style: TextStyle(color: Colors.white),
                  ),
                  onPressed: () {
                    showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(20),
                                topRight: Radius.circular(20))),
                        builder: (BuildContext context) {
                          return DraggableScrollableSheet(
                            initialChildSize: 0.4,
                            minChildSize: 0.2,
                            maxChildSize: 0.8,
                            expand: false,
                            builder: (context, ScrollController) {
                              return GestureDetector(
                                behavior: HitTestBehavior.translucent,
                                child: SingleChildScrollView(
                                  controller: ScrollController,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Center(
                                          child: Container(
                                            width: 50,
                                            height: 5,
                                            margin: const EdgeInsets.fromLTRB(
                                                0, 10, 0, 10),
                                            decoration: const ShapeDecoration(
                                                color: Colors.grey,
                                                shape: StadiumBorder()),
                                          ),
                                        ),
                                        const Row(
                                          children: [
                                            // IconButton(
                                            //     iconSize: 30,
                                            //     onPressed: () {
                                            //       Navigator.pop(context);
                                            //     },
                                            //     icon: const Icon(Icons.close)),
                                            Text(
                                              'Filter',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 30),
                                            ),
                                          ],
                                        ),
                                        const Text(
                                          'Urutkan',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                              fontSize: 20),
                                        ),
                                        Row(
                                          children: [
                                            InkWell(
                                              onTap: () {},
                                              child: Container(
                                                child: Text('Rating'),
                                              ),
                                            )
                                          ],
                                        ),
                                        ElevatedButton(
                                          onPressed: () {
                                            Navigator.pop(context);
                                          },
                                          child: const Text('Terapkan Filter'),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor:
                                                const Color(0xFFD08835),
                                            minimumSize:
                                                const Size.fromHeight(50),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        });
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFD08835)),
                ),
                const SizedBox(
                  width: 30,
                ),
                ToggleButtons(
                  direction: vertical ? Axis.vertical : Axis.horizontal,
                  onPressed: (int indexView) {
                    setState(() {
                      for (int i = 0; i < views.length; i++) {
                        _selectedView[i] = i == indexView;
                      }
                    });
                  },
                  borderRadius: const BorderRadius.all(Radius.circular(20)),
                  selectedBorderColor: const Color.fromRGBO(255, 208, 136, 0.7),
                  selectedColor: Colors.white,
                  fillColor: const Color.fromRGBO(255, 208, 136, 1),
                  color: const Color.fromRGBO(255, 208, 136, 1),
                  constraints: const BoxConstraints(
                    minHeight: 40.0,
                    minWidth: 80.0,
                  ),
                  isSelected: _selectedView,
                  children: views,
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.all(10),
            )
          ],
        ),
      ),
    );
  }
}

// Widget _gridView(List<Map<String, dynamic>> products) {
//   return GridView.builder(
//     gridDelegate: gridDelegate,
//     itemBuilder: itemBuilder)
// }

Widget _listView(List<Map<String, dynamic>> products) {
  return Container(
    width: 150,
  );
}
