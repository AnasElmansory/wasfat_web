import 'dart:async';

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:wasfat_web/firebase/dishes_services.dart';
import 'package:wasfat_web/models/dish.dart';

class DishesProvider extends ChangeNotifier {
  final DishesService _dishesService;
  DishesProvider(this._dishesService);

  final _controller = PagingController<int, Dish>(firstPageKey: 10);
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
        final result = await _dishesService.getDishes(pageSize: pageKey);
        final isLastPage = result.length < 10;
        if (isLastPage)
          this._controller.appendLastPage(result.toSet().toList());
        else
          this._controller.appendPage(result.toSet().toList(), pageKey + 10);
      });
    } catch (error) {
      await FluttertoastWebPlugin().addHtmlToast(msg: '$error');
      this._controller.error = error;
    }
  }

  void refresh() {
    _controller.itemList?.clear();
    this._dishes.clear();
    _controller.nextPageKey = 0;
    _controller.refresh();
  }

  @override
  void dispose() {
    this._controller.dispose();
    _likesSubscription?.cancel();
    SharedPreferences.getInstance().then((value) => value.remove('pageKey'));
    super.dispose();
  }
}
