import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wasfat_web/models/dish.dart';
import 'package:wasfat_web/widgets/dish_description_widget.dart';
import 'package:wasfat_web/widgets/dish_ingredients_widget.dart';
import 'package:wasfat_web/widgets/dish_widgets/confirmation_bar.dart';

class DescriptionEditField extends StatelessWidget {
  final Dish dish;

  const DescriptionEditField({Key? key, required this.dish}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: SingleChildScrollView(
        child: Column(
          children: [
            const DishIngredients(forEdit: true),
            const DishDescription(forEdit: true),
            ConfirmationBar(dish: dish),
          ],
        ),
      ),
    );
  }
}
