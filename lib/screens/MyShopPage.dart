import 'package:e_nusantara/models/product_models.dart';
import 'package:e_nusantara/models/pagination_models.dart';
import 'package:e_nusantara/api/product_service.dart';
import 'package:flutter/material.dart';
import 'package:e_nusantara/widget/cardShop.dart';
import 'package:filter_list/filter_list.dart';
import 'package:http/http.dart' as http;

class MyShopWidget extends StatefulWidget {
  const MyShopWidget({super.key});

  @override
  State<MyShopWidget> createState() => _MyShopWidgetState();
}

class _MyShopWidgetState extends State<MyShopWidget> {
  //Filter
  String? filterSearch = null;
  int? filterCategory = null;
  int? filterSubCategory = null;
  int? filterSpecificSubCategory = null;

  List<Category> selectedCategory = [];
  List<SubCategory> selectedSubCategory = [];
  List<SpecificSubCategory> selectedSpecificSubCategory = [];

  bool _isSearching = false;

  //Product
  List<Product> products = [];
  List<Category> listCategory = [];
  List<SubCategory> listSubcategory = [];
  List<SpecificSubCategory> listSpecificSubCategory = [];
  bool isLoading = true;
  late Pagination pagination;

  //Controller
  final scrollController = ScrollController(keepScrollOffset: true);

