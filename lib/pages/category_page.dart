import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/helper/constants.dart';
import 'package:wasfat_web/models/food_category.dart';
import 'package:wasfat_web/providers/category_provider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage();
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoriesProvider>().getFoodCategories();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final categoryProvider = context.watch<CategoriesProvider>();
    final categories = categoryProvider.categories;
    return Scaffold(
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GFListTile(
            onTap: () async => await changeCategoryPriorityDialog(category),
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            title: Align(
              alignment: Alignment.centerRight,
              child: Text(
                categories[index].name,
                textAlign: TextAlign.right,
                style: const TextStyle(
                  fontSize: 24,
                  color: Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            subTitle: Align(
              alignment: Alignment.centerRight,
              child: Text(categories[index].id),
            ),
            description: Align(
              alignment: Alignment.centerRight,
              child: Text(
                'priority: ${category.priority}',
                textAlign: TextAlign.right,
              ),
            ),
            avatar: FadeInImage.assetNetwork(
              height: size.height * 0.4,
              width: size.width * 0.3,
              image: corsBridge + categories[index].imageUrl,
              placeholder: 'assets/placeholder.png',
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}

Future<void> changeCategoryPriorityDialog(FoodCategory category) async {
  await Get.dialog(ChangeCategoryPriorityDialog(category: category));
}

class ChangeCategoryPriorityDialog extends StatefulWidget {
  final FoodCategory category;

  const ChangeCategoryPriorityDialog({
    Key? key,
    required this.category,
  }) : super(key: key);
  @override
  _ChangeCategoryPriorityDialogState createState() =>
      _ChangeCategoryPriorityDialogState();
}

class _ChangeCategoryPriorityDialogState
    extends State<ChangeCategoryPriorityDialog> {
  final _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final size = context.mediaQuerySize;
    final categoryProvider = context.watch<CategoriesProvider>();
    return Dialog(
      child: Container(
        constraints: BoxConstraints.loose(Size(size.width * 0.5, size.height)),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16.0),
              child: TextField(
                controller: _controller,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: 'priority',
                ),
              ),
            ),
            GFButton(
              text: 'confirm',
              color: Colors.amber,
              padding: const EdgeInsets.only(bottom: 16),
              onPressed: () async {
                if (_controller.text.isNum)
                  await categoryProvider.updateCategoryPriority(
                    widget.category,
                    int.parse(_controller.text),
                  );
                else
                  await FluttertoastWebPlugin()
                      .addHtmlToast(msg: 'numbers only');

                _controller.clear();
                Get.back();
              },
            ),
          ],
        ),
      ),
    );
  }
}
