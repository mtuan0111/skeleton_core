import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:skeleton_core/src/config/skeleton_config.dart';
import 'package:skeleton_core/src/helpers/preferences_key.dart';
import 'package:skeleton_core/src/services/auth_types.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Firebase Auth wrapper: anonymous sessions (with an offline fallback),
/// plus Google and Apple SNS sign-in ported from `mind_compass`'s
/// `FirebaseAuthService`.
///
/// Every SNS method **links** to the current session whenever one exists
/// (preserving `uid`, and with it the player's leaderboard history) and signs
/// in fresh otherwise. Linking is not limited to anonymous guests: Firebase
/// allows several providers on one account, so signing in with Google and
/// later tapping Apple adds Apple to that same account rather than switching
/// to a second one.
class AuthServices {
  FirebaseAuth? get _auth {
    try {
      return FirebaseAuth.instance;
    } catch (e) {
      return null;
    }
  }

  SharedPreferences? _prefs;
  bool _isOfflineMode = false;
  String? _offlineUserId;

  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;
  bool _googleInitialized = false;

  /// Set when a link attempt throws [AuthLinkConflict] — the credential that
  /// belongs to a *different* existing account, held just long enough for
  /// [signInWithPendingCredential] to complete the switch if the user
  /// confirms. Never exposed outside this class; no credential value ever
  /// needs to reach UserBloc.
  AuthCredential? _pendingConflictCredential;

  /// Which provider [_pendingConflictCredential] came from, so
  /// [signInWithPendingCredential] can map its failures through the right
  /// branch (an Apple conflict-switch failure must not be reported with
  /// Google's wording, and vice versa).
  AuthMethod? _pendingConflictMethod;

  /// Single shared instance.
  ///
  /// Call sites across both apps construct this as `AuthServices()` in
  /// several screens and in [UserServices]; before this was a singleton each
  /// of those got its own `_isOfflineMode`/`_offlineUserId`, so a screen's
  /// fresh instance reported "online" even when the session had actually
  /// fallen back to offline mode. The SNS flow makes sharing mandatory
  /// rather than merely correct: [_pendingConflictCredential] is stashed by
  /// the call that hit the conflict and read by the *later* call that
  /// resolves it, which is only the same object if there is exactly one.
  static final AuthServices _instance = AuthServices._internal();

  factory AuthServices() => _instance;

  AuthServices._internal() {
    loadSharedPreferences();
  }

  Future<void> loadSharedPreferences() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  /// Get current Firebase user (or null in offline mode)
  User? get currentUser {
    if (_isOfflineMode) {
      return null;
    }
    return _auth?.currentUser;
  }

  /// Check if we're in offline mode
  bool get isOfflineMode => _isOfflineMode;

  /// Get offline user ID
  String? get offlineUserId => _offlineUserId;

  /// Stream of auth state changes
  Stream<User?> get authStateChanges {
    if (_isOfflineMode || _auth == null) {
      return Stream.empty();
    }
    return _auth!.authStateChanges();
  }

  /// Sign in anonymously (works offline)
  Future<UserCredential?> signInAnonymously() async {
    if (_isOfflineMode) {
      _offlineUserId =
          'offline_${DateTime.now().millisecondsSinceEpoch}_${(DateTime.now().microsecond % 1000)}';
      await _prefs?.setString(
        PreferencesKey.FIREBASE_USER_ID,
        _offlineUserId!,
      );
      print('✅ Signed in anonymously (offline mode): $_offlineUserId');
      return null;
    }

    try {
      if (_auth == null) {
        throw FirebaseAuthException(code: 'not-initialized', message: 'Firebase not initialized yet');
      }
      final userCredential = await _auth!.signInAnonymously();

      if (userCredential.user != null) {
        await _prefs?.setString(
          PreferencesKey.FIREBASE_USER_ID,
          userCredential.user!.uid,
        );
      }

      return userCredential;
    } on FirebaseAuthException catch (e) {
      debugPrint('Failed to sign in anonymously: ${e.code} - ${e.message}');
      _isOfflineMode = true;
      return await signInAnonymously();
    } catch (e) {
      debugPrint('Failed to sign in anonymously: $e');
      _isOfflineMode = true;
      return await signInAnonymously();
    }
  }

  /// Sign out
  Future<void> signOut() async {
    try {
      if (_isOfflineMode) {
        _offlineUserId = null;
        print('✅ Signed out (offline mode)');
      } else {
        await _auth?.signOut();
      }
      await _prefs?.remove(PreferencesKey.FIREBASE_USER_ID);
    } catch (e) {
      debugPrint('Failed to sign out: $e');
    }
  }

