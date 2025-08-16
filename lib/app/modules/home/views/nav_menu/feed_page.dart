import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:meme_verse/app/modules/home/controllers/home_controller.dart';
import 'package:meme_verse/app/modules/home/widgets/meme_tile.dart';

class FeedPage extends GetView<HomeController> {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => RefreshIndicator(
        onRefresh: controller.refreshFeed,
        child: Column(
          children: [
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Meme Feed',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
            ),
            // Wrap ListView with Expanded to give it available space
            Expanded(
              child: ListView.builder(
                itemCount: controller.feedList.length,
                itemBuilder: (context, index) {
                  final meme = controller.feedList[index];
                  return MemeTile(meme: meme);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
