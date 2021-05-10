import 'package:flutter/material.dart';
import 'package:getwidget/components/list_tile/gf_list_tile.dart';
import 'package:wasfat_web/providers/categorylist_provider.dart';
import 'package:provider/provider.dart';

class CategoryIds extends StatelessWidget {
  const CategoryIds();

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final categoryProvider = context.watch<CategoryListProvider>();
    final categoryList = categoryProvider.foodCategories.values.toList();
    return Container(
      height: size.height * 0.5,
      child: Column(
        children: [
          Container(
            height: size.height * 0.2,
            width: size.width * 0.2,
            child: FlatButton(
              child: const Text('add another categoryId'),
              onPressed: () async => await showDialog(
                context: context,
                builder: (_) => Dialog(
                  child: ListView.builder(
                    itemCount: categoryList.length,
                    itemBuilder: (context, index) => GFListTile(
                      onTap: () {
                        categoryProvider
                            .addIdToCategoryIdsList(categoryList[index].id);
                        Navigator.of(context).pop();
                      },
                      hoverColor: Colors.teal[700],
                      title: Text(categoryList[index].name),
                      subtitle: Text(categoryList[index].id),
                      avatar: Container(
                        height: size.height * 0.2,
                        width: size.width * 0.2,
                        child: FadeInImage.assetNetwork(
                          image: categoryList[index].imageUrl,
                          placeholder: 'assets/placeholder.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Container(
            height: size.height * 0.3,
            width: size.width * 0.3,
            child: Wrap(
              spacing: 8,
              runSpacing: 8,
              alignment: WrapAlignment.center,
              children: categoryProvider.tempCategoryIdsList
                  .map((id) => Chip(
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
