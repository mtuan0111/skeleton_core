class UserModel {
  final String? username;
  final String? firebaseUserId;
  final bool isAnonymous;
  final List<int> clearedLevels;
  final bool isAutomationPlay;

  /// Email and display name of the linked SNS account (Google/Apple), when
  /// the session is no longer anonymous. Both stay null for a guest session,
  /// and Apple only supplies them on the *first* authorization — see
  /// `AuthServices.signInWithApple`.
  final String? email;
  final String? displayName;

  UserModel({
    this.username,
    this.firebaseUserId,
    this.isAnonymous = true,
    this.clearedLevels = const [],
    this.isAutomationPlay = false,
    this.email,
    this.displayName,
  });

  /// Whether this session is backed by a real SNS identity rather than an
  /// anonymous guest — the single check the UI uses to decide between
  /// "sign in" and "signed in as …".
  bool get isSignedIn => firebaseUserId != null && !isAnonymous;

  UserModel copyWith({
    String? username,
    String? firebaseUserId,
    bool? isAnonymous,
    List<int>? clearedLevels,
    bool? isAutomationPlay,
    String? email,
    String? displayName,
  }) {
    return UserModel(
      username: username ?? this.username,
      firebaseUserId: firebaseUserId ?? this.firebaseUserId,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      clearedLevels: clearedLevels ?? this.clearedLevels,
      isAutomationPlay: isAutomationPlay ?? this.isAutomationPlay,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
    );
  }
}
