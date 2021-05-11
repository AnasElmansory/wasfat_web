import 'package:get/get.dart';

import 'package:wasfat_web/pages/home_page.dart';
import 'package:wasfat_web/pages/sign_in_page.dart';

Future<void> navigateToHomePage() async {
  Get.off(() => const HomePage());
}

Future<void> navigateToSignPage() async {
  Get.off(() => const SignInPage());
}
