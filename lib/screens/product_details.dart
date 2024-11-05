import 'package:e_nusantara/provider/FavoriteProvider.dart';
import 'package:e_nusantara/screens/favoriteScreen.dart';
import 'package:e_nusantara/widget/cardList.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icon_snackbar/flutter_icon_snackbar.dart';
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

import '../provider/SizeChartProvider.dart';

class product_details extends StatefulWidget {
  const product_details({super.key, required this.image, required this.title});
  final String image;
  final String title;

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<product_details> {
  late List<String> sampleImages;

  @override
  void initState() {
    super.initState();

    sampleImages = [
      widget.image,
      'assets/image/example1.jpg',
      'assets/image/example2.jpg',
      'assets/image/example3.jpg',
    ];
  }

  final List<Map<String, dynamic>> _ratings = [
    {
      "username": "john_doe",
      "rating": 5,
      "review":
          "The batik shirt is stunning! Excellent quality and vibrant colors."
    },
    {
      "username": "sarah_123",
      "rating": 4,
      "review":
          "Beautiful design, but the size runs a little small. Still happy with it!"
    },
    {
      "username": "michael90",
      "rating": 3,
      "review":
          "The pattern is nice, but the material feels a bit rough on the skin."
    },
    {
      "username": "lisa_w",
      "rating": 5,
      "review":
          "Perfect gift! My husband loves it. Fits perfectly and looks elegant."
    },
    {
      "username": "david_k",
      "rating": 2,
      "review":
          "The shirt arrived with loose threads, disappointing for the price."
    },
    {
      "username": "emily_r",
      "rating": 4,
      "review":
          "Great shirt! The print is beautiful, though the delivery was slightly delayed."
    },
    {
      "username": "alex_b",
      "rating": 1,
      "review": "Terrible quality. Faded colors after just one wash."
    },
    {
      "username": "chris_t",
      "rating": 5,
      "review": "Absolutely love it! I get compliments every time I wear it."
    },
    {
      "username": "natalie_p",
      "rating": 4,
      "review": "Nice design, but the fabric could be a bit softer."
    },
    {
      "username": "samuel_h",
      "rating": 3,
      "review": "It looks okay, but the size doesn't match the description."
    },
  ];

  @override
  Widget build(BuildContext context) {
    final sizeChartProvider = Provider.of<SizeChartProvider>(context);
    final favoriteProvider = Provider.of<Favoriteprovider>(context);
    int ratingLength = _ratings.length;
    bool isFavorite =
        favoriteProvider.favorites.any((item) => item.title == widget.title);
    double totalRating =
        _ratings.fold(0, (sum, rating) => sum + rating["rating"]);

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
            onPressed: () {
              print(favoriteProvider.favorites.length);
            },
          ),
        ],
      ),
      body: CustomScrollView(
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
                isAssets: true,
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
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Batik",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        "Rp.300.000,00",
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    "authentic indonesian batik",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color.fromRGBO(117, 117, 117, 1),
                    ),
                  ),
                  SizeChart(),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
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
                  const Text(
                    "Discover the charm and elegance of Indonesia with our Authentic Indonesian Batik Shirt, a perfect blend of tradition and modern style. This shirt showcases the intricate patterns of Batik, an ancient textile art recognized by UNESCO as a Masterpiece of Oral and Intangible Heritage of Humanity.",
                    style: TextStyle(fontSize: 14, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  const Divider(color: Colors.black45),
                  Tabbar(),
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
                return Ratting(
                  username: _ratings[index]["username"],
                  rating: _ratings[index]["rating"],
                  review: _ratings[index]["review"],
                );
              },
              childCount: 4,
            ),
          ),
          SliverToBoxAdapter(
              child: GestureDetector(
            onTap: () {
              print("test");
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => RatingDetails(
                    ratings: _ratings,
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
                          itemCount: 10,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.only(
                                  left: 10, right: 10, bottom: 10),
                              child: CardList(
                                  image: 'assets/image/${index + 1}.png',
                                  index: index,
                                  title: 'Product${index + 1}'),
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
                              child: SizeChart(),
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