  /// Check if user is signed in
  bool isSignedIn() {
    if (_isOfflineMode) {
      return _offlineUserId != null;
    }
    return _auth?.currentUser != null;
  }

  /// Get stored Firebase user ID from preferences
  String? getStoredUserId() {
    return _prefs?.getString(PreferencesKey.FIREBASE_USER_ID);
  }

  /// Link anonymous account with credential
  Future<UserCredential?> linkWithCredential(AuthCredential credential) async {
    if (_isOfflineMode) {
      debugPrint('Cannot link credential in offline mode');
      return null;
    }

    try {
      final user = _auth?.currentUser;
      if (user != null && user.isAnonymous) {
        return await user.linkWithCredential(credential);
      }
      return null;
    } on FirebaseAuthException catch (e) {
      debugPrint('Failed to link credential: ${e.code} - ${e.message}');
      return null;
    } catch (e) {
      debugPrint('Failed to link credential: $e');
      return null;
    }
  }

  // ---------------------------------------------------------------------
  // SNS sign-in (Google / Apple)
  //
  // Ported from mind_compass's FirebaseAuthService. Both methods link to the
  // current session when there is one — an anonymous player keeps their uid,
  // and with it their leaderboard entries — and sign in fresh otherwise.
  // ---------------------------------------------------------------------

  /// Sign in with Google, linking to the current session when one exists.
  ///
  /// Throws [AuthCancelled] if the user dismisses the account chooser,
  /// [AuthLinkConflict] if the Google identity already belongs to a
  /// different account, [AuthFailure] otherwise.
  Future<UserCredential?> signInWithGoogle() async {
    if (!SkeletonConfig.snsLoginEnabled) {
      // Backstop for the master switch: the UI hides the button when SNS is
      // off, so reaching here means a stray call — refuse rather than start a
      // flow against a provider the app opted out of.
      throw const AuthFailure('authErrorProviderDisabled');
    }
    _pendingConflictCredential = null;
    if (_isOfflineMode) throw const AuthFailure('authErrorNetwork');

    late final GoogleSignInAccount account;
    try {
      if (!_googleInitialized) {
        // serverClientId is the app's *web* OAuth client id, and on Android
        // it is what makes `authentication.idToken` non-null below — the
        // one thing Firebase actually needs. iOS ignores it and reads
        // GIDClientID from Info.plist instead. See
        // SkeletonConfig.googleServerClientId.
        await _googleSignIn.initialize(
          serverClientId: SkeletonConfig.googleServerClientId,
        );
        _googleInitialized = true;
      }
      account = await _googleSignIn.authenticate();
    } on GoogleSignInException catch (e) {
      if (e.code == GoogleSignInExceptionCode.canceled) {
        throw const AuthCancelled();
      }
      // Keep e.code/e.description: collapsing every non-cancel failure into
      // a bare 'authError' is what turns a real misconfiguration into an
      // untraceable error at the UI. Report configuration problems as
      // configuration problems.
      debugPrint(
        'Google sign-in failed: code=${e.code}, description=${e.description}. '
        'clientConfigurationError/providerConfigurationError on Android '
        'almost always means the SHA-1/SHA-256 fingerprints are not '
        'registered in Firebase (no client_type 1 in google-services.json) '
        'or serverClientId is missing — see docs/SNS_LOGIN_SETUP.md §1.',
      );
      throw switch (e.code) {
        GoogleSignInExceptionCode.clientConfigurationError ||
        GoogleSignInExceptionCode.providerConfigurationError =>
          const AuthFailure('authErrorProviderDisabled'),
        _ => const AuthFailure('authError'),
      };
    }

    // Android returns a null idToken when no serverClientId was supplied at
    // initialize() time. Passing that straight through makes Firebase reject
    // the credential with a generic error far from the real cause, so name
    // it here instead (mirrors the Apple identityToken guard below).
    final idToken = account.authentication.idToken;
    if (idToken == null) {
      debugPrint(
        'Google sign-in returned no idToken for ${account.email}. Firebase '
        'needs one; on Android this means initialize() had no serverClientId '
        '(the web client_type 3 id) — see docs/SNS_LOGIN_SETUP.md §1.',
      );
      throw const AuthFailure('authErrorCredentialRejected');
    }

    final credential = GoogleAuthProvider.credential(idToken: idToken);
    return _linkOrSignInWith(
      credential: credential,
      method: AuthMethod.google,
    );
  }

