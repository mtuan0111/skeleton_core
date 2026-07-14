import 'dart:io' show Platform;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import '../helpers/ui_constants.dart';
import '../helpers/helper.dart';

// ============================================================================
// BaseAdMobConfig — abstract, registerable
// ============================================================================

/// Abstract base for per-app AdMob configuration.
///
/// Each project creates a concrete subclass that provides its ad unit IDs and
/// `useTestAds` flag, then registers a singleton instance at startup:
///
/// ```dart
/// // In each project's AdMobConfig:
/// class AdMobConfig extends BaseAdMobConfig {
///   AdMobConfig._();
///   static final AdMobConfig instance = AdMobConfig._();
///
///   @override
///   bool get useTestAds => true; // flip to false when account is approved
///
///   @override
///   String get androidGameOverBannerId => 'ca-app-pub-xxx/yyy';
///
///   @override
///   String get iosGameOverBannerId => 'ca-app-pub-xxx/zzz';
///
///   // ... other slots
/// }
///
/// // In main.dart, before runApp:
/// BaseAdMobConfig.register(AdMobConfig.instance);
/// ```
///
/// [AdMobBanner] then resolves `useTestAds` from the registered instance
/// automatically — no need to pass it at every call site.
abstract class BaseAdMobConfig {
  // ── Google's official test IDs (shared, read-only) ──────────────────────
  static const String androidTestBannerId =
      'ca-app-pub-3940256099942544/6300978111';
  static const String iosTestBannerId =
      'ca-app-pub-3940256099942544/2934735716';

  // ── Registration ─────────────────────────────────────────────────────────
  static BaseAdMobConfig? _registered;

  /// Register the app's concrete [BaseAdMobConfig] instance.
  ///
  /// Call this once in `main()` before `runApp`:
  /// ```dart
  /// BaseAdMobConfig.register(AdMobConfig.instance);
  /// ```
  static void register(BaseAdMobConfig config) {
    _registered = config;
    debugPrint('✅ [AdMob] Config registered: ${config.runtimeType}');
  }

  /// The currently registered config. `null` until [register] is called.
  static BaseAdMobConfig? get current => _registered;

  // ── Abstract API — implement per project ─────────────────────────────────

  /// Whether to use Google test ads.
  ///
  /// Set to `false` once your AdMob account is approved.
  bool get useTestAds;

  /// Ad unit IDs for each placement slot.
  /// Override only the slots your project uses; others can throw [UnimplementedError].
  String get androidGameOverBannerId =>
      throw UnimplementedError('androidGameOverBannerId not configured');
  String get iosGameOverBannerId =>
      throw UnimplementedError('iosGameOverBannerId not configured');

  String get androidTopScoreBannerId =>
      throw UnimplementedError('androidTopScoreBannerId not configured');
  String get iosTopScoreBannerId =>
      throw UnimplementedError('iosTopScoreBannerId not configured');

  // Add more slot getters here as needed (e.g. interstitial, rewarded, etc.)
}

// ============================================================================
// AdMobBanner widget
// ============================================================================

/// A reusable widget that displays a Google AdMob banner ad.
///
/// Handles the full ad lifecycle: loading → display → disposal.
///
/// **Minimal usage** — relies on the registered [BaseAdMobConfig]:
/// ```dart
/// // After BaseAdMobConfig.register(AdMobConfig.instance) in main():
/// AdMobBanner(
///   adUnitId: Platform.isIOS
///       ? AdMobConfig.instance.iosGameOverBannerId
///       : AdMobConfig.instance.androidGameOverBannerId,
/// )
/// ```
///
/// **Explicit override** — bypass registered config for one-off usage:
/// ```dart
/// AdMobBanner(
///   adUnitId: mySlotId,
///   useTestAds: false,
/// )
/// ```
class AdMobBanner extends StatefulWidget {
  /// Production ad unit ID for this placement.
  ///
  /// Ignored when [useTestAds] resolves to `true`.
  final String adUnitId;

  /// Banner size. Defaults to [AdSize.banner] (320×50).
  final AdSize adSize;

  /// Override the test-mode flag.
  ///
  /// When `null` (default), the value is read from [BaseAdMobConfig.current].
  /// If no config is registered, defaults to `true` (safe fallback).
  final bool? useTestAds;

  const AdMobBanner({
    super.key,
    required this.adUnitId,
    this.adSize = AdSize.banner,
    this.useTestAds, // null → read from registered config
  });

  @override
  State<AdMobBanner> createState() => _AdMobBannerState();
}

class _AdMobBannerState extends State<AdMobBanner> {
  BannerAd? _bannerAd;
  bool _isAdLoaded = false;

  /// Resolves useTestAds: explicit param > registered config > safe default.
  bool get _useTestAds =>
      widget.useTestAds ?? BaseAdMobConfig.current?.useTestAds ?? true;

  /// Resolves the effective ad unit ID: test IDs take priority.
  String get _effectiveAdUnitId {
    if (_useTestAds) {
      return !kIsWeb && Platform.isIOS
          ? BaseAdMobConfig.iosTestBannerId
          : BaseAdMobConfig.androidTestBannerId;
    }
    return widget.adUnitId;
  }

  @override
  void initState() {
    super.initState();
    _loadAd();
  }

  void _loadAd() {
    if (kIsWeb) {
      debugPrint('📱 [AdMob] Skipping banner ad load on web');
      return;
    }
    
    final adUnitId = _effectiveAdUnitId;
    debugPrint(
        '📱 [AdMob] Loading banner — ID: $adUnitId (test: $_useTestAds)');

    _bannerAd = BannerAd(
      adUnitId: adUnitId,
      size: widget.adSize,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          if (mounted) setState(() => _isAdLoaded = true);
          debugPrint('✅ [AdMob] Banner loaded');
        },
        onAdFailedToLoad: (ad, error) {
          debugPrint('❌ [AdMob] Banner failed: $error');
          ad.dispose();
          if (mounted) setState(() => _isAdLoaded = false);
        },
        onAdOpened: (_) => debugPrint('📱 [AdMob] Banner opened'),
        onAdClosed: (_) => debugPrint('🔒 [AdMob] Banner closed'),
      ),
    );

    _bannerAd?.load();
  }

  @override
  void dispose() {
    if (!kIsWeb) {
      _bannerAd?.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_isAdLoaded || _bannerAd == null) {
      return SizedBox(height: widget.adSize.height.toDouble());
    }

    return Container(
      padding: const EdgeInsets.all(kPaddingS),
      clipBehavior: Clip.hardEdge,
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor.withValues(alpha: 0.3),
        borderRadius: CoreHelper.getBorderRadius(
          radius: kPaddingS,
          shapeAt: RoundedWithShapeAt.bottom,
        ),
      ),
      child: SizedBox(
        height: widget.adSize.height.toDouble() + kPaddingS,
        width: widget.adSize.width.toDouble() + kPaddingS / 2,
        child: AdWidget(ad: _bannerAd!),
      ),
    );
  }
}
