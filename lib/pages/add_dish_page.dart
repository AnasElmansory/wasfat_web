import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:wasfat_web/providers/add_dish_provider.dart';
import 'package:wasfat_web/providers/images_provider.dart';
import 'package:wasfat_web/widgets/category_picker.dart';
import 'package:wasfat_web/widgets/dish_description_widget.dart';
import 'package:wasfat_web/widgets/dish_ingredients_widget.dart';
import 'package:wasfat_web/widgets/dish_name_widget.dart';
import 'package:wasfat_web/widgets/dish_subtitle_widget.dart';
import 'package:wasfat_web/widgets/image_picker.dart';

class AddDishPage extends StatelessWidget {
  const AddDishPage();

  @override
  Widget build(BuildContext context) {
    final addDishProvider = context.watch<AddDishProvider>();
    final imagesProvider = context.watch<ImagesProvider>();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      addDishProvider.setDishId = Uuid().v1();
    });
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: Colors.amber,
          onPressed: () async {
            await addDishProvider.addDish(
              dishImages: imagesProvider.images.values.toList(),
            );
            imagesProvider.clearLists();
          }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              child: Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: const DishName(),
                  ),
                  const Expanded(
                    flex: 1,
                    child: const DishSubtitle(forEdit: false),
                  ),
                ],
              ),
            ),
            Container(
              child: Row(
                children: [
                  const Expanded(
                    flex: 1,
                    child: const DishIngredients(forEdit: false),
                  ),
                  const Expanded(
                    flex: 1,
                    child: const DishDescription(forEdit: false),
                  ),
                ],
              ),
            ),
            const CategoryPicker(),
            const ImagePicker(forEdit: false),
          ],
        ),
      ),
    );
  }
}
