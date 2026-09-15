class SkeletonConfig {
  /// The primary font family for the app, used for display text styles.
  /// If null, defaults to "Inter".
  static String? primaryFontFamily;

  /// The secondary font family for the app, used for body text styles.
  /// If null, defaults to the theme's default textTheme font family.
  static String? secondaryFontFamily;

  /// The handwriting font family for the app, used for specialized handwriting text styles.
  /// If null, defaults to "Dancing Script".
  static String? handwritingFontFamily;

  /// The **web** OAuth client id (`client_type: 3` in the app's
  /// `android/app/google-services.json`), used as `serverClientId` when
  /// initializing Google Sign-In.
  ///
  /// Android-only in effect, and not optional there: without it
  /// `google_sign_in` 7.x returns an account whose `idToken` is null, and
  /// `GoogleAuthProvider.credential(idToken:)` has nothing to exchange —
  /// which surfaces far from its cause as a generic Firebase rejection
  /// (`AuthServices.signInWithGoogle` names it explicitly for that reason).
  /// iOS reads its own client id from `GIDClientID` in `Info.plist` instead
  /// and ignores this.
  ///
  /// Lives here rather than in [AuthServices] because the value is
  /// per-app — this package backs more than one — so each app sets it in
  /// `main()` before `launch()`. Null just means Google sign-in is not
  /// configured for that app yet.
  static String? googleServerClientId;

  /// Master switch for SNS (Google / Apple) sign-in. **Disabled by default** —
  /// it is an opt-in feature.
  ///
  /// An app turns it on in `main()` (before `launch()`) only once its Firebase
  /// Auth providers and OAuth client ids are actually configured. While this is
  /// false the sign-in UI stays hidden and [AuthServices]'s `signInWithGoogle`
  /// / `signInWithApple` refuse to run, so a half-configured provider can never
  /// be reached — and any app that hasn't wired SNS up yet gets no dangling,
  /// error-only sign-in button.
  ///
  /// Per-app, like [googleServerClientId], because this package backs several
  /// apps and each opts in on its own schedule.
  static bool snsLoginEnabled = false;
}
