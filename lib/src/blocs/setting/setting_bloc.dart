import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:skeleton_core/src/blocs/audio/audio_bloc.dart';
import 'package:skeleton_core/src/blocs/audio/audio_event.dart';
import 'package:skeleton_core/src/blocs/setting/setting_event.dart';
import 'package:skeleton_core/src/blocs/setting/setting_state.dart';
import 'package:skeleton_core/src/blocs/vibration/vibration_bloc.dart';
import 'package:skeleton_core/src/blocs/vibration/vibration_event.dart';
import 'package:skeleton_core/src/helpers/preferences_key.dart';
import 'package:skeleton_core/src/services/audio_services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  SharedPreferences? _prefs;
  late AudioServices _audioServices;

  /// Optional reference to AudioBloc for dispatching volume changes.
  /// When provided, ToggleMute and ChangedVol will sync volume via event.
  AudioBloc? audioBloc;

  /// Optional reference to VibrationBloc for dispatching vibration toggle.
  VibrationBloc? vibrationBloc;

  SettingBloc({this.audioBloc, this.vibrationBloc}) : super(SettingState()) {
    on<LoadData>(_onLoadData);

    on<ChangedThemeMode>(_onChangedThemeMode);
    on<ChangedLocale>(_onChangedLocale);
    on<ChangedVol>(_onChangedVol);
    on<ChangedIsVibrate>(_onChangedIsVibrate);
    on<ToggleMute>(_onToggleMute);
    on<ChangedFontSize>(_onChangedFontSize);
    on<ChangedNumberOfTopBoard>(_onChangedNumberOfTopBoard);
    on<ChangedOnlyShowMyRecorded>(_onChangedOnlyShowMyRecorded);

    _audioServices = AudioServices();

    add(LoadData());
  }

  Future<void> _onLoadData(
    LoadData event,
    Emitter<SettingState> emitter,
  ) async {
    _prefs ??= await SharedPreferences.getInstance();

    emitter(
      state.copyWith(
        themeMode: ThemeMode.values.where((element) => true).first,
        locale: _prefs!.getString(PreferencesKey.LOCALE),
        vol: _prefs!.getInt(PreferencesKey.VOL),
        isVibrate: _prefs!.getBool(PreferencesKey.IS_VIBRATE) ?? true,
        isMuted: _prefs!.getBool(PreferencesKey.IS_MUTED) ?? false,
        fontSize: _prefs!.getInt(PreferencesKey.FONT_SIZE),
        numberOfTopBoard: _prefs!.getInt(PreferencesKey.NUMBER_OF_TOP_BOARD),
        onlyShowMyRecorded:
            _prefs!.getBool(PreferencesKey.ONLY_SHOW_MY_RECORDED) ?? false,
        isLoading: false,
      ),
    );

    // Sync mute state to AudioBloc on load
    final savedMuted = _prefs!.getBool(PreferencesKey.IS_MUTED) ?? false;
    if (savedMuted && audioBloc?.isClosed == false) {
      final targetVolume = 0.0;
      audioBloc!.add(SetAudioVolume(volume: targetVolume));
    }
  }

  Future<void> _onChangedThemeMode(
    ChangedThemeMode event,
    Emitter<SettingState> emitter,
  ) async {
    _prefs ??= await SharedPreferences.getInstance();
    _prefs!.setString(PreferencesKey.THEME_MODE, event.themeMode.name);

    emitter(state.copyWith(themeMode: event.themeMode));
  }

  Future<void> _onChangedLocale(
    ChangedLocale event,
    Emitter<SettingState> emitter,
  ) async {
    _prefs ??= await SharedPreferences.getInstance();

    _prefs!.setString(PreferencesKey.LOCALE, event.locale);

    emitter(state.copyWith(locale: event.locale));
  }

  Future<void> _onChangedVol(
    ChangedVol event,
    Emitter<SettingState> emitter,
  ) async {
    _prefs ??= await SharedPreferences.getInstance();
    _prefs!.setInt(PreferencesKey.VOL, event.vol);

    emitter(state.copyWith(vol: event.vol));

    _audioServices.setVolume = event.vol / 10;
    _audioServices.playCorrect();
  }

  Future<void> _onChangedIsVibrate(
    ChangedIsVibrate event,
    Emitter<SettingState> emitter,
  ) async {
    _prefs ??= await SharedPreferences.getInstance();
    _prefs!.setBool(PreferencesKey.IS_VIBRATE, event.isVibrate);
    // Sync to game-scoped VibrationBloc
    if (vibrationBloc?.isClosed == false) {
      vibrationBloc!.add(SetVibrationEnabled(enabled: event.isVibrate));
    }
    emitter(state.copyWith(isVibrate: event.isVibrate));
  }

  Future<void> _onToggleMute(
    ToggleMute event,
    Emitter<SettingState> emitter,
  ) async {
    _prefs ??= await SharedPreferences.getInstance();
    final newMuted = !state.isMuted;
    _prefs!.setBool(PreferencesKey.IS_MUTED, newMuted);

    final targetVolume = newMuted ? 0.0 : state.vol / 10;
    // Sync volume to AudioBloc (which owns the real playback AudioServices)
    if (audioBloc?.isClosed == false) {
      audioBloc!.add(SetAudioVolume(volume: targetVolume));
      // Stop any currently playing audio when muting
      if (newMuted) {
        audioBloc!.add(StopAllAudio());
      }
    }
    // Also update our own AudioServices for any sounds SettingBloc plays
    _audioServices.setVolume = targetVolume;
    emitter(state.copyWith(isMuted: newMuted));
  }

  Future<void> _onChangedFontSize(
    ChangedFontSize event,
    Emitter<SettingState> emitter,
  ) async {
    _prefs ??= await SharedPreferences.getInstance();
    _prefs!.setInt(PreferencesKey.FONT_SIZE, event.fontSize);

    emitter(state.copyWith(fontSize: event.fontSize));
  }

  Future<void> _onChangedNumberOfTopBoard(
    ChangedNumberOfTopBoard event,
    Emitter<SettingState> emitter,
  ) async {
    _prefs ??= await SharedPreferences.getInstance();
    _prefs!.setInt(PreferencesKey.NUMBER_OF_TOP_BOARD, event.numberOfTopBoard);

    emitter(state.copyWith(numberOfTopBoard: event.numberOfTopBoard));
  }

  Future<void> _onChangedOnlyShowMyRecorded(
    ChangedOnlyShowMyRecorded event,
    Emitter<SettingState> emitter,
  ) async {
    _prefs ??= await SharedPreferences.getInstance();
    _prefs!.setBool(
      PreferencesKey.ONLY_SHOW_MY_RECORDED,
      event.onlyShowMyRecorded,
    );

    emitter(state.copyWith(onlyShowMyRecorded: event.onlyShowMyRecorded));
  }
}
