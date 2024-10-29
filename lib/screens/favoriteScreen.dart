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
      selectedListData: [],
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
            onPressed: openFilterDelegate,
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
                  onPressed: () {},
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
                  onPressed: () {},
                  icon: const Icon(
                    Icons.view_list,
                    size: 24,
                  ),
                )
              ],
            ),
          ),
          Expanded(
            child: ListView(
              children: filteredItems.asMap().entries.map((entry) {
                final index = entry.key;
                final item = entry.value;

                return FavoriteItem(
                    imageUrl: item.imageUrl,
                    title: item.title,
                    brand: item.brand,
                    color: item.color,
                    price: item.price,
                    size: item.size,
                    rating: item.rating,
                    isSoldOut: item.isSoldOut,
                    index: index);
              }).toList(),
            ),
          ),
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
  });

  @override
  Widget build(BuildContext context) {
    final favoriteProvider = Provider.of<Favoriteprovider>(context);
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
            }),
      ),
    );
  }
}
