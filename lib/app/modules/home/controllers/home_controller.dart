// import 'package:firebase_auth/firebase_auth.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:google_sign_in/google_sign_in.dart';
// import 'package:meme_verse/app/core/models/meme_model.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'dart:io';
// import 'package:image_picker/image_picker.dart';
// import 'package:meme_verse/app/routes/app_pages.dart';
// import 'package:permission_handler/permission_handler.dart';
// import 'package:supabase_flutter/supabase_flutter.dart';

// class HomeController extends GetxController {
//   var currentIndex = 0.obs;
//   var feedList = <MemeModel>[].obs;
//   final firestore = FirebaseFirestore.instance;
//   void changeTab(int index) {
//     currentIndex.value = index;
//   }

//   @override
//   void onInit() {
//     super.onInit();
//     // Fetch feed when controller initializes
//     refreshFeed();
//   }

//   Future<void> refreshFeed() async {
//     try {
//       // Get all documents in "memes" collection
//       final snapshot = await FirebaseFirestore.instance
//           .collection('memes')
//           .get();

//       final List<MemeModel> memes = [];

//       for (var doc in snapshot.docs) {
//         final memeList = doc['memeList'] as List<dynamic>? ?? [];
//         for (var meme in memeList) {
//           memes.add(
//             MemeModel(
//               id: doc.id, // optionally append index for unique ID
//               imageUrl: meme['imageUrl'] ?? '',
//               title: meme['title'] ?? '',
//               likeCount: meme['likeCount'] ?? 0,
//             ),
//           );
//         }
//       }

//       feedList.assignAll(memes);
//     } catch (e) {
//       debugPrint("Error fetching memes: $e");
//     }
//   }

//   final titleController = TextEditingController();
//   var pickedFile = Rx<File?>(null);
//   var isLoading = false.obs;

//   final ImagePicker _picker = ImagePicker();

//   Future<void> pickImage() async {
//     try {
//       // Check and request gallery permission
//       final permissionStatus = await Permission.photos.request();
//       if (!permissionStatus.isGranted) {
//         print('Gallery permission denied');
//         return;
//       }

//       // Pick image from gallery
//       final picked = await _picker.pickImage(
//         source: ImageSource.gallery,
//         maxWidth: 800, // Limit size
//         maxHeight: 800,
//         imageQuality: 85, // Compress for JPGs
//       );

//       if (picked != null) {
//         pickedFile.value = File(picked.path);
//       } else {
//         print('No image selected');
//       }
//     } catch (e) {
//       print('Error picking image: $e');
//     }
//   }

//   /// Upload meme
//   ///
//   final supabase = Supabase.instance.client;

//   Future<void> uploadMeme(
//     // TextEditingController titleController,
//     // Rx<File?> pickedFile,
//     // RxBool isLoading,
//   ) async {
//     if (pickedFile.value == null || titleController.text.isEmpty) {
//       Get.snackbar("Error", "Please select image and add description");
//       return;
//     }

//     try {
//       isLoading.value = true;

//       // Generate a safe filename
//       String fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
//       debugPrint('File Name ::: $fileName');

//       // Upload to Supabase Storage
//       final file = pickedFile.value!;
//       await supabase.storage.from("memes").upload(fileName, file);

//       // Get public URL
//       final publicUrl = supabase.storage.from("memes").getPublicUrl(fileName);

//       // 3. Save to Firestore using .set()
//       final docRef = firestore.collection("memes").doc('memeId');

//       await docRef.set({
//         "memeList": FieldValue.arrayUnion([
//           {
//             "imageUrl": publicUrl,
//             "title": titleController.text,
//             // "createdAt": FieldValue.serverTimestamp(),
//           },
//         ]),
//       }, SetOptions(merge: true)); // merge = update if exists, else create

//       Get.snackbar("Success", "Meme uploaded!");
//       titleController.clear();
//       pickedFile.value = null;
//     } catch (e) {
//       Get.snackbar("Error", e.toString());
//     } finally {
//       isLoading.value = false;
//     }
//   }

//   GoogleSignIn googleSignIn = GoogleSignIn.instance;
//   Future<void> signOut() async {
//     try {
//       // Sign out from Firebase
//       await FirebaseAuth.instance.signOut();

//       // Sign out from Google

//       await googleSignIn.signOut();
//       Get.offAllNamed(Routes.LOGIN);

//       debugPrint("✅ User signed out successfully");
//     } catch (e) {
//       debugPrint("❌ Error signing out: $e");
//     }
//   }
// }