  /// Sign in with Apple, linking to the current session when one exists.
  ///
  /// On iOS/macOS this is Apple's native authorization sheet; on Android it
  /// routes through Firebase's hosted OAuth handler (see
  /// [_signInWithAppleViaProvider]). Same provider, same resulting Firebase
  /// user, different front end.
  Future<UserCredential?> signInWithApple() async {
    if (!SkeletonConfig.snsLoginEnabled) {
      // Backstop for the master switch (see signInWithGoogle).
      throw const AuthFailure('authErrorProviderDisabled');
    }
    _pendingConflictCredential = null;
    if (_isOfflineMode) throw const AuthFailure('authErrorNetwork');

    if (!isAppleSignInSupported) {
      // Neither mechanism exists here; the UI already hides the button, so
      // this is the service-layer backstop.
      throw const AuthFailure('authErrorAppleUnavailable');
    }
    if (!(defaultTargetPlatform == TargetPlatform.iOS ||
        defaultTargetPlatform == TargetPlatform.macOS)) {
      return _signInWithAppleViaProvider();
    }

    final rawNonce = _generateNonce();
    final nonce = sha256.convert(utf8.encode(rawNonce)).toString();
    late final AuthorizationCredentialAppleID appleCredential;
    try {
      appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: const [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );
    } on SignInWithAppleAuthorizationException catch (e) {
      if (e.code == AuthorizationErrorCode.canceled) {
        throw const AuthCancelled();
      }
      // 'authErrorAppleUnavailable' is deliberately vague to the user, but
      // that vagueness costs real debugging time — an
      // AuthorizationErrorCode.unknown here is usually the missing
      // com.apple.developer.applesignin entitlement, indistinguishable in
      // the logs from any other cause. Keep the real code/message.
      debugPrint(
        'Sign in with Apple failed: code=${e.code}, message=${e.message}. '
        'If this is `unknown`, check the Sign in with Apple capability on '
        'the App ID and ios/Runner/Runner.entitlements; if the credential '
        'exchange itself failed, check the Apple provider is enabled in '
        'Firebase Auth — see docs/SNS_LOGIN_SETUP.md §2.',
      );
      throw const AuthFailure('authErrorAppleUnavailable');
    } on SignInWithAppleNotSupportedException catch (e) {
      debugPrint('Sign in with Apple not supported on this device: $e');
      throw const AuthFailure('authErrorAppleUnavailable');
    }

    // Apple can hand back a credential with no identityToken (revoked key,
    // an interrupted authorization). Passing that null straight through
    // makes Firebase reject it as "Invalid OAuth response from apple.com" —
    // the same message a misconfigured Firebase Apple provider produces, so
    // without this guard the two are indistinguishable in the logs.
    if (appleCredential.identityToken == null) {
      debugPrint(
        'Sign in with Apple returned no identityToken (userIdentifier='
        '${appleCredential.userIdentifier}). Nothing to exchange with '
        'Firebase — this is an Apple-side authorization problem, not a '
        'Firebase provider misconfiguration.',
      );
      throw const AuthFailure('authErrorCredentialRejected');
    }
    _debugLogAppleTokenClaims(appleCredential.identityToken!, nonce);

    final credential = OAuthProvider('apple.com').credential(
      idToken: appleCredential.identityToken,
      rawNonce: rawNonce,
      accessToken: appleCredential.authorizationCode,
    );
    final result = await _linkOrSignInWith(
      credential: credential,
      method: AuthMethod.apple,
    );

    // Apple returns givenName/familyName/email only on the FIRST
    // authorization between this app and the user's Apple ID — persist
    // immediately or it's gone for good.
    final fullName = [
      appleCredential.givenName,
      appleCredential.familyName,
    ].whereType<String>().join(' ').trim();
    if (fullName.isNotEmpty) {
      await _auth?.currentUser?.updateDisplayName(fullName);
    }
    return result;
  }

