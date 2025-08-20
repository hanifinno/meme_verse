// Upload, Notifications, Profile pages can be similar placeholders
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meme_verse/app/modules/home/controllers/home_controller.dart';

class LogoutPage extends GetView<HomeController> {
  @override
  const LogoutPage({super.key});
  @override
  Widget build(BuildContext context) {
    return AlertDialog.adaptive(
      title: const Text('Logout'),
      content: const Text('Are you sure you want to logout?'),
      actions: [
        ElevatedButton(
          onPressed: () {
            controller.signOut();
          },
          child: Text('Logout'),
        ),
        ElevatedButton(
          onPressed: () {
            Get.back();
          },
          child: Text('Cancel'),
        ),
      ],
    );
  }
}
