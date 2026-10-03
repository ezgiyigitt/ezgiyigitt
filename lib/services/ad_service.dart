import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

/// Centralized AdMob service for BrickUp.
/// All Ad Unit IDs below are Google's official TEST IDs — safe for development.
/// ⚠️ Replace with your real Ad Unit IDs from AdMob console before releasing.
class AdService {
  AdService._();
  static final AdService instance = AdService._();

  // ─── TEST AD UNIT IDs ──────────────────────────────────────────────────────
  static String get _interstitialAdUnitId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) return 'ca-app-pub-3940256099942544/1033173712';
    if (Platform.isIOS) return 'ca-app-pub-3940256099942544/4411468910';
    return '';
  }

  static String get _rewardedAdUnitId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) return 'ca-app-pub-3940256099942544/5224354917';
    if (Platform.isIOS) return 'ca-app-pub-3940256099942544/1712485313';
    return '';
  }

  static String get _bannerAdUnitId {
    if (kIsWeb) return '';
    if (Platform.isAndroid) return 'ca-app-pub-3940256099942544/6300978111';
    if (Platform.isIOS) return 'ca-app-pub-3940256099942544/2934735716';
    return '';
  }

  // ─── STATE ─────────────────────────────────────────────────────────────────
  InterstitialAd? _interstitialAd;
  RewardedAd? _rewardedAd;
  BannerAd? _bannerAd;

  bool _initialized = false;

  // ─── INIT ──────────────────────────────────────────────────────────────────
  Future<void> initialize() async {
    if (kIsWeb) return;
    await MobileAds.instance.initialize();
    _initialized = true;
    // Pre-load both ad types on startup so they're ready instantly when needed
    loadInterstitial();
    loadRewarded();
  }

  // ─── INTERSTITIAL (shown between levels on "Next Level" tap) ───────────────
  void loadInterstitial() {
    if (!_initialized || kIsWeb) return;
    InterstitialAd.load(
      adUnitId: _interstitialAdUnitId,
      request: const AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (ad) {
          _interstitialAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _interstitialAd = null;
              loadInterstitial(); // Pre-load next one immediately
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('[AdService] Interstitial failed to load: $error');
        },
      ),
    );
  }

  /// Shows the interstitial ad if loaded; [onComplete] is called after dismiss or if no ad available.
  void showInterstitial({VoidCallback? onComplete}) {
    if (_interstitialAd == null) {
      onComplete?.call();
      return;
    }
    _interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _interstitialAd = null;
        loadInterstitial();
        onComplete?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _interstitialAd = null;
        onComplete?.call();
      },
    );
    _interstitialAd!.show();
  }

  // ─── REWARDED (shown on Game Over to earn extra life) ─────────────────────
  void loadRewarded() {
    if (!_initialized || kIsWeb) return;
    RewardedAd.load(
      adUnitId: _rewardedAdUnitId,
      request: const AdRequest(),
      rewardedAdLoadCallback: RewardedAdLoadCallback(
        onAdLoaded: (ad) {
          _rewardedAd = ad;
          ad.fullScreenContentCallback = FullScreenContentCallback(
            onAdDismissedFullScreenContent: (ad) {
              ad.dispose();
              _rewardedAd = null;
              loadRewarded();
            },
          );
        },
        onAdFailedToLoad: (error) {
          debugPrint('[AdService] Rewarded failed to load: $error');
        },
      ),
    );
  }

  bool get isRewardedReady => _rewardedAd != null;

  /// Shows rewarded ad. [onRewarded] fires only when the user earns the reward.
  void showRewarded({
    required VoidCallback onRewarded,
    VoidCallback? onDismissed,
  }) {
    if (_rewardedAd == null) {
      onDismissed?.call();
      return;
    }
    _rewardedAd!.fullScreenContentCallback = FullScreenContentCallback(
      onAdDismissedFullScreenContent: (ad) {
        ad.dispose();
        _rewardedAd = null;
        loadRewarded();
        onDismissed?.call();
      },
      onAdFailedToShowFullScreenContent: (ad, error) {
        ad.dispose();
        _rewardedAd = null;
        onDismissed?.call();
      },
    );
    _rewardedAd!.show(
      onUserEarnedReward: (_, reward) => onRewarded(),
    );
  }

  // ─── BANNER ────────────────────────────────────────────────────────────────
  BannerAd? createBanner() {
    if (!_initialized || kIsWeb) return null;
    _bannerAd = BannerAd(
      adUnitId: _bannerAdUnitId,
      size: AdSize.banner,
      request: const AdRequest(),
      listener: BannerAdListener(
        onAdFailedToLoad: (ad, error) {
          debugPrint('[AdService] Banner failed to load: $error');
          ad.dispose();
        },
      ),
    )..load();
    return _bannerAd;
  }

  void disposeBanner() {
    _bannerAd?.dispose();
    _bannerAd = null;
  }

  void dispose() {
    _interstitialAd?.dispose();
    _rewardedAd?.dispose();
    _bannerAd?.dispose();
  }
}
