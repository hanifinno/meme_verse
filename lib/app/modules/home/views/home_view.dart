import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meme_verse/app/modules/home/views/nav_menu/feed_page.dart';
import 'package:meme_verse/app/modules/home/views/nav_menu/notification_page.dart';
import 'package:meme_verse/app/modules/home/views/nav_menu/profile_page.dart';
import 'package:meme_verse/app/modules/home/views/nav_menu/upload_page.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  HomeView({super.key});

  final List<Widget> _pages = [
    FeedPage(),
    UploadPage(),
    NotificationsPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Scaffold(
        body: _pages[controller.currentIndex.value],
        bottomNavigationBar: BottomNavigationBar(
          currentIndex: controller.currentIndex.value,
          onTap: (index) => controller.changeTab(index),
          type: BottomNavigationBarType.fixed,
          items: const [
            BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
            BottomNavigationBarItem(icon: Icon(Icons.add_box), label: 'Upload'),
            BottomNavigationBarItem(
              icon: Icon(Icons.notifications),
              label: 'Notifications',
            ),
            BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          ],
        ),
      ),
    );
  }
}

// // ---------------- Feed Page ----------------
// class FeedPage extends StatelessWidget {
//   FeedPage({super.key});

//   final HomeController controller = Get.find();

//   @override
//   Widget build(BuildContext context) {
//     return Obx(
//       () => RefreshIndicator(
//         onRefresh: controller.refreshFeed,
//         child: ListView.builder(
//           itemCount: controller.feedList.length,
//           itemBuilder: (context, index) {
//             final meme = controller.feedList[index];
//             return MemeTile(meme: meme);
//           },
//         ),
//       ),
//     );
//   }
// }

// // Upload, Notifications, Profile pages can be similar placeholders
// class UploadPage extends StatelessWidget {
//   const UploadPage({super.key});
//   @override
//   Widget build(BuildContext context) =>
//       const Center(child: Text("Upload Page"));
// }

// class NotificationsPage extends StatelessWidget {
//   const NotificationsPage({super.key});
//   @override
//   Widget build(BuildContext context) =>
//       const Center(child: Text("Notifications Page"));
// }

// class ProfilePage extends StatelessWidget {
//   const ProfilePage({super.key});
//   @override
//   Widget build(BuildContext context) =>
//       const Center(child: Text("Profile Page"));
// }
