import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:wasfat_web/models/food_category.dart';

class CategoryListProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;

  CategoryListProvider(this._firestore);

  List<String> _tempCategoryIdList = <String>[];
  List<String> get tempCategoryIdsList => _tempCategoryIdList;
  void addIdToCategoryIdsList(String value) {
    if (!_tempCategoryIdList.contains(value)) _tempCategoryIdList.add(value);
    notifyListeners();
  }

  void removeFromCategoryIdsList(String value) {
    if (_tempCategoryIdList.contains(value)) _tempCategoryIdList.remove(value);
    notifyListeners();
  }

  void emptyList() {
    _tempCategoryIdList.clear();
    notifyListeners();
  }

  var foodCategories = Map<String, FoodCategory>();
  Future<void> getFoodCategory() async {
    final query =
        await _firestore.collection('food_category').orderBy('priority').get();
    if (query.docs.isNotEmpty)
      foodCategories.addEntries(query.docs.map((foodCategory) =>
          MapEntry<String, FoodCategory>(foodCategory.data()['id'],
              FoodCategory.fromMap(foodCategory.data()))));
    notifyListeners();
  }
}
