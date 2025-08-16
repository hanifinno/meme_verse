import 'package:get/get_navigation/src/routes/get_route.dart';
import 'package:meme_verse/app/modules/home/bindings/home_binding.dart';
import 'package:meme_verse/app/modules/home/views/home_view.dart';
import 'package:meme_verse/app/modules/login/bindings/login_binding.dart';
import 'package:meme_verse/app/modules/login/views/login_view.dart';
import 'package:meme_verse/app/modules/splash/bindings/splash_binding.dart';
import 'package:meme_verse/app/modules/splash/views/splash_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH;
  // static const INITIAL = Routes.TEST_BOTTOMSHEET_THEME;

  static final routes = [
    // //Testing Theme
    // //Text Theme
    // GetPage(
    //   name: _Paths.TEST_TEXT_THEME,
    //   page: () => const TestTextThemeScreen(),
    //   binding: TestTextThemeBinding(),
    // ),
    // //PopUp Theme
    // GetPage(
    //   name: _Paths.TEST_POPUP_THEME,
    //   page: () => const PopupMenuTestScreen(),
    //   binding: TestTextThemeBinding(),
    // ),
    // //Bottomsheet Theme
    // GetPage(
    //   name: _Paths.TEST_BOTTOMSHEET_THEME,
    //   page: () => const BottomSheetThemeTestScreen(),
    //   binding: TestTextThemeBinding(),
    // ),
    // //Button Theme
    // GetPage(
    //   name: _Paths.TEST_BUTTON_THEME,
    //   page: () => const TestButtonThemeScreen(),
    //   binding: TestButtonThemeBinding(),
    // ),
    // //Input Theme
    // GetPage(
    //   name: _Paths.TEST_INPUT_THEME,
    //   page: () => const TestInputThemeScreen(),
    //   binding: TestButtonThemeBinding(),
    // ),
    // //SnackBar Theme
    // GetPage(
    //   name: _Paths.TEST_SNACKBAR_THEME,
    //   page: () => const TestSnackBarThemeScreen(),
    //   binding: TestButtonThemeBinding(),
    // ),
    // //Card Theme
    // GetPage(
    //   name: _Paths.TEST_CARD_THEME,
    //   page: () => const TestCardThemeScreen(),
    //   binding: TestButtonThemeBinding(),
    // ),
    // //CheckBox Theme
    // GetPage(
    //   name: _Paths.TEST_CHECKBOX_THEME,
    //   page: () => const CheckboxThemeTestScreen(),
    //   binding: TestButtonThemeBinding(),
    // ),
    // //Tabbar Theme
    // GetPage(
    //   name: _Paths.TEST_TABBAR_THEME,
    //   page: () => const TabBarThemeTestScreen(),
    //   binding: TestButtonThemeBinding(),
    // ),
    // //Date-Time Picker Theme
    // GetPage(
    //   name: _Paths.TEST_DATETIME_THEME,
    //   page: () => const DateTimePickerTestScreen(),
    //   binding: TestButtonThemeBinding(),
    // ),
    //-------------------------------------END THEME SCREENS----------------------------//
    GetPage(
      name: _Paths.SPLASH,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),

    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.LOGIN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),

    // GetPage(
    //   name: _Paths.NOTIFICATION,
    //   page: () => const NotificationView(),
    //   binding: NotificationsBinding(),
    // ),

    // GetPage(
    //   name: _Paths.PROFILE,
    //   page: () => const ProfileView(),
    //   binding: ProfileBinding(),
    // ),

    // GetPage(
    //   name: _Paths.CHANGE_PASSWORD,
    //   page: () => const ChangePasswordView(),
    //   binding: ChangePasswordBinding(),
    // ),
  ];
}
