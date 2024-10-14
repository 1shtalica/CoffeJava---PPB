import 'package:flutter/material.dart';

class SizeChart extends StatefulWidget {
  @override
  _SizeChartState createState() => _SizeChartState();
}

class _SizeChartState extends State<SizeChart> {
  int isSelected = -1; // Initially no size is selected

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Size",
            style: TextStyle(
              fontSize: 27,
              fontWeight: FontWeight.bold,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSelected = 0; // Update selected index
                  });
                  print("Size S tapped");
                },
                child: _sizeList(index: 0, name: "S"),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSelected = 1; // Update selected index
                  });
                  print("Size M tapped");
                },
                child: _sizeList(index: 1, name: "M"),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSelected = 2; // Update selected index
                  });
                  print("Size L tapped");
                },
                child: _sizeList(index: 2, name: "L"),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSelected = 3; // Update selected index
                  });
                  print("Size XL tapped");
                },
                child: _sizeList(index: 3, name: "XL"),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSelected = 4; // Update selected index
                  });
                  print("Size XXL tapped");
                },
                child: _sizeList(index: 4, name: "XXL"),
              ),
              GestureDetector(
                onTap: () {
                  setState(() {
                    isSelected = 5; // Update selected index
                  });
                  print("Size XXXL tapped");
                },
                child: _sizeList(index: 5, name: "XXXL"),
              ),
            ],
          )
        ],
      ),
    );
  }

  Widget _sizeList({required int index, required String name}) {
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.only(top: 10, right: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isSelected == index
            ? Color.fromARGB(255, 243, 227, 209)
            : Color(0xFFDDA86B), // Change color based on selection
      ),
      child: Text(
        name, // Display the name inside the container
        style: TextStyle(color: Colors.black), // Style the text
        
      ),
    );
  }
}
