import 'package:e_nusantara/api/checkLogin.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../api/favorite_service.dart';
import '../models/product_models.dart';
import 'package:e_nusantara/screens/product_details.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key, required});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  late Future<List<dynamic>> _favoritesFuture;
  final favoriteService _favoriteService = favoriteService();
  bool isGridView = true;
    final Checklogin _checklogin = new Checklogin();

  @override
  void initState() {
    super.initState();
     _checklogin.checkAndNavigate(context);
    _favoritesFuture = _favoriteService.fetchFavorites(context);
  }

  void deleteFavorite(int productId) async {
     _checklogin.checkAndNavigate(context);
    bool isSuccess = await _favoriteService.deleteFavorites(productId, context);
    if (isSuccess) {
      setState(() {
        _favoritesFuture = _favoriteService.fetchFavorites(context);
      });
    }
  }

  Widget buildFavoriteItem(dynamic item, bool isGridView) {
     _checklogin.checkAndNavigate(context);
    return isGridView ? _buildGridItem(item) : _buildListItem(item);
  }

  Widget _buildGridItem(dynamic item) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!, width: 3.0),
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => product_details(
                        image: item['images'][0]['image_url'] ?? "",
                        title: item['pName'] ?? '',
                        productId: item['product_id'] ?? 0,
                      )));
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  SizedBox(
                    width: double.infinity,
                    child: PageView.builder(
                        itemCount: item['images'].length ?? 0,
                        itemBuilder: (context, index) {
                          final imageUrl = item['images'][index];
                          return Container(
                            decoration: BoxDecoration(
                                image: DecorationImage(
                                    image: NetworkImage(imageUrl[
                                        'image_url']!), //busa juga kaya gini item['images'][index]['image_url']
                                    fit: BoxFit.cover)),
                          );
                        }),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      onPressed: () => deleteFavorite(item['product_id']!),
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      item['pName'] ?? '',
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      NumberFormat.currency(locale: 'id', symbol: 'Rp')
                          .format((item['price'].round())! * 1000),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    if (item['sale'] ?? false)
                      Container(
                        margin: const EdgeInsets.only(top: 4),
                        padding: const EdgeInsets.symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'On Sale',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 10,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildListItem(dynamic item) {
    if (item == null) return const SizedBox();

    final imageUrl = item['images']?[0]['image_url'] ?? "";
    final productName = item['pName'] ?? '';
    final productId = item['product_id'] ?? 0;
    final brand = item['brand'] ?? '';
    final price = (item['price'] ?? 0).round() * 1000;
    final isOnSale = item['sale'] ?? false;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => product_details(
              image: imageUrl,
              title: productName,
              productId: productId,
            ),
          ),
        );
      },
      child: Card(
        child: ListTile(
          leading: imageUrl.isNotEmpty
              ? Image.network(
                  imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return const Icon(Icons.error);
                  },
                )
              : const Icon(Icons.image_not_supported),
          title: Text(productName),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Brand: $brand'),
              Text(
                'Price: ${NumberFormat.currency(locale: 'id', symbol: 'Rp').format(price)}',
              ),
              if (isOnSale)
                const Text(
                  'On Sale',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
          trailing: IconButton(
            onPressed: () => deleteFavorite(productId),
            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorite Products'),
        actions: [
          IconButton(
            onPressed: () {
              setState(() {
                isGridView = !isGridView;
              });
            },
            icon: Icon(isGridView ? Icons.view_list : Icons.grid_view),
          ),
        ],
      ),
      body: FutureBuilder<List<dynamic>>(
        future: _favoritesFuture, // Gunakan future yang sudah diinisialisasi
        builder: (context, snapshot) {
           _checklogin.checkAndNavigate(context);
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load Favorite: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Favorite Products'));
          } else {
            List<dynamic> products =
                snapshot.data!.map((product) => product['product']).toList();
            return isGridView
                ? GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                      childAspectRatio: 0.8,
                    ),
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return _buildGridItem(products[index]);
                    },
                  )
                : ListView.builder(
                    itemCount: products.length,
                    itemBuilder: (context, index) {
                      return _buildListItem(products[index]);
                    },
                  );
          }
        },
      ),
    );
  }
}
