import 'package:wasfat_web/helper/constants.dart';

String? nameValidation(String value) {
  if (value.isEmpty || value.length > 50) return null;
  return value;
}

String? subtitleValidation(String value) {
  if (value.isEmpty || value.length > 1500) return null;
  return value;
}

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
