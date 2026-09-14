abstract class UserEvent {}

class AttempGettingUser extends UserEvent {}

// --- SNS sign-in (Google / Apple) -------------------------------------
// Same flow in both apps: request → link-or-sign-in → either success, a
// silent cancel, an error key, or a link conflict the user resolves with
// AccountSwitchConfirmed / LinkConflictDismissed.

class SignInWithGoogleRequested extends UserEvent {}

class SignInWithAppleRequested extends UserEvent {}

/// User confirmed abandoning the current guest session to sign in as the
/// existing account that owns the conflicting credential.
class AccountSwitchConfirmed extends UserEvent {}

class LinkConflictDismissed extends UserEvent {}

/// Clears the one-shot flags after the UI has shown them, so they don't
/// re-fire on the next unrelated state emit.
class AuthErrorCleared extends UserEvent {}

class LinkSuccessCleared extends UserEvent {}

/// Signs out of the SNS account and returns to a fresh anonymous session —
/// the app is playable as a guest, so there is no signed-out dead end.
class SignOutRequested extends UserEvent {}

class UsernameChanged extends UserEvent {
  final String newUsername;

  UsernameChanged({required this.newUsername});
}

class GetGreetingMessage extends UserEvent {
  final Future<String> Function() fetchGreeting;

  GetGreetingMessage({required this.fetchGreeting});
}

class ScheduleDailyReminder extends UserEvent {
  final Future<String> Function() fetchReminder;
  final Future<String> Function(String message) summarizeToTitle;
  final Future<void> Function(String title, String body) scheduleNotification;

  ScheduleDailyReminder({
    required this.fetchReminder,
    required this.summarizeToTitle,
    required this.scheduleNotification,
  });
}

class LevelCleared extends UserEvent {
  final int level;

  LevelCleared({required this.level});
}

class ToggleAutomationPlay extends UserEvent {
  final bool isEnabled;

  ToggleAutomationPlay({required this.isEnabled});
}
