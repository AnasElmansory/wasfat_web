import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasfat_web/models/food_category.dart';

class CategoryService {
  final FirebaseFirestore _firestore;

  const CategoryService(this._firestore);
  Future<List<FoodCategory>> getCategories() async {
    final query =
        await _firestore.collection('food_category').orderBy('priority').get();
    final categories = query.docs
        .map<FoodCategory>((category) => FoodCategory.fromMap(category.data()))
        .toList();
    return categories;
  }
}
