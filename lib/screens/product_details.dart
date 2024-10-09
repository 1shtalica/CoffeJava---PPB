import 'package:flutter/material.dart';
import '../widget/size.dart';

class product_details extends StatelessWidget {
  // Constructor
  const product_details({Key? key, required this.image}) : super(key: key);
  final String image;

  @override
  Widget build(BuildContext context) {
    int isSeleted = 0;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Container(
          alignment: Alignment.center,
          child: const Text(
            'Judul Halaman',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.black),
            onPressed: () {},
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
            expandedHeight: 600,
            flexibleSpace: FlexibleSpaceBar(
              background: Image(
                image: AssetImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: SizeChart(),
          ),
          SliverToBoxAdapter(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // First Row
                Row(
                  children: const [
                    Expanded(
                      child: Text(
                        "Product Descriptions",
                        style: TextStyle(fontSize: 30),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 50), // Spacing between rows

                // Second Row
                Row(
                  children: const [
                    Expanded(
                      child: Text(
                        "Lorem ipsum odor amet, consectetuer adipiscing elit. Quisque pretium finibus nec, nibh lacinia per. Fames quisque porta pellentesque magna nec lectus. Mi quis purus porttitor ornare dapibus erat platea ullamcorper. Aptent faucibus dictumst tellus mollis rutrum imperdiet nam aliquam. Consectetur platea tempus semper magnis primis sodales. Velit congue consequat sollicitudin mollis etiam luctus fermentum sapien. Senectus nostra curabitur est curabitur placerat.Placerat magnis leo justo facilisis euismod sed commodo. Senectus sit cubilia duis lectus, curae lobortis. Lacus amet tempor non urna congue. Volutpat tellus at scelerisque; praesent imperdiet consequat. Dictum suscipit semper luctus egestas in imperdiet nunc dapibus. Torquent tortor orci sociosqu lacinia sed mollis. Nisl sagittis vitae suscipit donec mus consequat blandit. Bibendum ad enim habitasse ad, aliquam ad.",
                        style: TextStyle(fontSize: 25),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  children: const [
                    Expanded(
                      child: Text(
                        "Lorem ipsum odor amet, consectetuer adipiscing elit. Quisque pretium finibus nec, nibh lacinia per. Fames quisque porta pellentesque magna nec lectus. Mi quis purus porttitor ornare dapibus erat platea ullamcorper. Aptent faucibus dictumst tellus mollis rutrum imperdiet nam aliquam. Consectetur platea tempus semper magnis primis sodales. Velit congue consequat sollicitudin mollis etiam luctus fermentum sapien. Senectus nostra curabitur est curabitur placerat.Placerat magnis leo justo facilisis euismod sed commodo. Senectus sit cubilia duis lectus, curae lobortis. Lacus amet tempor non urna congue. Volutpat tellus at scelerisque; praesent imperdiet consequat. Dictum suscipit semper luctus egestas in imperdiet nunc dapibus. Torquent tortor orci sociosqu lacinia sed mollis. Nisl sagittis vitae suscipit donec mus consequat blandit. Bibendum ad enim habitasse ad, aliquam ad.",
                        style: TextStyle(fontSize: 25),
                        textAlign: TextAlign.justify,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
