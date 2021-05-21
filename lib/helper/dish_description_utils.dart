import 'package:wasfat_web/helper/constants.dart';

String? nameValidation(String value) {
  if (value.isEmpty || value.length > 25) return null;
  return value;
}

String? subtitleValidation(String value) {
  if (value.isEmpty || value.length > 1500) return null;
  return value;
}

// String? ingredientsModelingAndValidation(String value) {
//   if (value.isEmpty) return null;

//   StringBuffer ingredients = StringBuffer("""<h2>المكونات</h2>""");
//   String temp = '';
//   if (value.contains('المكونات'))
//     temp = value.replaceAll('المكونات', "").trim();
//   if (value.contains('المقادير'))
//     temp = value.replaceAll('المقادير', "").trim();
//   temp = value.trim();

//   temp.split('\n').forEach((c) => ingredients.write("""<p>$c</p>"""));

//   return ingredients.toString();
// }

// String insertImagesToSteps(String value, List<String> images) {
//   images.forEach((image) {
//     int index = images.indexOf(image);
//     if (index > 0)
//       value = value
//           .toString()
//           .replaceAll('image$index', """<img src ="${images[index]}">""");
//   });
//   return value;
// }

// String? stepsModelingAndValidation(String value, List<String>? images) {
//   if (value.isEmpty) return null;

//   StringBuffer tempSteps = StringBuffer("""<h2>طريقه التحضير</h2>""");
//   String temp = '';
//   late String result;
//   if (value.contains('طريقه التحضير'))
//     temp = value.replaceAll('طريقه التحضير', "").trim();
//   if (value.contains('طريقة التحضير'))
//     temp = value.replaceAll('طريقه التحضير', "").trim();
//   if (value.contains('الخطوات')) temp = value.replaceAll('الخطوات', "").trim();
//   temp = value.trim();

//   temp.split('\n').forEach((c) => tempSteps.write("""<p>$c</p>"""));
//   result = tempSteps.toString();
//   if (images != null)
//     result = insertImagesToSteps(tempSteps.toString(), images);

//   return result;
// }

// String? dishDescriptionFormation(String? ingredients, String? steps) {
//   if (ingredients == null || steps == null) return null;
//   StringBuffer dishDescription = StringBuffer();
//   dishDescription.write("""
//     $ingredients
//     \n
//     $steps
//     """);
//   return dishDescription.toString();
// }

String filterIngredientsKeywords(String from) {
  if (from.contains(ingredientsType1))
    from = from.replaceAll(h2 + ingredientsType1 + h2Close, '');
  else if (from.contains(ingredientsType2))
    from = from.replaceAll(h2 + ingredientsType2 + h2Close, '');
  else if (from.contains(ingredientsType3))
    from = from.replaceAll(h2 + ingredientsType3 + h2Close, '');
  return from;
}

String filterStepsKeywords(String from) {
  if (from.contains(stepsType1))
    from = from.replaceAll(h2 + stepsType1 + h2Close, '');
  else if (from.contains(stepsType2))
    from = from.replaceAll(h2 + stepsType2 + h2Close, '');
  else if (from.contains(stepsType3))
    from = from.replaceAll(h2 + stepsType3 + h2Close, '');
  else if (from.contains(stepsType4))
    from = from.replaceAll(h2 + stepsType4 + h2Close, '');
  return from;
}

String ingredientsToHtml(String ingredients) {
  final html = StringBuffer("<h2>$ingredientsType3</h2>\n");
  ingredients.trim();
  final filteredIngredients = filterIngredientsKeywords(ingredients);
  final ingredientsList = filteredIngredients.split('\n');
  ingredientsList.forEach((ingredient) {
    if (ingredient.isNotEmpty) html.writeln("<p>$ingredient</p>");
  });
  return html.toString();
}

String stepsToHtml(String steps, List<String>? dishImages) {
  final html = StringBuffer("<h2>$stepsType2</h2>\n");
  steps.trim();
  final filteredsteps = filterStepsKeywords(steps);
  final stepsList = filteredsteps.split('\n');
  stepsList.forEach((step) {
    step.trim();
    if (step == ' ')
      return;
    else if (dishImages != null && step.contains('image')) {
      print(step[5]);
      final imageIndex = int.parse(step[5]);
      html.writeln('<img src = ${dishImages[imageIndex]}>');
    } else if (step.isNotEmpty) html.writeln("<p>$step</p>");
  });
  return html.toString();
}

String makeDishDescription(String ingredients, String steps) {
  return ingredients + '\n' + steps;
}
