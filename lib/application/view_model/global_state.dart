part of 'global_view_model.dart';

final class GlobalViewModelState {
  const GlobalViewModelState({
    this.accountType = .free,
    this.isAdmobReady = false,
    this.errorMessage,
    this.language = .english,
    this.isOnboardingCompleted = false,
    this.isNewSession = true,
    this.shouldShowInterstitialAd,
  });

  /// The current account type of the user.
  final AccessLevel accountType;

  /// Whether Admob is ready to use.
  final bool isAdmobReady;

  /// Error message if any.
  final String? errorMessage;

  /// The current app language stored in global state.
  final AppLanguage language;

  /// Locale derived from selected app language.
  Locale get locale => language.locale;

  /// Check if onboarding has been completed.
  final bool isOnboardingCompleted;

  /// Check if this is a new session of the app.
  final bool isNewSession;

  /// Whether the current user has a Pro account.
  bool get isPro => accountType == .pro;

  /// Flag to show interstitial ad
  final bool? shouldShowInterstitialAd;

  GlobalViewModelState copyWith({
    AccessLevel? accountType,
    bool? isAdmobReady,
    bool? isOnboardingCompleted,
    bool? isNewSession,
    AppLanguage? language,
    Nullable<String>? errorMessage,
    bool? showInterstitialAd,
  }) {
    return GlobalViewModelState(
      accountType: accountType ?? this.accountType,
      isAdmobReady: isAdmobReady ?? this.isAdmobReady,
      isOnboardingCompleted:
          isOnboardingCompleted ?? this.isOnboardingCompleted,
      isNewSession: isNewSession ?? this.isNewSession,
      language: language ?? this.language,
      shouldShowInterstitialAd: showInterstitialAd,
      errorMessage: errorMessage == null
          ? this.errorMessage
          : errorMessage.value,
    );
  }
}
