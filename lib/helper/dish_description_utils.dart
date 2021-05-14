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

String? insertImagesToSteps(String value, List<String> images) {
  images.forEach((image) {
    int index = images.indexOf(image);
    if (index > 0)
      value = value
          .toString()
          .replaceAll('image$index', """<img src ="${images[index]}">""");
  });
  return value;
}

String? stepsModelingAndValidation(String value, List<String>? images) {
  if (value.isEmpty) return null;

  StringBuffer tempSteps = StringBuffer("""<h2>طريقه التحضير</h2>""");
  String temp = '';
  late String result;
  if (value.contains('طريقه التحضير'))
    temp = value.replaceAll('طريقه التحضير', "").trim();
  if (value.contains('طريقة التحضير'))
    temp = value.replaceAll('طريقه التحضير', "").trim();
  if (value.contains('الخطوات')) temp = value.replaceAll('الخطوات', "").trim();
  temp = value.trim();

  temp.split('\n').forEach((c) => tempSteps.write("""<p>$c</p>"""));
  result = tempSteps.toString();
  if (images != null)
    result = insertImagesToSteps(tempSteps.toString(), images) ?? '';

  return result;
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
