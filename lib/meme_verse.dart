import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:meme_verse/app/core/config/app_constant.dart';
import 'package:meme_verse/app/core/theme/app_theme.dart';
import 'package:meme_verse/app/core/theme/theme_service/theme_service.dart';
import 'package:meme_verse/app/routes/app_pages.dart';

class MemeVerse extends StatelessWidget {
  const MemeVerse({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => GetMaterialApp(
        debugShowCheckedModeBanner: false,
        title: AppConstant.APP_NAME,
        initialRoute: AppPages.INITIAL,
        getPages: AppPages.routes,
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        themeMode: ThemeService.instance.currentMode.value,

        builder: EasyLoading.init(),
      ),
    );
  }
}
