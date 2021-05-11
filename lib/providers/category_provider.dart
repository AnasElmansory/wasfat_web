import 'package:flutter/material.dart';
import 'package:wasfat_web/firebase/category_service.dart';
import 'package:wasfat_web/models/food_category.dart';

class CategoriesProvider extends ChangeNotifier {
  final CategoryService _categoryService;

  CategoriesProvider(this._categoryService);

  List<String> _tempCategoryIdList = <String>[];
  List<String> get tempCategoryIdsList => this._tempCategoryIdList;
  void addIdToCategoryIdsList(String value) {
    if (!this._tempCategoryIdList.contains(value))
      this._tempCategoryIdList.add(value);
    notifyListeners();
  }

  List<FoodCategory> _categories = [];
  List<FoodCategory> get categories => this._categories;
  set categories(List<FoodCategory> value) {
    this._categories = value;
    notifyListeners();
  }

  void removeFromCategoryIdsList(String value) {
    if (this._tempCategoryIdList.contains(value))
      this._tempCategoryIdList.remove(value);
    notifyListeners();
  }

  void clearList() {
    _tempCategoryIdList.clear();
    notifyListeners();
  }

  Future<void> getFoodCategories() async {
    final result = await _categoryService.getCategories();
    categories = result;
  }
}
