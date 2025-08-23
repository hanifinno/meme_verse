import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:meme_verse/app/core/config/app_assets.dart';
import 'package:meme_verse/app/core/theme/color/app_colors.dart';

void showLoader() {
  EasyLoading.show();
}

void configLoader() {
  EasyLoading.instance
    ..loadingStyle = EasyLoadingStyle.custom
    ..backgroundColor = Colors.transparent
    ..indicatorColor = AppColors.TRANSPARENT
    ..textColor = Colors.transparent
    ..boxShadow = []
    ..indicatorWidget = Stack(
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
              AppAssets.APP_TRANSPARENT_LOGO,
              height: 40,
              width: 40,
              fit: BoxFit.fill,
            ),
          ),
        ),
      ],
    );
}

void dismissLoader() {
  EasyLoading.dismiss();
}
