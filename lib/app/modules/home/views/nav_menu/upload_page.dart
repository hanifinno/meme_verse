import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meme_verse/app/core/config/app_constant.dart';
import 'package:meme_verse/app/core/widgets/custom_widgets.dart';
import 'package:meme_verse/app/modules/home/controllers/home_controller.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:meme_verse/app/routes/app_pages.dart';
import 'package:http/http.dart' as http;
import 'package:supabase_flutter/supabase_flutter.dart';

class UploadMemePage extends GetView<HomeController> {
  const UploadMemePage({super.key});

  @override
  Widget build(BuildContext context) {
    final supabase = Supabase.instance.client;

    return Scaffold(
      backgroundColor: Color(0xFF121212),
      appBar: AppBar(
        backgroundColor: Color(0xFF121212),
        title: Text(
          "Upload Meme",
          style: GoogleFonts.poppins(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            children: [
              // IMAGE PREVIEW
              Obx(() {
                return controller.pickedFile.value != null
                    ? Animate(
                        effects: [
                          ScaleEffect(
                            duration: Duration(milliseconds: 300),
                            curve: Curves.bounceOut,
                          ),
                        ],
                        child: Image.file(
                          controller.pickedFile.value!,
                          height: 200,
                          fit: BoxFit.cover,
                        ),
                      )
                    : Container(
                        height: 200,
                        decoration: BoxDecoration(
                          color: Color(0xFF1E1E1E),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            "No image selected",
                            style: GoogleFonts.poppins(
                              color: Color(0xFFB0B0B0),
                            ),
                          ),
                        ),
                      );
              }),

              SizedBox(height: 16),

              // MEME DESCRIPTION
              CustomWidgets.customTextField(
                controller: controller.titleController,
                label: "Meme Description",
              ),

              SizedBox(height: 16),

              // PICK IMAGE & GENERATE CAPTION
              // In your upload_page.dart

              // Button to pick an image from the gallery
              CustomWidgets.customButton(
                label: "Pick Image",
                onPressed: controller.pickImage,
              ),

              const SizedBox(height: 16),

              // Button to generate captions for the picked image
              // It's wrapped in an Obx to be enabled/disabled based on whether an image is picked.
              CustomWidgets.customButton(
                label: "Generate AI Caption",
                onPressed: controller.generateCaptionsForImage,
              ),

              const SizedBox(height: 16),

              // Your existing text field for the title/caption
              // e.g., CustomTextField(controller: controller.titleController, ...)
              const SizedBox(height: 16),

              // Your existing button to perform the final upload
              CustomWidgets.customButton(
                label: "Upload Meme",
                onPressed: controller.uploadMeme,
              ),

              SizedBox(height: 16),

              // PICK IMAGE ONLY
              CustomWidgets.customButton(
                label: "Pick Image",
                onPressed: () async => await controller.pickImage(),
              ),

              SizedBox(height: 16),

              // UPLOAD MEME
              Obx(() {
                return controller.isLoading.value
                    ? CustomWidgets.customLottieLoader()
                    : CustomWidgets.customButton(
                        label: "Upload Meme",
                        onPressed: () async {
                          await controller.uploadMeme();
                          Get.offNamed(Routes.HOME);
                        },
                      );
              }),
            ],
          ),
        ),
      ),
    );
  }
}
