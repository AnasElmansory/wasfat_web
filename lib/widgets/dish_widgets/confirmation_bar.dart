import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/models/dish.dart';
import 'package:wasfat_web/providers/add_dish_provider.dart';

class ConfirmationBar extends StatelessWidget {
  final Dish dish;

  const ConfirmationBar({Key? key, required this.dish}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final addDishProvider = context.watch<AddDishProvider>();

    return Container(
      child: GFButtonBar(
        children: [
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
              Get.back();
            },
          ),
        ],
      ),
    );
  }
}
