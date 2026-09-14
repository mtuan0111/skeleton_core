import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeleton_core/src/blocs/user/user_event.dart';
import 'package:skeleton_core/src/blocs/user/user_state.dart';
import 'package:skeleton_core/src/services/auth_services.dart';
import 'package:skeleton_core/src/services/auth_types.dart';
import 'package:skeleton_core/src/services/user_services.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  final UserServices _userServices = UserServices();
  final AuthServices _authServices = AuthServices();
  UserBloc(super.initialState) {
    on<AttempGettingUser>(_onAttempGettingUser);

    on<UsernameChanged>(_onUsernameChanged);
    on<GetGreetingMessage>(_onGetGreetingMessage);
    on<ScheduleDailyReminder>(_onScheduleDailyReminder);
    on<LevelCleared>(_onLevelCleared);
    on<ToggleAutomationPlay>(_onToggleAutomationPlay);

    on<SignInWithGoogleRequested>(_onSignInWithGoogle);
    on<SignInWithAppleRequested>(_onSignInWithApple);
    on<AccountSwitchConfirmed>(_onAccountSwitchConfirmed);
    on<LinkConflictDismissed>(_onLinkConflictDismissed);
    on<AuthErrorCleared>(_onAuthErrorCleared);
    on<LinkSuccessCleared>(_onLinkSuccessCleared);
    on<SignOutRequested>(_onSignOut);

    add(AttempGettingUser());
  }

  void _onToggleAutomationPlay(
    ToggleAutomationPlay event,
    Emitter<UserState> emitter,
  ) {
    emitter(state.copyWith(
      model: state.model.copyWith(isAutomationPlay: event.isEnabled),
    ));
  }

  Future<void> _onAttempGettingUser(
    AttempGettingUser event,
    Emitter<UserState> emitter,
  ) async {
    emitter(UnAuthenticatedUser());

    // Initialize Firebase Anonymous Auth and get user session
    emitter(await _userServices.initializeAuth());
  }

  Future<void> _onUsernameChanged(
    UsernameChanged event,
    Emitter<UserState> emitter,
  ) async {
    if (await _userServices.saveUsername(event.newUsername)) {
      emitter(await _userServices.getUserSession());
    }
  }

  Future<void> _onGetGreetingMessage(
    GetGreetingMessage event,
    Emitter<UserState> emitter,
  ) async {
    try {
      final message = await event.fetchGreeting();
      emitter(state.copyWith(greetingMessage: message));
    } catch (e) {
      // Ignore errors and keep current state (or fallback)
    }
  }

  Future<void> _onScheduleDailyReminder(
    ScheduleDailyReminder event,
    Emitter<UserState> emitter,
  ) async {
    try {
      final message = await event.fetchReminder();
      final title = await event.summarizeToTitle(message);
      await event.scheduleNotification(title, message);
    } catch (e) {
      // Ignore errors for scheduling
    }
  }

  Future<void> _onLevelCleared(
    LevelCleared event,
    Emitter<UserState> emitter,
  ) async {
    if (await _userServices.saveClearedLevel(
        event.level, state.model.clearedLevels)) {
      emitter(await _userServices.getUserSession());
    }
  }

  // --- SNS sign-in (Google / Apple) ------------------------------------

  Future<void> _onSignInWithGoogle(
    SignInWithGoogleRequested event,
    Emitter<UserState> emitter,
  ) =>
      _authenticate(emitter, _authServices.signInWithGoogle,
          method: AuthMethod.google);

  Future<void> _onSignInWithApple(
    SignInWithAppleRequested event,
    Emitter<UserState> emitter,
  ) =>
      _authenticate(emitter, _authServices.signInWithApple,
          method: AuthMethod.apple);

  Future<void> _onAccountSwitchConfirmed(
    AccountSwitchConfirmed event,
    Emitter<UserState> emitter,
  ) async {
    final method = state.linkConflictMethod ?? AuthMethod.google;
    emitter(state.copyWith(
      shouldShowLinkConflict: false,
      clearLinkConflictMethod: true,
    ));
    await _authenticate(
      emitter,
      _authServices.signInWithPendingCredential,
      method: method,
    );
  }

  void _onLinkConflictDismissed(
    LinkConflictDismissed event,
    Emitter<UserState> emitter,
  ) {
    emitter(state.copyWith(
      shouldShowLinkConflict: false,
      clearLinkConflictMethod: true,
    ));
  }

  void _onAuthErrorCleared(
    AuthErrorCleared event,
    Emitter<UserState> emitter,
  ) {
    emitter(state.copyWith(clearErrorKey: true));
  }

  void _onLinkSuccessCleared(
    LinkSuccessCleared event,
    Emitter<UserState> emitter,
  ) {
    emitter(state.copyWith(shouldShowLinkSuccess: false));
  }

  /// Signs out and immediately re-establishes an anonymous session: the game
  /// is fully playable as a guest, so leaving the user with no session at
  /// all would break score saving rather than present a "signed out" screen.
  Future<void> _onSignOut(
    SignOutRequested event,
    Emitter<UserState> emitter,
  ) async {
    emitter(state.copyWith(isAuthenticating: true));
    try {
      await _authServices.signOut();
      emitter(await _userServices.initializeAuth());
    } catch (e) {
      debugPrint('Sign out failed: $e');
      emitter(state.copyWith(isAuthenticating: false, errorKey: 'authError'));
    }
  }

  /// Shared body for every SNS sign-in attempt. Reloads the session on
  /// success, flags a link-success when a guest was upgraded in place, and
  /// maps the three failure shapes: a silent cancel, a link conflict the UI
  /// asks about, and a real error the UI reports.
  Future<void> _authenticate(
    Emitter<UserState> emitter,
    Future<dynamic> Function() run, {
    required AuthMethod method,
  }) async {
    final wasGuest = state.isGuest;
    emitter(state.copyWith(isAuthenticating: true, clearErrorKey: true));
    try {
      await run();
      final session = await _userServices.getUserSession();
      emitter(session.copyWith(
        isAuthenticating: false,
        // Upgrading in place keeps the same uid — that is exactly why the
        // player's existing leaderboard entries stay theirs — so it is
        // worth confirming to them that nothing was lost.
        shouldShowLinkSuccess: wasGuest && !session.isGuest,
      ));
    } on AuthCancelled {
      // Dismissing the provider sheet is not an error: no message, just
      // back to where the attempt started.
      emitter(state.copyWith(isAuthenticating: false));
    } on AuthLinkConflict catch (e) {
      emitter(state.copyWith(
        isAuthenticating: false,
        shouldShowLinkConflict: true,
        linkConflictMethod: e.method,
      ));
    } on AuthException catch (e) {
      debugPrint('auth failed ($method): $e');
      emitter(state.copyWith(
        isAuthenticating: false,
        errorKey: e.messageKey,
      ));
    } catch (e) {
      debugPrint('auth failed ($method): $e');
      emitter(state.copyWith(isAuthenticating: false, errorKey: 'authError'));
    }
  }
}
