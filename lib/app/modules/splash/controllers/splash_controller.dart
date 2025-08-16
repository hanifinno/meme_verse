import 'dart:async';

import 'package:get/get.dart';
import 'package:meme_verse/app/data/login_credentials.dart';

import '../../../routes/app_pages.dart';

class SplashController {
  LoginCredential loginCredential = LoginCredential();
  void navigate() async {
    Timer(const Duration(seconds: 3), () {
      if (loginCredential.isUserLoggedIn()) {
        Get.offNamed(Routes.HOME);
      } else {
        Get.offNamed(Routes.LOGIN);
      }
    });
  }
}
