import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:nested/nested.dart';
import 'package:skeleton_core/skeleton_core.dart';

/// A generic app launcher for skeleton_core-based apps.
///
/// Encapsulates all common boilerplate:
/// - `SettingBloc`, `AppVersionBloc`, `TourBloc`, `MenuBloc`, `UserBloc` providers
/// - GestureDetector for keyboard unfocusing
/// - `SettingBloc` loading screen
/// - `MaterialApp` with localization, theme, themeMode
/// - Home screen wrapping: decoration → tour → update checker → menu nav
///
/// Example usage:
/// ```dart
/// void main() async {
///   final app = SkeletonApp(
///     title: 'MyApp',
///     localizationsDelegates: [AppLocalizations.delegate],
///     supportedLocales: AppLocalizations.supportedLocales,
///     themeBuilder: (context, state) => ThemeData(...),
///     menuNavBuilder: (context) => const MenuNav(),
///     appBlocProviders: [
///       BlocProvider(create: (ctx) => MyBloc()),
///     ],
///   );
///   await app.launch();
/// }
/// ```
class SkeletonApp {
  /// The app title shown in the task switcher.
  final String title;

  /// Localization delegates (app-specific + framework).
  /// `CoreLocalizations.delegate` and `GlobalMaterial/Widgets/Cupertino`
  /// are automatically included.
  final List<LocalizationsDelegate<dynamic>> localizationsDelegates;

  /// Supported locales for the app.
  final List<Locale> supportedLocales;

  /// Builds the app's theme based on the current [SettingState].
  final ThemeData Function(BuildContext context, SettingState state)
      themeBuilder;

  /// Builds the main navigation widget (e.g. `MenuNav`).
  final Widget Function(BuildContext context) menuNavBuilder;

  /// Optional: wraps the home screen in a tour overlay.
  /// Receives the child widget to wrap.
  final Widget Function(BuildContext context, Widget child)? tourWrapperBuilder;

  /// Optional: wraps the home screen in an update-checker.
  /// Receives the child widget to wrap.
  final Widget Function(BuildContext context, Widget child)?
      updateCheckerBuilder;

  /// Optional: additional bloc providers for the app.
  /// These are placed at the root level **after** core blocs, so their
  /// `create` callbacks can use `context.read<SettingBloc>()` etc.
  /// They are accessible from ALL routes and navigators.
  final List<SingleChildWidget>? appBlocProviders;

  /// Optional: async initialization (Firebase, dotenv, ads, etc.).
  /// Called before `runApp()`.
  final Future<void> Function()? onInit;

  /// Whether to show debug banner.
  final bool debugShowCheckedModeBanner;

  const SkeletonApp({
    required this.title,
    required this.localizationsDelegates,
    required this.supportedLocales,
    required this.themeBuilder,
    required this.menuNavBuilder,
    this.tourWrapperBuilder,
    this.updateCheckerBuilder,
    this.appBlocProviders,
    this.onInit,
    this.debugShowCheckedModeBanner = false,
  });

  /// Initializes services and runs the app.
  Future<void> launch() async {
    WidgetsFlutterBinding.ensureInitialized();

    if (onInit != null) {
      await onInit!();
    }

    runApp(_SkeletonAppWidget(config: this));
  }

  /// Merges the user-provided delegates with the core framework delegates.
  List<LocalizationsDelegate<dynamic>> get _allDelegates => [
        ...localizationsDelegates,
        CoreLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ];
}

/// Internal widget that builds the full app tree.
class _SkeletonAppWidget extends StatelessWidget {
  final SkeletonApp config;

  const _SkeletonAppWidget({required this.config});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Core blocs
        BlocProvider(create: (_) => SettingBloc()),
        BlocProvider(create: (_) => AppVersionBloc()),
        BlocProvider(create: (_) => TourBloc()),
        BlocProvider<MenuBloc>(create: (_) => MenuBloc(Menu())),
        BlocProvider(create: (_) => UserBloc(UnAuthenticatedUser())),
        // App-specific blocs (their create callbacks can access
        // core blocs above via context.read<...>())
        if (config.appBlocProviders != null) ...config.appBlocProviders!,
      ],
      child: GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: BlocBuilder<SettingBloc, SettingState>(
          builder: (context, state) {
            if (state.isLoading) {
              return const LoadingWidget();
            }

            return MaterialApp(
              debugShowCheckedModeBanner: config.debugShowCheckedModeBanner,
              title: config.title,
              localizationsDelegates: config._allDelegates,
              locale: Locale(state.locale),
              supportedLocales: config.supportedLocales,
              theme: config.themeBuilder(context, state),
              themeMode: state.themeMode,
              home: _buildHome(context),
            );
          },
        ),
      ),
    );
  }

  Widget _buildHome(BuildContext context) {
    return Builder(
      builder: (innerContext) {
        Widget content = config.menuNavBuilder(innerContext);

        if (config.updateCheckerBuilder != null) {
          content = config.updateCheckerBuilder!(innerContext, content);
        }

        if (config.tourWrapperBuilder != null) {
          content = config.tourWrapperBuilder!(innerContext, content);
        }

        return Container(
          decoration: LayoutConfig(innerContext).gradientDecoration,
          child: content,
        );
      },
    );
  }
}
