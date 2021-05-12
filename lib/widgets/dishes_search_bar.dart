import 'package:flutter/material.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/providers/dishes_provider.dart';
import 'package:wasfat_web/widgets/dish_widget.dart';

class DishesSearchBar extends StatefulWidget {
  const DishesSearchBar();
  @override
  _DishesSearchBarState createState() => _DishesSearchBarState();
}

class _DishesSearchBarState extends State<DishesSearchBar> {
  final _controller = FloatingSearchBarController();
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final dishProvider = context.watch<DishesProvider>();
    return FloatingSearchBar(
      controller: _controller,
      onSubmitted: (query) async {
        final result = await dishProvider.searchDish(query);
        print(result.length);
      },
      builder: (context, transition) {
        return Container(
          color: Colors.black.withAlpha(20),
          child: ListView.separated(
            shrinkWrap: true,
            itemCount: dishProvider.searchDishes.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final dish = dishProvider.searchDishes[index];
              return Container(
                color: Colors.white,
                child: DishWidget(dish: dish),
              );
            },
          ),
        );
      },
    );
  }
}
