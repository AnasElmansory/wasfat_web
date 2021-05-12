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
    int? page,
    int? pageSize,
    int? lastAddDish,
  }) async {
    final result = await _dishesService.getDishes(
      page: page,
      pageSize: pageSize,
      lastAddDish: lastAddDish,
    );
    dishes = result.toSet();
    return result;
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
        final result = await getDishes(page: pageKey, lastAddDish: lastAddDish);
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
    super.dispose();
  }
}
