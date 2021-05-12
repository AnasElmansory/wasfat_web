import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/helper/constants.dart';
import 'package:wasfat_web/models/dish.dart';
import 'package:wasfat_web/pages/one_dish_page.dart';
import 'package:wasfat_web/providers/category_provider.dart';

class DishWidget extends StatelessWidget {
  final Dish dish;

  const DishWidget({Key? key, required this.dish}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final categoriesProvider = context.watch<CategoriesProvider>();
    final size = context.mediaQuerySize;
    final category = categoriesProvider.categories
        .firstWhere((category) => dish.categoryId.first == category.id);
    final dishImage = dish.dishImages?.first ?? category.imageUrl;
    return GFListTile(
      onTap: () async => await Get.to(OneDishPage(dish: dish)),
      title: Align(
        alignment: Alignment.centerRight,
        child: Text(
          dish.name,
          textDirection: TextDirection.rtl,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.red,
          ),
        ),
      ),
      subTitle: Align(
        alignment: Alignment.centerRight,
        child: Text(
          dish.subtitle ?? '',
          textDirection: TextDirection.rtl,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      avatar: FadeInImage.assetNetwork(
        height: size.height * 0.4,
        width: size.width * 0.3,
        placeholder: 'assets/placeholder.png',
        image: corsBridge + dishImage,
        imageErrorBuilder: (context, error, stackTrace) =>
            Image.asset('assets/placeholder.png'),
        fit: BoxFit.cover,
      ),
    );
  }
}
