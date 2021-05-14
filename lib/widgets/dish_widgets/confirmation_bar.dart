import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/models/dish.dart';
import 'package:wasfat_web/providers/edit_dish_provider.dart';

class ConfirmationBar extends StatelessWidget {
  final Dish dish;

  const ConfirmationBar({Key? key, required this.dish}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final editDishProvider = context.watch<EditDishProvider>();

    return Container(
      child: GFButtonBar(
        children: [
          // GFButton(
          //   text: 'cancel',
          //   onPressed: () => Get.back(),
          // ),
          GFButton(
            text: 'edit',
            onPressed: () async {
              await editDishProvider.editDish(dish);
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
