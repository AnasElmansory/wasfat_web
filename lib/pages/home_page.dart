import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/pages/add_dish_page.dart';
import 'package:wasfat_web/pages/category_page.dart';
import 'package:wasfat_web/pages/dishes_page.dart';
import 'package:wasfat_web/providers/page_provider.dart';
import 'package:wasfat_web/widgets/home_side_bar.dart';

class HomePage extends StatelessWidget {
  const HomePage();
  @override
  Widget build(BuildContext context) {
    final pageProvider = context.watch<PageProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text('wasfat pannel'),
      ),
      body: Container(
        child: Row(
          children: [
            Expanded(flex: 1, child: const HomeSideBar()),
            Expanded(
              flex: 3,
              child: PageView(
                controller: pageProvider.controller,
                onPageChanged: (page) => pageProvider.currentPage = page,
                children: [
                  const CategoryPage(),
                  const DishesPage(),
                  const AddDishPage(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
