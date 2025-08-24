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
              CustomWidgets.customButton(
                label: "Pick Image & Generate Caption",
                onPressed: () async {
                  try {
                    // 1. Pick image
                    final picked = await ImagePicker().pickImage(
                      source: ImageSource.gallery,
                    );
                    if (picked == null) {
                      Get.snackbar('Error', 'No image selected');
                      return;
                    }

                    controller.pickedFile.value = File(picked.path);
                    controller.isLoading.value = true;

                    // 2. Temporarily upload image to public bucket
                    final tempFileName =
                        'temp_${DateTime.now().millisecondsSinceEpoch}.jpg';
                    await supabase.storage
                        .from('memes-temp')
                        .upload(
                          tempFileName,
                          controller.pickedFile.value!,
                          fileOptions: const FileOptions(upsert: true),
                        );

                    final tempUrl = supabase.storage
                        .from('memes-temp')
                        .getPublicUrl(tempFileName);

                    // 3. Send form-data to Edge Function
                    final uri = Uri.parse(
                      'https://cicipihemdigpsthnibk.supabase.co/functions/v1/meme-captions', // Updated to match function name
                    );
                    final request = http.MultipartRequest('POST', uri)
                      ..headers['Authorization'] =
                          'Bearer ${AppConstant.SUPABASE_ANON_KEY}'
                      ..fields['imageUrl'] = tempUrl;

                    final streamedResponse = await request.send();
                    final response = await http.Response.fromStream(
                      streamedResponse,
                    );

                    // 4. Handle response
                    if (response.statusCode != 200) {
                      Get.snackbar(
                        'Error',
                        'Failed to generate captions: ${response.body}',
                      );
                      return;
                    }

                    final data = jsonDecode(response.body);
                    final captions = (data['captions'] as List<dynamic>)
                        .map((e) => e.toString())
                        .toList();

                    if (captions.isEmpty) {
                      Get.snackbar('Error', 'No captions generated');
                      return;
                    }

                    // 5. Show bottom sheet for caption selection
                    await Get.bottomSheet(
                      Animate(
                        effects: [
                          SlideEffect(
                            begin: const Offset(0, 1),
                            end: const Offset(0, 0),
                            duration: const Duration(milliseconds: 300),
                          ),
                        ],
                        child: Container(
                          decoration: const BoxDecoration(
                            color: Color(0xFF1E1E1E),
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(24),
                            ),
                          ),
                          child: ListView.builder(
                            itemCount: captions.length,
                            itemBuilder: (context, index) => ListTile(
                              title: Text(
                                captions[index],
                                style: GoogleFonts.poppins(color: Colors.white),
                              ),
                              onTap: () {
                                controller.titleController.text =
                                    captions[index];
                                Get.back();
                              },
                            ),
                          ),
                        ),
                      ),
                      backgroundColor: Colors.transparent,
                    );

                    // 6. Remove temp image
                    await supabase.storage.from('memes-temp').remove([
                      tempFileName,
                    ]);
                  } catch (e) {
                    Get.snackbar('Error', 'Something went wrong: $e');
                  } finally {
                    controller.isLoading.value = false;
                  }
                },
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
