import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/SizeChartProvider.dart';

class SizeChart extends StatelessWidget {
  const SizeChart({super.key});

  @override
  Widget build(BuildContext context) {
    final sizeChartProvider = Provider.of<SizeChartProvider>(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Size",
            style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(6, (index) {
              final sizeNames = ["S", "M", "L", "XL", "XXL", "XXXL"];
              return GestureDetector(
                onTap: () {
                  sizeChartProvider.selectSize(index);
                },
                child: _sizeList(
                  index: index,
                  name: sizeNames[index],
                  isSelected: sizeChartProvider.selectedIndex == index,
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _sizeList({
    required int index,
    required String name,
    required bool isSelected,
  }) {
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.only(top: 10, right: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: isSelected ? const Color(0xFFD08835) : const Color(0xFFECC488),
      ),
      child: Text(
        name,
        style: const TextStyle(color: Colors.black),
      ),
    );
  }
}
