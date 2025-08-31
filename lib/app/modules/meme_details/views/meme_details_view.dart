import 'dart:convert';
import 'dart:math';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:meme_verse/app/modules/home/controllers/home_controller.dart';
import 'package:meme_verse/app/modules/meme_details/controllers/meme_details_controller.dart';
import 'package:meme_verse/app/routes/app_pages.dart';

class MemeDetailsView extends GetView<MemeDetailsController> {
  MemeDetailsView({super.key});

  final HomeController homeController =
      Get.find<HomeController>(); // Access reactions, etc.

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(useMaterial3: true), // Enable Material 3
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Get.back(),
          ),
          title: Text(
            "Meme Details",
            style: GoogleFonts.poppins(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.share, color: Colors.white),
              onPressed: _shareMeme,
            ),
            IconButton(
              icon: const Icon(Iconsax.scan, color: Colors.white), // AR icon
              onPressed: _showARPreview,
            ),
          ],
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF121212), Color(0xFF1E1E1E)],
            ),
          ),
          child: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection('memes')
                .doc(controller.memeModel.value.id)
                .snapshots(),
            builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
              if (!snapshot.hasData) {
                return const Center(child: CircularProgressIndicator());
              }
              final meme = snapshot.data!.data() as Map<String, dynamic>;
              final isOwner = meme['uploaderId'] == homeController.userId;
              final isForSale = meme['isForSale'] ?? false;
              final price = meme['price'] ?? 0.0;

              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Hero(
                      tag: 'meme-${controller.memeModel.value.id}',
                      child:
                          Card(
                                elevation: 8,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24),
                                ),
                                clipBehavior: Clip.antiAlias,
                                child: CachedNetworkImage(
                                  imageUrl:
                                      controller.memeModel.value.imageUrl ?? '',
                                  placeholder: (context, url) => const Center(
                                    child: CircularProgressIndicator(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      const Icon(
                                        Icons.error,
                                        color: Colors.red,
                                      ),
                                  fit: BoxFit.cover,
                                  height: 400,
                                ),
                              )
                              .animate()
                              .fadeIn(duration: 500.ms)
                              .scale(begin: const Offset(0.8, 0.8)),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            controller.memeModel.value.title ?? 'Untitled Meme',
                            style: Theme.of(context).textTheme.headlineMedium
                                ?.copyWith(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                  controller.memeModel.value.uploaderAvatar ??
                                      '',
                                ),
                                radius: 16,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                controller.memeModel.value.uploaderName ??
                                    'Anonymous',
                                style: Theme.of(context).textTheme.bodyLarge
                                    ?.copyWith(color: Colors.grey[300]),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          _buildReactionBar(meme),
                          const SizedBox(height: 16),
                          _buildActionButtons(isOwner, isForSale, price),
                        ],
                      ),
                    ),
                  ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text(
                        'Comments',
                        style: Theme.of(
                          context,
                        ).textTheme.titleLarge?.copyWith(color: Colors.white),
                      ),
                    ),
                  ),
                  SliverList(
                    delegate: SliverChildBuilderDelegate(
                      (context, index) =>
                          _buildCommentItem(), // Replace with actual comments
                      childCount: 10, // Placeholder
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Add a comment...',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.grey[800],
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(32),
                borderSide: BorderSide.none,
              ),
              suffixIcon: IconButton(
                icon: const Icon(Icons.send, color: Colors.tealAccent),
                onPressed: () {},
              ),
            ),
          ).animate().slideY(begin: 1.0, duration: 300.ms),
        ),
      ),
    );
  }

  Widget _buildReactionBar(Map<String, dynamic> meme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: homeController.reactionEmojis.entries.map((entry) {
        final isSelected = homeController.currentMemeComments.any(
          (c) => c.userReaction == entry.key,
        ); // Example
        return GestureDetector(
          onTap: () {
            // Toggle reaction
          },
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: isSelected
                  ? Colors.tealAccent.withOpacity(0.2)
                  : Colors.transparent,
            ),
            child: Text(entry.value, style: const TextStyle(fontSize: 24))
                .animate(target: isSelected ? 1 : 0)
                .scaleXY(begin: 1.0, end: 1.2, curve: Curves.elasticOut),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildActionButtons(bool isOwner, bool isForSale, double price) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        FilledButton.icon(
          icon: const Icon(Icons.auto_awesome),
          label: const Text('Remix'),
          onPressed: _showRemixSuggestions,
          style: FilledButton.styleFrom(
            backgroundColor: Colors.tealAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(32),
            ),
          ),
        ),
        if (isOwner && !isForSale)
          OutlinedButton.icon(
            icon: const Icon(Icons.sell),
            label: const Text('Sell'),
            onPressed: _listForSale,
            style: OutlinedButton.styleFrom(
              side: const BorderSide(color: Colors.tealAccent),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
          ),
        if (!isOwner && isForSale)
          FilledButton.icon(
            icon: const Icon(Icons.shopping_cart),
            label: Text('Buy for $price MemeCoins'),
            onPressed: _buyMeme,
            style: FilledButton.styleFrom(
              backgroundColor: Colors.greenAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(32),
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCommentItem() {
    // Placeholder for comment ListTile with Material 3 styling
    return ListTile(
      leading: const CircleAvatar(backgroundColor: Colors.teal),
      title: Text(
        'Comment text',
        style: GoogleFonts.poppins(color: Colors.white),
      ),
      subtitle: Text('By user', style: TextStyle(color: Colors.grey[400])),
      trailing: IconButton(icon: const Icon(Icons.thumb_up), onPressed: () {}),
    ).animate().fadeIn(
      delay: NumDurationExtensions(Random().nextDouble()).milliseconds * 200,
    );
  }

  void _shareMeme() {
    // Simulate sharing as NFT link
    Get.snackbar('Shared', 'Meme shared as digital asset link!');
  }

  void _showARPreview() {
    // Simulated AR preview
    Get.dialog(
      AlertDialog(
        title: const Text('AR Preview'),
        content: const Text('Imagine the meme in AR! (Placeholder)'),
        actions: [TextButton(onPressed: Get.back, child: const Text('Close'))],
      ),
    );
  }

  void _showRemixSuggestions() async {
    final response = await http.get(
      Uri.parse(
        'https://your-firebase-function/suggestMemeRemix?memeId=${controller.memeModel.value.id}',
      ),
    );
    if (response.statusCode == 200) {
      final suggestions =
          json.decode(response.body) as List; // Assume list of strings
      Get.bottomSheet(
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFF1E1E1E),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
          ),
          child: ListView.builder(
            itemCount: suggestions.length,
            itemBuilder: (context, index) => ListTile(
              leading: CachedNetworkImage(
                imageUrl:
                    'https://placeholder.com/remix-preview-$index', // Simulated thumbnail
                width: 50,
                height: 50,
              ),
              title: Text(
                suggestions[index],
                style: GoogleFonts.poppins(color: Colors.white),
              ),
              onTap: () => Get.toNamed(
                Routes.HOME,
                arguments: {
                  'tab': 1,
                  'memeId': controller.memeModel.value.id,
                  'suggestion': suggestions[index],
                  'imageUrl': controller.memeModel.value.imageUrl,
                },
              ),
            ).animate().slideX(begin: -0.2, duration: 300.ms),
          ),
        ),
      );
    }
  }

  void _listForSale() {
    Get.dialog(
      AlertDialog(
        title: const Text('List for Sale'),
        content: TextField(
          // controller: controller.priceController,
          decoration: const InputDecoration(labelText: 'Price in MemeCoins'),
          keyboardType: TextInputType.number,
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              // final price =
              //     double.tryParse(controller.priceController.text) ?? 0.0;
              // if (price <= 0) {
              //   Get.snackbar(
              //     'Invalid Price',
              //     'Please enter a price greater than 0.',
              //   );
              //   return;
              // }
              // FirebaseFirestore.instance
              //     .collection('memes')
              //     .doc(controller.memeModel.value.id)
              //     .update({'isForSale': true, 'price': price});
              // Get.back();
            },
            child: const Text('List'),
          ),
        ],
      ),
    );
  }

  void _buyMeme() {
    // This will call the `purchaseMeme` cloud function
    // The function will handle balance checks and atomic updates.
    // controller.purchaseMeme();
  }

  void _tipCreator() {
    // A simple way to support creators
    Get.dialog(
      AlertDialog(
        title: const Text('Tip Creator'),
        content: const Text(
          'Show your appreciation by sending 10 MemeCoins to the creator!',
        ),
        actions: [
          TextButton(onPressed: Get.back, child: const Text('Cancel')),
          FilledButton(
            onPressed: () {
              // TODO: Implement tipping logic (similar to purchase, but simpler)
              Get.back();
              Get.snackbar('Thanks!', 'You tipped the creator 10 MemeCoins.');
            },
            child: const Text('Send Tip'),
          ),
        ],
      ),
    );
  }
}

