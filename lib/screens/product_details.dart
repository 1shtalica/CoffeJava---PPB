import 'dart:convert';

import 'package:e_nusantara/models/product_models.dart';
import 'package:e_nusantara/provider/FavoriteProvider.dart';
import 'package:e_nusantara/screens/favoriteScreen.dart';
import 'package:e_nusantara/screens/sign_in.dart';
import 'package:e_nusantara/screens/sign_up.dart';
import 'package:e_nusantara/widget/cardList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../widget/size.dart';
import '../widget/ratting.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/safe_area_values.dart';
import 'package:top_snackbar_flutter/tap_bounce_container.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../widget/tabBar.dart';
import './ratingDetails.dart';
import 'package:fan_carousel_image_slider/fan_carousel_image_slider.dart';
import '../models/product_models.dart' as fixProduct;

import '../provider/SizeChartProvider.dart';
import 'package:http/http.dart' as http;
import '../api/auth_service.dart';
import "../api/product_service.dart";

class product_details extends StatefulWidget {
  const product_details(
      {super.key,
      required this.image,
      required this.title,
      required this.productId});
  final String image;
  final String title;
  final int productId;

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<product_details> {
  List<fixProduct.Product> products = [];
  bool isLoading = true;
  Product? productDetail;
  List<Review> _ratings = [];
  final storage = FlutterSecureStorage();
  List<String> sampleImages = [];
  final AuthService _authService = AuthService();

  Future<void> fetchProductCategory() async {
    final ProductService productService = ProductService();
    try {
      isLoading = true;
      final result = await productService.fetchAllProducts(
          limit: 25, categoryId: productDetail!.categories![0].categoryId);

      setState(() {
        products = result['products'];
        print(products[0].brand);
      });
    } catch (e) {
      print("Error loading products: $e");
    }
  }

  Future<Product> fetchProductDetails(int productId) async {
    isLoading = true;
    ProductService productService = ProductService();
    try {
      Product? product = await productService.fetchProductbyId(productId);

      if (product != null) {
        return product;
      } else {
        throw Exception("Product not found");
      }
    } catch (e) {
      print("e: ${e}");
      throw Exception(e);
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeProductDetails();
  }

  Future<void> _initializeProductDetails() async {
    ProductService productService = ProductService();

    Product? fetchedProduct = await fetchProductDetails(widget.productId);
    final result = await productService.fetchAllProducts(
        limit: 25, categoryId: fetchedProduct!.categories![0].categoryId);

    setState(() {
      productDetail = fetchedProduct;

      _ratings = productDetail!.ratings ?? [];
      products = result['products'];

      print(products.length);

      if (productDetail != null) {
        sampleImages = productDetail!.images!;
      }
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final sizeChartProvider = Provider.of<SizeChartProvider>(context);
    final favoriteProvider = Provider.of<Favoriteprovider>(context);
    int ratingLength = _ratings.length;
    bool isFavorite =
        favoriteProvider.favorites.any((item) => item.title == widget.title);
    double totalRating = _ratings.fold(0, (sum, rating) => sum + rating.value);

    double averageRating = ratingLength > 0 ? totalRating / ratingLength : 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Container(
          alignment: Alignment.center,
          child: Text(
            widget.title,
            style: const TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            sizeChartProvider.selectSize(-1);
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: isLoading == true
          ? Center(child: CircularProgressIndicator())
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  automaticallyImplyLeading: false,
                  backgroundColor: Colors.transparent,
                  elevation: 0,
                  primary: false,
                  pinned: false,
                  centerTitle: false,
                  expandedHeight: 500,
                  flexibleSpace: FlexibleSpaceBar(
                    background: FanCarouselImageSlider.sliderType1(
                      imagesLink: sampleImages,
                      isAssets: false,
                      autoPlay: false,
                      sliderHeight: 450,
                      showIndicator: true,
                      initalPageIndex: 0,
                    ),
                  ),
                ),
                const SliverToBoxAdapter(
                  child: SizedBox(height: 20),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          productDetail?.pName ?? '',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          NumberFormat.simpleCurrency(
                            locale: 'id_ID',
                            name: 'Rp',
                          )
                              .format((productDetail?.price.round())! * 1000)
                              .toString(),
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          productDetail?.brand ?? '',
                          style: const TextStyle(
                            fontSize: 16,
                            color: Color.fromRGBO(117, 117, 117, 1),
                          ),
                        ),
                        SizeChart(
                          stock: productDetail!.stock ?? [],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.star,
                                color: Colors.amber, size: 20),
                            const SizedBox(width: 4),
                            Text(
                              "${averageRating.toStringAsFixed(1)} ($ratingLength reviews) ",
                              style: const TextStyle(
                                  fontSize: 14,
                                  color: Color.fromRGBO(117, 117, 117, 1)),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        
                        
                        const Divider(color: Colors.black45),
                        Tabbar(
                          product: productDetail!,
                        ),
                        const Divider(color: Colors.black45),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              "Ratting & Review",
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Row(
                              children: [
                                Text("$averageRating/5"),
                                const SizedBox(width: 10),
                                Text("$ratingLength reviews")
                              ],
                            )
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      return _ratings == 0
                          ? Text("no raings")
                          : Ratting(
                              username: _ratings[index].name,
                              rating: _ratings[index].value,
                              review: _ratings[index].review);
                    },
                    childCount: _ratings.length,
                  ),
                ),
                SliverToBoxAdapter(
                    child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RatingDetails(
                          ratings: _ratings
                              .map((review) => {
                                    'username': review.name,
                                    'rating': review.value,
                                    'review': review.review,
                                  })
                              .toList(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: const BoxDecoration(color: Colors.transparent),
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Padding(
                        padding: EdgeInsets.only(right: 24.0, left: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("More Review"),
                            Icon(Icons.arrow_forward_ios)
                          ],
                        ),
                      ),
                    ),
                  ),
                )),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        const Divider(color: Colors.black45),
                        const ListTile(
                          title: Text("Shipping info"),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                        const Divider(color: Colors.black45),
                        const ListTile(
                          title: Text("Support"),
                          trailing: Icon(Icons.arrow_forward_ios),
                        ),
                        const Divider(color: Colors.black45),
                        const SizedBox(height: 40),
                        const Text(
                          "you may like other similar products",
                          style: TextStyle(),
                        ),
                        const SizedBox(
                          height: 30,
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
                                        image: products[index].images![0],
                                        index: index,
                                        title: products[index].pName ?? "",
                                        product_id:
                                            products[index].productId ?? 0,
                                        price:
                                            products[index].price.toInt() ?? 0,
                                        totalReview:
                                            products[index].ratings!.length),
                                  );
                                },
                              ),
                            ))
                      ],
                    ),
                  ),
                )
              ],
            ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(25.0)),
                    ),
                    builder: (BuildContext context) {
                      return SizedBox(
                        height: 180,
                        child: Column(
                          children: [
                            Padding(
                              padding:
                                  const EdgeInsets.only(left: 16, right: 16),
                              child: SizeChart(
                                stock: productDetail!.stock ?? [],
                              ),
                            ),
                            Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFD08835),
                                borderRadius: BorderRadius.circular(50),
                              ),
                              width: 380,
                              height: 50,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFD08835),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(50),
                                  ),
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 16),
                                ),
                                onPressed: () {
                                  if (sizeChartProvider.selectedIndex == -1) {
                                    showTopSnackBar(
                                      Overlay.of(context),
                                      const CustomSnackBar.error(
                                        message:
                                            "you have to selected the product size first",
                                      ),
                                    );
                                  } else {
                                    showTopSnackBar(
                                      Overlay.of(context),
                                      const CustomSnackBar.success(
                                        message:
                                            "you have successfully added a product",
                                      ),
                                    );
                                    sizeChartProvider.selectSize(-1);
                                    Navigator.pop(context);
                                  }
                                },
                                child: const Text(
                                  "ADD TO CART",
                                  style: TextStyle(
                                    fontSize: 18,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            )
                          ],
                        ),
                      );
                    },
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD08835),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                ),
                child: const Text(
                  "ADD TO CART",
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            IconButton(
              onPressed: () {
                setState(() {
                  if (!isFavorite) {
                    isFavorite = !isFavorite;
                    favoriteProvider.AddFavoriteItem(
                      FavoriteItem(
                        imageUrl: widget.image,
                        title: widget.title,
                        brand: 'sadd',
                        color: 'Gradssaday',
                        price: 100000,
                        size: 'L',
                        rating: 4.0,
                        isSoldOut: false,
                        index: -1,
                        isGridView: false,
                      ),
                    );
                  } else {
                    isFavorite = !isFavorite;
                    int productIndex = favoriteProvider.favorites
                        .indexWhere((item) => item.title == widget.title);
                    favoriteProvider.deleteFavoriteItem(productIndex);
                  }
                });
              },
              icon: favoriteProvider.favorites
                      .any((item) => item.title == widget.title)
                  ? const Icon(Icons.favorite, color: Colors.red)
                  : const Icon(Icons.favorite_border),
            ),
          ],
        ),
      ),
    );
  }
}
