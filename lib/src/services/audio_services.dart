import 'package:audioplayers/audioplayers.dart';
import 'package:vibration/vibration.dart';

class AudioServices {
  static const pathPrefix = "sounds/";

  static const tapSound = "tap.mp3";
  static const introSound = "intro.mp3";
  static const correctSound = "correct.mp3";
  static const correctUpSound = "correct_up.mp3";
  static const wrongSOund = "wrong.mp3";
  static const endSound = "end.mp3";
  static const secondTickingSound = "second_ticking.mp3";
  static const saveSuccessSound = "save_success.wav";
  static const newTingsSound = "new_tings.mp3";

  double volume = 0.7;
  double get getVolume => volume;
  set setVolume(double volume) {
    this.volume = volume;
  }

  AudioServices({double? volume}) {
    if (volume != null) {
      this.volume = volume;
    }
  }

  final Set<AudioPlayer> _activePlayers = {};

  Future<void> playSound(String soundPath) async {
    if (getVolume == 0) {
      return;
    }
    final player = AudioPlayer();
    _activePlayers.add(player);

    // Clean up when done
    player.onPlayerComplete.listen((_) {
      _activePlayers.remove(player);
      player.dispose();
    });

    await player.play(
      AssetSource(pathPrefix + soundPath),
      volume: getVolume,
      mode: PlayerMode.lowLatency,
    );
  }

  Future<void> playCustomAudio(String soundPath, {String? package}) async {
    if (getVolume == 0) return;
    final player = AudioPlayer();
    _activePlayers.add(player);

    player.onPlayerComplete.listen((_) {
      _activePlayers.remove(player);
      player.dispose();
    });

    // In audioplayers, if a package is provided, the path is generally 'packages/package_name/path'
    final String fullPath = package != null ? 'packages/$package/$soundPath' : soundPath;
    
    await player.play(
      AssetSource(fullPath),
      volume: getVolume,
      mode: PlayerMode.lowLatency,
    );
  }
  /// Stop any currently-playing audio immediately.
  Future<void> stopAll() async {
    for (final player in _activePlayers) {
      await player.stop();
      await player.dispose();
    }
    _activePlayers.clear();
  }

  Future<void> playTap() {
    return playSound(tapSound);
  }

  Future<void> playIntro() {
    return playSound(introSound);
  }

  Future<void> playCorrect() {
    return playSound(correctSound);
  }

  Future<void> playSaveSuccess() {
    return playSound(saveSuccessSound);
  }

  Future<void> playCorrectUp() {
    return playSound(correctUpSound);
  }

  Future<void> playWrong() {
    return playSound(wrongSOund);
  }

  Future<void> playEnd() {
    return playSound(endSound);
  }

  Future<void> playSecondTicking() {
    return playSound(secondTickingSound);
  }

  Future<void> playNewTings() async {
    return playSound(newTingsSound);
  }
}

class VibrationServices {
  bool isVibrate = true;

  set setIsVibrate(bool isVibrate) {
    this.isVibrate = isVibrate;
  }

  Future<void> vibrate({int duration = 100}) async {
    if (!isVibrate) {
      return;
    }

    try {
      if (await Vibration.hasVibrator() ?? false) {
        await Vibration.vibrate(duration: duration);
      }
    } catch (_) {
      // Ignore vibration errors (e.g., in test environments or on unsupported platforms)
    }
  }

  Future<void> multipleVibrate(
      {int count = 3, int duration = 200, int pause = 100}) async {
    if (!isVibrate) return;
    for (int i = 0; i < count; i++) {
      await vibrate(duration: duration);
      if (i < count - 1) {
        await Future.delayed(Duration(milliseconds: pause));
      }
    }
  }
}
