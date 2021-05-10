import 'package:flutter/material.dart';
import 'package:getwidget/getwidget.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/pages/add_wasfa_page.dart';
import 'package:wasfat_web/providers/categorylist_provider.dart';

class CategoryPage extends StatefulWidget {
  const CategoryPage();
  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  void initState() {
    super.initState();
    context.read<CategoryListProvider>().getFoodCategory();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final categoryProvider = context.watch<CategoryListProvider>();
    final categoryList = categoryProvider.foodCategories.values.toList();
    return Scaffold(
      body: ListView.builder(
        itemCount: categoryProvider.foodCategories.values.length,
        itemBuilder: (context, index) {
          return GFListTile(
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (_) =>
                          AddWasfaPage(foodCategory: categoryList[index])));
            },
            margin: const EdgeInsets.all(0),
            padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
            title: Text(
              categoryList[index].name,
              style: const TextStyle(
                fontSize: 16,
                color: Colors.red,
                fontWeight: FontWeight.bold,
              ),
            ),
            subtitle: Text(
              categoryList[index].id,
            ),
            avatar: Container(
              height: size.height * 0.5,
              width: size.width * 0.4,
              child: FadeInImage.assetNetwork(
                image: categoryList[index].imageUrl,
                placeholder: 'assets/placeholder.png',
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
