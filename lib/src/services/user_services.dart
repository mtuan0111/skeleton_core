import 'dart:convert';

import 'package:skeleton_core/src/blocs/user/user_state.dart';
import 'package:skeleton_core/src/helpers/preferences_key.dart';
import 'package:skeleton_core/src/models/user_model.dart';
import 'package:skeleton_core/src/services/auth_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserServices {
  SharedPreferences? _prefs;
  final AuthServices _authServices = AuthServices();

  UserServices() {
    loadSharedPreferences();
  }

  Future<void> loadSharedPreferences() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<UserState> getUserSession() async {
    final username = _prefs?.getString(PreferencesKey.USERNAME);
    final clearedLevelsJson = _prefs?.getString(PreferencesKey.CLEARED_LEVELS);
    List<int> clearedLevels = [];
    if (clearedLevelsJson != null) {
      try {
        clearedLevels = List<int>.from(jsonDecode(clearedLevelsJson));
      } catch (e) {
        print('Error decoding clearedLevels: $e');
      }
    }

    String? userId;
    bool isAnonymous = true;

    if (_authServices.isOfflineMode) {
      userId = _authServices.offlineUserId;
      print('📱 User session (offline mode): $userId');
    } else {
      final firebaseUser = _authServices.currentUser;
      userId = firebaseUser?.uid;
      isAnonymous = firebaseUser?.isAnonymous ?? true;
      print('☁️ User session (online mode): $userId');
    }

    UserModel userModel = UserModel(
      username: username,
      firebaseUserId: userId,
      isAnonymous: isAnonymous,
      clearedLevels: clearedLevels,
    );

    return AuthenticatedUser(model: userModel);
  }

  Future<bool> saveUsername(String newUsername) async {
    return _prefs!.setString(PreferencesKey.USERNAME, newUsername);
  }

  Future<bool> saveClearedLevel(int level, List<int> currentLevels) async {
    if (currentLevels.contains(level)) return true;
    final newList = [...currentLevels, level];
    return _prefs!.setString(PreferencesKey.CLEARED_LEVELS, jsonEncode(newList));
  }

  /// Initialize anonymous authentication (works offline)
  Future<UserState> initializeAuth() async {
    if (!_authServices.isSignedIn()) {
      final userCredential = await _authServices.signInAnonymously();

      if (_authServices.isOfflineMode) {
        print('✅ Authenticated in offline mode');
      } else if (userCredential == null) {
        print('⚠️ Authentication failed, falling back to offline mode');
      }
    }

    return await getUserSession();
  }
}
