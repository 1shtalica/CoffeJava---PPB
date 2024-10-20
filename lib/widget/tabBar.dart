import 'package:flutter/material.dart';

class Tabbar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2, 
      child: Column(
        children: [
        
          TabBar(
            tabs: [
              Tab(
                  text:
                      'Product Information'),
              Tab(text: 'About The Product'),
            ],
            labelColor: Colors.black,
            unselectedLabelColor: Colors.grey,
            indicatorColor: Color(0xFFD08835), 
          ),
          SizedBox(
            height: 200, 
            child: TabBarView(
              children: [
                
                Padding(
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Rincian",
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "SKU:xxxxxxxxx",
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Material: cotton cloth"),
                          SizedBox(
                            height: 5,
                          ),
                          Text("SKU:xxxxxxxxx"),
                          SizedBox(
                            height: 5,
                          ),
                          Text("SKU:xxxxxxxxx"),
                          SizedBox(
                            height: 5,
                          ),
                          Text("category: men's clothing"),
                          Text("SKU:xxxxxxxxx"),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Brand: authentic indonesian"),
                        ],
                      ),
                    )),
                
                Padding(
                    padding: EdgeInsets.all(10),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "About Batik Shirts",
                            style: TextStyle(fontSize: 25),
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text("A Blend of Tradition and Modern Style"),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              "High Quality Material: Soft and breathable cotton"),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Attractive Design: Classic and modern motifs"),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              "Environmentally Friendly: Sustainable production process"),
                          SizedBox(
                            height: 5,
                          ),
                          Text("Various Size and Color Options"),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              "Comfort in Wearing: Suitable for various occasions"),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              "Celebrating Culture: Showcasing the richness of Indonesian culture"),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                              "Guaranteed Quality: Made with attention to detail"),
                          SizedBox(
                            height: 15,
                          ),
                          Text(
                              "The image color is slightly different from the actual product color due to lighting during the photoshoot process.")
                        ],
                      ),
                    ))
              ],
            ),
          ),
        ],
      ),
    );
  }
}
