import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:filter_list/filter_list.dart';
// import 'package:provider/provider.dart';
import '../api/favorite_service.dart';
import '../models/product_models.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreen();
}

class _FavoriteScreen extends State<FavoriteScreen> {
  List<Product> favoritesItem = [];
  List<Product> filteredItems = [];
  bool isGridView = true;
  final favoriteService _favoriteService = favoriteService();
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadFavorites();
  }

  Future<void> loadFavorites() async {
    try {
      final List<dynamic> favorites = await _favoriteService.fetchFavorites();
      setState(() {
        favoritesItem = favorites
            .map((item) => Product.fromJson(item as Map<String, dynamic>))
            .toList();
        filteredItems = favoritesItem;
        isLoading = false;
      });
    } catch (err) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to load favorites: $err')));
    }
  }

  void removeFavorite(int productId) async {
    try {
      await _favoriteService.deleteFavorites(productId);
      setState(() {
        favoritesItem.removeWhere((product) => product.productId == productId);
        filteredItems.removeWhere((product) => product.productId == productId);
      });
    } catch (err) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to remove favorites: $err')));
    }
  }

  void openFilterDelegate() async {
    final List<String> options =
        favoritesItem.map((item) => item.brand ?? '').toSet().toList();

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
                .where((item) => list.contains(item.brand))
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
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: [
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                filteredItems = favoritesItem
                                    .where((item) =>
                                        item.categories?.any((any) =>
                                            any.categoryName.toLowerCase() ==
                                            'music') ??
                                        false)
                                    .toList();
                              });
                            },
                            child: const Text('Music')),
                        const SizedBox(width: 10),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                filteredItems = favoritesItem
                                    .where((item) =>
                                        item.categories?.any((any) =>
                                            any.categoryName.toLowerCase() ==
                                            'clothing') ??
                                        false)
                                    .toList();
                              });
                            },
                            child: const Text('Clothing')),
                        const SizedBox(width: 10),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                filteredItems = favoritesItem
                                    .where((item) =>
                                        item.categories?.any((any) =>
                                            any.categoryName.toLowerCase() ==
                                            'computers') ??
                                        false)
                                    .toList();
                              });
                            },
                            child: const Text('Computers')),
                        const SizedBox(width: 10),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                filteredItems = favoritesItem
                                    .where((item) =>
                                        item.categories?.any((any) =>
                                            any.categoryName.toLowerCase() ==
                                            'garden') ??
                                        false)
                                    .toList();
                              });
                            },
                            child: const Text('Garden')),
                        const SizedBox(width: 10),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                filteredItems = favoritesItem
                                    .where((item) =>
                                        item.categories?.any((any) =>
                                            any.categoryName.toLowerCase() ==
                                            'beauty') ??
                                        false)
                                    .toList();
                              });
                            },
                            child: const Text('Beauty')),
                        const SizedBox(width: 10),
                        ElevatedButton(
                            onPressed: () {
                              setState(() {
                                filteredItems = favoritesItem
                                    .where((item) =>
                                        item.categories?.any((any) =>
                                            any.categoryName.toLowerCase() ==
                                            'toys') ??
                                        false)
                                    .toList();
                              });
                            },
                            child: const Text('Toys')),
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
                  child: filteredItems.isEmpty
                      ? const Center(
                          child: Text('No Favorites Found'),
                        )
                      : isGridView
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
                                return buildFavoriteItem(item, true);
                              })
                          : ListView.builder(
                              itemCount: filteredItems.length,
                              itemBuilder: (context, index) {
                                final item = filteredItems[index];
                                return buildFavoriteItem(item, false);
                              },
                            ),
                )
              ],
            ),
    );
  }

  Widget buildFavoriteItem(Product item, bool isGridView) {
    if (isGridView) {
      return Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
                flex: 3,
                child: Stack(
                  children: [
                    Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                            image:
                                item.images != null && item.images!.isNotEmpty
                                    ? DecorationImage(
                                        image: NetworkImage(item.images!.first),
                                        fit: BoxFit.cover)
                                    : null),
                        child: item.images == null || item.images!.isEmpty
                            ? Center(child: Text('No Image Available'))
                            : null),
                    Positioned(
                        top: 8,
                        right: 8,
                        child: IconButton(
                            onPressed: () => removeFavorite(item.productId!),
                            icon: const Icon(
                              Icons.favorite,
                              color: Colors.red,
                            )))
                  ],
                )),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.pName ?? '',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 14),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        NumberFormat.currency(locale: 'id', symbol: 'Rp')
                            .format(item.price),
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 12),
                      ),
                      if (item.sale ?? false)
                        Container(
                          margin: const EdgeInsets.only(top: 4),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                              color: Colors.red,
                              borderRadius: BorderRadius.circular(4)),
                          child: const Text(
                            'On Sale',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        )
                    ],
                  ),
                ))
          ],
        ),
      );
    } else {
      return Card(
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
                  'Price: ${NumberFormat.currency(locale: 'id', symbol: 'Rp').format(item.price)}'),
              if (item.sale ?? false)
                const Text(
                  'on Sale',
                  style: TextStyle(color: Colors.red),
                )
            ],
          ),
          trailing: IconButton(
              onPressed: () => removeFavorite(item.productId!),
              icon: const Icon(
                Icons.favorite,
                color: Colors.red,
              )),
        ),
      );
    }
  }
}
