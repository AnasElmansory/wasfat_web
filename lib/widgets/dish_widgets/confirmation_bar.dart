import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/models/dish.dart';
import 'package:wasfat_web/providers/edit_dish_provider.dart';
import 'package:wasfat_web/providers/images_provider.dart';

class ConfirmationBar extends StatelessWidget {
  final Dish dish;

  const ConfirmationBar({Key? key, required this.dish}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final editDishProvider = context.watch<EditDishProvider>();
    final imageProvider = context.watch<ImagesProvider>();
    return Container(
      child: GFButtonBar(
        children: [
          GFButton(
            text: 'edit',
            onPressed: () async {
              List<String> dishImages = [];
              if (dish.dishImages != null) dishImages.addAll(dish.dishImages!);
              dishImages.addAll(imageProvider.images.values);
              await editDishProvider
                  .editDish(dish.copyWith(dishImages: dishImages));
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
