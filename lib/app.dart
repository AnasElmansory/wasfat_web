import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/d_injection.dart';
import 'package:wasfat_web/pages/auth_page.dart';
import 'package:wasfat_web/providers/add_dish_provider.dart';
import 'package:wasfat_web/providers/auth_provider.dart';
import 'package:wasfat_web/providers/category_provider.dart';
import 'package:wasfat_web/providers/dishes_provider.dart';
import 'package:wasfat_web/providers/edit_dish_provider.dart';
import 'package:wasfat_web/providers/images_provider.dart';
import 'package:wasfat_web/providers/page_provider.dart';

class App extends StatelessWidget {
  const App();
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<Auth>()),
        ChangeNotifierProvider(create: (_) => PageProvider()),
        ChangeNotifierProvider(create: (_) => getIt<CategoriesProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<AddDishProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<EditDishProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<DishesProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<ImagesProvider>()),
      ],
      child: GetMaterialApp(
        title: 'وصفات',
        theme: ThemeData(
          appBarTheme: AppBarTheme(
            backgroundColor: Colors.amber[800],
            centerTitle: true,
          ),
        ),
        home: const UserCheckIdenticator(),
      ),
    );
  }
}
