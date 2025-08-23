import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meme_verse/app/core/theme/color/app_colors.dart';
import 'package:meme_verse/app/modules/home/controllers/home_controller.dart';
import 'package:meme_verse/app/modules/home/views/nav_menu/feed_page.dart';
import 'package:meme_verse/app/modules/home/views/nav_menu/notification_page.dart';
import 'package:meme_verse/app/modules/home/views/nav_menu/profile_page.dart';
import 'package:meme_verse/app/modules/home/views/nav_menu/upload_page.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final List<Widget> _pages = [
    FeedPage(),
    UploadMemePage(),
    NotificationsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: _pages[controller.currentIndex.value],
        bottomNavigationBar: NavigationBar(
          selectedIndex: controller.currentIndex.value,
          onDestinationSelected: (index) => controller.changeTab(index),
          backgroundColor: AppColors.BLACK_COLOR, // #121212
          elevation: 0,
          indicatorColor: AppColors.PRIMARY_COLOR.withOpacity(0.3), // #00FFAA
          labelTextStyle: MaterialStateProperty.all(
            GoogleFonts.poppins(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.WHITE_COLOR,
            ),
          ),
          destinations: [
            NavigationDestination(
              icon: Animate(
                effects: [
                  ScaleEffect(
                    begin: const Offset(0.8, 0.8), // Fixed: Use Offset for uniform scaling
                    end: const Offset(1.0, 1.0),
                    curve: Curves.bounceOut,
                    duration: const Duration(milliseconds: 300),
                  ),
                ],
                child: Icon(Icons.home, color: AppColors.PRIMARY_COLOR),
              ),
              selectedIcon: Icon(Icons.home, color: AppColors.SECONDARY_COLOR),
              label: 'Home',
            ),
            NavigationDestination(
              icon: Animate(
                effects: [
                  ScaleEffect(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    curve: Curves.bounceOut,
                    duration: const Duration(milliseconds: 300),
                  ),
                ],
                child: Icon(Icons.add_box, color: AppColors.PRIMARY_COLOR),
              ),
              selectedIcon: Icon(Icons.add_box, color: AppColors.SECONDARY_COLOR),
              label: 'Upload',
            ),
            NavigationDestination(
              icon: Animate(
                effects: [
                  ScaleEffect(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    curve: Curves.bounceOut,
                    duration: const Duration(milliseconds: 300),
                  ),
                ],
                child: Icon(Icons.notifications, color: AppColors.PRIMARY_COLOR),
              ),
              selectedIcon: Icon(Icons.notifications, color: AppColors.SECONDARY_COLOR),
              label: 'Notifications',
            ),
            NavigationDestination(
              icon: Animate(
                effects: [
                  ScaleEffect(
                    begin: const Offset(0.8, 0.8),
                    end: const Offset(1.0, 1.0),
                    curve: Curves.bounceOut,
                    duration: const Duration(milliseconds: 300),
                  ),
                ],
                child: Icon(Icons.person, color: AppColors.PRIMARY_COLOR),
              ),
              selectedIcon: Icon(Icons.person, color: AppColors.SECONDARY_COLOR),
              label: 'Profile',
            ),
          ],
        ),
      ),
    );
  }
}