// New InAppPurchasePage for buying virtual currency (MemeCoins)
class InAppPurchasePage extends StatelessWidget {
  const InAppPurchasePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Get MemeCoins')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children:
              [
                    _buildCoinPackage(
                      context,
                      '100 MemeCoins',
                      '\$0.99',
                      'memecoins_100',
                      Iconsax.coin,
                    ),
                    _buildCoinPackage(
                      context,
                      '550 MemeCoins',
                      '\$4.99',
                      'memecoins_500',
                      Iconsax.money_3,
                      isPopular: true,
                    ),
                    _buildCoinPackage(
                      context,
                      '1200 MemeCoins',
                      '\$9.99',
                      'memecoins_1000',
                      Iconsax.wallet_money,
                    ),
                    _buildCoinPackage(
                      context,
                      '3000 MemeCoins',
                      '\$19.99',
                      'memecoins_2500',
                      Iconsax.money_tick,
                    ),
                  ]
                  .animate(interval: 100.ms)
                  .fadeIn(duration: 300.ms)
                  .slideY(begin: 0.2),
        ),
      ),
    );
  }

  Widget _buildCoinPackage(
    BuildContext context,
    String title,
    String price,
    String productId,
    IconData icon, {
    bool isPopular = false,
  }) {
    return Card(
      elevation: isPopular ? 8 : 4,
      shadowColor: isPopular
          ? Colors.tealAccent.withOpacity(0.5)
          : Colors.black,
      shape: RoundedRectangleBorder(
        side: isPopular
            ? const BorderSide(color: Colors.tealAccent, width: 2)
            : BorderSide.none,
        borderRadius: BorderRadius.circular(16),
      ),
      margin: const EdgeInsets.only(bottom: 16),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          vertical: 12,
          horizontal: 20,
        ),
        leading: Icon(icon, size: 40, color: Colors.amber),
        title: Text(title, style: Theme.of(context).textTheme.titleLarge),
        subtitle: Text(
          price,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(color: Colors.grey[400]),
        ),
        trailing: FilledButton(
          onPressed: () => _purchaseCoins(productId),
          style: FilledButton.styleFrom(
            backgroundColor: isPopular ? Colors.tealAccent : Colors.grey[700],
            foregroundColor: Colors.black,
          ),
          child: const Text('Buy'),
        ),
      ),
    );
  }

  void _purchaseCoins(String productId) {
    // TODO: Integrate with a real in-app purchase plugin like `in_app_purchase`.
    // This would involve initializing the plugin, fetching products, and launching the purchase flow.
    // For example:
    // final PurchaseParam purchaseParam = PurchaseParam(productDetails: productDetails);
    // InAppPurchase.instance.buyNonConsumable(purchaseParam: purchaseParam);
    Get.snackbar('Success', 'Purchased MemeCoins!');
    // On successful purchase, you would verify the receipt with your backend
    // and then update the user's `memeCoins` balance in Firestore.
  }
}
