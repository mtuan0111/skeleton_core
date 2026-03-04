import 'package:flutter/widgets.dart';
import 'package:skeleton_core/src/localization/core_localizations.dart';

export 'package:skeleton_core/src/localization/core_localizations.dart';

/// Shorthand helper to access [CoreLocalizations] from a [BuildContext].
///
/// Usage: `coreLang(context).yes`
CoreLocalizations coreLang(BuildContext context) =>
    CoreLocalizations.of(context)!;
