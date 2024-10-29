import 'package:e_nusantara/screens/favoriteScreen.dart';
import 'package:flutter/material.dart';

class Favoriteprovider extends ChangeNotifier {
  List<FavoriteItem> _favoritesItem = [];

  List<FavoriteItem> get favorites => _favoritesItem;

  void AddFavoriteItem(FavoriteItem item) {
    print(item.title);
    _favoritesItem.add(item);
    print(favorites.length);
    notifyListeners();
  }

  void deleteFavoriteItem(int index) {
    print(index);
    _favoritesItem.removeAt(index);

    notifyListeners();
  }
}
