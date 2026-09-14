import 'package:skeleton_core/src/models/user_model.dart';
import 'package:skeleton_core/src/services/auth_types.dart';

class UserState {
  final UserModel model;
  final String? greetingMessage;

  /// An SNS sign-in is in flight — the UI disables its buttons on this
  /// rather than tracking its own local loading flag.
  final bool isAuthenticating;

  /// l10n key of the last auth failure, or null. Services emit keys and the
  /// UI translates, so no Firebase type ever reaches a widget. Cleared via
  /// `AuthErrorCleared` once shown.
  final String? errorKey;

  /// The SNS identity the user just tried to link already belongs to a
  /// different account; the UI asks whether to switch to it, and answers
  /// with `AccountSwitchConfirmed` / `LinkConflictDismissed`.
  final bool shouldShowLinkConflict;
  final AuthMethod? linkConflictMethod;

  /// A guest session was just upgraded in place (same uid, so the player's
  /// leaderboard history follows them) — worth a confirmation toast.
  final bool shouldShowLinkSuccess;

  UserState({
    required this.model,
    this.greetingMessage,
    this.isAuthenticating = false,
    this.errorKey,
    this.shouldShowLinkConflict = false,
    this.linkConflictMethod,
    this.shouldShowLinkSuccess = false,
  });

  String? get username =>
      model.username?.isNotEmpty == true ? model.username : null;

  /// True while the session is an anonymous guest — the state in which the
  /// UI offers "sign in" rather than "signed in as …".
  bool get isGuest => !model.isSignedIn;

  /// Best label for the signed-in account: the SNS display name, else the
  /// email, else the locally-chosen username. Null while still a guest.
  String? get accountLabel {
    if (!model.isSignedIn) return null;
    final name = model.displayName;
    if (name != null && name.isNotEmpty) return name;
    final mail = model.email;
    if (mail != null && mail.isNotEmpty) return mail;
    return username;
  }

  /// [clearErrorKey], [clearLinkConflictMethod]: `??` can only ever *set* a
  /// field, so clearing one needs an explicit flag — without it a dismissed
  /// error would stick around forever and re-trigger the UI's listener on
  /// the next unrelated emit.
  UserState copyWith({
    String? username,
    UserModel? model,
    String? greetingMessage,
    bool? isAuthenticating,
    String? errorKey,
    bool clearErrorKey = false,
    bool? shouldShowLinkConflict,
    AuthMethod? linkConflictMethod,
    bool clearLinkConflictMethod = false,
    bool? shouldShowLinkSuccess,
  }) {
    return UserState(
      model: model ?? this.model.copyWith(username: username),
      greetingMessage: greetingMessage ?? this.greetingMessage,
      isAuthenticating: isAuthenticating ?? this.isAuthenticating,
      errorKey: clearErrorKey ? null : (errorKey ?? this.errorKey),
      shouldShowLinkConflict:
          shouldShowLinkConflict ?? this.shouldShowLinkConflict,
      linkConflictMethod: clearLinkConflictMethod
          ? null
          : (linkConflictMethod ?? this.linkConflictMethod),
      shouldShowLinkSuccess:
          shouldShowLinkSuccess ?? this.shouldShowLinkSuccess,
    );
  }
}

class UnAuthenticatedUser extends UserState {
  UnAuthenticatedUser({super.greetingMessage}) : super(model: UserModel());
}

class AuthenticatedUser extends UserState {
  AuthenticatedUser({
    required super.model,
    super.greetingMessage,
    super.isAuthenticating,
    super.errorKey,
    super.shouldShowLinkConflict,
    super.linkConflictMethod,
    super.shouldShowLinkSuccess,
  });

  /// Preserves the runtime type. [UserState.copyWith] builds a *base*
  /// [UserState], so without this override every copy of an authenticated
  /// session silently stopped being an [AuthenticatedUser] — and consumers
  /// that branch on the subtype (hasto's `HanoiGameBloc` gates its
  /// level-unlock check on `userState is AuthenticatedUser`) went quiet until
  /// the next emit that happened to come straight from
  /// `UserServices.getUserSession()`. The SNS flow made that reachable in
  /// normal use: `_authenticate` finishes with a `copyWith`, so signing in
  /// disabled unlock detection for the rest of the session.
  @override
  AuthenticatedUser copyWith({
    String? username,
    UserModel? model,
    String? greetingMessage,
    bool? isAuthenticating,
    String? errorKey,
    bool clearErrorKey = false,
    bool? shouldShowLinkConflict,
    AuthMethod? linkConflictMethod,
    bool clearLinkConflictMethod = false,
    bool? shouldShowLinkSuccess,
  }) {
    final base = super.copyWith(
      username: username,
      model: model,
      greetingMessage: greetingMessage,
      isAuthenticating: isAuthenticating,
      errorKey: errorKey,
      clearErrorKey: clearErrorKey,
      shouldShowLinkConflict: shouldShowLinkConflict,
      linkConflictMethod: linkConflictMethod,
      clearLinkConflictMethod: clearLinkConflictMethod,
      shouldShowLinkSuccess: shouldShowLinkSuccess,
    );
    return AuthenticatedUser(
      model: base.model,
      greetingMessage: base.greetingMessage,
      isAuthenticating: base.isAuthenticating,
      errorKey: base.errorKey,
      shouldShowLinkConflict: base.shouldShowLinkConflict,
      linkConflictMethod: base.linkConflictMethod,
      shouldShowLinkSuccess: base.shouldShowLinkSuccess,
    );
  }
}
