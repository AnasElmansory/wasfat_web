import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:wasfat_web/providers/add_dish_provider.dart';
import 'package:wasfat_web/widgets/category_picker.dart';
import 'package:wasfat_web/widgets/dish_description_widget.dart';
import 'package:wasfat_web/widgets/dish_name_widget.dart';
import 'package:wasfat_web/widgets/dish_subtitle_widget.dart';
import 'package:wasfat_web/widgets/image_picker.dart';

class AddDishPage extends StatefulWidget {
  const AddDishPage();

  @override
  _AddDishPageState createState() => _AddDishPageState();
}

class _AddDishPageState extends State<AddDishPage> {
  @override
  void initState() {
    context.read<AddDishProvider>().setDishId = Uuid().v1();
    super.initState();
  }

  @override
  void dispose() {
    context.read<AddDishProvider>().setDishId = null;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add),
          backgroundColor: Colors.amber,
          onPressed: () {
            //todo implement add dish
          }),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(flex: 1, child: const DishName()),
                  Expanded(flex: 1, child: const DishDescription()),
                ],
              ),
            ),
            Expanded(
              flex: 1,
              child: Row(
                children: [
                  Expanded(flex: 1, child: const DishSubtitle()),
                  Expanded(flex: 1, child: const CategoryPicker()),
                ],
              ),
            ),
            Expanded(flex: 1, child: const ImagePicker()),
          ],
        ),
      ),
    );
  }
}
