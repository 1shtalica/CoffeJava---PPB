import 'dart:math';
// import 'package:e_nusantara/models/product_models.dart';
import 'package:intl/intl.dart';
import 'package:e_nusantara/screens/product_details.dart';
import 'package:flutter/material.dart';
import '../api/favorite_service.dart';
// import '../models/product_models.dart';

class CardList extends StatefulWidget {
  const CardList(
      {super.key,
      required this.image,
      required this.index,
      required this.title,
      required this.product_id,
      required this.price,
      required this.totalReview});
  final String image;
  final int index;
  final String title;
  final int product_id;
  final int price;
  final int totalReview;

  @override
  State<CardList> createState() => _CardListState();
}

class _CardListState extends State<CardList> {
  Future<void> addFavorite(BuildContext context, bool isFavorite) async {
    favoriteService service = favoriteService();
    bool isFavorite = await service.isCheckFavorite(widget.product_id);
    // final product = Product(
    //     productId: widget.product_id,
    //     pName: widget.title,
    //     categories: [],
    //     subCategories: [],
    //     specificSubCategories: [],
    //     images: [widget.image],
    //     stock: [],
    //     dicount: null,
    //     ratings: [],
    //     sale: null,
    //     brand: null,
    //     decs: null,
    //     price: widget.price.toDouble());

    if (isFavorite) {
      await service.deleteFavorites(widget.product_id);
      setState(() {
        isFavorite = !isFavorite;
      });
    } else {
      await service.addFavorites(widget.product_id);
      setState(() {
        isFavorite = !isFavorite;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => product_details(
              image: widget.image,
              title: widget.title,
              productId: widget.product_id,
            ),
          ),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              offset: const Offset(3, 4),
              blurRadius: 4,
            )
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 10),
              child: Container(
                width: 120,
                height: 100,
                decoration: BoxDecoration(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(8),
                    topRight: Radius.circular(8),
                  ),
                  image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(widget.image),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.transparent,
              width: 120,
              child: Text(widget.title,
                  style: const TextStyle(fontSize: 12),
                  overflow: TextOverflow.fade),
            ),
            Text(
              NumberFormat.simpleCurrency(
                locale: 'id_ID',
                name: 'Rp',
              ).format((widget.price.round()) * 1000).toString(),
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            Row(
              children: [
                Text("${widget.totalReview} Review •"),
                const Icon(
                  Icons.star,
                  color: Colors.amber,
                ),
                FutureBuilder<bool>(
                  future: favoriteService().isCheckFavorite(widget.product_id),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else {
                      final isFavorite = snapshot.data ?? false;
                      return IconButton(
                          onPressed: () async {
                            await addFavorite(context, isFavorite);
                            (context as Element).markNeedsBuild();
                          },
                          icon: Icon(
                            isFavorite ? Icons.favorite : Icons.favorite_border,
                            color: isFavorite ? Colors.red : Colors.grey,
                          ));
                    }
                  },
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
