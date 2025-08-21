import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meme_verse/app/core/models/meme_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:meme_verse/app/routes/app_pages.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;
  var feedList = <MemeModel>[].obs;
  final firestore = FirebaseFirestore.instance;
  void changeTab(int index) {
    currentIndex.value = index;
  }

  @override
  void onInit() {
    super.onInit();
    // Fetch feed when controller initializes
    refreshFeed();
  }

  Future<void> refreshFeed() async {
    try {
      // Get all documents in "memes" collection
      final snapshot = await FirebaseFirestore.instance
          .collection('memes')
          .get();

      final List<MemeModel> memes = [];

      for (var doc in snapshot.docs) {
        final memeList = doc['memeList'] as List<dynamic>? ?? [];
        for (var meme in memeList) {
          memes.add(
            MemeModel(
              id: doc.id, // optionally append index for unique ID
              imageUrl: meme['imageUrl'] ?? '',
              title: meme['title'] ?? '',
              likeCount: meme['likeCount'] ?? 0,
            ),
          );
        }
      }

      feedList.assignAll(memes);
    } catch (e) {
      debugPrint("Error fetching memes: $e");
    }
  }

  final titleController = TextEditingController();
  var pickedFile = Rx<File?>(null);
  var isLoading = false.obs;

  final ImagePicker _picker = ImagePicker();

  Future<void> pickImage() async {
    try {
      // Check and request gallery permission
      final permissionStatus = await Permission.photos.request();
      if (!permissionStatus.isGranted) {
        print('Gallery permission denied');
        return;
      }

      // Pick image from gallery
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800, // Limit size
        maxHeight: 800,
        imageQuality: 85, // Compress for JPGs
      );

      if (picked != null) {
        pickedFile.value = File(picked.path);
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  /// Upload meme
  ///
  final supabase = Supabase.instance.client;

  Future<void> uploadMeme(
    // TextEditingController titleController,
    // Rx<File?> pickedFile,
    // RxBool isLoading,
  ) async {
    if (pickedFile.value == null || titleController.text.isEmpty) {
      Get.snackbar("Error", "Please select image and add description");
      return;
    }

    try {
      isLoading.value = true;

      // Generate a safe filename
      String fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
      debugPrint('File Name ::: $fileName');

      // Upload to Supabase Storage
      final file = pickedFile.value!;
      await supabase.storage.from("memes").upload(fileName, file);

      // Get public URL
      final publicUrl = supabase.storage.from("memes").getPublicUrl(fileName);

      // 3. Save to Firestore using .set()
      final docRef = firestore.collection("memes").doc('memeId');

      await docRef.set({
        "memeList": FieldValue.arrayUnion([
          {
            "imageUrl": publicUrl,
            "title": titleController.text,
            // "createdAt": FieldValue.serverTimestamp(),
          },
        ]),
      }, SetOptions(merge: true)); // merge = update if exists, else create

      Get.snackbar("Success", "Meme uploaded!");
      titleController.clear();
      pickedFile.value = null;
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  GoogleSignIn googleSignIn = GoogleSignIn.instance;
  Future<void> signOut() async {
    try {
      // Sign out from Firebase
      await FirebaseAuth.instance.signOut();

      // Sign out from Google

      await googleSignIn.signOut();
      Get.offAllNamed(Routes.LOGIN);

      debugPrint("✅ User signed out successfully");
    } catch (e) {
      debugPrint("❌ Error signing out: $e");
    }
  }
}
