import 'dart:async';

import 'package:get/get.dart';
import 'package:meme_verse/app/core/models/meme_model.dart';
import 'package:meme_verse/app/data/login_credentials.dart';

import '../../../routes/app_pages.dart';

class MemeDetailsController extends GetxController {
   String memeId=''; 
   MemeModel memeModel= MemeModel(); 
  @override
  void onInit() {
   memeModel= Get.arguments;
    super.onInit();
  }

}
