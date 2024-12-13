import 'package:e_nusantara/screens/orders.dart';
import 'package:flutter/material.dart';

class MyShopWidget extends StatefulWidget {
  const MyShopWidget({super.key});

  @override
  State<MyShopWidget> createState() => _MyShopWidgetState();
}

class _MyShopWidgetState extends State<MyShopWidget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
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
              title: Text("Shop"),
              centerTitle: true,
            ),
            actions: [IconButton(onPressed: () {}, icon: Icon(Icons.search))],
          ),
          SliverPersistentHeader(
            delegate: FilterListDelegate(
              maxExtent: 100,
              minExtent: 50,
            ),
            pinned: true,
          ),
          SliverList(
              delegate: SliverChildBuilderDelegate((Builder, index) {
            return Container(
              height: 100,
              child: Center(
                child: Text("item $index"),
              ),
              decoration: BoxDecoration(color: Colors.amber[100 * (index % 9)]),
            );
          }, childCount: 25))
        ],
      ),
    );
  }
}

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
                      onPressed: () {},
                      child: Text("Category"),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: TextButton(
                      onPressed: () {},
                      child: Text("SubCategory"),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: TextButton(
                      onPressed: () {},
                      child: Text("SpecificCategory"),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: TextButton(
                      onPressed: () {},
                      child: Text("Location"),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: TextButton(
                      onPressed: () {},
                      child: Text("Brand"),
                    )),
                Container(
                    margin: EdgeInsets.symmetric(horizontal: 10),
                    child: TextButton(
                      onPressed: () {},
                      child: Text("Price"),
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
