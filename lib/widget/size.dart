import 'package:e_nusantara/models/product_models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/SizeChartProvider.dart';

class SizeChart extends StatelessWidget {
  const SizeChart({super.key, required this.stock});
  final List<Stock> stock;

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
            mainAxisAlignment: MainAxisAlignment.start,
            children: List.generate(stock.length, (index) {
              final List<String> sizeNames =
                  stock.map((stockItem) => stockItem.size).toList();
              return GestureDetector(
                onTap: () {
                  if (stock[index].quantity > 0) {
                    sizeChartProvider.selectSize(index);
                  }
                },
                child: _sizeList(
                  index: index,
                  name: sizeNames[index],
                  isSelected: sizeChartProvider.selectedIndex == index,
                  isAvailable: stock[index].quantity > 0,
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
    required bool isAvailable,
  }) {
    return Container(
      width: 40,
      height: 40,
      margin: const EdgeInsets.only(top: 10, right: 10),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: !isAvailable
            ? Colors.grey.shade300 // Warna untuk ukuran yang tidak tersedia
            : isSelected
                ? const Color(0xFFD08835) // Warna untuk ukuran yang dipilih
                : const Color(0xFFECC488), // Warna untuk ukuran lainnya
      ),
      child: Text(
        name,
        style: TextStyle(
          color: !isAvailable
              ? Colors.grey
              : Colors.black, // Teks lebih gelap jika tidak tersedia
        ),
      ),
    );
  }
}
