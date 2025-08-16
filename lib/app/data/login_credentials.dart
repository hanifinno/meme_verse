import 'package:get_storage/get_storage.dart';
import 'package:meme_verse/app/core/models/user_model.dart';

import '../core/config/app_storage.dart';

class LoginCredential {
  late final GetStorage _getStorage;
  LoginCredential() {
    _getStorage = GetStorage();
  }

  void saveUserData(UserModel model) {
    _getStorage.write(AppStorage.USER_DATA_KEY, model.toJson());
  }

  UserModel getUserData() {
    UserModel model = UserModel.fromJson(
      _getStorage.read(AppStorage.USER_DATA_KEY),
    );
    return model;
  }

  void saveToken(String token) {
    _getStorage.write(AppStorage.TOKEN_KEY, token);
  }

  String? getToken() {
    String? token = _getStorage.read(AppStorage.TOKEN_KEY);
    return token;
  }

  changeUserAuthState(bool isLoggedIn) {
    _getStorage.write(AppStorage.AUTH_STATE_KEY, isLoggedIn);
  }

  bool isUserLoggedIn() {
    bool? isLoggedIn = _getStorage.read(AppStorage.AUTH_STATE_KEY);
    return isLoggedIn ?? false;
  }

  void clearLoginCredential() {
    _getStorage.remove(AppStorage.AUTH_STATE_KEY);
    _getStorage.remove(AppStorage.TOKEN_KEY);
    _getStorage.remove(AppStorage.USER_DATA_KEY);
  }
}
