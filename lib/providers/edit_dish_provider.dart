import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/firebase/dishes_services.dart';
import 'package:wasfat_web/helper/constants.dart';
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

  String getSubtitle(String subtitle) {
    this._subtitle.text = subtitle;
    return subtitle;
  }

  Map<DishDishcriptionContents, String> splitIngredientsFromSteps(
    String value,
  ) {
    List<String> values = [];
    final result = Map<DishDishcriptionContents, String>();
    if (value.contains(h2 + stepsType1 + h2Close))
      values = value.split(h2 + stepsType1 + h2Close);
    else if (value.contains(h2 + stepsType2 + h2Close))
      values = value.split(h2 + stepsType2 + h2Close);
    else if (value.contains(h2 + stepsType3 + h2Close))
      values = value.split(h2 + stepsType3 + h2Close);
    else if (value.contains(h2 + stepsType4 + h2Close))
      values = value.split(h2 + stepsType4 + h2Close);
    else if (value.contains(h2 + stepsType5 + h2Close))
      values = value.split(h2 + stepsType5 + h2Close);
    else {
      result[DishDishcriptionContents.Ingredients] = value;
      result[DishDishcriptionContents.Steps] = "";

      return result;
    }
    result[DishDishcriptionContents.Ingredients] = values.first;
    result[DishDishcriptionContents.Steps] = values.last;
    return result;
  }

  String getIngredients(String dishDescription) {
    String ingredients = splitIngredientsFromSteps(
        dishDescription)[DishDishcriptionContents.Ingredients]!;
    ingredients = ingredients.replaceAll(h2Close, '$h2Close' + '\n');
    ingredients = ingredients.replaceAll(pClose, '$pClose' + '\n');
    this._ingredients.text = ingredients;
    return ingredients;
  }

  String getSteps(String dishDescription, List<String> images) {
    String steps = splitIngredientsFromSteps(
        dishDescription)[DishDishcriptionContents.Steps]!;
    steps = steps.replaceAll(h2Close, '$h2Close' + '\n');
    steps = steps.replaceAll(pClose, '$pClose' + '\n');
    late String result;
    if (images.isEmpty)
      result = steps;
    else
      result = getStepsWithoutImages(steps, images);
    this._description.text = result;
    return result;
  }

  String getStepsWithoutImages(String steps, List<String> images) {
    String finalResult = steps;
    for (final image in images) {
      final index = images.indexOf(image);
      finalResult = finalResult.replaceAll(image, 'image$index');
    }
    return finalResult;
  }

  Future<void> editDish(Dish dish) async {
    final subtitle = this._subtitle.text;
    final ingredients = this._ingredients.text;
    final description = this._description.text;
    final steps = stepsModelingAndValidation(description, dish.dishImages);
    final dishDescription = dishDescriptionFormation(ingredients, steps);
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
