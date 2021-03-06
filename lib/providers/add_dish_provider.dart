import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:uuid/uuid.dart';
import 'package:wasfat_web/firebase/dishes_services.dart';
import 'package:wasfat_web/helper/dish_description_utils.dart';
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

  void clearFields() {
    this._dishId = Uuid().v1();
    this._dishNameController.clear();
    this._dishSubtitleController.clear();
    this._dishDescriptionController.clear();
    this._dishIngredientsController.clear();
    this._dishCategories.clear();
  }

  Future<void> addDish({
    required List<String> dishImages,
  }) async {
    if (_updatingDb) return;
    final name = nameValidation(this._dishNameController.text);
    final subtitle = subtitleValidation(this._dishSubtitleController.text);
    final ingredients = ingredientsToHtml(this._dishIngredientsController.text);
    final steps = stepsToHtml(this._dishDescriptionController.text, dishImages);
    final dishDescription = makeDishDescription(ingredients, steps);

    if (name == null ||
        subtitle == null ||
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
