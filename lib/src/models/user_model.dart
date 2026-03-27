class UserModel {
  final String? username;
  final String? firebaseUserId;
  final bool isAnonymous;
  final List<int> clearedLevels;

  UserModel({
    this.username,
    this.firebaseUserId,
    this.isAnonymous = true,
    this.clearedLevels = const [],
  });

  UserModel copyWith({
    String? username,
    String? firebaseUserId,
    bool? isAnonymous,
    List<int>? clearedLevels,
  }) {
    return UserModel(
      username: username ?? this.username,
      firebaseUserId: firebaseUserId ?? this.firebaseUserId,
      isAnonymous: isAnonymous ?? this.isAnonymous,
      clearedLevels: clearedLevels ?? this.clearedLevels,
    );
  }
}
