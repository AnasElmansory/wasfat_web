import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:get/get.dart';
import 'package:wasfat_web/helper/internet_helper.dart';
import 'package:wasfat_web/navigation.dart';
import 'package:wasfat_web/providers/auth_provider.dart';

class SignInPage extends StatelessWidget {
  const SignInPage();

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<Auth>();
    final size = context.mediaQuerySize;

    return Scaffold(
      appBar: AppBar(
        title: const Text('wasfat panel'),
        centerTitle: true,
        backgroundColor: Colors.amber[700],
      ),
      backgroundColor: Colors.black.withAlpha(20),
      body: Center(
        child: Container(
          height: size.height * .4,
          width: size.width * .6,
          child: Card(
            child: Column(
              children: [
                const Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: const Text(
                    'Welcome!',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Padding(
                  padding: const EdgeInsets.symmetric(vertical: 24.0),
                  child: const Text(
                    'Sign In To Wasfat Dashboard',
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                SignInButton(
                  Buttons.Google,
                  onPressed: () async {
                    if (!await isConnected())
                      return ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: const Text('no internet connection')),
                      );
                    else {
                      await auth.signInWithGoogle();
                      if (await auth.isLoggedIn()) await navigateToHomePage();
                    }
                  },
                  shape: const RoundedRectangleBorder(
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(10)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
