import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/pages/home_page.dart';
import 'package:wasfat_web/pages/sign_in_page.dart';
import 'package:wasfat_web/providers/auth_provider.dart';

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
