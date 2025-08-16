import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:meme_verse/app/core/config/app_constant.dart';
import 'package:meme_verse/app/routes/app_pages.dart';

class LoginController extends GetxController {
  static LoginController instance = Get.find();

  late Rx<User?> firebaseUser;
  final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn.instance;

  // Replace with your Web client ID from Firebase (Android needs serverClientId)
  final String? serverClientId = AppConstant.SERVER_CLIENT_ID;

  @override
  void onInit() {
    super.onInit();

    // Initialize GoogleSignIn
    googleSignIn.initialize(serverClientId: serverClientId);

    // Bind Firebase user
    firebaseUser = Rx<User?>(auth.currentUser);
    firebaseUser.bindStream(auth.userChanges());

    // Listen to Google authentication events
    googleSignIn.authenticationEvents.listen((event) async {
      if (event is GoogleSignInAuthenticationEventSignIn) {
        await _firebaseSignInWithGoogle(event.user);
      } else if (event is GoogleSignInAuthenticationEventSignOut) {
        await signOut();
      }
    });

    // Navigate based on auth state
    ever(firebaseUser, _setInitialScreen);

    // Optional: Attempt lightweight sign-in
    googleSignIn.attemptLightweightAuthentication();
  }

  void _setInitialScreen(User? user) {
    if (user == null) {
      Get.offAllNamed(Routes.LOGIN);
    } else {
      Get.offAllNamed(Routes.HOME);
    }
  }

  Future<void> signInWithGoogle() async {
    try {
      if (googleSignIn.supportsAuthenticate()) {
        await googleSignIn.authenticate(); // triggers authenticationEvents
      } else {
        Get.snackbar(
          'Error',
          'Platform requires platform-specific sign-in UI',
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        'Error',
        'Sign-in failed: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<void> _firebaseSignInWithGoogle(GoogleSignInAccount? user) async {
    if (user == null) return;

    final GoogleSignInAuthentication googleAuth = await user.authentication;
    final credential = GoogleAuthProvider.credential(
      idToken: googleAuth.idToken,
      // accessToken: googleAuth.accessToken,
    );

    await auth.signInWithCredential(credential);
  }

  Future<void> signOut() async {
    await auth.signOut();
    await googleSignIn.signOut();
  }
}
