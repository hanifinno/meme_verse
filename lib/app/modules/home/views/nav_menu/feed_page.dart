import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:meme_verse/app/core/helper_methods/helper_methods.dart';
import 'package:meme_verse/app/core/models/comment_model.dart';
import 'package:meme_verse/app/core/config/app_assets.dart';
import 'package:meme_verse/app/core/models/meme_model.dart';
import 'package:meme_verse/app/core/models/reply_model.dart';
import 'package:meme_verse/app/core/theme/color/app_colors.dart';
import 'package:meme_verse/app/core/widgets/custom_widgets.dart';
import 'package:meme_verse/app/modules/home/controllers/home_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meme_verse/app/routes/app_pages.dart';

class FeedPage extends GetView<HomeController> {
  const FeedPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.BLACK_COLOR,
      body: NestedScrollView(
        headerSliverBuilder: (context, innerBoxIsScrolled) {
          return [
            SliverAppBar(
              backgroundColor: AppColors.BLACK_COLOR,
              expandedHeight: 120,
              floating: true,
              snap: true,
              pinned: true,
              flexibleSpace: FlexibleSpaceBar(
                title: Text(
                  'Meme Verse',
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    foreground: Paint()
                      ..shader = LinearGradient(
                        colors: [
                          AppColors.PRIMARY_COLOR,
                          AppColors.SECONDARY_COLOR,
                        ],
                      ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
                  ),
                ),
                centerTitle: true,
                background: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        AppColors.BLACK_COLOR.withOpacity(0.8),
                        AppColors.BLACK_COLOR.withOpacity(0.4),
                      ],
                    ),
                  ),
                ),
              ),
              actions: [
                IconButton(
                  onPressed: () => controller.refreshFeed(),
                  icon: Icon(Iconsax.refresh, color: AppColors.WHITE_COLOR),
                ),
              ],
            ),
            SliverPersistentHeader(
              pinned: true,
              delegate: _SliverAppBarDelegate(
                TabBar(
                  controller: controller
                      .tabController, // Use controller's TabController
                  indicatorSize: TabBarIndicatorSize.tab,
                  indicator: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: AppColors.PRIMARY_COLOR,
                  ),
                  labelColor: AppColors.BLACK_COLOR,
                  unselectedLabelColor: AppColors.GREY_TEXT_COLOR,
                  labelStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  unselectedLabelStyle: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                  tabs: const [
                    Tab(text: 'For You'),
                    Tab(text: 'Trending'),
                    Tab(text: 'New'),
                  ],
                ),
              ),
            ),
          ];
        },
        body: TabBarView(
          controller: controller.tabController, // Sync with TabBar's controller
          children: [_buildForYouTab(), _buildTrendingTab(), _buildNewTab()],
        ),
      ),
      floatingActionButton: _buildFloatingActionButton(),
    );
  }

  Widget _buildFloatingActionButton() {
    return FloatingActionButton(
      backgroundColor: AppColors.PRIMARY_COLOR,
      onPressed: () {
        Get.toNamed('/upload');
      },
      child: const Icon(Iconsax.add, color: AppColors.BLACK_COLOR, size: 28),
    ).animate().scale(duration: 600.ms, curve: Curves.elasticOut);
  }

  Widget _buildForYouTab() {
    return RefreshIndicator(
      onRefresh: () async {
        await controller.refreshFeed();
        await controller.fetchRecommendations();
      },
      color: AppColors.PRIMARY_COLOR,
      backgroundColor: AppColors.BLACK_COLOR,
      child: CustomScrollView(
        slivers: [
          _buildRecommendationsSection(),
          _buildMemeList(controller.feedList, false),
        ],
      ),
    );
  }

  Widget _buildTrendingTab() {
    return RefreshIndicator(
      onRefresh: controller.refreshTrending,
      color: AppColors.PRIMARY_COLOR,
      backgroundColor: AppColors.BLACK_COLOR,
      child: CustomScrollView(
        slivers: [_buildMemeList(controller.trendingList, true)],
      ),
    );
  }

  Widget _buildNewTab() {
    return RefreshIndicator(
      onRefresh: controller.refreshFeed,
      color: AppColors.PRIMARY_COLOR,
      backgroundColor: AppColors.BLACK_COLOR,
      child: CustomScrollView(
        slivers: [_buildMemeList(controller.newList, false)],
      ),
    );
  }

  Widget _buildRecommendationsSection() {
    return SliverToBoxAdapter(
      child: Obx(() {
        final recommendations = controller.recommendations;
        if (controller.isLoading.value && recommendations.isEmpty) {
          return SizedBox(
            height: 120,
            child: Center(child: CustomWidgets.customLottieLoader()),
          );
        }
        if (recommendations.isEmpty) {
          return const SizedBox.shrink();
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Row(
                children: [
                  Text(
                    'AI Recommendations',
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.WHITE_COLOR,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Iconsax.flash, color: AppColors.PRIMARY_COLOR, size: 18),
                ],
              ),
            ),
            SizedBox(
              height: 120,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                itemCount: recommendations.length,
                itemBuilder: (context, index) {
                  final recommendation = recommendations[index];
                  return _buildRecommendationCard(recommendation, index);
                },
              ),
            ),
            const SizedBox(height: 16),
          ],
        );
      }),
    );
  }

  Widget _buildRecommendationCard(
    Map<String, dynamic> recommendation,
    int index,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: InkWell(
        onTap: () =>
            Get.toNamed('/meme-detail', arguments: recommendation['id']),
        borderRadius: BorderRadius.circular(12),
        child: Container(
          width: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: AppColors.PRIMARY_COLOR.withOpacity(0.7),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(11),
            child: Stack(
              children: [
                Image.network(
                  recommendation['imageUrl'] ?? '',
                  width: 100,
                  height: 120,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.GRAY_WHITE_COLOR,
                    child: Icon(
                      Iconsax.gallery_slash,
                      color: AppColors.GREY_TEXT_COLOR,
                      size: 30,
                    ),
                  ),
                ),
                Positioned(
                  bottom: 0,
                  left: 0,
                  right: 0,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withOpacity(0.8),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Text(
                      'AI Picked',
                      style: GoogleFonts.poppins(
                        fontSize: 10,
                        color: AppColors.WHITE_COLOR,
                        fontWeight: FontWeight.w500,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ).animate().fadeIn(delay: (100 * index).ms).slideX(begin: 0.2, end: 0),
      ),
    );
  }

  Widget _buildMemeList(RxList<MemeModel> memeList, bool isTrending) {
    return Obx(() {
      if (memeList.isEmpty) {
        return SliverFillRemaining(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  Iconsax.gallery_slash,
                  color: AppColors.GREY_TEXT_COLOR,
                  size: 48,
                ),
                const SizedBox(height: 16),
                Text(
                  'No memes found',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: AppColors.GREY_TEXT_COLOR,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Be the first to upload a meme!',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.GREY_TEXT_COLOR.withOpacity(0.7),
                  ),
                ),
              ],
            ),
          ),
        );
      }

      return SliverList(
        delegate: SliverChildBuilderDelegate((context, index) {
          final meme = memeList[index];
          return _buildInteractiveMemeCard(context, meme, isTrending, index);
        }, childCount: memeList.length),
      );
    });
  }

  Widget _buildInteractiveMemeCard(
    BuildContext context,
    MemeModel meme,
    bool isTrending,
    int index,
  ) {
    return Container(
      margin: const EdgeInsets.fromLTRB(12, 8, 12, 8),
      child: InkWell(
        onTap: () {
          Get.toNamed(Routes.MEME_DETAILS, arguments: meme);
        },
        borderRadius: BorderRadius.circular(16),
        child:
            Container(
                  decoration: BoxDecoration(
                    color: AppColors.GRAY_WHITE_COLOR,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        blurRadius: 6,
                        offset: const Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildUserInfoSection(meme),
                      _buildMemeImage(meme),
                      _buildInteractionButtons(context, meme),
                      _buildCaptionAndCommentsSection(context, meme),
                    ],
                  ),
                )
                .animate()
                .fadeIn(delay: (50 * index).ms)
                .slideY(begin: 0.1, end: 0, curve: Curves.easeOut),
      ),
    );
  }

  Widget _buildUserInfoSection(MemeModel meme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
      child: Row(
        children: [
          CircleAvatar(
            radius: 18,
            backgroundColor: AppColors.PRIMARY_COLOR.withOpacity(0.2),
            backgroundImage: meme.uploaderAvatar != null
                ? NetworkImage(meme.uploaderAvatar ?? '')
                : null,
            child: meme.uploaderAvatar == null
                ? Image.asset(AppAssets.APP_USER_PROFILE)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meme.uploaderName ?? 'Anonymous Memer',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.WHITE_COLOR,
                  ),
                ),
                if (meme.createdAt != null)
                  Text(
                    HelperMethods.formatTime(meme.createdAt!),
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: AppColors.GREY_TEXT_COLOR,
                    ),
                  ),
              ],
            ),
          ),
          if (meme.isTrending ?? false)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.SECONDARY_COLOR.withOpacity(0.2),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Iconsax.trend_up,
                    size: 14,
                    color: AppColors.SECONDARY_COLOR,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Trending',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: AppColors.SECONDARY_COLOR,
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildMemeImage(MemeModel meme) {
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: CachedNetworkImage(
            imageUrl: meme.imageUrl ?? '',
            width: double.infinity,
            height: 300,
            fit: BoxFit.cover,
            placeholder: (context, url) => Container(
              height: 300,
              color: AppColors.GRAY_WHITE_COLOR,
              child: const Center(
                child: CircularProgressIndicator(
                  color: AppColors.PRIMARY_COLOR,
                ),
              ),
            ),
            errorWidget: (context, url, error) => Container(
              height: 300,
              color: AppColors.GRAY_WHITE_COLOR,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Iconsax.gallery_slash,
                      color: AppColors.GREY_TEXT_COLOR,
                      size: 40,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Failed to load image',
                      style: GoogleFonts.poppins(
                        color: AppColors.GREY_TEXT_COLOR,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Positioned(
          bottom: 8,
          right: 8,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.6),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Iconsax.eye, size: 14, color: Colors.white70),
                const SizedBox(width: 4),
                Text(
                  '${meme.views ?? 0}',
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    color: Colors.white70,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInteractionButtons(BuildContext context, MemeModel meme) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Builder(
            builder: (buttonContext) {
              Widget iconWidget = Icon(
                Iconsax.heart,
                size: 22,
                color: meme.userReaction != null
                    ? AppColors.SECONDARY_COLOR
                    : AppColors.GREY_TEXT_COLOR,
              );
              if (meme.userReaction != null) {
                iconWidget = Text(
                  controller.reactionEmojis[meme.userReaction] ?? '❤️',
                  style: const TextStyle(fontSize: 22),
                );
              }
              return _buildInteractionButton(
                iconWidget,
                meme.totalReactionCount,
                meme.userReaction != null,
                AppColors.SECONDARY_COLOR,
                () => _showMemeReactionOverlay(buttonContext, meme),
              );
            },
          ),
          _buildInteractionButton(
            Icon(Iconsax.message, color: AppColors.WHITE_COLOR, size: 22),
            meme.commentCount ?? 0,
            false,
            AppColors.WARNING_COLOR,
            () => _showCommentsBottomSheet(context, meme),
          ),
          _buildInteractionButton(
            Icon(Iconsax.share, size: 22, color: AppColors.WHITE_COLOR),
            meme.shareCount ?? 0,
            false,
            AppColors.GREEN_COLOR,
            () {
              controller.shareMeme(meme);
            },
          ),
          _buildInteractionButton(
            Icon(
              Iconsax.bookmark,
              size: 22,
              color: meme.isSaved == true
                  ? AppColors.PRIMARY_COLOR
                  : AppColors.WHITE_COLOR,
            ),
            meme.saveCount ?? 0,
            meme.isSaved ?? false,
            AppColors.PRIMARY_COLOR,
            () {
              controller.toggleSave(meme.id!);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInteractionButton(
    Widget iconWidget,
    int count,
    bool isActive,
    Color activeColor,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        child: Row(
          children: [
            iconWidget,
            const SizedBox(width: 6),
            Text(
              HelperMethods.formatCount(count),
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: isActive ? activeColor : AppColors.GREY_TEXT_COLOR,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCaptionAndCommentsSection(BuildContext context, MemeModel meme) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (meme.title != null && meme.title!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: 4.0),
              child: RichText(
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    color: AppColors.WHITE_COLOR,
                  ),
                  children: [
                    TextSpan(
                      text: '${meme.uploaderName ?? 'User'} ',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                      text: meme.title!,
                      style: const TextStyle(fontWeight: FontWeight.normal),
                    ),
                  ],
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          const SizedBox(height: 4),
          InkWell(
            onTap: () => _showCommentsBottomSheet(context, meme),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Text(
                (meme.commentCount ?? 0) > 0
                    ? 'View all ${HelperMethods.formatCount(meme.commentCount ?? 0)} comments'
                    : 'Add a comment...',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: AppColors.GREY_TEXT_COLOR,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCommentsBottomSheet(BuildContext context, MemeModel meme) {
    controller.getCommentsForMeme(meme.id!);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) {
        return DraggableScrollableSheet(
          initialChildSize: 0.7,
          minChildSize: 0.4,
          maxChildSize: 0.9,
          builder: (_, scrollController) => Container(
            decoration: BoxDecoration(
              color: AppColors.GRAY_WHITE_COLOR,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(20),
              ),
            ),
            child: CommentsSection(
              meme: meme,
              scrollController: scrollController,
            ),
          ),
        );
      },
    );
  }

  void _showMemeReactionOverlay(BuildContext context, MemeModel meme) {
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final userReaction = meme.userReaction;

    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          onTap: () => overlayEntry?.remove(),
          child: Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned(
                  left: offset.dx,
                  top: offset.dy - 50, // Position above the button
                  child: Material(
                    color: Colors.transparent,
                    child:
                        Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.BLACK_COLOR,
                                borderRadius: BorderRadius.circular(30),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.3),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (userReaction != null) {
                                        controller.toggleMemeReaction(
                                          meme.id!,
                                          userReaction,
                                        );
                                      }
                                      overlayEntry?.remove();
                                    },
                                    child: AnimatedContainer(
                                      duration: 200.ms,
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: userReaction == null
                                            ? AppColors.PRIMARY_COLOR
                                                  .withOpacity(0.2)
                                            : Colors.transparent,
                                      ),
                                      child: const Icon(
                                        Icons.not_interested,
                                        color: AppColors.GREY_TEXT_COLOR,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  ...controller.reactionEmojis.entries.map((
                                    entry,
                                  ) {
                                    final isSelected =
                                        userReaction == entry.key;
                                    return GestureDetector(
                                      onTap: () {
                                        controller.toggleMemeReaction(
                                          meme.id!,
                                          entry.key,
                                        );
                                        overlayEntry?.remove();
                                      },
                                      child:
                                          AnimatedContainer(
                                                duration: 200.ms,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                    ),
                                                padding: const EdgeInsets.all(
                                                  6,
                                                ),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: isSelected
                                                      ? AppColors.PRIMARY_COLOR
                                                            .withOpacity(0.2)
                                                      : Colors.transparent,
                                                ),
                                                child: Text(
                                                  entry.value,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              )
                                              .animate(
                                                target: isSelected ? 1 : 0,
                                              )
                                              .scale(
                                                begin: const Offset(1, 1),
                                                end: const Offset(1.2, 1.2),
                                                curve: Curves.elasticOut,
                                              ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 200.ms)
                            .scale(
                              begin: const Offset(0.8, 0.8),
                              curve: Curves.easeOutBack,
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
  }
}

class _SliverAppBarDelegate extends SliverPersistentHeaderDelegate {
  _SliverAppBarDelegate(this._tabBar);

  final TabBar _tabBar;

  @override
  double get minExtent => _tabBar.preferredSize.height;
  @override
  double get maxExtent => _tabBar.preferredSize.height;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return Container(color: AppColors.BLACK_COLOR, child: _tabBar);
  }

  @override
  bool shouldRebuild(_SliverAppBarDelegate oldDelegate) {
    return false;
  }
}

class CommentsSection extends GetView<HomeController> {
  final MemeModel meme;
  final ScrollController scrollController;
  final textController = TextEditingController();

  CommentsSection({
    super.key,
    required this.meme,
    required this.scrollController,
  });

  void _postComment() {
    if (textController.text.trim().isEmpty) return;
    if (controller.replyingToCommentId.value != null) {
      controller.postReply(
        meme.id!,
        controller.replyingToCommentId.value!,
        textController.text,
      );
      controller.replyingToCommentId.value = null;
      controller.replyingToUsername.value = null;
    } else {
      controller.postComment(meme.id!, textController.text);
    }
    textController.clear();
    Get.focusScope?.unfocus();
  }

  @override
  Widget build(BuildContext context) {
    // This Padding moves the content up when the keyboard appears
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Column(
        children: [
          // Handle for the bottom sheet with gradient
          Container(
            width: 50,
            height: 6,
            margin: const EdgeInsets.symmetric(vertical: 12),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [AppColors.PRIMARY_COLOR, AppColors.SECONDARY_COLOR],
              ),
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              'Comments (${HelperMethods.formatCount(meme.commentCount ?? 0)})',
              style: GoogleFonts.poppins(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                foreground: Paint()
                  ..shader = LinearGradient(
                    colors: [
                      AppColors.PRIMARY_COLOR,
                      AppColors.SECONDARY_COLOR,
                    ],
                  ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
              ),
            ),
          ),
          const Divider(
            height: 24,
            color: AppColors.PRIMARY_COLOR,
            thickness: 1.5,
          ),
          Expanded(
            child: Obx(() {
              if (controller.isCommentsLoading.value) {
                return Center(child: CustomWidgets.customLottieLoader());
              }
              if (controller.currentMemeComments.isEmpty) {
                return _buildEmptyState();
              }
              return ListView.separated(
                controller: scrollController,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                itemCount: controller.currentMemeComments.length,
                separatorBuilder: (context, index) =>
                    const SizedBox(height: 16),
                itemBuilder: (itemContext, index) {
                  final comment = controller.currentMemeComments[index];
                  return _buildCommentTile(itemContext, comment)
                      .animate()
                      .fadeIn(duration: 300.ms, delay: (50 * index).ms)
                      .slideX(begin: -0.1, curve: Curves.easeOut);
                },
              );
            }),
          ),
          _buildCommentInputField(),
        ],
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Iconsax.message_notif,
            color: AppColors.PRIMARY_COLOR,
            size: 60,
          ),
          const SizedBox(height: 16),
          Text(
            'No comments yet',
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.WHITE_COLOR,
            ),
          ),
          Text(
            'Be the first to share your thoughts!',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.GREY_TEXT_COLOR,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentTile(BuildContext context, CommentModel comment) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Avatar and thread line
          SizedBox(
            width: 40, // A bit more space
            child: Stack(
              alignment: Alignment.topCenter,
              children: [
                // The vertical line for the thread
                if (comment.replies.isNotEmpty || comment.replyCount > 0)
                  Positioned.fill(
                    child: Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: const EdgeInsets.only(top: 40),
                        width: 2,
                        color: AppColors.GREY_TEXT_COLOR.withOpacity(0.2),
                      ),
                    ),
                  ),
                CircleAvatar(
                  radius: 20,
                  backgroundColor: AppColors.PRIMARY_COLOR,
                  child: CircleAvatar(
                    radius: 19,
                    backgroundColor: AppColors.PRIMARY_COLOR.withOpacity(0.2),
                    backgroundImage:
                        comment.userAvatarUrl != null &&
                            comment.userAvatarUrl!.isNotEmpty
                        ? CachedNetworkImageProvider(comment.userAvatarUrl!)
                        : null,
                    child:
                        comment.userAvatarUrl == null ||
                            comment.userAvatarUrl!.isEmpty
                        ? Image.asset(AppAssets.APP_USER_PROFILE)
                        : null,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // The comment bubble
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        AppColors.BLACK_COLOR,
                        AppColors.GRAY_WHITE_COLOR.withOpacity(0.8),
                      ],
                    ),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.PRIMARY_COLOR.withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: GoogleFonts.poppins(
                                fontWeight: FontWeight.bold,
                                color: AppColors.PRIMARY_COLOR,
                                fontSize: 15,
                              ),
                              children: [
                                TextSpan(text: comment.userName),
                                TextSpan(
                                  text:
                                      '  ·  ${HelperMethods.formatTime(comment.createdAt)}',
                                  style: TextStyle(
                                    fontWeight: FontWeight.normal,
                                    color: AppColors.GREY_TEXT_COLOR,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            comment.text,
                            style: GoogleFonts.poppins(
                              color: AppColors.WHITE_COLOR,
                              fontSize: 14,
                            ),
                          ),
                          _buildCommentActions(context, comment),
                          if (comment.totalReactionCount > 0)
                            const SizedBox(
                              height: 24,
                            ), // Space for the reaction summary
                        ],
                      ),
                      if (comment.totalReactionCount > 0)
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: _buildReactionSummary(comment),
                        ),
                    ],
                  ),
                ),
                _buildRepliesSection(context, meme, comment),
              ],
            ).animate().fade(duration: 200.ms),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentInputField() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.GRAY_WHITE_COLOR,
        border: Border(
          top: BorderSide(
            color: AppColors.PRIMARY_COLOR.withOpacity(0.5),
            width: 1.5,
          ),
        ),
      ),
      child: Obx(() {
        final isReplying = controller.replyingToCommentId.value != null;
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (isReplying)
              Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: AppColors.BLACK_COLOR,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Row(
                    children: [
                      Text(
                        'Replying to ${controller.replyingToUsername.value ?? ''}',
                        style: GoogleFonts.poppins(
                          color: AppColors.PRIMARY_COLOR,
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const Spacer(),
                      InkWell(
                        onTap: () {
                          controller.replyingToCommentId.value = null;
                          controller.replyingToUsername.value = null;
                        },
                        child: const Icon(
                          Icons.close,
                          size: 18,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                      ),
                    ],
                  ),
                ).animate().fadeIn(duration: 200.ms).slideY(begin: 0.5),
              ),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: textController,
                    minLines: 1,
                    maxLines: 4,
                    style: const TextStyle(color: AppColors.WHITE_COLOR),
                    textCapitalization: TextCapitalization.sentences,
                    decoration: InputDecoration(
                      hintText: isReplying
                          ? 'Write a reply...'
                          : 'Add a comment...',
                      hintStyle: const TextStyle(
                        color: AppColors.GREY_TEXT_COLOR,
                      ),
                      filled: true,
                      fillColor: AppColors.BLACK_COLOR,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                      suffixIcon: IconButton(
                        icon: const Icon(
                          Iconsax.emoji_happy,
                          color: AppColors.PRIMARY_COLOR,
                        ),
                        onPressed: () {
                          // Optional: Integrate emoji picker here
                        },
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(
                    Iconsax.send_1,
                    color: AppColors.PRIMARY_COLOR,
                    size: 28,
                  ),
                  onPressed: _postComment,
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  void _showReactionOverlay(BuildContext context, CommentModel comment) {
    final currentUser = controller.loginCredential.getUserData();
    if (currentUser == null) return;
    final userReaction = comment.getUserReaction(currentUser.id ?? '');

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenWidth = MediaQuery.of(context).size.width;

    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          onTap: () => overlayEntry?.remove(),
          child: Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned(
                  // Adjusted position to prevent overflow
                  left: (offset.dx + 320 > screenWidth)
                      ? screenWidth - 320
                      : (offset.dx > 16 ? offset.dx : 16),
                  top: offset.dy - 60,
                  child: Material(
                    color: Colors.transparent,
                    child:
                        Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.BLACK_COLOR,
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.PRIMARY_COLOR.withOpacity(
                                      0.2,
                                    ),
                                    blurRadius: 12,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Undo button
                                  GestureDetector(
                                    onTap: () {
                                      if (userReaction != null) {
                                        controller.toggleCommentReaction(
                                          meme.id!,
                                          comment.id,
                                          userReaction,
                                        );
                                      }
                                      overlayEntry?.remove();
                                    },
                                    child: AnimatedContainer(
                                      duration: 200.ms,
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: userReaction == null
                                            ? AppColors.PRIMARY_COLOR
                                                  .withOpacity(0.2)
                                            : Colors.transparent,
                                      ),
                                      child: Icon(
                                        Icons.not_interested,
                                        color: AppColors.GREY_TEXT_COLOR,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  ...controller.reactionEmojis.entries.map((
                                    entry,
                                  ) {
                                    final isSelected =
                                        userReaction == entry.key;
                                    return GestureDetector(
                                      onTap: () {
                                        controller.toggleCommentReaction(
                                          meme.id!,
                                          comment.id,
                                          entry.key,
                                        );
                                        overlayEntry?.remove();
                                      },
                                      child:
                                          AnimatedContainer(
                                                duration: 200.ms,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                    ),
                                                padding: const EdgeInsets.all(
                                                  6,
                                                ),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: isSelected
                                                      ? AppColors.PRIMARY_COLOR
                                                            .withOpacity(0.2)
                                                      : Colors.transparent,
                                                ),
                                                child: Text(
                                                  entry.value,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              )
                                              .animate(
                                                target: isSelected ? 1 : 0,
                                              )
                                              .scale(
                                                begin: const Offset(1, 1),
                                                end: const Offset(1.2, 1.2),
                                                curve: Curves.elasticOut,
                                              ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 250.ms)
                            .scale(
                              begin: const Offset(0.7, 0.7),
                              curve: Curves.easeOutBack,
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
  }

  Widget _buildCommentActions(BuildContext context, CommentModel comment) {
    final currentUser = controller.loginCredential.getUserData();
    if (currentUser == null) return const SizedBox.shrink();
    final userReaction = comment.getUserReaction(currentUser.id ?? '');

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Builder(
            builder: (buttonContext) {
              return InkWell(
                onTap: () => _showReactionOverlay(buttonContext, comment),
                child: Row(
                  children: [
                    if (userReaction != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Text(
                          controller.reactionEmojis[userReaction] ?? '',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    Text(
                      userReaction != null ? 'Reacted' : 'React',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: userReaction != null
                            ? AppColors.PRIMARY_COLOR
                            : AppColors.GREY_TEXT_COLOR,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(width: 24),
          InkWell(
            onTap: () {
              controller.replyingToCommentId.value = comment.id;
              controller.replyingToUsername.value = comment.userName;
            },
            child: Text(
              'Reply',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.bold,
                color: AppColors.GREY_TEXT_COLOR,
                fontSize: 13,
              ),
            ),
          ),
          if (comment.userId == currentUser.id) ...[
            const SizedBox(width: 24),
            InkWell(
              onTap: () => _showEditCommentDialog(context, comment),
              child: Text(
                'Edit',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: AppColors.PRIMARY_COLOR,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 24),
            InkWell(
              onTap: () => _confirmDeleteComment(context, comment),
              child: Text(
                'Delete',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: AppColors.WARNING_COLOR,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildReactionSummary(CommentModel comment) {
    final sortedReactions = comment.reactions.entries.toList()
      ..removeWhere((entry) => entry.value.isEmpty)
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            AppColors.PRIMARY_COLOR.withOpacity(0.8),
            AppColors.SECONDARY_COLOR.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (sortedReactions.isNotEmpty)
            SizedBox(
              height: 20,
              child: Stack(
                children: List.generate(
                  sortedReactions.take(3).length,
                  (index) => Padding(
                    padding: EdgeInsets.only(left: (index * 12).toDouble()),
                    child: Text(
                      controller.reactionEmojis[sortedReactions[index].key] ??
                          '',
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
                ).reversed.toList(),
              ),
            ),
          const SizedBox(width: 6),
          Text(
            comment.totalReactionCount.toString(),
            style: GoogleFonts.poppins(
              color: AppColors.WHITE_COLOR,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRepliesSection(
    BuildContext context,
    MemeModel meme,
    CommentModel comment,
  ) {
    return Obx(() {
      if (comment.replyCount > 0 &&
          comment.replies.isEmpty &&
          !comment.areRepliesVisible.value) {
        return Padding(
          padding: const EdgeInsets.only(left: 10, top: 8),
          child: InkWell(
            onTap: () {
              comment.areRepliesVisible.value = true;
              controller.getRepliesForComment(meme.id!, comment);
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: AppColors.PRIMARY_COLOR.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 20,
                    height: 1,
                    color: AppColors.PRIMARY_COLOR.withOpacity(0.5),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'View ${comment.replyCount} ${comment.replyCount > 1 ? "replies" : "reply"}',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.bold,
                      color: AppColors.PRIMARY_COLOR,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }

      if (!comment.areRepliesVisible.value) return const SizedBox.shrink();

      return Container(
        margin: const EdgeInsets.only(left: 20, top: 8),
        padding: const EdgeInsets.only(left: 12),
        decoration: BoxDecoration(
          border: Border(
            left: BorderSide(
              color: AppColors.GREY_TEXT_COLOR.withOpacity(0.2),
              width: 2,
            ),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (comment.areRepliesLoading.value)
              const Padding(
                padding: EdgeInsets.all(8.0),
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: AppColors.PRIMARY_COLOR,
                  ),
                ),
              ),
            ...comment.replies.map(
              (reply) => _buildReplyTile(context, meme, reply, comment),
            ),
          ],
        ),
      );
    });
  }

  Widget _buildReplyTile(
    BuildContext context,
    MemeModel meme,
    ReplyModel reply,
    CommentModel parentComment,
  ) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CircleAvatar(
            radius: 14,
            backgroundColor: AppColors.SECONDARY_COLOR.withOpacity(0.2),
            backgroundImage:
                reply.userAvatarUrl != null && reply.userAvatarUrl!.isNotEmpty
                ? CachedNetworkImageProvider(reply.userAvatarUrl!)
                : null,
            child: reply.userAvatarUrl == null || reply.userAvatarUrl!.isEmpty
                ? Image.asset(AppAssets.APP_USER_PROFILE, scale: 1.5)
                : null,
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.BLACK_COLOR,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Stack(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            color: AppColors.WHITE_COLOR,
                            fontSize: 13,
                          ),
                          children: [
                            TextSpan(
                              text: reply.userName,
                              style: const TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            TextSpan(
                              text:
                                  '  ·  ${HelperMethods.formatTime(reply.createdAt)}',
                              style: TextStyle(
                                color: AppColors.GREY_TEXT_COLOR,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 4),
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.poppins(
                            color: AppColors.WHITE_COLOR.withOpacity(0.9),
                            fontSize: 13,
                            height: 1.4,
                          ),
                          children: [
                            TextSpan(
                              text: '@${parentComment.userName} ',
                              style: TextStyle(
                                color: AppColors.PRIMARY_COLOR,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            TextSpan(text: reply.text),
                          ],
                        ),
                      ),
                      if (reply.totalReactionCount > 0)
                        const SizedBox(
                          height: 24,
                        ), // Space for reaction summary
                      _buildReplyActions(context, meme, reply, parentComment),
                    ],
                  ),
                  if (reply.totalReactionCount > 0)
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: _buildReplyReactionSummary(reply),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    ).animate().fadeIn(duration: 300.ms).slideX(begin: 0.2);
  }

  Widget _buildReplyActions(
    BuildContext context,
    MemeModel meme,
    ReplyModel reply,
    CommentModel parentComment,
  ) {
    final currentUser = controller.loginCredential.getUserData();
    if (currentUser == null) return const SizedBox.shrink();
    final userReaction = reply.getUserReaction(currentUser.id ?? '');

    return Padding(
      padding: const EdgeInsets.only(top: 8.0),
      child: Row(
        children: [
          Builder(
            builder: (buttonContext) {
              return InkWell(
                onTap: () => _showReplyReactionOverlay(
                  buttonContext,
                  meme,
                  parentComment,
                  reply,
                ),
                child: Row(
                  children: [
                    if (userReaction != null)
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: Text(
                          controller.reactionEmojis[userReaction] ?? '',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ),
                    Text(
                      userReaction != null ? 'Reacted' : 'React',
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.bold,
                        color: userReaction != null
                            ? AppColors.PRIMARY_COLOR
                            : AppColors.GREY_TEXT_COLOR,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          if (reply.userId == currentUser.id) ...[
            const SizedBox(width: 24),
            InkWell(
              onTap: () =>
                  _showEditReplyDialog(context, meme, parentComment, reply),
              child: Text(
                'Edit',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: AppColors.PRIMARY_COLOR,
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(width: 24),
            InkWell(
              onTap: () =>
                  _confirmDeleteReply(context, meme, parentComment, reply),
              child: Text(
                'Delete',
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  color: AppColors.WARNING_COLOR,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  void _showEditCommentDialog(BuildContext context, CommentModel comment) {
    final textController = TextEditingController(text: comment.text);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.GRAY_WHITE_COLOR,
        title: Text(
          'Edit Comment',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: AppColors.WHITE_COLOR,
          ),
        ),
        content: TextField(
          controller: textController,
          minLines: 1,
          maxLines: 4,
          style: GoogleFonts.poppins(color: AppColors.WHITE_COLOR),
          decoration: InputDecoration(
            hintText: 'Edit your comment...',
            hintStyle: GoogleFonts.poppins(color: AppColors.GREY_TEXT_COLOR),
            filled: true,
            fillColor: AppColors.BLACK_COLOR,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: AppColors.GREY_TEXT_COLOR),
            ),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.trim().isNotEmpty) {
                controller.editComment(
                  comment.memeId,
                  comment.id,
                  textController.text.trim(),
                );
                Get.back();
              } else {
                Get.snackbar('Error', 'Comment cannot be empty.');
              }
            },
            child: Text(
              'Save',
              style: GoogleFonts.poppins(
                color: AppColors.PRIMARY_COLOR,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteComment(BuildContext context, CommentModel comment) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.GRAY_WHITE_COLOR,
        title: Text(
          'Delete Comment',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: AppColors.WHITE_COLOR,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this comment?',
          style: GoogleFonts.poppins(color: AppColors.GREY_TEXT_COLOR),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: AppColors.GREY_TEXT_COLOR),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.deleteComment(comment.memeId, comment.id);
              Get.back();
            },
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(
                color: AppColors.WARNING_COLOR,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showEditReplyDialog(
    BuildContext context,
    MemeModel meme,
    CommentModel parentComment,
    ReplyModel reply,
  ) {
    final textController = TextEditingController(text: reply.text);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.GRAY_WHITE_COLOR,
        title: Text(
          'Edit Reply',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: AppColors.WHITE_COLOR,
          ),
        ),
        content: TextField(
          controller: textController,
          minLines: 1,
          maxLines: 4,
          style: GoogleFonts.poppins(color: AppColors.WHITE_COLOR),
          decoration: InputDecoration(
            hintText: 'Edit your reply...',
            hintStyle: GoogleFonts.poppins(color: AppColors.GREY_TEXT_COLOR),
            filled: true,
            fillColor: AppColors.BLACK_COLOR,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: AppColors.GREY_TEXT_COLOR),
            ),
          ),
          TextButton(
            onPressed: () {
              if (textController.text.trim().isNotEmpty) {
                controller.editReply(
                  meme.id!,
                  parentComment.id,
                  reply.id,
                  textController.text.trim(),
                );
                Get.back();
              } else {
                Get.snackbar('Error', 'Reply cannot be empty.');
              }
            },
            child: Text(
              'Save',
              style: GoogleFonts.poppins(
                color: AppColors.PRIMARY_COLOR,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _confirmDeleteReply(
    BuildContext context,
    MemeModel meme,
    CommentModel parentComment,
    ReplyModel reply,
  ) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: AppColors.GRAY_WHITE_COLOR,
        title: Text(
          'Delete Reply',
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.bold,
            color: AppColors.WHITE_COLOR,
          ),
        ),
        content: Text(
          'Are you sure you want to delete this reply?',
          style: GoogleFonts.poppins(color: AppColors.GREY_TEXT_COLOR),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: GoogleFonts.poppins(color: AppColors.GREY_TEXT_COLOR),
            ),
          ),
          TextButton(
            onPressed: () {
              controller.deleteReply(meme.id!, parentComment.id, reply.id);
              Get.back();
            },
            child: Text(
              'Delete',
              style: GoogleFonts.poppins(
                color: AppColors.WARNING_COLOR,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showReplyReactionOverlay(
    BuildContext context,
    MemeModel meme,
    CommentModel parentComment,
    ReplyModel reply,
  ) {
    final currentUser = controller.loginCredential.getUserData();
    if (currentUser == null) return;
    final userReaction = reply.getUserReaction(currentUser.id ?? '');

    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox;
    final offset = renderBox.localToGlobal(Offset.zero);
    final screenWidth = MediaQuery.of(context).size.width;

    OverlayEntry? overlayEntry;

    overlayEntry = OverlayEntry(
      builder: (context) => Positioned.fill(
        child: GestureDetector(
          onTap: () => overlayEntry?.remove(),
          child: Container(
            color: Colors.transparent,
            child: Stack(
              children: [
                Positioned(
                  // Adjusted position to prevent overflow
                  left: (offset.dx + 320 > screenWidth)
                      ? screenWidth - 320
                      : (offset.dx > 16 ? offset.dx : 16),
                  top: offset.dy - 60,
                  child: Material(
                    color: Colors.transparent,
                    child:
                        Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.BLACK_COLOR,
                                borderRadius: BorderRadius.circular(40),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.PRIMARY_COLOR.withOpacity(
                                      0.2,
                                    ),
                                    blurRadius: 12,
                                    spreadRadius: 3,
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      if (userReaction != null) {
                                        controller.toggleReplyReaction(
                                          meme.id!,
                                          parentComment.id,
                                          reply.id,
                                          userReaction,
                                        );
                                      }
                                      overlayEntry?.remove();
                                    },
                                    child: AnimatedContainer(
                                      duration: 200.ms,
                                      padding: const EdgeInsets.all(6),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: userReaction == null
                                            ? AppColors.PRIMARY_COLOR
                                                  .withOpacity(0.2)
                                            : Colors.transparent,
                                      ),
                                      child: const Icon(
                                        Icons.not_interested,
                                        color: AppColors.GREY_TEXT_COLOR,
                                        size: 24,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  ...controller.reactionEmojis.entries.map((
                                    entry,
                                  ) {
                                    final isSelected =
                                        userReaction == entry.key;
                                    return GestureDetector(
                                      onTap: () {
                                        controller.toggleReplyReaction(
                                          meme.id!,
                                          parentComment.id,
                                          reply.id,
                                          entry.key,
                                        );
                                        overlayEntry?.remove();
                                      },
                                      child:
                                          AnimatedContainer(
                                                duration: 200.ms,
                                                margin:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 4,
                                                    ),
                                                padding: const EdgeInsets.all(
                                                  6,
                                                ),
                                                decoration: BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: isSelected
                                                      ? AppColors.PRIMARY_COLOR
                                                            .withOpacity(0.2)
                                                      : Colors.transparent,
                                                ),
                                                child: Text(
                                                  entry.value,
                                                  style: const TextStyle(
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              )
                                              .animate(
                                                target: isSelected ? 1 : 0,
                                              )
                                              .scale(
                                                begin: const Offset(1, 1),
                                                end: const Offset(1.2, 1.2),
                                                curve: Curves.elasticOut,
                                              ),
                                    );
                                  }).toList(),
                                ],
                              ),
                            )
                            .animate()
                            .fadeIn(duration: 250.ms)
                            .scale(
                              begin: const Offset(0.7, 0.7),
                              curve: Curves.easeOutBack,
                            ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );

    overlay.insert(overlayEntry);
  }

  Widget _buildReplyReactionSummary(ReplyModel reply) {
    if (reply.totalReactionCount == 0) return const SizedBox.shrink();

    final sortedReactions = reply.reactions.entries.toList()
      ..removeWhere((entry) => entry.value.isEmpty)
      ..sort((a, b) => b.value.length.compareTo(a.value.length));

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          colors: [
            AppColors.PRIMARY_COLOR.withOpacity(0.8),
            AppColors.SECONDARY_COLOR.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (sortedReactions.isNotEmpty)
            SizedBox(
              height: 20,
              child: Stack(
                children: List.generate(
                  sortedReactions.take(3).length,
                  (index) => Padding(
                    padding: EdgeInsets.only(left: (index * 12).toDouble()),
                    child: Text(
                      controller.reactionEmojis[sortedReactions[index].key] ??
                          '',
                      style: const TextStyle(fontSize: 12),
                    ),
                  ),
                ).reversed.toList(),
              ),
            ),
          const SizedBox(width: 6),
          Text(
            reply.totalReactionCount.toString(),
            style: GoogleFonts.poppins(
              color: AppColors.WHITE_COLOR,
              fontSize: 13,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}
