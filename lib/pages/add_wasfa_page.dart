import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:wasfat_web/custom_widgets/category_ids_widget.dart';
import 'package:wasfat_web/custom_widgets/dish_name_widget.dart';
import 'package:wasfat_web/custom_widgets/image_picker.dart';
import 'package:wasfat_web/custom_widgets/ingredients_widget.dart';
import 'package:wasfat_web/custom_widgets/steps_widget.dart';
import 'package:wasfat_web/custom_widgets/subtitle_widget.dart';
import 'package:wasfat_web/models/dish.dart';
import 'package:wasfat_web/models/food_category.dart';
import 'package:wasfat_web/providers/add_wasfa_provider.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/providers/categorylist_provider.dart';
import 'package:wasfat_web/providers/images_provider.dart';

class AddWasfaPage extends StatefulWidget {
  final FoodCategory foodCategory;

  const AddWasfaPage({Key key, this.foodCategory}) : super(key: key);
  @override
  _AddWasfaPageState createState() => _AddWasfaPageState();
}

class _AddWasfaPageState extends State<AddWasfaPage> {
  final _nameController = TextEditingController();
  final _subtitleController = TextEditingController();
  final _ingredientsController = TextEditingController();
  final _stepsController = TextEditingController();
  String dishId;
  Dish testDish;

  @override
  void dispose() {
    _nameController.dispose();
    _subtitleController.dispose();
    _ingredientsController.dispose();
    _stepsController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    dishId = Uuid().v1();
    context
        .read<CategoryListProvider>()
        .addIdToCategoryIdsList(widget.foodCategory.id);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dishProvider = context.watch<AddWasfaProvider>();
    final categoryProvider = context.watch<CategoryListProvider>();
    final imagesProvider = context.watch<ImagesProvider>();
    final size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.foodCategory.name),
        centerTitle: true,
        backgroundColor: Colors.amber[700],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            LimitedBox(
              maxHeight: size.height * 0.2,
              child: Row(
                children: [
                  DishName(controller: _nameController),
                  Subtitle(controller: _subtitleController),
                ],
              ),
            ),
            LimitedBox(
              maxHeight: size.height * 0.2,
              child: Row(
                children: [
                  Ingredients(controller: _ingredientsController),
                  StepsWidget(controller: _stepsController),
                ],
              ),
            ),
            ImagePicker(
              category: widget.foodCategory.name,
              dishId: dishId,
            ),
            const CategoryIds(),
          ],
        ),
      ),
      floatingActionButton: IgnorePointer(
        ignoring: dishProvider.updatingDb,
        child: FloatingActionButton(
          backgroundColor: Colors.amber[900],
          child: const Icon(Icons.add),
          onPressed: () async => await dishProvider
              .addDish(
                  id: dishId,
                  dishName: _nameController.text.trim(),
                  dishSubtitle: _subtitleController.text.trim(),
                  dishIngredients: _ingredientsController.text.trim(),
                  dishSteps: _stepsController.text.trim(),
                  categoryIds: categoryProvider.tempCategoryIdsList,
                  dishImages: imagesProvider.images.values.toList())
              .then((_) {
            _nameController.clear();
            _subtitleController.clear();
            _ingredientsController.clear();
            _stepsController.clear();
            categoryProvider.emptyList();
            imagesProvider.emptyLists();
          }),
        ),
      ),
    );
  }
}
