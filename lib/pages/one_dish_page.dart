import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/models/dish.dart';
import 'package:wasfat_web/providers/add_dish_provider.dart';
import 'package:wasfat_web/widgets/custom_bar.dart';
import 'package:wasfat_web/widgets/dish_steps_box.dart';
import 'package:wasfat_web/widgets/dish_subtitle_box.dart';
import 'package:wasfat_web/widgets/dish_widgets/subtitle_edit_dialog.dart';
import 'package:wasfat_web/widgets/image_picker.dart';

class OneDishPage extends StatelessWidget {
  final Dish dish;

  const OneDishPage({Key? key, required this.dish}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    handleDishIdAndCategory(dish);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          DishCustomBar(dish: dish),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                InkWell(
                    onTap: () async {
                      await Get.dialog(SubtitleEditDialog(dish: dish));
                    },
                    child: DishSubtitleBox(subtitle: dish.subtitle ?? '')),
                DishStepsBox(dishDescription: dish.dishDescription),
                const Center(child: const ImagePicker()),
              ],
            ),
          )
        ],
      ),
    );
  }
}

void handleDishIdAndCategory(Dish dish) {
  WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
    final dishProvider = Get.context!.read<AddDishProvider>();
    dishProvider.setDishId = dish.id;
    dishProvider.dishCategories = dish.categoryId;
  });
}
