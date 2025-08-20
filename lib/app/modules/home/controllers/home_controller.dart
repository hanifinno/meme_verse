import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meme_verse/app/core/models/meme_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:meme_verse/app/routes/app_pages.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;
  var feedList = <MemeModel>[].obs;

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
        // Handle permission denial (e.g., show a dialog)
        print('Gallery permission denied');
        return;
      }

      // Pick image from gallery
      final picker = ImagePicker();
      final picked = await picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800, // Limit size to reduce memory usage
        maxHeight: 800,
        imageQuality: 85, // Compress image to reduce file size
      );

      if (picked != null) {
        // Process file in an isolate to avoid blocking the main thread
        final file = await compute(_processImage, picked.path);
        pickedFile.value = file;
      } else {
        print('No image selected');
      }
    } catch (e) {
      print('Error picking image: $e');
      // Optionally show a user-friendly error message
    }
  }

  // Process image in a separate isolate
  File _processImage(String path) {
    return File(path);
  }

  /// Upload meme
  Future<void> uploadMeme() async {
    if (pickedFile.value == null || titleController.text.isEmpty) {
      Get.snackbar("Error", "Please select image and add description");
      return;
    }

    try {
      isLoading.value = true;

      // Upload image to Firebase Storage
      String fileName = DateTime.now().millisecondsSinceEpoch.toString();
      Reference ref = FirebaseStorage.instance.ref().child(
        "memes/$fileName.jpg",
      );
      await ref.putFile(pickedFile.value!);

      String downloadUrl = await ref.getDownloadURL();

      // Add into Firestore under "memes" collection
      await FirebaseFirestore.instance
          .collection("memes")
          .doc("defaultMemeId")
          .update({
            "memeList": FieldValue.arrayUnion([
              {
                "imageUrl": downloadUrl,
                "title": titleController.text,
                "likeCount": 0,
              },
            ]),
          });

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
