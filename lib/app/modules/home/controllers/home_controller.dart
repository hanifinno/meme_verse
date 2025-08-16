import 'package:get/get.dart';
import 'package:meme_verse/app/core/models/meme_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

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
      final snapshot = await FirebaseFirestore.instance.collection('memes').get();

      final List<MemeModel> memes = [];

      for (var doc in snapshot.docs) {
        final memeList = doc['memeList'] as List<dynamic>? ?? [];
        for (var meme in memeList) {
          memes.add(MemeModel(
            id: doc.id, // optionally append index for unique ID
            imageUrl: meme['imageUrl'] ?? '',
            title: meme['title'] ?? '',
            likeCount: meme['likeCount'] ?? 0,
          ));
        }
      }

      feedList.assignAll(memes);
    } catch (e) {
      print("Error fetching memes: $e");
    }
  }
}
  // Future<void> refreshFeed() async {
  //   // TODO: Fetch memes from backend or local storage
  //   await Future.delayed(const Duration(seconds: 1));
  //   feedList.assignAll([
  //     MemeModel(
  //       id: '1',
  //       imageUrl: 'https://i.imgflip.com/1ur9b0.jpg',
  //       likeCount: 10,
  //       title: 'Funny Meme 1',
  //     ),
  //     MemeModel(
  //       id: '2',
  //       imageUrl: 'https://i.imgflip.com/26am.jpg',
  //       likeCount: 25,
  //       title: 'Funny Meme 2',
  //     ),
  //   ]);
  // }

