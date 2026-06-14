abstract class UserEvent {}

class AttempGettingUser extends UserEvent {}

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
