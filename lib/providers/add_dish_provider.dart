import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:wasfat_web/firebase/dishes_services.dart';
import 'package:wasfat_web/models/dish.dart';
import 'package:wasfat_web/providers/dishes_provider.dart';

class AddDishProvider extends ChangeNotifier {
  final DishesService _dishesService;

  AddDishProvider(this._dishesService);
  final _dishNameController = TextEditingController();
  TextEditingController get dishNameController => this._dishNameController;
  final _dishSubtitleController = TextEditingController();
  TextEditingController get dishSubtitleController =>
      this._dishSubtitleController;
  final _dishIngredientsController = TextEditingController();
  TextEditingController get dishIngredientsController =>
      this._dishIngredientsController;
  final _dishDescriptionController = TextEditingController();
  TextEditingController get dishDescriptionController =>
      this._dishDescriptionController;

  @override
  void dispose() {
    this._dishNameController.dispose();
    this._dishSubtitleController.dispose();
    this._dishDescriptionController.dispose();
    this._dishIngredientsController.dispose();
    super.dispose();
  }

  bool _updatingDb = false;
  bool get updatingDb => _updatingDb;
  set updatingDb(bool value) {
    _updatingDb = value;
    notifyListeners();
  }

  String? _dishId;
  String? get getDishId => this._dishId;
  set setDishId(String? value) {
    this._dishId = value;
    notifyListeners();
  }

  List<String> _dishCategories = [];
  List<String> get dishCategories => this._dishCategories;
  set dishCategories(List<String> value) {
    this._dishCategories = value;
    notifyListeners();
  }

  String? nameValidation(String value) {
    if (value.isEmpty || value.length > 25) return null;
    return value;
  }

  String? subtitleValidation(String value) {
    if (value.isEmpty || value.length > 1500) return null;
    return value;
  }

  String? ingredientsModelingAndValidation(String value) {
    if (value.isEmpty) return null;

    StringBuffer ingredients = StringBuffer("""<h2>المكونات</h2>""");
    String temp = '';
    if (value.contains('المكونات'))
      temp = value.replaceAll('المكونات', "").trim();
    if (value.contains('المقادير'))
      temp = value.replaceAll('المقادير', "").trim();
    temp = value.trim();

    temp.split('\n').forEach((c) => ingredients.write("""<p>$c</p>"""));

    return ingredients.toString();
  }

  String? stepsModelingAndValidation(String value, List<String> images) {
    if (value.isEmpty) return null;

    StringBuffer tempSteps = StringBuffer("""<h2>طريقه التحضير</h2>""");
    String finalSteps = '';
    String temp = '';
    if (value.contains('طريقه التحضير'))
      temp = value.replaceAll('طريقه التحضير', "").trim();
    if (value.contains('طريقة التحضير'))
      temp = value.replaceAll('طريقه التحضير', "").trim();
    if (value.contains('الخطوات'))
      temp = value.replaceAll('الخطوات', "").trim();
    temp = value.trim();

    temp.split('\n').forEach((c) => tempSteps.write("""<p>$c</p>"""));

    images.forEach((image) {
      int index = images.indexOf(image);
      if (index > 0)
        finalSteps = tempSteps
            .toString()
            .replaceAll('image$index', """<img src ="${images[index]}">""");
    });

    return finalSteps.toString();
  }

  String? dishDescriptionFormation(String? ingredients, String? steps) {
    if (ingredients == null || steps == null) return null;
    StringBuffer dishDescription = StringBuffer();
    dishDescription.write("""
    $ingredients 
    \n
    $steps
    """);
    return dishDescription.toString();
  }

  void clearFields() {
    this._dishId = Uuid().v1();
    this._dishNameController.clear();
    this._dishSubtitleController.clear();
    this._dishDescriptionController.clear();
    this._dishIngredientsController.clear();
    this._dishCategories.clear();
  }

  String getIngredientsFromDish(String description) {
    late String ingredients;
    ingredients = description.replaceAll('<p>', '');
    ingredients = ingredients.replaceAll('</p>', '');
    ingredients = ingredients.replaceAll('<h2>', '');
    ingredients = ingredients.replaceAll('</h2>', '');
    ingredients = ingredients.split("طريقة التحضير").first;
    ingredients = ingredients.replaceFirst('المكوّنات', '');
    this.dishIngredientsController.text = ingredients;
    return ingredients;
  }

  Future<void> editDish(Dish dish) async {
    final subtitle = this._dishSubtitleController.text;
    // final ingredients = this._dishIngredientsController.text;
    // final description = this._dishDescriptionController.text;

    final editedDish = dish.copyWith(
      subtitle: subtitle.isNotEmpty ? subtitle : null,
    );
    updateDish(dish, editedDish);
    await _dishesService.editDish(editedDish);
  }

  void updateDish(Dish oldDish, Dish editedDish) {
    final dishesProvider = Get.context!.read<DishesProvider>();
    dishesProvider.dishes.removeWhere((_dish) => _dish.id == oldDish.id);
    dishesProvider.dishes.add(editedDish);
    print(editedDish.subtitle);
    dishesProvider.controller.itemList = dishesProvider.dishes.toList();
    dishesProvider.controller.notifyListeners();
  }

  Future<void> addDish({
    required List<String> dishImages,
  }) async {
    if (_updatingDb) return;
    final name = nameValidation(this._dishNameController.text);
    final subtitle = subtitleValidation(this._dishSubtitleController.text);
    final ingredients =
        ingredientsModelingAndValidation(this._dishIngredientsController.text);
    final steps = stepsModelingAndValidation(
        this._dishDescriptionController.text, dishImages);
    final dishDescription = dishDescriptionFormation(ingredients, steps);
    if (name == null ||
        subtitle == null ||
        ingredients == null ||
        steps == null ||
        dishDescription == null ||
        this._dishCategories.isEmpty ||
        this._dishId == null)
      return await FluttertoastWebPlugin()
          .addHtmlToast(msg: 'fill up all the fields');
    final dish = Dish(
      id: this._dishId!,
      name: name,
      subtitle: subtitle,
      categoryId: this._dishCategories,
      dishDescription: dishDescription,
      addDate: DateTime.now(),
      dishImages: dishImages,
    );

    updatingDb = true;
    await _dishesService.addDish(dish);
    updatingDb = false;
    await FluttertoastWebPlugin().addHtmlToast(msg: 'dish uploaded');
    clearFields();
  }
}
