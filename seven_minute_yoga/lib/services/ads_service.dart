import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:yandex_mobileads/mobile_ads.dart';

import 'yandex_ads_config.dart';

class AdsService {
  AdsService._();

  static final AdsService instance = AdsService._();

  bool _initialized = false;
  bool _sdkReady = false;

  AppOpenAd? _appOpenAd;
  Future<AppOpenAdLoader>? _appOpenAdLoader;
  bool _isAppOpenLoading = false;
  bool _isAppOpenShowing = false;
  bool _showAppOpenWhenLoaded = false;

  InterstitialAd? _interstitialAd;
  Future<InterstitialAdLoader>? _interstitialAdLoader;
  bool _isInterstitialLoading = false;
  bool _isInterstitialShowing = false;

  bool get isSdkReady => _sdkReady;

  String get bannerAdUnitId => YandexAdsConfig.bannerAdUnitId;
  String get interstitialAdUnitId => YandexAdsConfig.interstitialAdUnitId;
  String get appOpenAdUnitId => YandexAdsConfig.appOpenAdUnitId;

  Future<void> initialize() async {
    if (_initialized) return;
    _initialized = true;

    try {
      await MobileAds.initialize();
      if (kDebugMode) {
        await MobileAds.setLogging(true);
      }
      _sdkReady = true;
      _appOpenAdLoader = _createAppOpenAdLoader();
      _interstitialAdLoader = _createInterstitialAdLoader();
      await preloadAppOpenAd();
    } catch (error, stackTrace) {
      _sdkReady = false;
      debugPrint('Yandex Ads init error: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> preloadAppOpenAd() async {
    if (!_sdkReady || _isAppOpenLoading || _appOpenAd != null) return;
    _isAppOpenLoading = true;
    final loader = await (_appOpenAdLoader ??= _createAppOpenAdLoader());
    await loader.loadAd(
      adRequestConfiguration: AdRequestConfiguration(adUnitId: appOpenAdUnitId),
    );
  }

  Future<void> showAppOpenAdIfAvailable() async {
    if (!_sdkReady || _isAppOpenShowing) return;
    final ad = _appOpenAd;
    if (ad == null) {
      _showAppOpenWhenLoaded = true;
      await preloadAppOpenAd();
      return;
    }

    await ad.setAdEventListener(
      eventListener: AppOpenAdEventListener(
        onAdShown: () {
          _isAppOpenShowing = true;
          debugPrint('App open ad shown');
        },
        onAdFailedToShow: (error) {
          _isAppOpenShowing = false;
          _disposeAppOpenAd();
          preloadAppOpenAd();
          debugPrint(
            'App open ad failed to show: ${error.description}',
          );
        },
        onAdDismissed: () {
          _isAppOpenShowing = false;
          _disposeAppOpenAd();
          preloadAppOpenAd();
          debugPrint('App open ad dismissed');
        },
      ),
    );

    try {
      await ad.show();
      await ad.waitForDismiss();
    } catch (error) {
      _isAppOpenShowing = false;
      _disposeAppOpenAd();
      await preloadAppOpenAd();
      debugPrint('App open ad show error: $error');
    }
  }

  Future<void> preloadInterstitialAd() async {
    if (!_sdkReady || _isInterstitialLoading || _interstitialAd != null) return;
    _isInterstitialLoading = true;
    final loader = await (_interstitialAdLoader ??=
        _createInterstitialAdLoader());
    await loader.loadAd(
      adRequestConfiguration: AdRequestConfiguration(
        adUnitId: interstitialAdUnitId,
      ),
    );
  }

  Future<bool> showInterstitialAdIfAvailable() async {
    if (!_sdkReady || _isInterstitialShowing) return false;
    final ad = _interstitialAd;
    if (ad == null) {
      await preloadInterstitialAd();
      return false;
    }

    await ad.setAdEventListener(
      eventListener: InterstitialAdEventListener(
        onAdShown: () {
          _isInterstitialShowing = true;
          debugPrint('Interstitial ad shown');
        },
        onAdFailedToShow: (error) {
          _isInterstitialShowing = false;
          _disposeInterstitialAd();
          preloadInterstitialAd();
          debugPrint(
            'Interstitial ad failed to show: ${error.description}',
          );
        },
        onAdDismissed: () {
          _isInterstitialShowing = false;
          _disposeInterstitialAd();
          preloadInterstitialAd();
          debugPrint('Interstitial ad dismissed');
        },
      ),
    );

    try {
      await ad.show();
      await ad.waitForDismiss();
      return true;
    } catch (error) {
      _isInterstitialShowing = false;
      _disposeInterstitialAd();
      await preloadInterstitialAd();
      debugPrint('Interstitial ad show error: $error');
      return false;
    }
  }

  BannerAd createBannerAd({
    required int widthDp,
    void Function()? onAdLoaded,
    void Function(AdRequestError error)? onAdFailedToLoad,
  }) {
    return BannerAd(
      adUnitId: bannerAdUnitId,
      adSize: BannerAdSize.sticky(width: widthDp),
      adRequest: const AdRequest(),
      onAdLoaded: onAdLoaded,
      onAdFailedToLoad: onAdFailedToLoad,
    );
  }

  Future<AppOpenAdLoader> _createAppOpenAdLoader() {
    return AppOpenAdLoader.create(
      onAdLoaded: (ad) {
        _appOpenAd?.destroy();
        _appOpenAd = ad;
        _isAppOpenLoading = false;
        debugPrint('App open ad loaded');
        if (_showAppOpenWhenLoaded) {
          _showAppOpenWhenLoaded = false;
          unawaited(showAppOpenAdIfAvailable());
        }
      },
      onAdFailedToLoad: (error) {
        _isAppOpenLoading = false;
        _showAppOpenWhenLoaded = false;
        debugPrint(
          'App open ad load error: code=${error.code}, description=${error.description}',
        );
      },
    );
  }

  Future<InterstitialAdLoader> _createInterstitialAdLoader() {
    return InterstitialAdLoader.create(
      onAdLoaded: (ad) {
        _interstitialAd?.destroy();
        _interstitialAd = ad;
        _isInterstitialLoading = false;
        debugPrint('Interstitial ad loaded');
      },
      onAdFailedToLoad: (error) {
        _isInterstitialLoading = false;
        debugPrint(
          'Interstitial ad load error: code=${error.code}, description=${error.description}',
        );
      },
    );
  }

  void _disposeAppOpenAd() {
    _appOpenAd?.destroy();
    _appOpenAd = null;
  }

  void _disposeInterstitialAd() {
    _interstitialAd?.destroy();
    _interstitialAd = null;
  }
}
