import 'dart:io';

import 'package:flutter/widgets.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ============================================================================
// Menu State
// ============================================================================

abstract class MenuState {}

/// Menu options available in the game shell.
/// [start] and [instantStart] are game-specific — their behavior
/// is defined by the game via callbacks.
enum MenuOption { start, instantStart, topScore, setting, about, exit }

class Menu extends MenuState {}

class Play extends MenuState {}

class InstantStart extends MenuState {}

class TopScore extends MenuState {}

class Setting extends MenuState {}

class About extends MenuState {}

class Exit extends MenuState {}

// ============================================================================
// Menu Event
// ============================================================================

abstract class MenuEvent {}

class SelectOption extends MenuEvent {
  final MenuOption option;

  SelectOption({required this.option});
}

class ShowMenu extends MenuEvent {
  ShowMenu();
}

// ============================================================================
// Menu Bloc
// ============================================================================

class MenuBloc extends Bloc<MenuEvent, MenuState> {
  MenuBloc(super.initialState) {
    on<SelectOption>(_onSelectOption);
    on<ShowMenu>(_onShowMenu);
  }

  Future<void> _onSelectOption(
    SelectOption event,
    Emitter<MenuState> emitter,
  ) async {
    switch (event.option) {
      case MenuOption.start:
        emitter(Play());
        break;

      case MenuOption.instantStart:
        emitter(InstantStart());
        break;

      case MenuOption.topScore:
        emitter(TopScore());
        break;

      case MenuOption.setting:
        emitter(Setting());
        break;

      case MenuOption.about:
        emitter(About());
        break;

      case MenuOption.exit:
        emitter(Exit());
        SystemNavigator.pop();
        exit(0);
    }
  }

  Future<void> _onShowMenu(ShowMenu event, Emitter<MenuState> emitter) async {
    emitter(Menu());
  }
}

// ============================================================================
// Menu Item Configuration
// ============================================================================

/// Defines the display configuration for a menu option.
class MenuItemConfig {
  final String text;
  final IconData icon;

  const MenuItemConfig({required this.text, required this.icon});
}

/// Returns default icons for each menu option.
/// Games should provide localized text via [buildMenuItems].
Map<MenuOption, IconData> get defaultMenuIcons => {
  MenuOption.instantStart: FontAwesomeIcons.bolt,
  MenuOption.start: FontAwesomeIcons.play,
  MenuOption.topScore: FontAwesomeIcons.trophy,
  MenuOption.setting: FontAwesomeIcons.gear,
  MenuOption.about: FontAwesomeIcons.circleInfo,
  MenuOption.exit: FontAwesomeIcons.rightFromBracket,
};

/// Build menu items with localized text.
///
/// Games provide a map of [MenuOption] to display text; icons come from
/// [defaultMenuIcons] or can be overridden.
Map<MenuOption, MenuItemConfig> buildMenuItems({
  required Map<MenuOption, String> labels,
  Map<MenuOption, IconData>? iconOverrides,
}) {
  final icons = defaultMenuIcons;
  if (iconOverrides != null) {
    icons.addAll(iconOverrides);
  }

  return {
    for (final option in MenuOption.values)
      if (labels.containsKey(option))
        option: MenuItemConfig(
          text: labels[option]!,
          icon: icons[option] ?? FontAwesomeIcons.question,
        ),
  };
}
