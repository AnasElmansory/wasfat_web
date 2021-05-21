import 'package:html/parser.dart' as html_parser;
import 'package:html/dom.dart' as dom;

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/firebase/dishes_services.dart';
import 'package:wasfat_web/helper/dish_description_utils.dart';
import 'package:wasfat_web/models/dish.dart';
import 'package:wasfat_web/providers/dishes_provider.dart';

class EditDishProvider extends ChangeNotifier {
  final DishesService _dishesService;

  EditDishProvider(this._dishesService);
  final _subtitle = TextEditingController();
  final _description = TextEditingController();
  final _ingredients = TextEditingController();
  TextEditingController get description => this._description;
  TextEditingController get subtitle => this._subtitle;
  TextEditingController get ingredients => this._ingredients;

  @override
  dispose() {
    this._subtitle.dispose();
    this._description.dispose();
    this._ingredients.dispose();
    super.dispose();
  }

  List<dom.Element> _descriptionElements = [];

  String getSubtitle(String subtitle) {
    this._subtitle.text = subtitle;
    return subtitle;
  }

  void parseDishDescription(String dishDescription, List<String> dishImages) {
    final hasImages = dishImages.isNotEmpty;
    final parsedIngredients = filterIngredientsKeywords(dishDescription);
    final parsedSteps = filterIngredientsKeywords(parsedIngredients);
    final document = html_parser.parseFragment(parsedSteps);
    _descriptionElements = document.children;
    final stepsEndIndex = _descriptionElements.length - 1;
    final ingredientEndIndex = _descriptionElements
        .lastIndexWhere((element) => element.localName == 'h2');
    final ingredientsElements = _descriptionElements.take(ingredientEndIndex);
    final stepsElements = _descriptionElements.getRange(
        ingredientEndIndex + 1, stepsEndIndex + 1);
    final ingredientString = StringBuffer();
    final stepsString = StringBuffer();
    ingredientsElements.forEach((element) {
      final text = element.text;
      if (text.isNotEmpty) ingredientString.writeln(text);
    });
    stepsElements.forEach((element) {
      final text = element.text;
      final imageUrl = element.attributes['src'];
      if (hasImages && imageUrl != null) {
        final imageIndex = dishImages.indexOf(imageUrl);
        stepsString.writeln('image$imageIndex');
      } else if (text.isNotEmpty) stepsString.writeln(text);
    });

    this._ingredients.text = ingredientString.toString();
    this._description.text = stepsString.toString();
  }

  Future<void> editDish(Dish dish) async {
    final subtitle = this._subtitle.text;
    final ingredients = ingredientsToHtml(_ingredients.text);
    final description = stepsToHtml(_description.text, dish.dishImages);
    final dishDescription = makeDishDescription(ingredients, description);
    final editedDish = dish.copyWith(
      subtitle: subtitle.isNotEmpty ? subtitle : null,
      dishDescription: dishDescription,
    );
    updateDish(dish, editedDish);
    await _dishesService.editDish(editedDish);
  }

  void updateDish(Dish oldDish, Dish editedDish) {
    final dishesProvider = Get.context!.read<DishesProvider>();
    dishesProvider.dishes.removeWhere((_dish) => _dish.id == oldDish.id);
    dishesProvider.dishes.add(editedDish);
    dishesProvider.controller.itemList = dishesProvider.dishes.toList();
    dishesProvider.controller.notifyListeners();
  }
}

enum DishDishcriptionContents {
  Ingredients,
  Steps,
}
