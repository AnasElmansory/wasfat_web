import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/getwidget.dart';
import 'package:wasfat_web/helper/constants.dart';
import 'package:wasfat_web/models/food_category.dart';
import 'package:wasfat_web/providers/add_dish_provider.dart';
import 'package:wasfat_web/providers/category_provider.dart';
import 'package:provider/provider.dart';

class CategoryPicker extends StatelessWidget {
  const CategoryPicker();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final categoryProvider = context.watch<CategoriesProvider>();
    final categoryList = categoryProvider.categories;
    return Container(
      child: Column(
        children: [
          Container(
            child: GFButton(
              text: 'Add Category Id',
              onPressed: () async {
                final categoriesIds = await showDialog<List<String>>(
                  context: context,
                  builder: (_) => Dialog(
                    child: ListView.builder(
                      itemCount: categoryList.length,
                      itemBuilder: (context, index) {
                        return GFListTile(
                          onTap: () {
                            categoryProvider
                                .addIdToCategoryIdsList(categoryList[index].id);
                            Get.back(
                                result: categoryProvider.tempCategoryIdsList);
                          },
                          hoverColor: Colors.black12,
                          title: Text(categoryList[index].name),
                          subTitle: Text(categoryList[index].id),
                          avatar: FadeInImage.assetNetwork(
                            height: size.height * 0.2,
                            width: size.width * 0.2,
                            image: corsBridge + categoryList[index].imageUrl,
                            placeholder: 'assets/placeholder.png',
                            fit: BoxFit.cover,
                          ),
                        );
                      },
                    ),
                  ),
                );
                context.read<AddDishProvider>().dishCategories =
                    categoriesIds ?? const <String>[];
              },
            ),
          ),
          Container(
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: categoryProvider.tempCategoryIdsList
                  .map<Widget>((id) => Chip(
                        label: Text(id),
                        onDeleted: () =>
                            categoryProvider.removeFromCategoryIdsList(id),
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
