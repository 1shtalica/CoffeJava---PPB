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

  @override
  void initState() {
    super.initState();
    _favoritesFuture = _favoriteService.fetchFavorites();
  }

  void deleteFavorite(int productId) async {
    bool isSuccess = await _favoriteService.deleteFavorites(productId);
    if (isSuccess) {
      setState(() {
        _favoritesFuture = _favoriteService.fetchFavorites();
      });
    }
  }

  Widget buildFavoriteItem(dynamic item, bool isGridView) {
    return isGridView ? _buildGridItem(item) : _buildListItem(item);
  }

  Widget _buildGridItem(dynamic item) {
    
    
    return GestureDetector(
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
                                  image: NetworkImage(imageUrl['image_url']!),//busa juga kaya gini item['images'][index]['image_url']
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
    );
  }

  Widget _buildListItem(Product item) {//ubah jadi dyanamic
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => product_details(
                      image: item.images?.first ?? '',//ubah seus
                      title: item.pName ?? '',
                      productId: item.productId ?? 0,
                    )));
      },
      child: ListTile(
        leading: Image.network(
          item.images?.first ?? '',
          width: 80,
          height: 80,
          fit: BoxFit.cover,
        ),
        title: Text(item.pName ?? ''),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Brand: ${item.brand ?? ''}'),
            Text(
              'Price: ${NumberFormat.currency(locale: 'id', symbol: 'Rp').format(item.price)}',
            ),
            if (item.sale ?? false)
              const Text(
                'on Sale',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
        trailing: IconButton(
          onPressed: () => deleteFavorite(item.productId!),
          icon: const Icon(
            Icons.favorite,
            color: Colors.red,
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
        future: favoriteService().fetchFavorites(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Text('Failed to load Favorite: ${snapshot.error}'),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No Favorite Products'));
          } else {
            print(snapshot.data);
            List<dynamic> products =
                snapshot.data!.map((product) => product['product']).toList();

            return GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: isGridView ? 2 : 1,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: isGridView ? 0.8 : 1.2,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                return buildFavoriteItem(products[index], isGridView);
              },
            );
          }
        },
      ),
    );
  }
}
