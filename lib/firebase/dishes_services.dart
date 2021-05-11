import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:wasfat_web/models/dish.dart';

class DishesService {
  final FirebaseFirestore _firestore;

  const DishesService(this._firestore);

  Future<List<Dish>> getDishes({
    int? page,
    int? pageSize,
    int? lastAddDish,
  }) async {
    final _page = page ?? 1;
    final limit = pageSize ?? 10;
    final skip = (_page - 1) * limit;
    final orderQuery = _firestore.collection('dishes').orderBy('addDate');
    final query = await orderQuery.startAfter([lastAddDish]).limit(limit).get();
    final dishes =
        query.docs.map<Dish>((dish) => Dish.fromMap(dish.data())).toList();
    return dishes;
  }

  Future<List<Dish>> searchDish(String query) async {
    final searchQuery = await _firestore
        .collection('dishes')
        .startAt([query]).endAt([query + '\uf8ff']).get();
    final dishes = searchQuery.docs
        .map<Dish>((dish) => Dish.fromMap(dish.data()))
        .toList();
    return dishes;
  }

  Future<void> addDish(Dish dish) async =>
      await _firestore.collection('dishes').doc(dish.id).set(dish.toMap());
}
