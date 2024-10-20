import 'package:flutter/material.dart';

class SizeChartProvider extends ChangeNotifier {
  int _selectedIndex = -1;

  int get selectedIndex => _selectedIndex;

  void selectSize(int index) {
    _selectedIndex = index;
    notifyListeners(); 
  }
}
