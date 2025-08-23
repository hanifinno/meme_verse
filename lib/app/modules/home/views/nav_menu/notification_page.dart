import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meme_verse/app/core/widgets/custom_widgets.dart';
import 'package:meme_verse/app/modules/home/controllers/home_controller.dart';
import 'package:meme_verse/app/routes/app_pages.dart';

class NotificationsPage extends GetView<HomeController> {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Color(0xFF121212),
        title: Text("Notifications", style: GoogleFonts.poppins(color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold)),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance
            .collection('notifications')
            .where('userId', isEqualTo: controller.userId)
            .snapshots(),
        builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CustomWidgets.customLottieLoader());
          }
          return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final notification = snapshot.data!.docs[index];
              return Animate(
                effects: [
                  FadeEffect(delay: Duration(milliseconds: index * 100)),
                  ShakeEffect(duration: Duration(milliseconds: 200), ),
                ],
                child: ListTile(
                  title: Text(notification['message'], style: GoogleFonts.poppins(color: Color(0xFFFFFFFF))),
                  subtitle: Text(
                    notification['timestamp'].toDate().toString(),
                    style: GoogleFonts.poppins(color: Color(0xFFB0B0B0)),
                  ),
                  onTap: () {
                    if (notification['type'] == 'meme') {
                      Get.toNamed(Routes.MEME_DETAILS, arguments: notification['memeId']);
                    } else if (notification['type'] == 'profile') {
                      Get.toNamed(Routes.HOME, arguments: {'tab': 3, 'userId': notification['userId']});
                    }
                  },
                  tileColor: notification['read'] ? Color(0xFF1E1E1E) : Color(0xFFFF2D55).withOpacity(0.2),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  contentPadding: EdgeInsets.all(16),
                  leading: Icon(Icons.notifications, color: Color(0xFF00FFAA)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}