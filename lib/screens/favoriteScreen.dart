import 'package:flutter/material.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({super.key});

  @override
  State<FavoriteScreen> createState() => _FavoriteScreen();
}

class _FavoriteScreen extends State<FavoriteScreen> {
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
          )
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8.0),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  ElevatedButton(onPressed: () {}, child: const Text('Summer')),
                  SizedBox(width: 10),
                  ElevatedButton(
                      onPressed: () {}, child: const Text('T-Shirts')),
                  SizedBox(width: 10),
                  ElevatedButton(onPressed: () {}, child: const Text('Shirts')),
                  SizedBox(width: 10),
                  ElevatedButton(onPressed: () {}, child: const Text('Spring')),
                  SizedBox(width: 10),
                  ElevatedButton(
                      onPressed: () {}, child: const Text('T-Shirts')),
                  SizedBox(width: 10),
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
                Row(
                  children: [
                    Icon(Icons.sort, size: 24),
                    const SizedBox(width: 5),
                    const Text(
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
              children: const [
                FavoriteItem(
                  imageUrl: 'assets/image/3.png',
                  title: 'Shirt',
                  brand: 'LIME',
                  color: 'Blue',
                  price: 32,
                  size: 'L',
                  rating: 4.5,
                  isSoldOut: false,
                ),
                FavoriteItem(
                  imageUrl: 'assets/image/2.png',
                  title: 'Longsleeve Violeta',
                  brand: 'Mango',
                  color: 'Orange',
                  price: 90,
                  size: 'S',
                  rating: 3.0,
                  isSoldOut: false,
                ),
                FavoriteItem(
                  imageUrl: 'assets/image/3.png',
                  title: 'Shirt',
                  brand: 'Olivier',
                  color: 'Gray',
                  price: 89,
                  size: 'L',
                  rating: 4.0,
                  isSoldOut: true,
                ),
                FavoriteItem(
                  imageUrl: 'assets/image/4.png',
                  title: 'Shirt',
                  brand: 'Olivier',
                  color: 'Gray',
                  price: 65,
                  size: 'L',
                  rating: 4.0,
                  isSoldOut: false,
                ),
                FavoriteItem(
                  imageUrl: 'assets/image/5.png',
                  title: 'Shirt',
                  brand: 'Olivier',
                  color: 'Gray',
                  price: 100,
                  size: 'L',
                  rating: 4.0,
                  isSoldOut: true,
                ),
                FavoriteItem(
                  imageUrl: 'assets/image/3.png',
                  title: 'Shirt',
                  brand: 'Olivier',
                  color: 'Gray',
                  price: 80,
                  size: 'L',
                  rating: 4.0,
                  isSoldOut: false,
                ),
              ],
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
  });

  @override
  Widget build(BuildContext context) {
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
            Text('Price: \$${price.toString()}'),
            if (isSoldOut)
              const Text(
                'Sold Out',
                style: TextStyle(color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }
}
