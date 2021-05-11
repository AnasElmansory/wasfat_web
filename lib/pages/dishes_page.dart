import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/helper/constants.dart';
import 'package:wasfat_web/models/dish.dart';
import 'package:wasfat_web/providers/category_provider.dart';
import 'package:wasfat_web/providers/dishes_provider.dart';

class DishesPage extends StatefulWidget {
  const DishesPage();
  @override
  _DishesPageState createState() => _DishesPageState();
}

class _DishesPageState extends State<DishesPage> {
  @override
  void initState() {
    context.read<DishesProvider>().handleDishesPagination();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final dishesProvider = context.watch<DishesProvider>();
    final categoriesProvider = context.watch<CategoriesProvider>();
    return Scaffold(
      body: PagedListView.separated(
        pagingController: dishesProvider.controller,
        separatorBuilder: (context, index) => const Divider(),
        builderDelegate: PagedChildBuilderDelegate<Dish>(
          itemBuilder: (context, dish, index) {
            final size = context.mediaQuerySize;
            final category = categoriesProvider.categories
                .firstWhere((category) => dish.categoryId.first == category.id);
            final dishImage = dish.dishImages?.first ?? category.imageUrl;
            return GFListTile(
              titleText: dish.name,
              subTitleText: dish.subtitle,
              avatar: FadeInImage.assetNetwork(
                height: size.height * 0.5,
                width: size.width * 0.4,
                placeholder: 'assets/placeholder.png',
                image: corsBridge + dishImage,
                imageErrorBuilder: (context, error, stackTrace) =>
                    Image.asset('assets/placeholder.png'),
                fit: BoxFit.cover,
              ),
            );
          },
        ),
      ),
    );
  }
}