  /// Sign in with Apple on non-Apple platforms (Android).
  ///
  /// Apple provides no native authorization UI outside its own platforms, so
  /// this uses Firebase's generic OAuth flow: a Chrome Custom Tab to Apple's
  /// sign-in page via Firebase's hosted handler
  /// (`https://<project>.firebaseapp.com/__/auth/handler`), which then hands
  /// back a credential.
  ///
  /// Deliberately Firebase's `signInWithProvider` rather than
  /// `sign_in_with_apple`'s own `webAuthenticationOptions`: that package's
  /// Android path needs a redirect endpoint the app hosts and that then
  /// deep-links back, i.e. a whole extra server surface. Firebase already
  /// runs exactly that endpoint for the Apple provider, so there is nothing
  /// to build or maintain.
  ///
  /// **Console setup this requires** (beyond what iOS needs): the Firebase
  /// Apple provider must have the OAuth code flow filled in — Services ID,
  /// Apple Team ID, Key ID, private key — and that Services ID must list the
  /// Firebase handler URL as a Return URL in the Apple Developer portal.
  /// Without it Apple rejects the redirect and this surfaces as
  /// `invalid-credential`.
  Future<UserCredential?> _signInWithAppleViaProvider() async {
    final provider = AppleAuthProvider()
      ..addScope('email')
      ..addScope('name');

    final current = _auth?.currentUser;
    final linking = current != null;
    try {
      return linking
          ? await current.linkWithProvider(provider)
          : await _auth?.signInWithProvider(provider);
    } on FirebaseAuthException catch (e) {
      // Dismissing the Custom Tab is a cancellation, not a failure — it must
      // not raise an error message. Firebase reports it under a couple of
      // different codes depending on how the tab was closed.
      if (e.code == 'web-context-canceled' ||
          e.code == 'user-canceled' ||
          e.code == 'canceled') {
        throw const AuthCancelled();
      }
      final mapped = mapFirebaseAuthError(
        e,
        method: AuthMethod.apple,
        linking: linking,
      );
      // Unlike the native path there's no locally-built credential to stash
      // for the "switch account" retry — Firebase attaches the one it minted
      // to the exception instead.
      if (mapped is AuthLinkConflict) {
        _pendingConflictCredential = e.credential;
        _pendingConflictMethod = AuthMethod.apple;
      }
      throw mapped;
    }
  }

  /// Completes a pending [AuthLinkConflict] by signing in as the *existing*
  /// account that owns the credential — the current anonymous session and
  /// its local-only progress are abandoned.
  Future<UserCredential?> signInWithPendingCredential() async {
    final credential = _pendingConflictCredential;
    final method = _pendingConflictMethod ?? AuthMethod.google;
    _pendingConflictCredential = null;
    _pendingConflictMethod = null;
    if (credential == null) {
      // Nothing stashed to switch with: the conflict and the confirmation
      // got separated. signOut(), or a fresh signInWithGoogle/Apple attempt,
      // clears the stash on entry, and the confirm action can also arrive
      // twice. Naming it matters — otherwise this surfaces as a bare
      // AuthFailure('authError') with no clue which of those happened.
      debugPrint(
        'signInWithPendingCredential called with no stashed credential. The '
        'link conflict was cleared before the switch was confirmed (sign '
        'out, a new sign-in attempt, or a duplicate confirmation).',
      );
      throw const AuthFailure('authError');
    }
    try {
      return await _auth?.signInWithCredential(credential);
    } on FirebaseAuthException catch (e) {
      throw mapFirebaseAuthError(e, method: method, linking: false);
    }
  }

  /// Shared "link to the signed-in user, else sign in fresh" behavior.
  ///
  /// Links whenever *any* user is signed in, not only an anonymous one:
  /// Firebase supports several providers on one account, so a user who
  /// signed in with Google and then taps Apple ends up with one account
  /// reachable by both, rather than silently switching to a second account
  /// and stranding the first one's data.
  Future<UserCredential?> _linkOrSignInWith({
    required AuthCredential credential,
    required AuthMethod method,
  }) async {
    final current = _auth?.currentUser;
    final linking = current != null;
    try {
      final result = linking
          ? await current.linkWithCredential(credential)
          : await _auth?.signInWithCredential(credential);
      if (result?.user != null) {
        await _prefs?.setString(
          PreferencesKey.FIREBASE_USER_ID,
          result!.user!.uid,
        );
      }
      return result;
    } on FirebaseAuthException catch (e) {
      // Already attached to *this* account — the user asked for a state they
      // are already in, so treat it as success rather than an error.
      // (Distinct from 'credential-already-in-use', which means it belongs
      // to a *different* account and genuinely needs the switch prompt.)
      if (e.code == 'provider-already-linked') return null;

      final mapped = mapFirebaseAuthError(e, method: method, linking: linking);
      if (mapped is AuthLinkConflict) {
        // Prefer the credential Firebase attaches to the exception over the
        // one built above. For 'credential-already-in-use' Firebase mints a
        // fresh credential precisely so the caller can complete the switch;
        // the local one has *already been consumed* by the failed
        // linkWithCredential call, and an Apple/Google identity token is
        // single-use and short-lived, so replaying it tends to be rejected —
        // surfacing as a second, confusing failure on "Switch account"
        // rather than the switch actually happening.
        _pendingConflictCredential = e.credential ?? credential;
        _pendingConflictMethod = method;
      }
      throw mapped;
    }
  }

