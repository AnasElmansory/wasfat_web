import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/providers/add_dish_provider.dart';

class DishName extends StatelessWidget {
  const DishName();
  @override
  Widget build(BuildContext context) {
    // final size = context.mediaQuerySize;
    final addDishProvider = context.watch<AddDishProvider>();
    return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        // height: size.height * 0.2,
        // width: size.width * 0.5,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8),
          child: TextField(
            controller: addDishProvider.dishNameController,
            maxLength: 50,
            // maxLines: 1,
            decoration: const InputDecoration(
              border: const OutlineInputBorder(
                borderSide: const BorderSide(
                  color: const Color(0xFFFF8000),
                ),
              ),
              labelText: 'Dish Name',
            ),
          ),
        ));
  }
}
