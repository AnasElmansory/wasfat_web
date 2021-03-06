import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/helper/constants.dart';
import 'package:wasfat_web/providers/add_dish_provider.dart';
import 'package:wasfat_web/providers/edit_dish_provider.dart';

class DishDescription extends StatelessWidget {
  final bool forEdit;
  const DishDescription({Key? key, required this.forEdit}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final addDishProvider = context.watch<AddDishProvider>();
    final editDishProvider = context.watch<EditDishProvider>();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: TextField(
          controller: forEdit
              ? editDishProvider.description
              : addDishProvider.dishDescriptionController,
          maxLength: 5000,
          maxLines: null,
          textAlign: TextAlign.right,
          textDirection: TextDirection.rtl,
          decoration: const InputDecoration(
            border: const OutlineInputBorder(
              borderSide: const BorderSide(
                color: const Color(0xFFFF8000),
              ),
            ),
            suffixText: stepsType2,
            labelText: 'Dish Description',
          ),
        ),
      ),
    );
  }
}
