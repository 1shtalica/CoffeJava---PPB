import 'package:e_nusantara/models/product_models.dart';
import 'package:flutter/material.dart';

class Tabbar extends StatefulWidget {
  final Product product;
  Tabbar({super.key, required this.product});

  @override
  _TabbarState createState() => _TabbarState();
}

class _TabbarState extends State<Tabbar> with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double _maxHeight = 180;

  var category;
  var subCategorY;
  var specificSubCategory;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    category = widget.product.categories!
        .map((category) => category.categoryName)
        .join(", ");
    subCategorY = widget.product.subCategories!
        .map((subCategory) => subCategory.subCategoryName)
        .join(", ");
    specificSubCategory = widget.product.specificSubCategories!
        .map((specificSubCategory) =>
            specificSubCategory.specificSubCategoryName)
        .join(", ");

    _tabController.addListener(_handleTabSelection);
  }

  void _handleTabSelection() {
    setState(() {
      _maxHeight = _tabController.index == 0 ? 180 : 150;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            controller: _tabController,
            tabs: const [
              Tab(text: 'Product Information'),
              Tab(text: 'About The Product'),
            ],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: const Color(0xFFD08835),
          ),
          ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: _maxHeight,
            ),
            child: TabBarView(
              controller: _tabController,
              children: [
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Rincian",
                          style: TextStyle(fontSize: 25),
                        ),
                        const SizedBox(height: 10),
                        Text("SKU: ${widget.product.productId}"),
                        const SizedBox(height: 5),
                        Text("Brand: ${widget.product.brand}"),
                        const SizedBox(height: 5),
                        Text("Categories: ${category}"),
                        const SizedBox(height: 5),
                        Text("Sub categories: ${subCategorY}"),
                        const SizedBox(height: 5),
                        Text("Spesific categories: ${specificSubCategory}"),
                       
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(10),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "About ${widget.product.pName}",
                          style: const TextStyle(fontSize: 25),
                        ),
                        const SizedBox(height: 10),
                        Text("${widget.product.decs}"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
