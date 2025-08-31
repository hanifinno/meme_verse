import 'dart:async';

import 'package:get/get.dart';
import 'package:meme_verse/app/core/models/meme_model.dart';
import 'package:meme_verse/app/data/login_credentials.dart';

import '../../../routes/app_pages.dart';

class MemeDetailsController extends GetxController {
  // Reactive String
  RxString memeId = ''.obs;

  // Reactive Model
  Rx<MemeModel> memeModel = MemeModel().obs;
  @override
  void onInit() {
    memeModel.value = Get.arguments;
    super.onInit();
  }
}
