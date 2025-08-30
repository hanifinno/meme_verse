import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:meme_verse/app/core/models/comment_model.dart';
import 'package:meme_verse/app/core/config/app_assets.dart';
import 'package:meme_verse/app/core/models/meme_model.dart';
import 'package:meme_verse/app/core/theme/color/app_colors.dart';
import 'package:meme_verse/app/core/widgets/custom_widgets.dart';
import 'package:meme_verse/app/modules/home/controllers/home_controller.dart';
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
                  'MemeVerse',
                  style: GoogleFonts.poppins(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: AppColors.PRIMARY_COLOR,
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
      child: _buildMemeList(controller.trendingList, true),
    );
  }

  Widget _buildNewTab() {
    return RefreshIndicator(
      onRefresh: controller.refreshFeed,
      color: AppColors.PRIMARY_COLOR,
      backgroundColor: AppColors.BLACK_COLOR,
      child: _buildMemeList(controller.newList, false),
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
            backgroundImage: meme.userAvatar != null
                ? NetworkImage(meme.userAvatar ?? '')
                : null,
            child: meme.userAvatar == null
                ? Image.asset(AppAssets.APP_USER_PROFILE)
                : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meme.username ?? 'Anonymous Memer',
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.WHITE_COLOR,
                  ),
                ),
                if (meme.createdAt != null)
                  Text(
                    _formatTime(meme.createdAt!),
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
          _buildInteractionButton(
            Iconsax.heart,
            meme.likeCount ?? 0,
            meme.isLikedByUser ?? false,
            AppColors.SECONDARY_COLOR,
            () {
              controller.toggleLike(meme.id!);
            },
          ),
          _buildInteractionButton(
            Iconsax.message,
            meme.commentCount ?? 0,
            false,
            AppColors.WARNING_COLOR,
            () => _showCommentsBottomSheet(context, meme),
          ),
          _buildInteractionButton(
            Iconsax.share,
            meme.shareCount ?? 0,
            false,
            AppColors.GREEN_COLOR,
            () {
              controller.shareMeme(meme);
            },
          ),
          _buildInteractionButton(
            Iconsax.bookmark,
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
    IconData icon,
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
            Icon(
              icon,
              size: 22,
              color: isActive ? activeColor : AppColors.GREY_TEXT_COLOR,
            ),
            const SizedBox(width: 6),
            Text(
              _formatCount(count),
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
                      text: '${meme.username ?? 'User'} ',
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
                    ? 'View all ${meme.commentCount} comments'
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

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m ago';
    if (difference.inDays < 1) return '${difference.inHours}h ago';
    if (difference.inDays < 7) return '${difference.inDays}d ago';

    return '${time.day}/${time.month}/${time.year}';
  }

  String _formatCount(int count) {
    if (count < 1000) return count.toString();
    if (count < 1000000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '${(count / 1000000).toStringAsFixed(1)}M';
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
    controller.postComment(meme.id!, textController.text);
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
          // Handle for the bottom sheet
          Container(
            width: 40,
            height: 5,
            margin: const EdgeInsets.symmetric(vertical: 10),
            decoration: BoxDecoration(
              color: AppColors.GREY_TEXT_COLOR.withOpacity(0.5),
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child:
                //  Obx(
                //   () =>
                Text(
                  'Comments (${_formatCount(meme.commentCount ?? 0)})',
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: AppColors.WHITE_COLOR,
                  ),
                ),
            // ),
          ),
          const Divider(height: 20, color: AppColors.GREY_TEXT_COLOR),
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
                itemBuilder: (context, index) {
                  final comment = controller.currentMemeComments[index];
                  return _buildCommentTile(comment)
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
            color: AppColors.GREY_TEXT_COLOR,
            size: 50,
          ),
          const SizedBox(height: 16),
          Text(
            'No comments yet',
            style: GoogleFonts.poppins(
              fontSize: 16,
              color: AppColors.GREY_TEXT_COLOR,
            ),
          ),
          Text(
            'Be the first to share your thoughts!',
            style: GoogleFonts.poppins(
              fontSize: 14,
              color: AppColors.GREY_TEXT_COLOR.withOpacity(0.7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentTile(CommentModel comment) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          radius: 18,
          backgroundColor: AppColors.PRIMARY_COLOR.withOpacity(0.2),
          backgroundImage:
              comment.userAvatarUrl != null && comment.userAvatarUrl!.isNotEmpty
              ? CachedNetworkImageProvider(comment.userAvatarUrl!)
              : null,
          child: comment.userAvatarUrl == null || comment.userAvatarUrl!.isEmpty
              ? Image.asset(AppAssets.APP_USER_PROFILE)
              : null,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    comment.userName ?? '',
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      color: AppColors.WHITE_COLOR,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '• ${_formatTime(comment.createdAt ?? DateTime.now())}',
                    style: GoogleFonts.poppins(
                      color: AppColors.GREY_TEXT_COLOR,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 2),
              Text(
                comment.text ?? '',
                style: GoogleFonts.poppins(
                  color: AppColors.WHITE_COLOR.withOpacity(0.9),
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCommentInputField() {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      decoration: BoxDecoration(
        color: AppColors.GRAY_WHITE_COLOR,
        border: Border(
          top: BorderSide(
            color: AppColors.GREY_TEXT_COLOR.withOpacity(0.5),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: textController,
              minLines: 1,
              maxLines: 4,
              style: const TextStyle(color: AppColors.WHITE_COLOR),
              textCapitalization: TextCapitalization.sentences,
              decoration: InputDecoration(
                hintText: 'Add a comment...',
                hintStyle: const TextStyle(color: AppColors.GREY_TEXT_COLOR),
                filled: true,
                fillColor: AppColors.BLACK_COLOR,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),
          Obx(
            () => controller.isPostingComment.value
                ? const Padding(
                    padding: EdgeInsets.all(12.0),
                    child: SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : IconButton(
                    icon: const Icon(
                      Iconsax.send_1,
                      color: AppColors.PRIMARY_COLOR,
                    ),
                    onPressed: _postComment,
                  ),
          ),
        ],
      ),
    );
  }

  String _formatTime(DateTime time) {
    final now = DateTime.now();
    final difference = now.difference(time);

    if (difference.inMinutes < 1) return 'Just now';
    if (difference.inHours < 1) return '${difference.inMinutes}m';
    if (difference.inDays < 1) return '${difference.inHours}h';
    return '${difference.inDays}d';
  }

  String _formatCount(int count) {
    if (count < 1000) return count.toString();
    if (count < 1000000) return '${(count / 1000).toStringAsFixed(1)}K';
    return '${(count / 1000000).toStringAsFixed(1)}M';
  }
}
