import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:wasfat_web/models/dish.dart';

class AddWasfaProvider extends ChangeNotifier {
  final FirebaseFirestore _firestore;

  AddWasfaProvider(this._firestore);

  bool _updatingDb = false;
  bool get updatingDb => _updatingDb;
  set updatingDb(bool value) {
    _updatingDb = value;
    notifyListeners();
  }

  String nameValidation(String value) {
    if (value.isEmpty || value.length > 25) return null;
    return value;
  }

  String subtitleValidation(String value) {
    if (value.isEmpty || value.length > 1500) return null;
    return value;
  }

  String ingredientsModelingAndValidation(String value) {
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

  String stepsModelingAndValidation(String value, List<String> images) {
    if (value.isEmpty) return null;

    StringBuffer tempSteps = StringBuffer("""<h2>طريقه التحضير</h2>""");
    String finalSteps = """""";
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
            .replaceAll('i', """<img src ="${images[index]}">""");
    });

    return finalSteps.toString();
  }

  String dishDescriptionFormation(String ingredients, String steps) {
    StringBuffer dishDescription = StringBuffer();
    dishDescription.write("""
    $ingredients
    $steps
    """);
    return dishDescription.toString();
  }

  Future<void> addDish({
    @required String id,
    @required String dishName,
    @required String dishSubtitle,
    @required String dishIngredients,
    @required String dishSteps,
    @required List<String> categoryIds,
    @required List<String> dishImages,
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
      return Fluttertoast.showToast(msg: 'fill up all the fields');
    final dish = Dish(
      id: id,
      name: name,
      subtitle: subtitle,
      categoryId: categoryIds,
      dishDescription: dishDescription,
      addDate: DateTime.now(),
      dishImages: dishImages,
    );
    updatingDb = true;
    await _firestore
        .collection('dishes')
        .doc(dish.id)
        .set(dish.toMap())
        .then((_) async {
      updatingDb = false;
      await Fluttertoast.showToast(msg: 'dish uploaded');
    });
  }
}
