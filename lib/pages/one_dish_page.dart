import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/models/dish.dart';
import 'package:wasfat_web/providers/add_dish_provider.dart';
import 'package:wasfat_web/widgets/custom_bar.dart';
import 'package:wasfat_web/widgets/dish_steps_box.dart';
import 'package:wasfat_web/widgets/dish_subtitle_box.dart';
import 'package:wasfat_web/widgets/image_picker.dart';

class OneDishPage extends StatelessWidget {
  final Dish dish;

  const OneDishPage({Key? key, required this.dish}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    handleDishIdAndCategory(dish.id, dish.categoryId);
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          DishCustomBar(dish: dish),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                DishSubtitleBox(subtitle: dish.subtitle ?? ''),
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

void handleDishIdAndCategory(String dishId, List<String> categoryId) {
  WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
    final dishProvider = Get.context!.read<AddDishProvider>();
    dishProvider.setDishId = dishId;
    dishProvider.dishCategories = categoryId;
  });
}
