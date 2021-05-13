import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

import 'package:provider/provider.dart';

import 'package:wasfat_web/models/dish.dart';
import 'package:wasfat_web/providers/add_dish_provider.dart';
import 'package:wasfat_web/widgets/dish_subtitle_widget.dart';
import 'package:wasfat_web/widgets/dish_widgets/confirmation_bar.dart';

class SubtitleEditDialog extends StatelessWidget {
  final Dish dish;
  const SubtitleEditDialog({
    Key? key,
    required this.dish,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final addDishProvider = context.watch<AddDishProvider>();
    final size = context.mediaQuerySize;
    return Dialog(
      child: Container(
        height: size.height * .3,
        child: Column(
          children: [
            Container(child: const DishSubtitle()),
            ConfirmationBar(dish: dish),
          ],
        ),
      ),
    );
  }
}
