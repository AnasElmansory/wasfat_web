import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
// import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasfat_web/models/dish.dart';
import 'package:wasfat_web/providers/auth_provider.dart';

class DishesService {
  final FirebaseFirestore _firestore;

  const DishesService(this._firestore);

  Stream<List<String>> listenDishLikes(String dishId) async* {
    final query = _firestore.collection('dishLikes').doc(dishId).snapshots();
    final likes = query.map((event) =>
        List<String>.from(event.data()?['likes'] ?? const <String>[]));
    yield* likes;
  }

  Future<void> likeDish(String dishId) async {
    final userId = Get.context!.read<Auth>().wasfatUser?.uid;
    if (userId == null) return;
    final query = _firestore.collection('dishLikes').doc(dishId);
    await query.set(
      {
        'likes': FieldValue.arrayUnion([userId])
      },
      SetOptions(merge: true),
    );
  }

  Future<void> unlikeDish(String dishId) async {
    final userId = Get.context!.read<Auth>().wasfatUser?.uid;
    if (userId == null) return;
    final query = _firestore.collection('dishLikes').doc(dishId);
    await query.set(
      {
        'likes': FieldValue.arrayRemove([userId])
      },
      SetOptions(merge: true),
    );
  }

  Future<List<Dish>> getDishes({
    required int pageSize,
  }) async {
    final orderQuery =
        _firestore.collection('dishes').orderBy('addDate', descending: true);
    final query = await orderQuery.limit(pageSize).get();
    final docsList = query.docs;
    final dishes = docsList.map<Dish>((dish) {
      return Dish.fromMap(dish.data());
    }).toList();
    return dishes;
  }

  // Future<List<Dish>> getPaginatedDishes({
  //   int? pageSize,
  // }) async {
  //   print('this');
  //   final shared = await SharedPreferences.getInstance();
  //   final pageKey = shared.getInt('pageKey') ?? 0;
  //   final limit = pageSize ?? 10;
  //   final orderQuery =
  //       _firestore.collection('dishes').orderBy('addDate', descending: true);
  //   final query = await orderQuery.startAfter([pageKey]).limit(limit).get();
  //   final docsList = query.docs;
  //   await shared.setInt('pageKey', docsList.last.data()['addDate']);
  //   final dishes = docsList.map<Dish>((dish) {
  //     return Dish.fromMap(dish.data());
  //   }).toList();
  //   return dishes;
  // }

  Future<List<Dish>> searchDish(String query) async {
    final searchQuery = await _firestore
        .collection('dishes')
        .orderBy('name')
        .startAt([query]).endAt([query + '\uf8ff']).get();
    final dishes = searchQuery.docs
        .map<Dish>((dish) => Dish.fromMap(dish.data()))
        .toList();
    return dishes;
  }

  Future<void> addDish(Dish dish) async =>
      await _firestore.collection('dishes').doc(dish.id).set(dish.toMap());

  Future<void> editDish(Dish dish) async =>
      await _firestore.collection('dishes').doc(dish.id).update(dish.toMap());
}
