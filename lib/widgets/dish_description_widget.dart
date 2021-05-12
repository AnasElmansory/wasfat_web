import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/providers/add_dish_provider.dart';

class DishDescription extends StatelessWidget {
  const DishDescription();
  @override
  Widget build(BuildContext context) {
    final addDishProvider = context.watch<AddDishProvider>();
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: TextField(
          controller: addDishProvider.dishDescriptionController,
          maxLength: 5000,
          maxLines: null,
          decoration: const InputDecoration(
            border: const OutlineInputBorder(
              borderSide: const BorderSide(
                color: const Color(0xFFFF8000),
              ),
            ),
            labelText: 'Dish Description',
          ),
        ),
      ),
    );
  }
}