  String _generateNonce([int length = 32]) {
    const charset =
        '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(
      length,
      (_) => charset[random.nextInt(charset.length)],
    ).join();
  }

  /// Debug-only: prints the *claims* of Apple's identity token (never the
  /// token itself — it is a credential) so an `invalid-credential` /
  /// "Invalid OAuth response from apple.com" rejection can be pinned on a
  /// specific mismatch instead of guessed at. The three that matter:
  ///
  ///  * `aud` — for a native iOS authorization this is the **bundle ID**.
  ///    Firebase only accepts it if the Apple provider's Services ID has
  ///    that bundle ID as its Primary App ID.
  ///  * `iss` — must be `https://appleid.apple.com`.
  ///  * `nonce` — must equal the SHA-256 hex we sent Apple. If it is absent
  ///    or different, Firebase's own SHA-256(rawNonce) comparison fails and
  ///    the exchange is rejected regardless of how the console is set up.
  void _debugLogAppleTokenClaims(String identityToken, String sentNonce) {
    if (!kDebugMode) return;
    try {
      final parts = identityToken.split('.');
      if (parts.length != 3) {
        debugPrint('Apple token: unexpected JWT shape (${parts.length} parts)');
        return;
      }
      final payload = json.decode(
        utf8.decode(base64Url.decode(base64Url.normalize(parts[1]))),
      ) as Map<String, dynamic>;
      final tokenNonce = payload['nonce'];
      debugPrint(
        'Apple identity token claims: aud=${payload['aud']} '
        'iss=${payload['iss']} noncePresent=${tokenNonce != null} '
        'nonceMatchesSent=${tokenNonce == sentNonce} '
        'emailVerified=${payload['email_verified']}',
      );
    } on Object catch (e) {
      // Diagnostics must never break the sign-in they are diagnosing.
      debugPrint('Apple token claim decode failed (non-fatal): $e');
    }
  }

  /// Delete current user account
  Future<bool> deleteAccount() async {
    if (_isOfflineMode) {
      _offlineUserId = null;
      await _prefs?.remove(PreferencesKey.FIREBASE_USER_ID);
      debugPrint('Deleted offline account');
      return true;
    }

    try {
      final user = _auth?.currentUser;
      if (user != null) {
        await user.delete();
        await _prefs?.remove(PreferencesKey.FIREBASE_USER_ID);
        return true;
      }
      return false;
    } on FirebaseAuthException catch (e) {
      debugPrint('Failed to delete account: ${e.code} - ${e.message}');
      return false;
    } catch (e) {
      debugPrint('Failed to delete account: $e');
      return false;
    }
  }
}

/// Pure code→[AuthException] table, kept top-level (rather than a private
/// method) so it's directly unit-testable without a real Firebase instance.
///
/// [linking] distinguishes an ordinary "this credential is taken" failure
/// from a link conflict, where the same Firebase codes instead mean "this
/// identity already belongs to a different account" and should route through
/// [AuthLinkConflict].
@visibleForTesting
AuthException mapFirebaseAuthError(
  FirebaseAuthException e, {
  required AuthMethod method,
  required bool linking,
}) {
  // The mapped key is deliberately coarse for the user; the raw Firebase
  // code is what anyone debugging actually needs.
  debugPrint(
    'FirebaseAuthException during $method (linking=$linking): '
    'code=${e.code}, message=${e.message}',
  );
  switch (e.code) {
    case 'credential-already-in-use':
      return AuthLinkConflict(method);
    case 'email-already-in-use':
    case 'account-exists-with-different-credential':
      return const AuthFailure('authErrorAccountExistsDifferentCredential');
    case 'invalid-credential':
    case 'user-not-found':
      // For Google/Apple there is no password to get wrong:
      // `invalid-credential` means Firebase rejected the OAuth token
      // (provider not configured in the console, nonce mismatch, expired
      // token). Naming that precisely is what keeps a console
      // misconfiguration from being chased as a user error.
      return const AuthFailure('authErrorCredentialRejected');
    case 'network-request-failed':
      return const AuthFailure('authErrorNetwork');
    case 'too-many-requests':
      return const AuthFailure('authErrorTooManyRequests');
    case 'operation-not-allowed':
      return const AuthFailure('authErrorProviderDisabled');
    case 'provider-already-linked':
      return const AuthFailure('authErrorAlreadyLinked');
    case 'user-disabled':
      return const AuthFailure('authErrorAccountDisabled');
    default:
      return const AuthFailure('authError');
  }
}
