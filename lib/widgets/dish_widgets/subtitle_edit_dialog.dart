import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/button/gf_button.dart';
import 'package:provider/provider.dart';

import 'package:wasfat_web/models/dish.dart';
import 'package:wasfat_web/providers/add_dish_provider.dart';
import 'package:wasfat_web/providers/dishes_provider.dart';
import 'package:wasfat_web/widgets/dish_subtitle_widget.dart';

class SubtitleEditDialog extends StatelessWidget {
  final Dish dish;
  const SubtitleEditDialog({
    Key? key,
    required this.dish,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final addDishProvider = context.watch<AddDishProvider>();

    return Dialog(
      child: Column(
        children: [
          Container(child: const DishSubtitle()),
          GFButton(
            text: 'cancel',
            onPressed: () => Get.back(),
          ),
          GFButton(
            text: 'edit',
            onPressed: () async {
              await addDishProvider.editDish(dish);
              await FluttertoastWebPlugin().addHtmlToast(
                  msg: 'the update will take place when you reload this dish');
            },
          ),
        ],
      ),
    );
  }
}
