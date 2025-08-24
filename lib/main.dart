import 'package:ansicolor/ansicolor.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:meme_verse/app/core/config/app_constant.dart';
import 'package:meme_verse/app/core/theme/theme_service/theme_service.dart';
import 'package:meme_verse/firebase_options.dart';
import 'package:meme_verse/meme_verse.dart';
import 'package:meme_verse/app/utils/loader.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Supabase.initialize(
    url: AppConstant.SUPABASE_URL, // 👈 Project URL
    anonKey: AppConstant.SUPABASE_ANON_KEY, // 👈 anon key
  );
  await GetStorage.init();
  configLoader();
  // Initialize ThemeService
  ThemeService.instance.loadCachedTheme();
  ansiColorDisabled = false;
  runApp(const MemeVerse());
}
