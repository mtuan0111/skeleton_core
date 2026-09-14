import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, TargetPlatform;

/// Provider-agnostic auth vocabulary, ported from `mind_compass`'s
/// `lib/services/auth_service.dart` so both apps describe an SNS sign-in the
/// same way.
///
/// The one deliberate difference: mind_compass splits an abstract
/// `AuthService` contract from its `FirebaseAuthService` implementation (it
/// injects fakes in tests). skeleton_core already has a single concrete
/// [AuthServices], used directly by two apps, so the Google/Apple methods
/// were added there instead and only the *types* live here. The flow —
/// link-or-sign-in, cancel-is-not-an-error, conflict-then-confirm-switch —
/// is identical.

/// The provider behind a sign-in/link attempt. Carried on [AuthLinkConflict]
/// (which method is in conflict) rather than re-derived at each call site.
enum AuthMethod { anonymous, google, apple }

/// Provider-agnostic auth failure. [messageKey] is an l10n key — services
/// emit keys, the UI translates — so a `FirebaseAuthException` never escapes
/// the service layer into a BLoC or a widget.
sealed class AuthException implements Exception {
  final String messageKey;
  const AuthException(this.messageKey);

  @override
  String toString() => 'AuthException($messageKey)';
}

/// A real failure the user should see a message about.
final class AuthFailure extends AuthException {
  const AuthFailure(super.messageKey);
}

/// The user dismissed the Google/Apple sheet before completing it. Not an
/// error: no message, no state change beyond returning to wherever the
/// attempt started.
final class AuthCancelled extends AuthException {
  const AuthCancelled() : super('authErrorCancelled');
}

/// Linking the current session to [method] failed because that identity
/// already belongs to a different account (`credential-already-in-use`).
/// [AuthServices] has stashed the credential that produced this;
/// `signInWithPendingCredential()` completes the switch if the user confirms
/// they want to abandon the current (anonymous) session and sign in as the
/// existing account instead.
final class AuthLinkConflict extends AuthException {
  final AuthMethod method;
  const AuthLinkConflict(this.method) : super('authErrorLinkConflict');
}

/// Whether Sign in with Apple can be offered on the current platform.
///
/// Two different mechanisms sit behind one answer:
/// - **iOS/macOS** — Apple's native authorization sheet.
/// - **Android** — the same provider via Firebase's hosted web OAuth flow
///   (see `AuthServices._signInWithAppleViaProvider`).
///
/// Everywhere else there is neither, so the button must stay hidden.
///
/// Shared by the sign-in UI and the service-layer backstop so the two can't
/// drift apart.
///
/// [defaultTargetPlatform], not `dart:io`'s `Platform`: it's overridable via
/// `debugDefaultTargetPlatformOverride`, which is the only thing that makes
/// per-platform behavior testable — `flutter test` always runs the Dart VM on
/// the host, so `Platform.isMacOS` is true in every CI/dev run regardless of
/// the target platform a test wants to simulate.
bool get isAppleSignInSupported =>
    defaultTargetPlatform == TargetPlatform.iOS ||
    defaultTargetPlatform == TargetPlatform.macOS ||
    defaultTargetPlatform == TargetPlatform.android;
