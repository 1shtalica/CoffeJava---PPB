import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:filter_list/filter_list.dart';
import 'package:provider/provider.dart';
import '../provider/FavoriteProvider.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreen();
}

class _FavoriteScreen extends State<FavoriteScreen> {
  List<FavoriteItem> favoritesItem = [];
  List<FavoriteItem> filteredItems = [];
  bool isGridView = true;

  @override
  void initState() {
    super.initState();
    filteredItems = Favoriteprovider().favorites;
  }

  void openFilterDelegate() async {
    final List<String> options =
        favoritesItem.map((item) => item.title).toSet().toList();

    await FilterListDialog.display<String>(
      context,
      listData: options,
      selectedListData: options,
      choiceChipLabel: (item) => item,
      validateSelectedItem: (list, val) => list!.contains(val),
      onItemSearch: (item, query) {
        return item.toLowerCase().contains(query.toLowerCase());
      },
      onApplyButtonClick: (list) {
        if (list != null) {
          setState(() {
            filteredItems = favoritesItem
                .where((item) => list.contains(item.title))
                .toList();
          });
        }
        Navigator.pop(context);
      },
    );
  }

  void toggleView() {
    setState(() {
      isGridView = !isGridView;
    });
  }

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<Favoriteprovider>(context);
    favoritesItem = favoriteProvider.favorites;
    filteredItems = favoritesItem;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        title: const Text(
          'Favorites',
          style: TextStyle(
              color: Colors.black, fontWeight: FontWeight.bold, fontSize: 24),
        ),
        actions: <Widget>[
          IconButton(
            onPressed: () {},
            icon: const Icon(
              Icons.search,
              color: Colors.black,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton(onPressed: () {}, child: const Text('Summer')),
                  const SizedBox(width: 10),
                  ElevatedButton(
                      onPressed: () {}, child: const Text('T-Shirts')),
                  const SizedBox(width: 10),
                  ElevatedButton(onPressed: () {}, child: const Text('Shirts')),
                  const SizedBox(width: 10),
                  ElevatedButton(onPressed: () {}, child: const Text('Spring')),
                  const SizedBox(width: 10),
                  ElevatedButton(
                      onPressed: () {}, child: const Text('T-Shirts')),
                  const SizedBox(width: 10),
                  ElevatedButton(onPressed: () {}, child: const Text('Shirts')),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: openFilterDelegate,
                  child: const Text(
                    'Filters',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const Row(
                  children: [
                    Icon(Icons.sort, size: 24),
                    SizedBox(width: 5),
                    Text(
                      'Price: lowest to high',
                      style: TextStyle(fontSize: 16),
                    )
                  ],
                ),
                IconButton(
                  onPressed: toggleView,
                  icon: Icon(
                    isGridView ? Icons.view_list : Icons.grid_view,
                    size: 24,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: isGridView
                ? GridView.builder(
                    padding: const EdgeInsets.all(8),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      childAspectRatio: 0.7,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10,
                    ),
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return FavoriteItem(
                        imageUrl: item.imageUrl,
                        title: item.title,
                        brand: item.brand,
                        color: item.color,
                        price: item.price,
                        size: item.size,
                        rating: item.rating,
                        isSoldOut: item.isSoldOut,
                        index: index,
                        isGridView: true,
                      );
                    })
                : ListView.builder(
                    itemCount: filteredItems.length,
                    itemBuilder: (context, index) {
                      final item = filteredItems[index];
                      return FavoriteItem(
                        imageUrl: item.imageUrl,
                        title: item.title,
                        brand: item.brand,
                        color: item.color,
                        price: item.price,
                        size: item.size,
                        rating: item.rating,
                        isSoldOut: item.isSoldOut,
                        index: index,
                        isGridView: false,
                      );
                    },
                  ),
          )
        ],
      ),
    );
  }
}

class FavoriteItem extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String brand;
  final String color;
  final double price;
  final String size;
  final double rating;
  final bool isSoldOut;
  final int index;
  final bool isGridView;

  const FavoriteItem({
    super.key,
    required this.imageUrl,
    required this.title,
    required this.brand,
    required this.color,
    required this.price,
    required this.size,
    required this.rating,
    required this.isSoldOut,
    required this.index,
    required this.isGridView,
  });

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<Favoriteprovider>(context);

    if (isGridView) {
      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image container with fixed aspect ratio
            Expanded(
              flex: 3,
              child: Stack(
                children: [
                  Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage(imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: IconButton(
                      icon: const Icon(
                        Icons.favorite,
                        color: Colors.red,
                      ),
                      onPressed: () {
                        favoriteProvider.deleteFavoriteItem(index);
                      },
                    ),
                  ),
                ],
              ),
            ),
            // Content container
            Expanded(
              flex: 2,
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      brand,
                      style: const TextStyle(fontSize: 12),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      NumberFormat.currency(locale: 'id', symbol: 'Rp')
                          .format(price),
                      style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                    if (isSoldOut)
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
                          'Sold Out',
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
    } else {
      return Card(
        child: ListTile(
          leading: Image.asset(imageUrl),
          title: Text(title),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Brand: $brand'),
              Text('Color: $color'),
              Text('Size: $size'),
              Text('Rating: $rating'),
              Text(
                  'Price: ${NumberFormat.currency(locale: 'id', symbol: 'Rp').format(price)}'),
              if (isSoldOut)
                const Text(
                  'Sold Out',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
          trailing: IconButton(
            icon: const Icon(
              Icons.favorite,
              color: Colors.red,
            ),
            onPressed: () {
              favoriteProvider.deleteFavoriteItem(index);
            },
          ),
        ),
      );
    }
  }
}
