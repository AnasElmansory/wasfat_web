import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/models/dish.dart';
import 'package:wasfat_web/providers/add_dish_provider.dart';
import 'package:wasfat_web/providers/edit_dish_provider.dart';
import 'package:wasfat_web/widgets/custom_bar.dart';
import 'package:wasfat_web/widgets/dish_steps_box.dart';
import 'package:wasfat_web/widgets/dish_subtitle_box.dart';
import 'package:wasfat_web/widgets/dish_widgets/description_edit_dialog.dart';
import 'package:wasfat_web/widgets/dish_widgets/subtitle_edit_dialog.dart';
import 'package:wasfat_web/widgets/image_picker.dart';

class OneDishPage extends StatefulWidget {
  final Dish dish;

  const OneDishPage({Key? key, required this.dish}) : super(key: key);

  @override
  _OneDishPageState createState() => _OneDishPageState();
}

class _OneDishPageState extends State<OneDishPage> {
  Dish get dish => widget.dish;

  @override
  void initState() {
    final editProvider = context.read<EditDishProvider>();
    final containsImages = dish.dishImages?.isNotEmpty ?? false;
    editProvider.getSubtitle(dish.subtitle ?? '');
    editProvider.getIngredients(dish.dishDescription);
    editProvider.getSteps(
      dish.dishDescription,
      containsImages ? dish.dishImages! : const <String>[],
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    handleDishIdAndCategory(dish);
    return Scaffold(
      appBar: AppBar(
        title: const Text('edit dish'),
      ),
      body: Row(
        children: [
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.amber),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      DishCustomBar(dish: dish),
                      DishSubtitleBox(subtitle: dish.subtitle ?? ''),
                      DishStepsBox(dishDescription: dish.dishDescription),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    SubtitleEditField(dish: dish),
                    DescriptionEditField(dish: dish),
                    Center(
                      child: ImagePicker(
                        forEdit: true,
                        dishImages: dish.dishImages ?? const <String>[],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

void handleDishIdAndCategory(Dish dish) {
  WidgetsBinding.instance?.addPostFrameCallback((_) {
    final dishProvider = Get.context!.read<AddDishProvider>();
    dishProvider.setDishId = dish.id;
    dishProvider.dishCategories = dish.categoryId;
  });
}
