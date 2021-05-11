import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:wasfat_web/firebase/dishes_services.dart';
import 'package:wasfat_web/models/dish.dart';

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
      this._dishSubtitleController;
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

  String? _category;
  String? get category => this._category;
  set category(String? value) {
    this._category = value;
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

  Future<void> addDish({
    required String id,
    required String dishName,
    required String dishSubtitle,
    required String dishIngredients,
    required String dishSteps,
    required List<String> categoryIds,
    required List<String> dishImages,
  }) async {
    if (_updatingDb) return;
    final name = nameValidation(dishName);
    final subtitle = subtitleValidation(dishSubtitle);
    final ingredients = ingredientsModelingAndValidation(dishIngredients);
    final steps = stepsModelingAndValidation(dishSteps, dishImages);
    final dishDescription = dishDescriptionFormation(ingredients, steps);
    if (name == null ||
        subtitle == null ||
        ingredients == null ||
        steps == null ||
        dishDescription == null)
      return await FluttertoastWebPlugin()
          .addHtmlToast(msg: 'fill up all the fields');
    final dish = Dish(
      id: id,
      name: name,
      subtitle: subtitle,
      categoryId: categoryIds,
      dishDescription: dishDescription,
      addDate: DateTime.now(),
      dishImages: dishImages,
    );
    print(dish.dishDescription);
    updatingDb = true;
    await _dishesService.addDish(dish);
    updatingDb = false;
    await FluttertoastWebPlugin().addHtmlToast(msg: 'dish uploaded');
  }
}
