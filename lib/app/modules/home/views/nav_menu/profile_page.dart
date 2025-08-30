import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meme_verse/app/core/config/app_assets.dart';
import 'package:meme_verse/app/core/theme/color/app_colors.dart';
import 'package:meme_verse/app/core/widgets/custom_widgets.dart';
import 'package:meme_verse/app/modules/home/controllers/home_controller.dart';
import 'package:meme_verse/app/modules/home/views/nav_menu/logout_page.dart';
import 'package:meme_verse/app/routes/app_pages.dart';
import 'package:particles_flutter/component/particle/particle.dart';
import 'package:particles_flutter/particles_engine.dart';

class ProfilePage extends GetView<HomeController> {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: const Color(0xFF121212),
        title: Text(
          "Profile",
          style: GoogleFonts.poppins(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            foreground: Paint()
              ..shader = LinearGradient(
                colors: [AppColors.PRIMARY_COLOR, AppColors.SECONDARY_COLOR],
              ).createShader(const Rect.fromLTWH(0, 0, 200, 70)),
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFFFF2D55)),
            onPressed: () => Get.dialog(const LogoutPage()),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 200,
              child: Stack(
                children: [
                  // Particles widget as background
                  Particles(
                    height: 200,
                    width: MediaQuery.of(context).size.width,
                    particles: List.generate(
                      10, // Number of particles
                      (index) => Particle(
                        color: const Color(0xFF00FFAA).withOpacity(0.5),
                        size: 5.0,
                        velocity: Offset(
                          (index % 2 == 0 ? 1 : -1) * 0.5, // vx
                          (index % 3 == 0 ? 1 : -1) * 0.5, // vy
                        ),
                      ),
                    ),
                    awayRadius: 50,
                    onTapAnimation: true,
                    awayAnimationDuration: const Duration(milliseconds: 600),
                    awayAnimationCurve: Curves.easeIn,
                    enableHover: false,
                    hoverRadius: 80,
                    connectDots: false,
                  ),
                  // Profile content centered over particles
                  Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Animate(
                          effects: [
                            const ScaleEffect(
                              duration: Duration(milliseconds: 400),
                              curve: Curves.bounceOut,
                            ),
                          ],
                          child: CircleAvatar(
                            radius: 50,
                            backgroundImage: NetworkImage(
                              controller.loginCredential
                                      .getUserData()
                                      .photoUrl ??
                                  AppAssets.APP_USER_PROFILE,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          controller.loginCredential.getUserData().name ??
                              'Anonymous',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFFFFFFFF),
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          'Points: 100',
                          // ${controller.userPoints}',
                          style: GoogleFonts.poppins(
                            color: const Color(0xFF00FFAA),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Padding(
            //   padding: const EdgeInsets.all(16),
            //   child: Wrap(
            //     spacing: 8,
            //     children: controller.badges
            //         .map(
            //           (badge) => Animate(
            //             effects: [
            //               const ScaleEffect(
            //                 duration: Duration(milliseconds: 800),
            //               ),
            //             ],
            //             child: Chip(
            //               label: Text(
            //                 badge,
            //                 style: GoogleFonts.poppins(
            //                   color: const Color(0xFFFFFFFF),
            //                 ),
            //               ),
            //               backgroundColor: const Color(0xFFFF2D55).withOpacity(0.8),
            //               shape: RoundedRectangleBorder(
            //                 borderRadius: BorderRadius.circular(20),
            //               ),
            //             ),
            //           ),
            //         )
            //         .toList(),
            //   ),
            // ),
            StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('memes')
                  .where('userId', isEqualTo: controller.userId)
                  .snapshots(),
              builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (!snapshot.hasData) {
                  return CustomWidgets.customLottieLoader();
                }
                return GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                  ),
                  itemCount: snapshot.data!.docs.length,
                  itemBuilder: (context, index) {
                    final meme = snapshot.data!.docs[index];
                    return Animate(
                      effects: [
                        ScaleEffect(delay: Duration(milliseconds: index * 100)),
                      ],
                      child: GestureDetector(
                        onTap: () => Get.toNamed(
                          Routes.MEME_DETAILS,
                          arguments: meme.id,
                        ),
                        child: Image.network(
                          meme['imageUrl'],
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.error, color: Color(0xFFFF1744)),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
