import 'package:flutter/material.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/models/dish.dart';
import 'package:wasfat_web/providers/dishes_provider.dart';
import 'package:wasfat_web/widgets/dish_widget.dart';
import 'package:wasfat_web/widgets/dishes_search_bar.dart';

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
    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          Positioned.fill(
            top: 64,
            child: PagedListView.separated(
              pagingController: dishesProvider.controller,
              separatorBuilder: (context, index) => const Divider(),
              builderDelegate: PagedChildBuilderDelegate<Dish>(
                itemBuilder: (context, dish, index) {
                  return DishWidget(dish: dish);
                },
              ),
            ),
          ),
          const DishesSearchBar(),
        ],
      ),
    );
  }
}
