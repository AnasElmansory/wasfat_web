import 'package:flutter/material.dart';
import 'package:wasfat_web/models/dish.dart';
import 'package:wasfat_web/widgets/dish_description_widget.dart';
import 'package:wasfat_web/widgets/dish_ingredients_widget.dart';
import 'package:wasfat_web/widgets/dish_widgets/confirmation_bar.dart';

class DescriptionEditDialog extends StatelessWidget {
  final Dish dish;

  const DescriptionEditDialog({Key? key, required this.dish}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Dialog(
      child: Container(
        child: Column(
          children: [
            const DishIngredients(),
            const DishDescription(),
            ConfirmationBar(dish: dish),
          ],
        ),
      ),
    );
  }
}
