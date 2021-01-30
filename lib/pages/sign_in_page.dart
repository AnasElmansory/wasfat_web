import 'package:flutter/material.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';
import 'package:provider/provider.dart';
import 'package:wasfat_web/helper/internet_helper.dart';
import 'package:wasfat_web/pages/home_page.dart';
import 'package:wasfat_web/providers/auth_provider.dart';

class SignInPage extends StatefulWidget {
  const SignInPage();
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final auth = context.watch<Auth>();
    return Scaffold(
      appBar: AppBar(elevation: 0, backgroundColor: Colors.amber[700]),
      backgroundColor: Colors.amber[700],
      body: Container(
        height: size.height * 0.8,
        width: size.width,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(height: 50),
              Expanded(
                flex: 2,
                child: const Text(
                  'Welcome!',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: const Text(
                    'sign in to add wasfat',
                    style: const TextStyle(fontSize: 16, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 50),
              SignInButton(
                Buttons.Google,
                onPressed: () async {
                  if (!await isConnected())
                    return ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: const Text(
                        'no internet connection',
                      ),
                    ));
                  else
                    await auth.signInWithGoogle().then((_) async {
                      if (context.read<Auth>().isLoggedIn)
                        Navigator.of(context).pushReplacement(
                            MaterialPageRoute(builder: (_) => HomePage()));
                    });
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
    );
  }
}
