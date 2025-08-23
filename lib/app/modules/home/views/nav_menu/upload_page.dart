import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:meme_verse/app/core/widgets/custom_widgets.dart';
import 'package:meme_verse/app/modules/home/controllers/home_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meme_verse/app/routes/app_pages.dart';

class UploadMemePage extends GetView<HomeController> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Color(0xFF121212),
        title: Text("Upload Meme", style: GoogleFonts.poppins(color: Color(0xFFFFFFFF), fontWeight: FontWeight.bold)),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            Obx(() {
              return controller.pickedFile.value != null
                  ? Animate(
                      effects: [ScaleEffect(duration: Duration(milliseconds: 300), curve: Curves.bounceOut)],
                      child: Image.file(controller.pickedFile.value!, height: 200, fit: BoxFit.cover),
                    )
                  : Container(
                      height: 200,
                      decoration: BoxDecoration(
                        color: Color(0xFF1E1E1E),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Center(child: Text("No image selected", style: GoogleFonts.poppins(color: Color(0xFFB0B0B0)))),
                    );
            }),
            SizedBox(height: 16),
            CustomWidgets.customTextField(
              controller: controller.titleController,
              label: "Meme Description",
            ),
            SizedBox(height: 16),
            CustomWidgets.customButton(
              label: "Generate Caption with AI",
              onPressed: () async {
                // if (controller.pickedFile.value != null) {
                //   final response = await http.get(
                //     Uri.parse('https://your-firebase-function/generateMemeCaption?imageUrl=${controller.imageUrl}'),
                //   );
                //   final captions = response.body as List; // Parse JSON
                //   Get.bottomSheet(
                //     Animate(
                //       effects: [SlideEffect(begin: Offset(0, 1), end: Offset(0, 0), duration: Duration(milliseconds: 300))],
                //       child: Container(
                //         decoration: BoxDecoration(
                //           color: Color(0xFF1E1E1E),
                //           borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
                //         ),
                //         child: ListView.builder(
                //           itemCount: captions.length,
                //           itemBuilder: (context, index) => ListTile(
                //             title: Text(captions[index], style: GoogleFonts.poppins(color: Color(0xFFFFFFFF))),
                //             onTap: () {
                //               controller.titleController.text = captions[index];
                //               Get.back();
                //             },
                //           ),
                //         ),
                //       ),
                //     ),
                //   );
                // }
              },
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                CustomWidgets.customButton(
                  label: "Pick Image",
                  onPressed: () async => await controller.pickImage(),
                ),
                Obx(() {
                  return controller.isLoading.value
                      ? CustomWidgets.customLottieLoader()
                      : CustomWidgets.customButton(
                          label: "Upload",
                          onPressed: () {
                            controller.uploadMeme();
                            Get.offNamed(Routes.HOME);
                          },
                        );
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }
}