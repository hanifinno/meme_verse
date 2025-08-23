import 'package:get/get.dart';

import '../controllers/meme_details_controller.dart';

class MemeDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MemeDetailsController>(
      () => MemeDetailsController(),
    );
  }
}