  @override
  void initState() {
    super.initState();
    scrollController.addListener(_scrollListener);
    fetchProduct();
    fetchAllData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : CustomScrollView(
              controller: scrollController,
              slivers: [
                SliverAppBar(
                  backgroundColor: Color(0xFFDDA86B),
                  expandedHeight: 200,
                  pinned: true,
                  flexibleSpace: FlexibleSpaceBar(
                    background: Image.asset(
                      "assets/image/banner.png",
                      fit: BoxFit.cover,
                    ),
                    title: !_isSearching ? Text("Shop") : _searchTextField(),
                    centerTitle: true,
                  ),
                  actions: !_isSearching
                      ? [
                          IconButton(
                              onPressed: () {
                                setState(() {
                                  _isSearching = true;
                                });
                              },
                              icon: Icon(Icons.search))
                        ]
                      : [
                          IconButton(
                              icon: Icon(Icons.clear),
                              onPressed: () {
                                setState(() {
                                  _isSearching = false;
                                });
                              })
                        ],
                ),
                SliverPersistentHeader(
                  delegate: FilterListDelegate(
                    maxExtent: 100,
                    minExtent: 50,
                  ),
                  pinned: true,
                ),
                products.isEmpty
                    ? SliverFillRemaining(
                        hasScrollBody: false,
                        child: Center(
                          child: Text(
                              "There are no products with the required specifications"),
                        ),
                      )
                    : SliverGrid.builder(
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          maxCrossAxisExtent: 250.0,
                        ),
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Card(
                              child: Center(
                                child: ProductCard(
                                  image: products[index].images?[0] ?? '',
                                  title: products[index].pName ?? 'No Title',
                                  productId: products[index].productId ?? 0,
                                  price: products[index].price.toInt() ?? 0,
                                  totalReview: products[index].ratings!.length,
                                ),
                              ),
                            ),
                          );
                        },
                        itemCount: products.length,
                      ),
                if (isLoading)
                  SliverToBoxAdapter(
                    child: Center(child: CircularProgressIndicator()),
                  ),
              ],
            ),
    );
  }

  Future<void> fetchAllData() async {
    final ProductService pService = ProductService();
    setState(() {
      isLoading = true;
    });

    try {
      // Fetch paralel
      final results = await Future.wait([
        pService.fetchAllCategories(),
        pService.fetchAllSubcategories(),
        pService.fetchAllSpecificSubcategories(),
      ]);
      if (this.mounted) {
        setState(() {
          listCategory = results[0] as List<Category>;
          listSubcategory = results[1] as List<SubCategory>;
          listSpecificSubCategory = results[2] as List<SpecificSubCategory>;
          print('Categories: ${results[0]}');
          print('Subcategories: ${results[1]}');
          print('Specific Subcategories: ${results[2]}');
          isLoading = false;
        });
      }
    } catch (e) {
      print("Error fetching data: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> fetchProduct({int page = 1}) async {
    final ProductService pService = ProductService();
    try {
      isLoading = true;
      if (page == 1) {
        products = [];
      }

      print("Fetching products with parameters:");
      print("Page: $page");
      print("Search: $filterSearch");
      print("Category ID: $filterCategory");
      print("Subcategory ID: $filterSubCategory");
      print("Specific Subcategory ID: $filterSpecificSubCategory");

      final result = await pService.fetchAllProducts(
        page: page,
        limit: 20,
        search: filterSearch,
        categoryId: filterCategory,
        subcategoryId: filterSubCategory,
        specificSubcategoryId: filterSpecificSubCategory,
      );

      if (this.mounted) {
        setState(() {
          products.addAll(result['products']);
          pagination = result['pagination'];
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print("Error loading products: $e");
    }
  }

  Future<void> fetchCategory() async {
    final ProductService pService = ProductService();
    try {
      isLoading = true;
      final result = await pService.fetchAllCategories();

      setState(() {
        listCategory = result;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      throw Exception('Failed to load category');
    }
  }

  Future<void> fetchSubCategory() async {
    final ProductService pService = ProductService();
    try {
      isLoading = true;
      final result = await pService.fetchAllSubcategories();

      setState(() {
        listSubcategory = result;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      throw Exception('Failed to load subcategory');
    }
  }

  Future<void> fetchSpecificSubCategory() async {
    final ProductService pService = ProductService();
    try {
      isLoading = true;
      final result = await pService.fetchAllSpecificSubcategories();

      setState(() {
        listSpecificSubCategory = result;
        isLoading = false;
      });
    } catch (e) {
      print(e);
      throw Exception('Failed to load specificsubcategory');
    }
  }

  void _scrollListener() {
    if (scrollController.position.pixels ==
        scrollController.position.maxScrollExtent) {
      int totalPages =
          (pagination.items.total / pagination.items.perPage).ceil();
      if (pagination.currentPage < totalPages) {
        fetchProduct(page: pagination.currentPage + 1);
      }
    }
  }

  void openFilterCategoryDialog() async {
    await FilterListDialog.display<Category>(
      context,
      height: 450.0,
      listData: listCategory,
      enableOnlySingleSelection: true,
      selectedListData: selectedCategory,
      choiceChipLabel: (category) => category?.categoryName ?? 'Unknown',
      validateSelectedItem: (list, val) => list?.contains(val) ?? false,
      onItemSearch: (category, query) {
        return category?.categoryName
                ?.toLowerCase()
                .contains(query.toLowerCase()) ??
            false;
      },
      onApplyButtonClick: (list) {
        if (list != null && list.isNotEmpty) {
          setState(() {
            filterCategory = list.first.categoryId;
          });
        } else {
          setState(() {
            filterCategory = null;
          });
        }
        Navigator.pop(context);
      },
    );
  }

  void openFilterSubCategoryDialog() async {
    await FilterListDialog.display<SubCategory>(
      context,
      height: 450.0,
      listData: listSubcategory,
      enableOnlySingleSelection: true,
      selectedListData: selectedSubCategory,
      choiceChipLabel: (sub) => sub?.subCategoryName ?? 'Unknown',
      validateSelectedItem: (list, val) => list?.contains(val) ?? false,
      onItemSearch: (sub, query) {
        return sub?.subCategoryName
                ?.toLowerCase()
                .contains(query.toLowerCase()) ??
            false;
      },
      onApplyButtonClick: (list) {
        if (list != null && list.isNotEmpty) {
          setState(() {
            filterSubCategory = list.first.subCategoryId;
          });
        } else {
          setState(() {
            filterSubCategory = null;
          });
        }
        Navigator.pop(context);
      },
    );
  }

  void openFilterSpecificSubCategoryDialog() async {
    await FilterListDialog.display<SpecificSubCategory>(
      context,
      height: 450.0,
      listData: listSpecificSubCategory,
      enableOnlySingleSelection: true,
      selectedListData: selectedSpecificSubCategory,
      choiceChipLabel: (spec) => spec?.specificSubCategoryName ?? 'Unknown',
      validateSelectedItem: (list, val) => list?.contains(val) ?? false,
      onItemSearch: (spec, query) {
        return spec?.specificSubCategoryName
                ?.toLowerCase()
                .contains(query.toLowerCase()) ??
            false;
      },
      onApplyButtonClick: (list) {
        if (list != null && list.isNotEmpty) {
          setState(() {
            filterSpecificSubCategory = list.first.specificSubCategoryId;
          });
        } else {
          setState(() {
            filterSpecificSubCategory = null;
          });
        }
        Navigator.pop(context);
      },
    );
  }

  Future<void> applyButtonPressed() async {
    print("Filter Search: ${filterSearch ?? 'No Search Query'}");
    print("Filter Category: ${filterCategory ?? 'No Category'}");
    print("Filter SubCategory: ${filterSubCategory ?? 'No SubCategory'}");
    print(
        "Filter Specific SubCategory: ${filterSpecificSubCategory ?? 'No Specific SubCategory'}");
    print("Category select: ${selectedCategory ?? 'EMPTY'}");
    print("sub Category select: ${selectedSubCategory ?? 'EMPTY'}");
    print(
        "specific SubCategory select: ${selectedSpecificSubCategory ?? 'EMPTY'}");

    fetchProduct();
  }

  Future<void> resetButtonPressed() async {
    filterSearch = null;
    filterCategory = null;
    filterSubCategory = null;
    filterSpecificSubCategory = null;

    selectedCategory = [];
    selectedSubCategory = [];

    fetchProduct();
  }

  Widget _searchTextField() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: TextField(
        autofocus: true,
        cursorColor: Colors.white,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 20,
        ),
        textInputAction: TextInputAction.search,
        decoration: const InputDecoration(
          enabledBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          focusedBorder:
              UnderlineInputBorder(borderSide: BorderSide(color: Colors.white)),
          hintText: 'Search',
          hintStyle: TextStyle(
            color: Colors.white60,
            fontSize: 20,
          ),
        ),
        onSubmitted: (value) {
          if (value.isEmpty) {
            _isSearching = false;
            filterSearch = null;
            fetchProduct();
          } else {
            _isSearching = false;
            filterSearch = value;
            fetchProduct();
          }
        },
      ),
    );
  }
}

//DAFTAR KELAS
class FilterListDelegate extends SliverPersistentHeaderDelegate {
  FilterListDelegate({
    required this.maxExtent,
    required this.minExtent,
  });

  final double maxExtent;
  final double minExtent;

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    final double progress =
        1 - (shrinkOffset / (maxExtent - minExtent)).clamp(0.0, 1.0);
    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: Card(
            margin: EdgeInsets.zero,
            color: Colors.white,
            child: Container(
              height: maxExtent,
            ),
          ),
        ),
        Positioned(
          top: progress * 10,
          left: 10,
          child: Opacity(
            opacity: progress,
            child: const Text(
              "Filter",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
        Positioned(
          bottom: progress * 10,
          left: 0,
          right: 0,
          child: SizedBox(
            height: 50,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: TextButton(
                      onPressed: () {
                        (context as Element)
                            .findAncestorStateOfType<_MyShopWidgetState>()
                            ?.resetButtonPressed();
                      },
                      child: Text("Reset"),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: TextButton(
                      onPressed: () {
                        (context as Element)
                            .findAncestorStateOfType<_MyShopWidgetState>()
                            ?.applyButtonPressed();
                      },
                      child: Text("Apply"),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: TextButton(
                      onPressed: () {
                        (context as Element)
                            .findAncestorStateOfType<_MyShopWidgetState>()
                            ?.openFilterCategoryDialog();
                      },
                      child: Text("Category"),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: TextButton(
                      onPressed: () {
                        (context as Element)
                            .findAncestorStateOfType<_MyShopWidgetState>()
                            ?.openFilterSubCategoryDialog();
                      },
                      child: Text("SubCategory"),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: TextButton(
                      onPressed: () {
                        (context as Element)
                            .findAncestorStateOfType<_MyShopWidgetState>()
                            ?.openFilterSpecificSubCategoryDialog();
                      },
                      child: Text("SpecificCategory"),
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  @override
  bool shouldRebuild(covariant SliverPersistentHeaderDelegate oldDelegate) =>
      false;
}