import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:meme_verse/app/core/config/app_constant.dart';
import 'package:meme_verse/app/core/models/meme_model.dart';
import 'package:meme_verse/app/core/theme/color/app_colors.dart';
import 'package:meme_verse/app/routes/app_pages.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class HomeController extends GetxController {
  var currentIndex = 0.obs;
  var feedList = <MemeModel>[].obs;
  var trendingList = <MemeModel>[].obs;
  var recommendations = <Map<String, dynamic>>[].obs;
  var isLoading = false.obs;
  final firestore = FirebaseFirestore.instance;
  final supabase = Supabase.instance.client;
  final ImagePicker _picker = ImagePicker();
  final titleController = TextEditingController();
  var pickedFile = Rx<File?>(null);
  String get userId => FirebaseAuth.instance.currentUser?.uid ?? '';

  @override
  void onInit() {
    super.onInit();
    // Fetch feeds and recommendations on initialization
    refreshFeed();
    refreshTrending();
    fetchRecommendations();
  }

  void changeTab(int index) {
    currentIndex.value = index;
  }

  Future<void> refreshFeed() async {
    try {
      isLoading.value = true;
      final snapshot = await firestore.collection('memes').get();
      final List<MemeModel> memes = [];
      for (var doc in snapshot.docs) {
        final memeList = doc['memeList'] as List<dynamic>? ?? [];
        for (var meme in memeList) {
          if (meme['isTrending'] == false || meme['isTrending'] == null) {
            memes.add(MemeModel(
              id: doc.id,
              imageUrl: meme['imageUrl'] ?? '',
              title: meme['title'] ?? '',
              likeCount: meme['likeCount'] ?? 0,
            ));
          }
        }
      }
      feedList.assignAll(memes);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load feed: $e',
        backgroundColor: AppColors.RED_COLOR,
        colorText: AppColors.WHITE_COLOR,
      );
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refreshTrending() async {
    try {
      isLoading.value = true;
      final snapshot = await firestore.collection('memes').get();
      final List<MemeModel> memes = [];
      for (var doc in snapshot.docs) {
        final memeList = doc['memeList'] as List<dynamic>? ?? [];
        for (var meme in memeList) {
          if (meme['isTrending'] == true) {
            memes.add(MemeModel(
              id: doc.id,
              imageUrl: meme['imageUrl'] ?? '',
              title: meme['title'] ?? '',
              likeCount: meme['likeCount'] ?? 0,
            ));
          }
        }
      }
      trendingList.assignAll(memes);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to load trending memes: $e',
        backgroundColor: AppColors.RED_COLOR,
        colorText: AppColors.WHITE_COLOR,
      );
    } finally {
      isLoading.value = false;
    }
  }

 Future<void> fetchRecommendations() async {
  try {
    isLoading.value = true;

    // Replace with your Supabase function URL
    final supabaseFunctionUrl =
        'https://cicipihemdigpsthnibk.functions.supabase.co/recommendMemes?userId=$userId';

    final response = await http.get(Uri.parse(supabaseFunctionUrl), headers: {
    'Authorization': 'Bearer ${AppConstant.SUPABASE_ANON_KEY}',
  },);

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body) as List<dynamic>;
      recommendations.assignAll(data.cast<Map<String, dynamic>>());
    } else {
      Get.snackbar(
        'Error',
        'Failed to load recommendations: ${response.statusCode}',
        backgroundColor: AppColors.RED_COLOR,
        colorText: AppColors.WHITE_COLOR,
      );
    }
  } catch (e) {
    Get.snackbar(
      'Error',
      'Error fetching recommendations: $e',
      backgroundColor: AppColors.RED_COLOR,
      colorText: AppColors.WHITE_COLOR,
    );
  } finally {
    isLoading.value = false;
  }
}

  Future<void> pickImage() async {
    try {
      final permissionStatus = await Permission.photos.request();
      if (!permissionStatus.isGranted) {
        Get.snackbar(
          'Error',
          'Gallery permission denied',
          backgroundColor: AppColors.RED_COLOR,
          colorText: AppColors.WHITE_COLOR,
        );
        return;
      }
      final picked = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 800,
        maxHeight: 800,
        imageQuality: 85,
      );
      if (picked != null) {
        pickedFile.value = File(picked.path);
      } else {
        Get.snackbar(
          'Info',
          'No image selected',
          backgroundColor: AppColors.GREY_TEXT_COLOR,
          colorText: AppColors.WHITE_COLOR,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error picking image: $e',
        backgroundColor: AppColors.RED_COLOR,
        colorText: AppColors.WHITE_COLOR,
      );
    }
  }

  Future<void> uploadMeme() async {
    if (pickedFile.value == null || titleController.text.isEmpty) {
      Get.snackbar(
        'Error',
        'Please select an image and add a title',
        backgroundColor: AppColors.RED_COLOR,
        colorText: AppColors.WHITE_COLOR,
      );
      return;
    }
    try {
      isLoading.value = true;
      final fileName = '${DateTime.now().millisecondsSinceEpoch}.jpg';
      final file = pickedFile.value!;
      await supabase.storage.from('memes').upload(fileName, file);
      final publicUrl = supabase.storage.from('memes').getPublicUrl(fileName);
      final docRef = firestore.collection('memes').doc('memeId');
      await docRef.set({
        'memeList': FieldValue.arrayUnion([
          {
            'imageUrl': publicUrl,
            'title': titleController.text,
            'likeCount': 0,
            'isTrending': false,
            'createdAt': FieldValue.serverTimestamp(),
          },
        ]),
      }, SetOptions(merge: true));
      Get.snackbar(
        'Success',
        'Meme uploaded successfully!',
        backgroundColor: AppColors.PRIMARY_COLOR,
        colorText: AppColors.BUTTON_TEXT_COLOR,
      );
      titleController.clear();
      pickedFile.value = null;
      await refreshFeed(); // Refresh feed after upload
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error uploading meme: $e',
        backgroundColor: AppColors.RED_COLOR,
        colorText: AppColors.WHITE_COLOR,
      );
    } finally {
      isLoading.value = false;
    }
  }
 GoogleSignIn googleSignIn = GoogleSignIn.instance;
  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      await googleSignIn.signOut();
      Get.offAllNamed(Routes.LOGIN);
      Get.snackbar(
        'Success',
        'Signed out successfully',
        backgroundColor: AppColors.PRIMARY_COLOR,
        colorText: AppColors.BUTTON_TEXT_COLOR,
      );
    } catch (e) {
      Get.snackbar(
        'Error',
        'Error signing out: $e',
        backgroundColor: AppColors.RED_COLOR,
        colorText: AppColors.WHITE_COLOR,
      );
    }
  }
}
