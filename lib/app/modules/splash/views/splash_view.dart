import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meme_verse/app/core/theme/color/app_colors.dart';

import '../../../core/config/app_assets.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.navigate();
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SizedBox(
          height: double.maxFinite,
          width: double.maxFinite,
          child: Stack(
            alignment: AlignmentDirectional.topCenter,
            children: [
              Positioned(
                top: Get.height / 5,
                child: Image(
                  fit: BoxFit.contain,
                  height: MediaQuery.of(context).size.height / 10,
                  image: AssetImage(AppAssets.APP_TRANSPARENT_LOGO),
                ),
              ),
              Positioned(
                top: Get.height / 1.8,
                child: Stack(
                  children: [
                    Image.asset(
                      AppAssets.LOADER_CIRCLE,
                      width: 100,
                      height: 100,
                      fit: BoxFit.fill,
                    ),
                    SizedBox(
                      width: 100,
                      height: 100,
                      child: Center(
                        child: Image.asset(
                          AppAssets.MASK_ICON,
                          height: 40,
                          width: 40,
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Positioned(
                bottom: Get.height / 20,
                child: Column(
                  children: [
                    Text(
                      'Powered by',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: AppColors.WHITE_COLOR),
                    ),
                    ShaderMask(
                      blendMode: BlendMode.srcIn,
                      shaderCallback: (bounds) =>
                          AppColors.PRIMARY_GRADIENT.createShader(
                            Rect.fromLTWH(0, 0, bounds.width, bounds.height),
                          ),
                      child: Text(
                        'Hanif Uddin',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: AppColors.WHITE_COLOR,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
