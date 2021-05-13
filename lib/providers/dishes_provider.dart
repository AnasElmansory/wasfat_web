import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:wasfat_web/firebase/dishes_services.dart';
import 'package:wasfat_web/models/dish.dart';

class DishesProvider extends ChangeNotifier {
  final DishesService _dishesService;
  DishesProvider(this._dishesService);

  final _controller = PagingController<int, Dish>(firstPageKey: 1);
  PagingController<int, Dish> get controller => this._controller;

  StreamSubscription<List<String>>? _likesSubscription;

  List<String> _oneDishLikes = [];
  List<String> get oneDishLikes => this._oneDishLikes;
  set oneDishLikes(List<String> value) {
    this._oneDishLikes = value;
    notifyListeners();
  }

  Set<Dish> _dishes = Set();
  Set<Dish> get dishes => this._dishes;
  set dishes(Set<Dish> value) {
    this._dishes.addAll(value);
    notifyListeners();
  }

  List<Dish> _searchDishes = [];
  List<Dish> get searchDishes => this._searchDishes;
  set searchDishes(List<Dish> value) {
    this._searchDishes = value;
    notifyListeners();
  }

  Future<List<Dish>> getDishes({
    int? pageSize,
    int? lastAddDish,
  }) async {
    final result = await _dishesService.getDishes(
      pageSize: pageSize,
      lastAddDish: lastAddDish,
    );
    dishes = result.toSet();
    return dishes.toList();
  }

  Future<void> listenDishLikes(String dishId) async {
    await _likesSubscription?.cancel();
    _likesSubscription = null;
    _likesSubscription = _dishesService
        .listenDishLikes(dishId)
        .listen((likes) => oneDishLikes = likes);
  }

  Future<void> likeDish(String dishId) async {
    await _dishesService.likeDish(dishId);
  }

  Future<void> unlikeDish(String dishId) async {
    await _dishesService.unlikeDish(dishId);
  }

  Future<List<Dish>> searchDish(String query) async {
    final dishes = await _dishesService.searchDish(query);
    searchDishes = dishes;
    return dishes;
  }

  Future<void> handleDishesPagination() async {
    try {
      this._controller.addPageRequestListener((pageKey) async {
        late int lastAddDish;
        if (this._dishes.isNotEmpty)
          lastAddDish = this._dishes.last.addDate.millisecondsSinceEpoch;
        else
          lastAddDish = 0;
        final result = await getDishes(lastAddDish: lastAddDish);
        final isLastPage = dishes.length < 10;
        if (isLastPage)
          this._controller.appendLastPage(result);
        else
          this._controller.appendPage(result, pageKey++);
      });
    } catch (error) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '$error');
      this._controller.error = error;
    }
  }

  @override
  void dispose() {
    this._controller.dispose();
    _likesSubscription?.cancel();
    super.dispose();
  }
}
