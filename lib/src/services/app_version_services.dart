import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:skeleton_core/src/models/app_version_model.dart';
import 'package:package_info_plus/package_info_plus.dart';

class AppVersionServices {
  late final FirebaseFirestore? _firestore;
  static const String collectionName = 'app_versions';
  bool _isOfflineMode = false;

  AppVersionServices() {
    try {
      _firestore = FirebaseFirestore.instance;
    } catch (e) {
      print('⚠️ Firestore not available (offline mode): $e');
      _firestore = null;
      _isOfflineMode = true;
    }
  }

  String getCurrentPlatform() {
    if (Platform.isAndroid) {
      return 'android';
    } else if (Platform.isIOS) {
      return 'iOS';
    }
    return 'unknown';
  }

  Future<PackageInfo> getCurrentAppVersion() async {
    return await PackageInfo.fromPlatform();
  }

  Future<int> getCurrentBuildNumber() async {
    final packageInfo = await getCurrentAppVersion();
    return int.tryParse(packageInfo.buildNumber) ?? 0;
  }

  Future<List<AppVersionModel>> fetchVersionsForPlatform() async {
    if (_isOfflineMode || _firestore == null) {
      print('📱 App version check skipped (offline mode)');
      return [];
    }

    try {
      final platform = getCurrentPlatform();
      final querySnapshot = await _firestore
          .collection(collectionName)
          .where('platform', isEqualTo: platform)
          .orderBy('build_number', descending: true)
          .get();

      return querySnapshot.docs
          .map((doc) => AppVersionModel.fromJson(doc.data()))
          .toList();
    } catch (e) {
      print('⚠️ Failed to fetch app versions (falling back to offline): $e');
      _isOfflineMode = true;
      return [];
    }
  }

  Future<AppVersionModel?> checkForUpdate() async {
    if (_isOfflineMode) {
      print('📱 Update check skipped (offline mode)');
      return null;
    }

    try {
      final currentBuildNumber = await getCurrentBuildNumber();
      final versions = await fetchVersionsForPlatform();

      if (versions.isEmpty) {
        return null;
      }

      final forceUpdate = versions.firstWhere(
        (version) =>
            version.isForceUpdate &&
            version.buildNumberInt > currentBuildNumber,
        orElse: () => versions.first,
      );

      if (forceUpdate.isForceUpdate &&
          forceUpdate.buildNumberInt > currentBuildNumber) {
        return forceUpdate;
      }

      final latestVersion = versions.first;
      if (latestVersion.buildNumberInt > currentBuildNumber) {
        return latestVersion;
      }

      return null;
    } catch (e) {
      print('⚠️ Failed to check for updates (falling back to offline): $e');
      _isOfflineMode = true;
      return null;
    }
  }

  bool isNewerVersion(String remoteBuildNumber, String currentBuildNumber) {
    final remoteInt = int.tryParse(remoteBuildNumber) ?? 0;
    final currentInt = int.tryParse(currentBuildNumber) ?? 0;
    return remoteInt > currentInt;
  }

  Future<AppVersionModel?> getLatestVersion() async {
    if (_isOfflineMode) {
      print('📱 Latest version check skipped (offline mode)');
      return null;
    }

    try {
      final versions = await fetchVersionsForPlatform();
      return versions.isNotEmpty ? versions.first : null;
    } catch (e) {
      print('⚠️ Failed to get latest version (falling back to offline): $e');
      _isOfflineMode = true;
      return null;
    }
  }
}
