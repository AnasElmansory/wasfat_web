import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/get_service.dart';
import 'package:wasfat_web/pages/home_page.dart';
import 'package:wasfat_web/pages/sign_in_page.dart';
import 'package:wasfat_web/providers/add_wasfa_provider.dart';
import 'package:wasfat_web/providers/auth_provider.dart';
import 'package:wasfat_web/providers/categorylist_provider.dart';
import 'package:wasfat_web/providers/images_provider.dart';

class App extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => getIt<Auth>()),
        ChangeNotifierProvider(create: (_) => getIt<CategoryListProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<AddWasfaProvider>()),
        ChangeNotifierProvider(create: (_) => getIt<ImagesProvider>()),
      ],
      child: MaterialApp(
        title: 'وصفات',
        home: UserCheckIdenticator(),
      ),
    );
  }
}

class UserCheckIdenticator extends StatelessWidget {
  void checkifUserSignedIn(BuildContext context) {
    final auth = context.watch<Auth>();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (auth.isLoggedIn)
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => HomePage()));
      else
        Navigator.of(context)
            .pushReplacement(MaterialPageRoute(builder: (_) => SignInPage()));
    });
  }

  @override
  Widget build(BuildContext context) {
    checkifUserSignedIn(context);
    return Scaffold(
        body: const Center(
      child: const CircularProgressIndicator(),
    ));
  }
}
