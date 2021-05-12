import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/d_injection.dart';
import 'package:wasfat_web/pages/home_page.dart';
import 'package:wasfat_web/pages/sign_in_page.dart';
import 'package:wasfat_web/providers/add_dish_provider.dart';
import 'package:wasfat_web/providers/auth_provider.dart';
import 'package:wasfat_web/providers/category_provider.dart';
import 'package:wasfat_web/providers/dishes_provider.dart';
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

class UserCheckIdenticator extends StatelessWidget {
  const UserCheckIdenticator();

  void _checkifUserSignedIn(BuildContext context) {
    final auth = context.watch<Auth>();
    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) async {
      final isLoggedIn = await auth.isLoggedIn();
      if (isLoggedIn)
        await _navigateToHomePage();
      else
        await _navigateSignPage();
    });
  }

  @override
  Widget build(BuildContext context) {
    _checkifUserSignedIn(context);
    return Scaffold(
      body: const Center(
        child: const CircularProgressIndicator(),
      ),
    );
  }
}

Future<void> _navigateToHomePage() async {
  await Get.context!.read<Auth>().getUserData();
  await Get.off(() => const HomePage());
}

Future<void> _navigateSignPage() async {
  await Get.off(() => const SignInPage());
}