import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:getwidget/getwidget.dart';
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
      height: size.height * 0.5,
      child: Column(
        children: [
          Container(
            height: size.height * 0.2,
            // width: size.width * 0.2,
            child: GFButton(
              text: 'Add Another Category Id',
              onPressed: () async => await showDialog(
                context: context,
                builder: (_) => Dialog(
                  child: ListView.builder(
                    itemCount: categoryList.length,
                    itemBuilder: (context, index) {
                      return GFListTile(
                        onTap: () {
                          categoryProvider
                              .addIdToCategoryIdsList(categoryList[index].id);
                          Get.back();
                        },
                        hoverColor: Colors.black12,
                        title: Text(categoryList[index].name),
                        subTitle: Text(categoryList[index].id),
                        avatar: FadeInImage.assetNetwork(
                          height: size.height * 0.2,
                          width: size.width * 0.2,
                          image: categoryList[index].imageUrl,
                          placeholder: 'assets/placeholder.png',
                          fit: BoxFit.cover,
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: size.height * 0.3,
            // width: size.width * 0.3,
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
