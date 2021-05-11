import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/helper/constants.dart';
import 'package:wasfat_web/providers/category_provider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage();
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoriesProvider>().getFoodCategories();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final categoryProvider = context.watch<CategoriesProvider>();
    final categories = categoryProvider.categories;
    return Scaffold(
      body: ListView.builder(
        itemCount: categories.length,
        itemBuilder: (context, index) {
          return GFListTile(
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            title: Text(
              categories[index].name,
              textAlign:TextAlign.right,
              style: const TextStyle(
                fontSize: 24,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            subTitleText: categories[index].id,
            avatar: FadeInImage.assetNetwork(
              height: size.height * 0.4,
              width: size.width * 0.3,
              image: corsBridge + categories[index].imageUrl,
              placeholder: 'assets/placeholder.png',
              fit: BoxFit.cover,
            ),
          );
        },
      ),
    );
  }
}
