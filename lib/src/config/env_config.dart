import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Environment configuration for shared game-shell settings.
///
/// Games should call [SkeletonEnvConfig.init()] during startup after `dotenv.load()`.
class SkeletonEnvConfig {
  static SkeletonEnvConfig? _instance;

  final String profileUrl;
  final String privacyPolicyUrl;
  final String facebookUrl;
  final String emailContact;
  final String firebaseProjectId;
  final String androidPackageName;
  final String iosBundleId;
  final String iosAppId;

  SkeletonEnvConfig._({
    required this.profileUrl,
    required this.privacyPolicyUrl,
    required this.facebookUrl,
    required this.emailContact,
    required this.firebaseProjectId,
    required this.androidPackageName,
    required this.iosBundleId,
    required this.iosAppId,
  });

  /// Initialize from dotenv values. Call after `dotenv.load()`.
  static void init() {
    _instance = SkeletonEnvConfig._(
      profileUrl: dotenv.env['PROFILE_URL'] ?? '',
      privacyPolicyUrl: dotenv.env['PRIVACY_POLICY_URL'] ?? '',
      facebookUrl: dotenv.env['FACEBOOK_URL'] ?? '',
      emailContact: dotenv.env['EMAIL_CONTACT'] ?? '',
      firebaseProjectId: dotenv.env['FIREBASE_PROJECT_ID'] ?? '',
      androidPackageName: dotenv.env['ANDROID_PACKAGE_NAME'] ?? '',
      iosBundleId: dotenv.env['IOS_BUNDLE_ID'] ?? '',
      iosAppId: dotenv.env['IOS_APP_ID'] ?? '',
    );
  }

  /// Initialize with explicit values (useful for testing or non-dotenv setups).
  static void initWith({
    String profileUrl = '',
    String privacyPolicyUrl = '',
    String facebookUrl = '',
    String emailContact = '',
    String firebaseProjectId = '',
    String androidPackageName = '',
    String iosBundleId = '',
    String iosAppId = '',
  }) {
    _instance = SkeletonEnvConfig._(
      profileUrl: profileUrl,
      privacyPolicyUrl: privacyPolicyUrl,
      facebookUrl: facebookUrl,
      emailContact: emailContact,
      firebaseProjectId: firebaseProjectId,
      androidPackageName: androidPackageName,
      iosBundleId: iosBundleId,
      iosAppId: iosAppId,
    );
  }

  static SkeletonEnvConfig get instance {
    if (_instance == null) {
      throw StateError(
        'SkeletonEnvConfig has not been initialized. '
        'Call SkeletonEnvConfig.init() or SkeletonEnvConfig.initWith() first.',
      );
    }
    return _instance!;
  }
}
