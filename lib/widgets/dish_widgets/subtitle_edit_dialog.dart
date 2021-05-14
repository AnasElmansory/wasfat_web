import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast_web.dart';
import 'package:get/get.dart';
import 'package:getwidget/getwidget.dart';

import 'package:provider/provider.dart';

import 'package:wasfat_web/models/dish.dart';
import 'package:wasfat_web/providers/add_dish_provider.dart';
import 'package:wasfat_web/widgets/dish_subtitle_widget.dart';
import 'package:wasfat_web/widgets/dish_widgets/confirmation_bar.dart';

class SubtitleEditField extends StatelessWidget {
  final Dish dish;
  const SubtitleEditField({
    Key? key,
    required this.dish,
  }) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      child: Column(
        children: [
          Container(child: const DishSubtitle(forEdit: true)),
          ConfirmationBar(dish: dish),
        ],
      ),
    );
  }
}
