import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:http/http.dart' as http;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:meme_verse/app/core/models/meme_model.dart';
import 'package:meme_verse/app/core/theme/color/app_colors.dart';
import 'package:meme_verse/app/core/widgets/custom_widgets.dart';
import 'package:meme_verse/app/modules/home/controllers/home_controller.dart';

class FeedPage extends GetView<HomeController> {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: AppColors.BLACK_COLOR, // #121212
        appBar: AppBar(
          backgroundColor: AppColors.BLACK_COLOR,
          title: Text(
            'Meme Verse',
            style: GoogleFonts.poppins(
              fontSize: 24,
              fontWeight: FontWeight.w600,
              color: AppColors.WHITE_COLOR,
            ),
          ),
          // bottom: TabBar(
          //   labelStyle: GoogleFonts.poppins(
          //     fontSize: 16,
          //     fontWeight: FontWeight.w500,
          //     color: AppColors.PRIMARY_COLOR, // #00FFAA
          //   ),
          //   unselectedLabelStyle: GoogleFonts.poppins(
          //     fontSize: 16,
          //     fontWeight: FontWeight.w500,
          //     color: AppColors.GREY_TEXT_COLOR,
          //   ),
          //   indicatorColor: AppColors.SECONDARY_COLOR, // #FF2D55
          //   tabs: const [
          //     Tab(text: 'For You'),
          //     Tab(text: 'Trending'),
          //   ],
          // ).animate().fadeIn(duration: const Duration(milliseconds: 500)),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: AppColors.PRIMARY_COLOR,
          onPressed: () => Get.toNamed('/upload'), // Navigate to UploadMemePage
          child: const Icon(Icons.add, color: AppColors.BUTTON_TEXT_COLOR),
        ).animate().scale(
              begin: const Offset(0.8, 0.8),
              end: const Offset(1.0, 1.0),
              curve: Curves.bounceOut,
              duration: const Duration(milliseconds: 300),
            ),
        body: TabBarView(
          children: [
            _buildForYouTab(),
            _buildTrendingTab(),
          ],
        ),
      ),
    );
  }

 Widget _buildForYouTab() {
  return  RefreshIndicator(
      onRefresh: () async {
        await controller.refreshFeed();
        await controller.fetchRecommendations();
      },
      color: AppColors.PRIMARY_COLOR,
      backgroundColor: AppColors.BLACK_COLOR,
      child: Column(
        children: [
          // AI Recommendations
          Obx(() {
            final recommendations = controller.recommendations;
            if (controller.isLoading.value && recommendations.isEmpty) {
              return SizedBox(
                height: 100,
                child: Center(child: CustomWidgets.customLottieLoader()),
              );
            }
            if (recommendations.isEmpty) {
              return SizedBox(
                height: 100,
                child: Center(
                  child: Text(
                    'No recommendations yet',
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      color: AppColors.GREY_TEXT_COLOR,
                    ),
                  ),
                ),
              );
            }
            return SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 8),
                itemCount: recommendations.length,
                itemBuilder: (context, index) {
                  final recommendation = recommendations[index];
                  return Padding(
                    padding: const EdgeInsets.all(8),
                    child: GestureDetector(
                      onTap: () => Get.toNamed(
                        '/meme-detail',
                        arguments: recommendation['id'],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: AppColors.PRIMARY_COLOR,
                              width: 2,
                            ),
                          ),
                          child: Image.network(
                            recommendation['imageUrl'] ?? '',
                            width: 100,
                            height: 80,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) =>
                                const Icon(
                              Icons.broken_image,
                              color: AppColors.RED_COLOR,
                              size: 50,
                            ),
                          ),
                        ),
                      ).animate().fadeIn().scale(
                            begin: const Offset(0.8, 0.8),
                            end: const Offset(1.0, 1.0),
                            curve: Curves.bounceOut,
                          ),
                    ),
                  );
                },
              ),
            );
          }),
          // Meme Feed
          Expanded(
            child: _buildMemeList(controller.feedList, false),
          ),
        ],
      ),
    )
  ;
}

  Widget _buildTrendingTab() {
    return Obx(
      () => RefreshIndicator(
        onRefresh: controller.refreshTrending,
        color: AppColors.PRIMARY_COLOR,
        backgroundColor: AppColors.BLACK_COLOR,
        child: _buildMemeList(controller.trendingList, true),
      ),
    );
  }

 Widget _buildMemeList(RxList<MemeModel> memeList, bool isTrending) {
  return Obx(() {
    if (memeList.isEmpty) {
      return Center(
        child: Text(
          'No memes found',
          style: GoogleFonts.poppins(
            fontSize: 16,
            color: AppColors.WHITE_COLOR,
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: memeList.length,
      itemBuilder: (context, index) {
        final meme = memeList[index];
        return Padding(
          padding: const EdgeInsets.only(bottom: 16),
          child: CustomWidgets.customMemeCard(
            imageUrl: meme.imageUrl ?? '',
            caption: meme.title ?? '',
            isTrending: isTrending,
            onTap: () => Get.toNamed('/meme-detail', arguments: meme.id),
          ).animate().fadeIn().shake(),
        );
      },
    );
  });
}


}