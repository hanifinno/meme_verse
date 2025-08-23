import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meme_verse/app/core/widgets/custom_widgets.dart';
import 'package:meme_verse/app/modules/home/controllers/home_controller.dart';
import 'package:meme_verse/app/modules/meme_details/controllers/meme_details_controller.dart';
import 'package:meme_verse/app/routes/app_pages.dart';

class MemeDetailsView extends GetView<MemeDetailsController> {

   MemeDetailsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Color(0xFF121212),
        leading: IconButton(onPressed: (){
          Get.back();
        }, icon: Icon(Icons.arrow_back)),
        title: Text("Meme Details", style: GoogleFonts.poppins(color: Color(0xFFFFFFFF))),
      ),
      body: StreamBuilder(
        stream: FirebaseFirestore.instance.collection('memes').doc(controller.memeModel.id).snapshots(),
        builder: (context, AsyncSnapshot<DocumentSnapshot> snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CustomWidgets.customLottieLoader());
          }
          final meme = snapshot.data!.data() as Map<String, dynamic>;
          return Column(
            children: [
              Hero(
                tag: 'meme-${controller.memeModel.title}',
                child: Stack(
                  children: [
                    CachedNetworkImage(
                      imageUrl: controller.memeModel.imageUrl??'',
                      placeholder: (context, url) => CustomWidgets.customLottieLoader(),
                      errorWidget: (context, url, error) => Icon(Icons.error, color: Color(0xFFFF1744)),
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Container(
                        padding: EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [Colors.transparent, Color(0xFF121212)],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                        child: Text(
                         ' ${controller.memeModel.title??''}',
                          style: GoogleFonts.poppins(color: Color(0xFFFFFFFF), fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Animate(
                      effects: [ShakeEffect(duration: Duration(milliseconds: 200))],
                      child: IconButton(
                        icon: Icon(Icons.favorite, color: Color(0xFF00FFAA)),
                        onPressed: () {
                          // controller.likeMeme(memeId)
                        },
                      ),
                    ),
                    CustomWidgets.customButton(
                      label: "Remix",
                      onPressed: () => Get.bottomSheet(
                        Animate(
                          effects: [SlideEffect(begin: Offset(0, 1), end: Offset(0, 0), duration: Duration(milliseconds: 300))],
                          child: Container(
                            decoration: BoxDecoration(
                              color: Color(0xFF1E1E1E),
                              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                            ),
                            child: FutureBuilder(
                              future: http.get(Uri.parse('https://your-firebase-function/suggestMemeRemix?memeId=${controller.memeModel.id}')),
                              builder: (context, snapshot) {
                                if (!snapshot.hasData) {
                                  return CustomWidgets.customLottieLoader();
                                }
                                final suggestions = snapshot.data as List; // Parse JSON
                                return ListView.builder(
                                  itemCount: suggestions.length,
                                  itemBuilder: (context, index) => ListTile(
                                    title: Text(suggestions[index], style: GoogleFonts.poppins(color: Color(0xFFFFFFFF))),
                                    onTap: () => Get.toNamed(Routes.HOME, arguments: {
                                      'tab': 1,
                                      'memeId': controller.memeModel.id,
                                      'suggestion': suggestions[index],
                                      'imageUrl': meme['imageUrl'],
                                    }),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: StreamBuilder(
                  stream: FirebaseFirestore.instance
                      .collection('comments')
                      .where('memeId', isEqualTo: controller.memeModel.id)
                      .snapshots(),
                  builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CustomWidgets.customLottieLoader());
                    }
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) => Animate(
                        effects: [SlideEffect(delay: Duration(milliseconds: index * 100))],
                        child: ListTile(
                          title: Text(
                            snapshot.data!.docs[index]['text'],
                            style: GoogleFonts.poppins(color: Color(0xFFFFFFFF)),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(8),
                child: CustomWidgets.customTextField(
                  controller: TextEditingController(),
                  label: "Add a comment...",
                  borderColor: Color(0xFF00FFAA),
                ).animate().fadeIn(),
              ),
            ],
          );
        },
      ),
    );
  }
}