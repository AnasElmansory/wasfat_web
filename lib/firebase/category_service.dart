import 'package:cloud_firestore/cloud_firestore.dart';

class CategoryService {
  final FirebaseFirestore _firestore;

  const CategoryService(this._firestore);
  Future<List<FoodCategory>> getCategories() async {
    final query = _firestore.;
  }
}
